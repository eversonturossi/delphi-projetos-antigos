// Wheberson Hudson Migueletti, em Brasília.
// Internet  : http://www.geocities.com/whebersite
// E-mail    : whebersite@zipmail.com.br
// Referência: [1] PCX - Technical Reference Manual
// Codificação/Descodificação de arquivos ".pcx" (PC Paintbrush)

unit DelphiPCX;

interface

uses Windows, SysUtils, Classes, Graphics, DelphiImage;

type
  TPCXRGBType= (Red, Green, Blue);
  TPCXRGBColor= array[TPCXRGBType] of Byte;
  TPCXPaleta16= array[0..15] of TPCXRGBColor;
  TPCXPaleta256= array[0..255] of TPCXRGBColor;

  PPCXHeader= ^TPCXHeader;
  TPCXHeader= packed record
    Manufacturer: Byte;                 // 10
    Version     : Byte;                 // 0, 2, 3, e 5
    Enconding   : Byte;
    BitsPerPixel: Byte;                 // Bits per pixel per plane (1= 4-bit, 8= 8-bit)
    XMin        : Word;
    YMin        : Word;
    XMax        : Word;
    YMax        : Word;
    HRes        : Word;
    VRes        : Word;
    ColorMap    : TPCXPaleta16;
    Reserved    : Byte;
    NPlanes     : Byte;                 // 4=4-bit, 1=8-bit
    BytesPerLine: Word;                 // Bytes per scan line per plane
    PaletteInfo : Word;                 // 1=color/BW, 2=grayscale
    Filler      : array[0..57] of Byte;
  end;

  TPCXEncoder= class
    private
      Old  : Byte;
      Count: Byte;
    protected
      BitsPerPixel : Integer;
      BytesPerLine : Integer;
      PaletteLength: Integer;
      Stream       : TStream;

      procedure WritePalette (Bitmap: TBitmap);
      procedure Flush;
      procedure WriteValue (Value, Count: Byte);
      procedure EncodeValue (Current: Byte);
      procedure WriteImage24b (Bitmap: TBitmap);
      procedure WriteImage8b (Bitmap: TBitmap);
    public
      constructor Create (AStream: TStream); 
      procedure   Encode (Bitmap: TBitmap);
  end;

  TPCX= class (TBitmap)
    protected       
      BitsPerPixel: Byte;
      NPlanes     : Byte;
      Version     : Byte;
      BytesPerLine: Integer;
      LogPalette  : TMaxLogPalette;
      Stream      : TStream;

      procedure Read (var Buffer; Count: Integer);
      procedure InitializePalette;
      procedure SetPalette;
      procedure DumpHeader;
      procedure DumpPalette;
      procedure Dump24b;
      procedure Dump8b;
      procedure Dump4b;
      procedure DumpImage;
      procedure ReadStream (AStream: TStream);
    public
      function  IsValid (const FileName: String): Boolean;
      procedure LoadFromStream (Stream: TStream); override;
      procedure LoadFromFile (const FileName: String); override;
  end;

implementation

const
  cMask= $C0; // 11000000

type
  PLine= ^TLine;
  TLine= array[0..0] of Byte;





constructor TPCXEncoder.Create (AStream: TStream);

begin
  inherited Create;

  Stream:= AStream;
end;





procedure TPCXEncoder.Encode (Bitmap: TBitmap);
var
  BitmapInfo: Windows.TBitmap;
  Header    : TPCXHeader;

begin
  if not Bitmap.Empty then begin
    GetObject (Bitmap.Handle, SizeOf (Windows.TBitmap), @BitmapInfo);

    FillChar (Header, SizeOf (TPCXHeader), #0);
    with Header do begin
      if BitmapInfo.bmBitsPixel = 24 then begin
        BitsPerPixel:= 8;
        NPlanes     := 3;
      end
      else begin
        BitsPerPixel:= BitmapInfo.bmBitsPixel;
        NPlanes     := 1;
      end;
      Manufacturer:= 10;
      Version     := 5;
      Enconding   := 1;
      XMin        := 0;
      YMin        := 0;
      XMax        := Bitmap.Width-1;
      YMax        := Bitmap.Height-1;
      BytesPerLine:= BytesPerScanLine (Bitmap.Width, BitmapInfo.bmBitsPixel, 32) div NPlanes; // Bytes per scan line per plane
      PaletteInfo := 1;
    end;
    Stream.Write (Header, SizeOf (TPCXHeader));

    BitsPerPixel := BitmapInfo.bmBitsPixel;
    PaletteLength:= 1 shl BitsPerPixel;
    BytesPerLine := BytesPerScanLine (Bitmap.Width, BitmapInfo.bmBitsPixel, 32);

    if BitsPerPixel = 24 then
      WriteImage24b (Bitmap)
    else
      WriteImage8b (Bitmap);

    WritePalette (Bitmap);
  end;
end;





procedure TPCXEncoder.WritePalette (Bitmap: TBitmap);
var
  SaveIgnorePalette: Boolean;
  I                : Byte;
  Palette          : array[Byte] of TPaletteEntry;
  Header           : TPCXHeader;

begin
  if BitsPerPixel <= 8 then begin
    SaveIgnorePalette   := Bitmap.IgnorePalette;
    Bitmap.IgnorePalette:= False; // Do contrário pode vir uma paleta vazia !!!
    FillChar (Palette, PaletteLength*SizeOf (TPaletteEntry), #0);
    if GetPaletteEntries (Bitmap.Palette, 0, PaletteLength, Palette) = 0 then
      if PaletteLength = 2 then
        FillChar (Palette[1], 3, #255)
      else
        GetPaletteEntries (GetStockObject (DEFAULT_PALETTE), 0, PaletteLength, Palette);
    Bitmap.IgnorePalette:= SaveIgnorePalette;
    if BitsPerPixel <= 4 then begin
      Stream.Seek (0, soFromBeginning);
      Stream.Read (Header, SizeOf (TPCXHeader));
      for I:= 0 to PaletteLength-1 do begin
        Header.ColorMap[I, Red]  := Palette[I].peRed;
        Header.ColorMap[I, Green]:= Palette[I].peGreen;
        Header.ColorMap[I, Blue] := Palette[I].peBlue;
      end;
      Stream.Seek (0, soFromBeginning);
      Stream.Write (Header, SizeOf (TPCXHeader));
    end
    else begin
      I:= 12;
      Stream.Seek (0, soFromEnd);
      Stream.Write (I, 1);
      for I:= 0 to PaletteLength-1 do begin
        Stream.Write (Palette[I].peRed, 1);
        Stream.Write (Palette[I].peGreen, 1);
        Stream.Write (Palette[I].peBlue, 1);
      end;
    end;
  end;
end;





procedure TPCXEncoder.WriteValue (Value, Count: Byte);

begin
  if (Count > 1) or ((Count = 1) and (Value >= cMask)) then begin // Valores repetidos ou o valor ultrapassa a "máscara"
    Inc (Count, cMask);
    Stream.Write (Count, 1);
  end;
  Stream.Write (Value, 1);
end;





procedure TPCXEncoder.EncodeValue (Current: Byte);

begin
  if Current = Old then begin
    Inc (Count);
    if Count = 63 then begin // if (Count+cMask) = 255 then
      WriteValue (Old, Count);
      Count:= 0;
    end;
  end
  else begin
    if Count > 0 then
      WriteValue (Old, Count);
    Count:= 1;
    Old  := Current;
  end;
end;





procedure TPCXEncoder.Flush;

begin
  if Count > 0 then
    WriteValue (Old, Count);
  Count:= 0;
end;





procedure TPCXEncoder.WriteImage24b (Bitmap: TBitmap);
type
  PLine= ^TLine;
  TLine= array[0..0] of Byte;

var
  BytesPerPlane: Integer;
  X, Y         : Integer;
  Line         : PLine;

begin
  Stream.Seek (SizeOf (TPCXHeader), soFromBeginning);
  BytesPerPlane:= BytesPerLine div 3;
  Line         := Bitmap.ScanLine[0];
  Count        := 1;
  X            := 0;
  Old          := Line[X*3 + 2];
  for X:= 1 to BytesPerPlane-1 do
    EncodeValue (Line[X*3 + 2]);
  for X:= 0 to BytesPerPlane-1 do
    EncodeValue (Line[X*3 + 1]);
  for X:= 0 to BytesPerPlane-1 do
    EncodeValue (Line[X*3]);
  for Y:= 1 to Bitmap.Height-1 do begin
    Line:= Bitmap.ScanLine[Y];
    for X:= 0 to BytesPerPlane-1 do
      EncodeValue (Line[X*3 + 2]);
    for X:= 0 to BytesPerPlane-1 do
      EncodeValue (Line[X*3 + 1]);
    for X:= 0 to BytesPerPlane-1 do
      EncodeValue (Line[X*3]);
  end;
  Flush;
end;





procedure TPCXEncoder.WriteImage8b (Bitmap: TBitmap);
type
  PLine= ^TLine;
  TLine= array[0..0] of Byte;

var
  X, Y: Integer;
  Line: PLine;

begin
  Stream.Seek (SizeOf (TPCXHeader), soFromBeginning);
  Count:= 1;
  Line := Bitmap.ScanLine[0];
  Old  := Line[0];
  for X:= 1 to BytesPerLine-1 do
    EncodeValue (Line[X]);
  for Y:= 1 to Bitmap.Height-1 do begin
    Line:= Bitmap.ScanLine[Y];
    for X:= 0 to BytesPerLine-1 do
      EncodeValue (Line[X]);
  end;
  Flush;
end;




//----------------------------------------------------------------------------------------------
procedure TPCX.Read (var Buffer; Count: Integer);
var
  Lidos: Integer;

begin
  Lidos:= Stream.Read (Buffer, Count);
  if Lidos <> Count then
    raise EInvalidImage.Create (Format ('PCX read error at %.8xH (%d byte(s) expected, but %d read)', [Stream.Position-Lidos, Count, Lidos]));
end;





procedure TPCX.InitializePalette;
var
  Tripla: Word;
  Count : Integer;

begin
  { Version: 0 = Version 2.5
             2 = Version 2.8 with palette information
             3 = Version 2.8 without palette information
             5 = Version 3.0 }

  if BitsPerPixel <= 4 then begin
    if Version <> 3 then begin
      // Para evitar de se encontrar uma paleta zerada
      Count:= 0;
      for Tripla:= 0 to 15 do
        Inc (Count, Integer (LogPalette.palPalEntry[Tripla]));
      if Count = 0 then
        Version:= 3;
    end;
  end;
  if Version = 3 then begin // Não declara paleta
    if BitsPerPixel = 1 then begin
      FillChar (LogPalette.palPalEntry[0], 3, #$00);
      FillChar (LogPalette.palPalEntry[1], 3, #$FF);
    end
    else
      with LogPalette do
        GetPaletteEntries (GetStockObject (DEFAULT_PALETTE), 0, palNumEntries, palPalEntry);
  end;
end;





procedure TPCX.SetPalette;

begin
  Palette:= CreatePalette (PLogPalette (@LogPalette)^);
end;


// NPlanes: 1; BPP: 1, 4, 8, 24
// NPlanes: 4; BPP: 4
// NPlanes: 3; BPP: 24
procedure TPCX.DumpHeader;
var
  Tripla: Byte;
  Header: TPCXHeader;

begin
  Read (Header, SizeOf (TPCXHeader));
  if Header.Manufacturer = 10 then begin
    Width        := (Header.XMax-Header.XMin) + 1;
    Height       := (Header.YMax-Header.YMin) + 1;
    BytesPerLine := Header.BytesPerLine;
    NPlanes      := Header.NPlanes;
    Version      := Header.Version;
    BitsPerPixel := Header.BitsPerPixel*Header.NPlanes;
    IgnorePalette:= BitsPerPixel > 8;
    case BitsPerPixel of
      1: PixelFormat:= pf1bit;
      4: PixelFormat:= pf4bit;
      8: PixelFormat:= pf8bit;
    else
      PixelFormat:= pf24bit;
    end;
    with LogPalette do begin
      FillChar (palPalEntry[0], 256, #0);
      palVersion:= $0300;
      if BitsPerPixel <= 8 then begin
        LogPalette.palNumEntries:= 1 shl BitsPerPixel;
        if BitsPerPixel <= 4 then
          for Tripla:= 0 to LogPalette.palNumEntries-1 do
            with LogPalette.palPalEntry[Tripla] do begin
              peRed  := Header.ColorMap[Tripla, Red];
              peGreen:= Header.ColorMap[Tripla, Green];
              peBlue := Header.ColorMap[Tripla, Blue];
            end;
      end
      else
        LogPalette.palNumEntries:= 0;
    end;
  end
  else
    raise EUnsupportedImage.Create ('Unsupported file format !');
end;





procedure TPCX.DumpPalette;
var
  Flag        : Byte;
  Tripla      : Byte;
  SavePosition: Integer;
  RGB         : TPCXRGBColor;

begin
  if (BitsPerPixel = 8) and (Stream.Size >= 769) then begin
    SavePosition:= Stream.Position;
    try
      Stream.Seek (-769, soFromEnd);
      Read (Flag, 1);
      if Flag = 12 then
        for Tripla:= 0 to 255 do begin
          Read (RGB, SizeOf (TPCXRGBColor));
          with LogPalette.palPalEntry[Tripla] do begin
            peRed  := RGB[Red];
            peGreen:= RGB[Green];
            peBlue := RGB[Blue];
          end;
        end;
    finally
      Stream.Seek (SavePosition, soFromBeginning);
    end;
  end;
end;

{ Exemplo:
  Width       = 4
  Planes      = 3
  BitsPerPixel= 24
  Fórmula     = 3*X + Plano


          0           4           8
     PCX: B0 B1 B2 B3 G0 G1 G2 G3 R0 R1 R2 R3
          -  -  -  -  -  -  -  -  -  -  -  -
Plano     -  -  -  -  -  -  -  -  -  -  -  -
2         -  -  B0 -  -  B1 -  -  B2 -  -  B3
1         -  G0 -  -  G1 -  -  G2 -  -  G3 -
0         R0 -  -  R1 -  -  R2 -  -  R3 -  -
          -  -  -  -  -  -  -  -  -  -  -  -
          -  -  -  -  -  -  -  -  -  -  -  -
          -  -  -  -  -  -  -  -  -  -  -  -
          -  -  -  -  -  -  -  -  -  -  -  -
     BMP: R0 G0 B0 R1 G1 B1 R2 G2 B2 R3 G3 B3
}

procedure TPCX.Dump24b;
var
  Atual  : Byte;
  Altura : Integer;
  Largura: Integer;
  X, Y   : Integer;
  Line   : PLine;
  Plano  : ShortInt;

 // A ordem no PCX é R-G-B mas no BMP é B-G-R
 procedure Inserir;

 begin
   if X < Largura then // Pode ocorrer "BytesPerLine > Width"
     Line[(X+X+X) + Plano]:= Atual;
   Inc (X);
   if X = BytesPerLine then begin
     X:= 0;
     if Plano > 0 then
       Dec (Plano)
     else begin
       Plano:= 2;
       Inc (Y);
       if Y < Altura then
         Line:= ScanLine[Y];
     end;
   end;
 end;

var
  Contador, K: Byte;

begin
  X      := 0;
  Y      := 0;
  Altura := Height;
  Largura:= Width;
  Line   := ScanLine[Y];
  Plano  := 2;
  while Y < Altura do begin
    Read (Atual, 1);
    if Atual >= cMask then begin
      Contador:= Atual and (not cMask);
      Read (Atual, 1);
      for K:= 1 to Contador do
        Inserir;
    end
    else
      Inserir;
  end;
end;





procedure TPCX.Dump8b;
var
  Atual  : Byte;
  Altura : Integer;
  Largura: Integer;
  X, Y   : Integer;
  Line   : PLine;

 procedure Inserir;

 begin
   if X < Largura then // Pode ocorrer "BytesPerLine > Width"
     Line[X]:= Atual;
   Inc (X);
   if X = BytesPerLine then begin
     X:= 0;
     Inc (Y);
     if Y < Altura then
       Line:= ScanLine[Y];
   end;
 end;

var
  Contador, K: Byte;

begin
  X      := 0;
  Y      := 0;
  Altura := Height;
  Largura:= Width;
  Line   := ScanLine[Y];
  while Y < Altura do begin
    Read (Atual, 1);
    if Atual >= cMask then begin
      Contador:= Atual and (not cMask);
      Read (Atual, 1);
      for K:= 1 to Contador do
        Inserir;
    end
    else
      Inserir;
  end;
end;




// Os Planos estão na ordem: Plano3 Plano2 Plano1 Plano0
procedure TPCX.Dump4b;
var
  Atual  : Byte;
  Altura : Integer;
  Largura: Integer;
  X, Y   : Integer;
  Line   : PLine;
  Plano  : ShortInt;

 procedure Inserir;
 var
   B     : Byte;
   Bit   : Byte;
   Offset: Integer;

 begin
   if X < Largura then begin// Pode ocorrer "BytesPerLine > Width"
     Offset:= X+X+X+X;
     Bit   := 0;
     while Bit < 8 do begin
       // Primeiro "NIBBLE"
       B           := Atual shl Bit;
       Line[Offset]:= Line[Offset] or ((B and 128) shr Plano);

       // Segundo "NIBBLE"
       Line[Offset]:= Line[Offset] or (((B shr 3) and 8) shr Plano);
       Inc (Bit, 2);
       Inc (Offset);
     end;
   end;
   Inc (X);
   if X = BytesPerLine then begin
     X:= 0;
     if Plano > 0 then
       Dec (Plano)
     else begin
       Plano:= 3;
       Inc (Y);
       if Y < Altura then begin
         Line:= ScanLine[Y];
         FillChar (Line[0], Largura shr 1, #0);
       end;
     end;
   end;
 end;

var
  Contador, K: Byte;

begin
  X      := 0;
  Y      := 0;
  Plano  := 3;
  Altura := Height;
  Largura:= Width;
  Line   := ScanLine[Y];
  FillChar (Byte (ScanLine[0]^), Largura div 2, #0);
  while Y < Altura do begin
    Read (Atual, 1);
    if Atual >= cMask then begin
      Contador:= Atual and (not cMask);
      Read (Atual, 1);
      for K:= 1 to Contador do
        Inserir;
    end
    else
      Inserir;
  end;
end;





procedure TPCX.DumpImage;

begin
  if NPlanes = 1 then
    Dump8b
  else
    case BitsPerPixel of
      1, 8: Dump8b;
      4   : Dump4b;
      24  : Dump24b;
    end;
end;





procedure TPCX.ReadStream (AStream: TStream);

begin
  Stream:= AStream;
  if Stream.Size > 0 then begin
    DumpHeader;
    InitializePalette;
    DumpPalette;
    SetPalette;
    DumpImage;
  end;
end;





function TPCX.IsValid (const FileName: String): Boolean;
var
  Header: TPCXHeader;
  Local : TStream;

begin
  Result:= False;
  if FileExists (FileName) then begin
    Local:= TFileStream.Create (FileName, fmOpenRead);
    try
      Result:= (Local.Read (Header, SizeOf (TPCXHeader)) = SizeOf (TPCXHeader)) and (Header.Manufacturer = 10);
    finally
      Local.Free;
    end;
  end;
end;





procedure TPCX.LoadFromStream (Stream: TStream);

begin
  if Assigned (Stream) then
    ReadStream (Stream);
end;




// Se "TPCX.LoadFromFile" não for definido "TGraphic" chama "TPCX.LoadFromStream" com "TFileStream"
procedure TPCX.LoadFromFile (const FileName: String);
var
  Stream: TStream;

begin
  Stream:= TMemoryStream.Create;
  try
    TMemoryStream (Stream).LoadFromFile (FileName);
    Stream.Seek (0, soFromBeginning);
    ReadStream (Stream);
  finally
    Stream.Free;
  end;
end;

initialization
  TPicture.RegisterFileFormat ('PCX', 'PCX - PC Paintbrush', TPCX);
finalization
  TPicture.UnRegisterGraphicClass (TPCX);
end.
