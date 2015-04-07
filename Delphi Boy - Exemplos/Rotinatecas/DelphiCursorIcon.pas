// Wheberson Hudson Migueletti, em Brasília, 03 de abril de 1999.
// Codificação/Descodificação de arquivos ".cur" e ".ico" (Windows CUR/ICO).
// Captura a primeira (caso tenha mais de 1) imagem e a primeira máscara.

unit DelphiCursorIcon;

interface

uses Windows, SysUtils, Classes, Graphics, DelphiImage;

type
  PCursorDirectoryEntry= ^TCursorDirectoryEntry;
  TCursorDirectoryEntry= packed record
    bWidth       : Byte;    // Largura do cursor
    bHeight      : Byte;    // Altura do cursor
    bColorCount  : Byte;    // Deve ser 0
    bReserved    : Byte;    // Deve ser 0
    wXHotspot    : Word;    // Coordenada em X do Hotspot
    wYHotspot    : Word;    // Coordenada em Y do Hotspot
    lBytesInRes  : Integer; // Tamanho do objeto em bytes
    dwImageOffset: Integer; // Onde começa a imagem (a partir da posição 0)
  end;

  PIconDirectoryEntry= ^TIconDirectoryEntry;
  TIconDirectoryEntry= packed record
    bWidth       : Byte;    // Largura do ícone
    bHeight      : Byte;    // Altura do ícone
    bColorCount  : Byte;    // Deve ser 0
    bReserved    : Byte;    // Deve ser 0
    wPlanes      : Word;    // Planos
    wBitCount    : Word;    // Bits por pixel
    lBytesInRes  : Integer; // Tamanho objeto em bytes
    dwImageOffset: Integer; // Onde começa a imagem (a partir da posição 0)
  end;

  PCursorOrIcon= ^TCursorOrIcon;
  TCursorOrIcon= packed record
    cdReserved: Word; // Deve ser sempre 0
    cdType    : Word; // Deve ser sempre 2
    cdCount   : Word; // Número de cursores
  end;

  PCursorDirectory= ^TCursorDirectory;
  TCursorDirectory= packed record
    cdReserved: Word;       	       // Deve ser sempre 0
    cdType    : Word;		       // Deve ser sempre 2
    cdCount   : Word;                  // Número de cursores
    cdEntries : TCursorDirectoryEntry; // Primeiro "CursorDirectoryEntry"
  end;

  PIconDirectory= ^TIconDirectory;
  TIconDirectory= packed record
    cdReserved: Word;       	     // Deve ser sempre 0
    cdType    : Word;	             // Deve ser sempre 1
    cdCount   : Word;                // Número de ícones
    cdEntries : TIconDirectoryEntry; // Primeiro "IconDirectoryEntry"
  end;

  TCursorIcon= class (TBitmap)
    protected
      Color : TRGBQuad;
      Stream: TStream;

      procedure Read (var Buffer; Count: Integer);
      procedure ReadStream (AStream: TStream);
      procedure DumpHeader;
      procedure DumpImage;
    public
      Cursor : Boolean; // Cursor -> True; Icon -> False
      Mask   : TBitmap;
      Hotspot: TPoint;

      constructor Create (AColor: TColor);
      destructor  Destroy; override;
      function    IsValid (const FileName: String): Boolean;
      procedure   LoadFromStream (Stream: TStream); override;
  end;

function  CriarCursor                 (XorBits, AndBits: HBitmap; XHotSpot, YHotSpot: LongInt): HCursor;
procedure SaveBitmapsAsCursorToStream (Stream: TStream; Bitmap, Mask: TBitmap; Hotspot: TPoint);
procedure SaveBitmapsAsCursorToFile   (const FileName: String; Bitmap, Mask: TBitmap; Hotspot: TPoint);
procedure SaveBitmapAsCursorToFile    (const FileName: String; Bitmap: TBitmap; Hotspot: TPoint; CreateMask, Mono: Boolean);

function  CriarIcone                  (XorBits, AndBits: HBitmap): HIcon;
procedure SaveBitmapsAsIconToStream   (Stream: TStream; Bitmap, Mask: TBitmap);
procedure SaveBitmapsAsIconToFile     (const FileName: String; Bitmap, Mask: TBitmap);
procedure SaveBitmapAsIconToFile      (const FileName: String; Bitmap: TBitmap; CreateMask: Boolean);

procedure MergeColorMask              (Bitmap, BMColor, BMMask: TBitmap);

implementation

uses DelphiColorQuantization;




// Borland
function DupBits (Src: HBitmap; Size: TPoint; Mono: Boolean): HBitmap;
var
  DC, Mem1, Mem2: HDC;
  Old1, Old2    : HBitmap;
  Bitmap        : Windows.TBitmap;

begin
  Result:= 0;
  Mem1  := CreateCompatibleDC (0);
  Mem2  := CreateCompatibleDC (0);

  try
    GetObject (Src, SizeOf (Bitmap), @Bitmap);
    if Mono then
      Result:= CreateBitmap (Size.X, Size.Y, 1, 1, nil)
    else begin
      DC:= GetDC (0);
      if DC <> 0 then begin
        try
          Result:= CreateCompatibleBitmap (DC, Size.X, Size.Y);
        finally
          ReleaseDC (0, DC);
        end;
      end;
    end;

    if Result <> 0 then begin
      Old1:= SelectObject (Mem1, Src);
      Old2:= SelectObject (Mem2, Result);

      StretchBlt (Mem2, 0, 0, Size.X, Size.Y, Mem1, 0, 0, Bitmap.bmWidth, Bitmap.bmHeight, SrcCopy);
      
      if Old1 <> 0 then
        SelectObject (Mem1, Old1);
      if Old2 <> 0 then
        SelectObject (Mem2, Old2);
    end;
  finally
    DeleteDC (Mem1);
    DeleteDC (Mem2);
  end;
end;




// Borland
function CriarCursor (XorBits, AndBits: HBitmap; XHotSpot, YHotSpot: LongInt): HCursor;
var
  Length          : Integer;
  XorLen, AndLen  : Integer;
  ResData         : Pointer;
  XorMem, AndMem  : Pointer;
  XorInfo, AndInfo: Windows.TBitmap;
  CursorSize      : TPoint;

begin
  CursorSize.X:= GetSystemMetrics (SM_CXCURSOR);
  CursorSize.Y:= GetSystemMetrics (SM_CYCURSOR);
  XorBits     := DupBits (XorBits, CursorSize, True);
  AndBits     := DupBits (AndBits, CursorSize, True);
  GetObject (AndBits, SizeOf (Windows.TBitmap), @AndInfo);
  GetObject (XorBits, SizeOf (Windows.TBitmap), @XorInfo);
  with AndInfo do
    AndLen:= bmWidthBytes * bmHeight * bmPlanes;
  with XorInfo do
    XorLen:= bmWidthBytes * bmHeight * bmPlanes;
  Length := AndLen + XorLen;
  ResData:= AllocMem (Length);
  try
    AndMem:= ResData;
    with AndInfo do
      XorMem:= Pointer (LongInt (ResData) + AndLen);
    GetBitmapBits (AndBits, AndLen, AndMem);
    GetBitmapBits (XorBits, XorLen, XorMem);
    Result:= CreateCursor (HInstance, XHotSpot, YHotSpot, CursorSize.X, CursorSize.Y, AndMem, XorMem);
  finally
    FreeMem (ResData, Length);
  end;
end;




// Borland
function CriarIcone (XorBits, AndBits: HBitmap): HIcon;
var
  Length          : Integer;
  XorLen, AndLen  : Integer;
  ResData         : Pointer;
  XorMem, AndMem  : Pointer;
  XorInfo, AndInfo: Windows.TBitmap;
  IconSize        : TPoint;

begin
  IconSize.X:= GetSystemMetrics (SM_CXICON);
  IconSize.Y:= GetSystemMetrics (SM_CYICON);
  XorBits   := DupBits (XorBits, IconSize, False);
  AndBits   := DupBits (AndBits, IconSize, True);
  GetObject (AndBits, SizeOf (Windows.TBitmap), @AndInfo);
  GetObject (XorBits, SizeOf (Windows.TBitmap), @XorInfo);
  with AndInfo do
    AndLen:= bmWidthBytes * bmHeight * bmPlanes;
  with XorInfo do
    XorLen:= bmWidthBytes * bmHeight * bmPlanes;
  Length := AndLen + XorLen;
  ResData:= AllocMem (Length);
  try
    AndMem:= ResData;
    with AndInfo do
      XorMem:= Pointer (LongInt (ResData) + AndLen);
    GetBitmapBits (AndBits, AndLen, AndMem);
    GetBitmapBits (XorBits, XorLen, XorMem);
    Result:= CreateIcon (HInstance, IconSize.X, IconSize.Y, XorInfo.bmPlanes, XorInfo.bmBitsPixel, AndMem, XorMem);
  finally
    FreeMem (ResData, Length);
  end;
end;





function ConverterIconeParaCursor (HotSpot: TPoint; Icon: Graphics.TIcon): HCursor;
var
  Length          : Integer;
  XorLen, AndLen  : Integer;
  ResData         : Pointer;
  XorMem, AndMem  : Pointer;
  XorInfo, AndInfo: Windows.TBitmap;
  IconInfo        : TIconInfo;
  CursorSize      : TPoint;

begin
  GetIconInfo (Icon.Handle, IconInfo);
  CursorSize.X     := GetSystemMetrics (SM_CXCURSOR);
  CursorSize.Y     := GetSystemMetrics (SM_CYCURSOR);
  IconInfo.hbmColor:= DupBits (IconInfo.hbmColor, CursorSize, True);
  IconInfo.hbmMask := DupBits (IconInfo.hbmMask, CursorSize, True);
  GetObject (IconInfo.hbmMask, SizeOf (Windows.TBitmap), @AndInfo);
  GetObject (IconInfo.hbmColor, SizeOf (Windows.TBitmap), @XorInfo);
  with AndInfo do
    AndLen:= bmWidthBytes * bmHeight * bmPlanes;
  with XorInfo do
    XorLen:= bmWidthBytes * bmHeight * bmPlanes;
  Length := AndLen + XorLen;
  ResData:= AllocMem (Length);
  try
    AndMem:= ResData;
    with AndInfo do
      XorMem:= Pointer (LongInt (ResData) + AndLen);
    GetBitmapBits (IconInfo.hbmMask, AndLen, AndMem);
    GetBitmapBits (IconInfo.hbmMask, XorLen, XorMem);
    Result:= CreateCursor (HInstance, HotSpot.X, HotSpot.Y, CursorSize.X, CursorSize.Y, AndMem, XorMem);
  finally
    FreeMem (ResData, Length);
  end;
end;




// O armazenamento é feito a partir da posição corrente da "Stream"
procedure SaveBitmapsAsCursorToStream (Stream: TStream; Bitmap, Mask: TBitmap; Hotspot: TPoint);
var
  StartPosition: Integer;
  BFH          : TBitmapFileHeader;
  BIH, BIHMask : TBitmapInfoHeader;
  CursorDir    : TCursorDirectory;
  DIBStream    : TMemoryStream;

begin
  if Assigned (Stream) then begin
    DIBStream:= TMemoryStream.Create;
    try
      // Carregando o DIB do "Bitmap"
      Bitmap.SaveToStream (DIBStream);
      DIBStream.Seek (SizeOf (TBitmapFileHeader), soFromBeginning);

      DIBStream.Read (BIH, SizeOf (TBitmapInfoHeader));
      DIBStream.Seek (SizeOf (TBitmapFileHeader), soFromBeginning);

      // Inicializando
      FillChar (CursorDir, SizeOf (TCursorDirectory), #0);
      with CursorDir, cdEntries do begin
        cdType       := 2;
        cdCount      := 1;
        wXHotspot    := Hotspot.X;
        wYHotspot    := Hotspot.Y;
        dwImageOffset:= SizeOf (TCursorDirectory);
        if Bitmap.Width < 256 then
          bWidth:= Bitmap.Width;
        if Bitmap.Height < 256 then
          bHeight:= Bitmap.Height;
      end;
      StartPosition:= Stream.Position;
      Stream.Write (CursorDir, SizeOf (TCursorDirectory));
      
      // Copiando o DIB do "Bitmap"
      Stream.CopyFrom (DIBStream, DIBStream.Size-DIBStream.Position);

      // Carregando/Copiando o DIB do "Mask"
      DIBStream.Clear;
      Mask.SaveToStream (DIBStream);
      DIBStream.Seek (0, soFromBeginning);
      DIBStream.Read (BFH, SizeOf (TBitmapFileHeader));
      DIBStream.Read (BIHMask, SizeOf (TBitmapInfoHeader));
      DIBStream.Seek (BFH.bfOffBits, soFromBeginning);
      Stream.CopyFrom (DIBStream, DIBStream.Size-DIBStream.Position);

      // Atualizando o "Header"
      try
        CursorDir.cdEntries.lBytesInRes:= Stream.Size - StartPosition - SizeOf (TCursorDirectory);
        Inc (BIH.biHeight, BIHMask.biHeight);
        Inc (BIH.biSizeImage, BIHMask.biSizeImage);
        Stream.Seek (StartPosition, soFromBeginning);
        Stream.Write (CursorDir, SizeOf (TCursorDirectory));
        Stream.Write (BIH, SizeOf (TBitmapInfoHeader));
      finally
        Stream.Seek (0, soFromEnd);
      end;
    finally
      DIBStream.Free;
    end;
  end;
end;





procedure SaveBitmapsAsCursorToFile (const FileName: String; Bitmap, Mask: TBitmap; Hotspot: TPoint);
var
  Stream: TMemoryStream;

begin
  if (FileName <> '') and Assigned (Bitmap) and Assigned (Mask) then begin
    Stream:= TMemoryStream.Create;
    try
      // Copia
      SaveBitmapsAsCursorToStream (Stream, Bitmap, Mask, Hotspot);

      // Grava
      Stream.Seek (0, soFromBeginning);
      Stream.SaveToFile (FileName);
    finally
      Stream.Free;
    end;
  end;
end;





procedure SaveBitmapAsCursorToFile (const FileName: String; Bitmap: TBitmap; Hotspot: TPoint; CreateMask, Mono: Boolean);
const
  cTamanhoDefault= 32;

var
  TamanhoExato: Boolean;
  Mask        : TBitmap;

 procedure MontarMascara (Bmp: TBitmap);
 var
   R: TRect;

 begin
   Mask.Width := Bmp.Width;
   Mask.Height:= Bmp.Height;
   if CreateMask then begin
     Mask.Canvas.CopyMode:= cmSrcInvert;
     Mask.Canvas.CopyRect (Rect (0, 0, Bmp.Width, Bmp.Height), Bmp.Canvas, Rect (0, 0, Bmp.Width, Bmp.Height));
   end
   else if TamanhoExato then begin
     Mask.Canvas.Brush.Color:= clBlack;
     Mask.Canvas.FillRect (Rect (0, 0, Mask.Width, Mask.Height));
   end
   else begin
     Mask.Canvas.Brush.Color:= clWhite;
     Mask.Canvas.FillRect (Rect (0, 0, Mask.Width, Mask.Height));
     Mask.Canvas.Brush.Color:= clBlack;
     R                      := Enquadrar (Bitmap.Width, Bitmap.Height, Mask.Width, Mask.Height, True);
     Inc (R.Right);
     Inc (R.Bottom);
     Mask.Canvas.FillRect (R);
   end;
   SetPixelFormat (Mask, pf1bit);
 end;

var
  Bmp: TBitmap;

begin
  if (FileName <> '') and Assigned (Bitmap) then begin
    Mask:= TBitmap.Create;
    try
      TamanhoExato:= (Bitmap.Width = cTamanhoDefault) and (Bitmap.Height = cTamanhoDefault);
      if (not Mono) and TamanhoExato and (Bitmap.PixelFormat in [pf1bit, pf4bit, pf8bit]) then begin
        MontarMascara (Bitmap);
        SaveBitmapsAsCursorToFile (FileName, Bitmap, Mask, Hotspot);
      end
      else begin
        Bmp:= TBitmap.Create;
        try
          if TamanhoExato then
            Bmp.Assign (Bitmap)
          else
            DimensionarBitmap (Bitmap, Bmp, cTamanhoDefault, cTamanhoDefault, cteQuandoNecessario, True, True, clBlack);
          if Mono then
            SetPixelFormat (Bmp, pf1bit)
          else
            SetPixelFormat (Bmp, pf8bit);
          MontarMascara (Bmp);
          SaveBitmapsAsCursorToFile (FileName, Bmp, Mask, Hotspot);
        finally
          Bmp.Free;
        end;
      end;
    finally
      Mask.Free;
    end;
  end;
end;




// O armazenamento é feito a partir da posição corrente da "Stream"
procedure SaveBitmapsAsIconToStream (Stream: TStream; Bitmap, Mask: TBitmap);
var
  StartPosition: Integer;
  BFH          : TBitmapFileHeader;
  BIH, BIHMask : TBitmapInfoHeader;
  IconDir      : TIconDirectory;
  DIBStream    : TMemoryStream;

begin
  if Assigned (Stream) then begin
    DIBStream:= TMemoryStream.Create;
    try
      // Carregando o DIB do "Bitmap"
      Bitmap.SaveToStream (DIBStream);
      DIBStream.Seek (SizeOf (TBitmapFileHeader), soFromBeginning);

      DIBStream.Read (BIH, SizeOf (TBitmapInfoHeader));
      DIBStream.Seek (SizeOf (TBitmapFileHeader), soFromBeginning);

      // Inicializando
      FillChar (IconDir, SizeOf (TIconDirectory), #0);
      with IconDir, cdEntries do begin
        cdType       := 1;
        cdCount      := 1;
        wPlanes      := BIH.biPlanes;
        wBitCount    := BIH.biBitCount;
        dwImageOffset:= SizeOf (TIconDirectory);
        if Bitmap.Width < 256 then
          bWidth:= Bitmap.Width;
        if Bitmap.Height < 256 then
          bHeight:= Bitmap.Height;
      end;
      StartPosition:= Stream.Position;
      Stream.Write (IconDir, SizeOf (TIconDirectory));

      // Copiando o DIB do "Bitmap"
      Stream.CopyFrom (DIBStream, DIBStream.Size-DIBStream.Position);

      // Carregando/Copiando o DIB do "Mask"
      DIBStream.Clear;
      Mask.SaveToStream (DIBStream);
      DIBStream.Seek (0, soFromBeginning);
      DIBStream.Read (BFH, SizeOf (TBitmapFileHeader));
      DIBStream.Read (BIHMask, SizeOf (TBitmapInfoHeader));
      DIBStream.Seek (BFH.bfOffBits, soFromBeginning);
      Stream.CopyFrom (DIBStream, DIBStream.Size-DIBStream.Position);

      // Atualizando o "Header"
      try
        IconDir.cdEntries.lBytesInRes:= Stream.Size - StartPosition - SizeOf (TIconDirectory);
        Inc (BIH.biHeight, BIHMask.biHeight);
        Inc (BIH.biSizeImage, BIHMask.biSizeImage);
        Stream.Seek (StartPosition, soFromBeginning);
        Stream.Write (IconDir, SizeOf (TIconDirectory));
        Stream.Write (BIH, SizeOf (TBitmapInfoHeader));
      finally
        Stream.Seek (0, soFromEnd);
      end;
    finally
      DIBStream.Free;
    end;
  end;
end;





procedure SaveBitmapsAsIconToFile (const FileName: String; Bitmap, Mask: TBitmap);
var
  Stream: TMemoryStream;

begin
  if (FileName <> '') and Assigned (Bitmap) and Assigned (Mask) then begin
    Stream:= TMemoryStream.Create;
    try
      // Copia
      SaveBitmapsAsIconToStream (Stream, Bitmap, Mask);

      // Grava
      Stream.Seek (0, soFromBeginning);
      Stream.SaveToFile (FileName);
    finally
      Stream.Free;
    end;
  end;
end;





procedure SaveBitmapAsIconToFile (const FileName: String; Bitmap: TBitmap; CreateMask: Boolean);
const
  cTamanhoDefault= 32;

var
  TamanhoExato: Boolean;
  Mask        : TBitmap;

 procedure MontarMascara (Bmp: TBitmap);
 var
   R: TRect;

 begin
   Mask.Width := Bmp.Width;
   Mask.Height:= Bmp.Height;
   if CreateMask then begin
     Mask.Canvas.CopyMode:= cmSrcInvert;
     Mask.Canvas.CopyRect (Rect (0, 0, Bmp.Width, Bmp.Height), Bmp.Canvas, Rect (0, 0, Bmp.Width, Bmp.Height));
   end
   else if TamanhoExato then begin
     Mask.Canvas.Brush.Color:= clBlack;
     Mask.Canvas.FillRect (Rect (0, 0, Mask.Width, Mask.Height));
   end
   else begin
     Mask.Canvas.Brush.Color:= clWhite;
     Mask.Canvas.FillRect (Rect (0, 0, Mask.Width, Mask.Height));
     Mask.Canvas.Brush.Color:= clBlack;
     R                      := Enquadrar (Bitmap.Width, Bitmap.Height, Mask.Width, Mask.Height, True);
     Inc (R.Right);
     Inc (R.Bottom);
     Mask.Canvas.FillRect (R);
   end;
   SetPixelFormat (Mask, pf1bit);
 end;

var
  Bmp: TBitmap;

begin
  if (FileName <> '') and Assigned (Bitmap) then begin
    Mask:= TBitmap.Create;
    try
      TamanhoExato:= (Bitmap.Width = cTamanhoDefault) and (Bitmap.Height = cTamanhoDefault);
      if TamanhoExato and (Bitmap.PixelFormat in [pf1bit, pf4bit, pf8bit]) then begin
        MontarMascara (Bitmap);
        SaveBitmapsAsIconToFile (FileName, Bitmap, Mask);
      end
      else begin
        Bmp:= TBitmap.Create;
        try
          if TamanhoExato then
            Bmp.Assign (Bitmap)
          else
            DimensionarBitmap (Bitmap, Bmp, cTamanhoDefault, cTamanhoDefault, cteQuandoNecessario, True, True, clBlack);
          SetPixelFormat (Bmp, pf8bit);
          MontarMascara (Bmp);
          SaveBitmapsAsIconToFile (FileName, Bmp, Mask);
        finally
          Bmp.Free;
        end;
      end;
    finally
      Mask.Free;
    end;
  end;
end;





procedure MergeColorMask (Bitmap, BMColor, BMMask: TBitmap);
type
  PLine08= ^TLine08;
  PLine24= ^TLine24;
  TLine08= array[0..0] of Byte;
  TLine24= array[0..0] of TRGBTriple;

var
  Entries: array[Byte] of TPaletteEntry;
  Black  : Byte;
  X, Y   : Integer;
  MLine  : PLine08;
  BLine  : PLine24;
  CLine  : PLine24;
  Color  : TRGBTriple;

begin
  if Assigned (Bitmap) and Assigned (BMColor) and Assigned (BMMask) and (BMMask.PixelFormat = pf1bit) then begin
    GetPaletteEntries (BMMask.Palette, 0, 2, Entries);
    if (Entries[0].peRed = 0) and (Entries[0].peGreen = 0) and (Entries[0].peBlue = 0) then
      with Color do begin
        rgbtRed  := Entries[1].peRed;
        rgbtGreen:= Entries[1].peGreen;
        rgbtBlue := Entries[1].peBlue;
      end
    else
      with Color do begin
        rgbtRed  := Entries[0].peRed;
        rgbtGreen:= Entries[0].peGreen;
        rgbtBlue := Entries[0].peBlue;
      end;
    Bitmap.PixelFormat := pf24bit;
    BMColor.PixelFormat:= pf24bit;
    BMMask.PixelFormat := pf8bit;
    Black              := GetNearestPaletteIndex (BMMask.Palette, 0);
    for Y:= 0 to Abs (Bitmap.Height)-1 do begin
      CLine:= BMColor.ScanLine[Y];
      MLine:= BMMask.ScanLine[Y];
      BLine:= Bitmap.ScanLine[Y];
      for X:= 0 to Bitmap.Width-1 do
        if MLine[X] = Black then
          BLine[X]:= CLine[X]
        else
          BLine[X]:= Color;
    end;
  end;
end;




//----------------------------------------------------------------------------------------------
constructor TCursorIcon.Create (AColor: TColor);

begin
  inherited Create;

  AColor:= Graphics.ColorToRGB (AColor);
  Mask  := TBitmap.Create;
  with Color do begin
    rgbRed     := GetRValue (AColor);
    rgbGreen   := GetGValue (AColor);
    rgbBlue    := GetBValue (AColor);
    rgbReserved:= 0;
  end;
end;





destructor TCursorIcon.Destroy;

begin
  Mask.Free;

  inherited Destroy;
end;





procedure TCursorIcon.Read (var Buffer; Count: Integer);
var
  Lidos: Integer;

begin
  Lidos:= Stream.Read (Buffer, Count);
  if Lidos <> Count then
    raise EInvalidImage.Create (Format ('CURSOR/ICON read error at %.8xH (%d byte(s) expected, but %d read)', [Stream.Position-Lidos, Count, Lidos]));
end;





procedure TCursorIcon.ReadStream (AStream: TStream);

begin
  Stream:= AStream;
  if Stream.Size > 0 then begin
    DumpHeader;
    DumpImage;
  end
  else begin
    Assign (nil);
    Mask.Assign (nil);
  end;
end;





procedure TCursorIcon.DumpHeader;
var
  CursorOrIcon: TCursorOrIcon;
  Entry       : TIconDirectoryEntry;

begin
  Read (CursorOrIcon, Sizeof (TCursorOrIcon));
  if (CursorOrIcon.cdReserved = 0) and (CursorOrIcon.cdType in [1, 2]) then begin
    Read (Entry, Sizeof (TIconDirectoryEntry));
    {if CursorOrIcon.cdCount > 1 then
      Stream.Seek (CursorOrIcon.cdCount*Sizeof (TIconDirectoryEntry), soFromCurrent);}
    Stream.Seek (Entry.dwImageOffset, soFromBeginning);
    Cursor:= CursorOrIcon.cdType = 2;
    if Cursor then
      Hotspot:= Point (Entry.wPlanes, Entry.wBitCount);
  end
  else
    raise EUnsupportedImage.Create ('Unsupported file format !');
end;





procedure TCursorIcon.DumpImage;
const
  cBlack: Integer= $00000000;

var
  Size            : Integer;
  BMMaskSize      : Integer;
  BitmapFileHeader: TBitmapFileHeader;
  BitmapInfoHeader: TBitmapInfoHeader;
  Local           : TMemoryStream;

begin
  Read (BitmapInfoHeader, SizeOf (TBitmapInfoHeader));
  Local:= TMemoryStream.Create;
  try
    // BMColor
    with BitmapInfoHeader do begin
      Size      := 0;
      biHeight  := Abs (biHeight div 2);
      BMMaskSize:= BytesPerScanLine (biWidth, 1, 32)*biHeight;
      Dec (biSizeImage, BMMaskSize);
      if biBitCount <= 8 then begin
        if biClrUsed = 0 then
          Inc (Size, (1 shl biBitCount)*SizeOf (TRGBQuad))
        else
          Inc (Size, biClrUsed*SizeOf (TRGBQuad));
      end
      else if (biCompression and BI_BITFIELDS) <> 0 then
        Inc (Size, 12);
    end;
    with BitmapFileHeader do begin
      bfType     := $4D42;
      bfOffBits  := SizeOf (TBitmapFileHeader) + SizeOf (TBitmapInfoHeader) + Size;
      bfReserved1:= 0;
      bfReserved2:= 0;
      bfSize     := bfOffBits + BitmapInfoHeader.biSizeImage;
    end;
    Local.Write (BitmapFileHeader, SizeOf (TBitmapFileHeader));
    Local.Write (BitmapInfoHeader, SizeOf (TBitmapInfoHeader));
    Local.CopyFrom (Stream, Size + BitmapInfoHeader.biSizeImage);
    Local.Seek (0, soFromBeginning);
    inherited LoadFromStream (Local);

    // BMMask
    Local.Clear;
    with BitmapFileHeader do begin
      bfType     := $4D42;
      bfOffBits  := SizeOf (TBitmapFileHeader) + SizeOf (TBitmapInfoHeader) + 8;
      bfReserved1:= 0;
      bfReserved2:= 0;
      bfSize     := bfOffBits + BMMaskSize;
    end;
    with BitmapInfoHeader do begin
      biPlanes      := 1;
      biBitCount    := 1;
      biCompression := BI_RGB;
      biSizeImage   := BMMaskSize;
      biClrUsed     := 2;
      biClrImportant:= 2;
    end;
    Local.Write (BitmapFileHeader, SizeOf (TBitmapFileHeader));
    Local.Write (BitmapInfoHeader, SizeOf (TBitmapInfoHeader));
    Local.Write (cBlack, 4);
    Local.Write (Color, 4);
    Local.CopyFrom (Stream, BMMaskSize);
    Local.Seek (0, soFromBeginning);
    Mask.LoadFromStream (Local);
  finally
    Local.Free;
  end;
end;





function TCursorIcon.IsValid (const FileName: String): Boolean;
var
  Local : TStream;
  Header: TIconDirectory;

begin
  Result:= False;
  if FileExists (FileName) then begin
    Local:= TFileStream.Create (FileName, fmOpenRead);
    try
      Result:= (Local.Read (Header, SizeOf (TIconDirectory)) = SizeOf (TIconDirectory)) and (Header.cdReserved = 0) and (Header.cdType in [1, 2]);
      Cursor:= Header.cdType = 2;
    finally
      Local.Free;
    end;
  end;
end;





procedure TCursorIcon.LoadFromStream (Stream: TStream);

begin
  if Assigned (Stream) then
    ReadStream (Stream);
end;

end.
