{ Wheberson Hudson Migueletti, em Brasília, 25 de março de 1999.
  Internet   : http://www.geocities.com/whebersite
  E-mail     : whebersite@zipmail.com.br
  Atualização: 02/06/2001
  Referências: 1) GRAPHICS INTERCHANGE FORMAT(sm) - Version 89a - Specification
               2) Data Compression Reference Center
                  http://www.rasip.fer.hr/research/compress
               3) California Technical Publishing Data Compression
                  http://www.dspguide.com/datacomp.htm
               4) Mark Nelson's Home Page - LZW
                  http://www.dogma.net/markn/articles/lzw/lzw.htm
               5) InfoSite - LZW
                  http://luke.megagis.lt/lzw.htm
               6) GIF.HTM - Alexander Larkin
                  http://larkin.spa.umn.edu/index.htm
}

unit DelphiGIF;

interface

uses Windows, SysUtils, Classes, Graphics, DelphiImage;

type
  PGIFPalette= ^TGIFPalette;
  TGIFPalette= array[0..255] of TRGB;

  PScreenDescriptor= ^TScreenDescriptor;
  TScreenDescriptor= packed record
    Signature           : array[0..2] of Char; // "GIF"
    Version             : array[0..2] of Char; // "87a" ou "89a"
    ScreenWidth         : Word;
    ScreenHeight        : Word;
    PackedFields        : Byte;
    BackgroundColorIndex: Byte;
    PixelAspectRatio    : Byte;
  end;

  PImageDescriptor= ^TImageDescriptor;
  TImageDescriptor= packed record
    ImageLeft   : Word;
    ImageTop    : Word;
    ImageWidth  : Word;
    ImageHeight : Word;
    PackedFields: Byte; // Se NÃO existir a Paleta Local deve-se utilizar a Global
  end;

  PGraphicExtension= ^TGraphicExtension;
  TGraphicExtension= packed record
    BlockSize            : Byte;
    PackedFields         : Byte;
    DelayTime            : Word;
    TransparentColorIndex: Byte;
    BlockTerminator      : Byte;
  end;

  PGIFInfo= ^TGIFInfo;
  TGIFInfo= record
    Interlaced           : Boolean;
    Transparent          : Boolean;
    DisposalMethod       : Byte;
    TransparentColorIndex: Byte;
    Height               : Integer;
    Width                : Integer;
    Comment              : String;
    Origin               : TPoint;
    DelayTime            : Word;
    PaletteLength        : Word;
  end;

  TGIFDecoder= class
    protected
      GIFBitsPerPixel: Integer;
      Bitmap         : TBitmap;
      Info           : TGIFInfo;
      GIFPalette     : TGIFPalette;
      Frames         : TList;
      Stream         : TStream;

      procedure Read (var Buffer; Count: Integer);
      procedure ColorMapToPalette (var Palette: HPalette; PaletteLength: Word);
      procedure DumpPalette (PaletteLength: Word);
      procedure DumpScreenDescriptor;
      procedure DumpImageDescriptor;
      procedure DumpGraphicControlExtension;
      procedure DumpCommentExtension;
      procedure DumpApplicationExtension;
      procedure DumpExtension;
      procedure DumpBlockTerminator;
      procedure DumpImage (Width, Height: Integer; Interlaced: Boolean);
      procedure SkipImage (FirstImageOnly: Boolean);
      procedure ClearInfo;
    public
      BackgroundColorIndex: Byte;
      GlobalPalette       : HPalette;
      Count               : Integer;
      GlobalPaletteLength : Integer;
      ScreenHeight        : Integer;
      ScreenWidth         : Integer;
      TrailingComment     : String;
      BackgroundColor     : TRGB;
      Loops               : Word;

      constructor Create (AStream: TStream);
      destructor  Destroy; override;
      procedure   Clear;
      procedure   Load (FirstImageOnly: Boolean);
      procedure   GetFrame (AIndex: Integer; ABitmap: TBitmap; var AInfo: TGIFInfo);
  end;

  TGIFEncoder= class
    protected
      GlobalPalette  : HPalette;
      BitsPerPixel   : Integer;
      TrailingComment: String;
      Bitmap         : TBitmap;
      Stream         : TStream;

      procedure WriteLoops (Count: Word);
      procedure WriteComment (const Comment: String);
      procedure WritePalette (Palette: HPalette; PaletteLength: Integer);
      procedure WriteImage;
    public
      constructor Create (AStream: TStream);
      destructor  Destroy; override;
      procedure   Encode   (AScreenWidth, AScreenHeight: Integer; ALoops: Word; ABackgroundColorIndex: Byte; AGlobalPalette: HPalette; ATrailingComment: String);
      procedure   AddImage (ABitmap: TBitmap; ALocalPalette: HPalette; ALeft, ATop: Integer);
      procedure   Add      (ABitmap: TBitmap; ALocalPalette: HPalette; ALeft, ATop: Integer; ADelayTime: Word; ADisposalMethod: Byte; ATransparent: Boolean; ATransparentColorIndex: Byte; const AComment: String);
  end;

  TGIF= class (TBitmap)
    public
      function  IsValid        (const FileName: String): Boolean;
      procedure LoadFromStream (Stream: TStream); override;
  end;

implementation

const
  // Usado quando a imagem está entrelaçada
  cYInc: array[1..4] of Byte= (8, 8, 4, 2); // As linhas de cada grupo (são 4) são incrementadas de acordo com este vetor 
  cYLin: array[1..4] of Byte= (0, 4, 2, 1); // Linha inicial de cada grupo

type
  PLine= ^TLine;
  TLine= array[0..0] of Byte;

  TCelula= record
    Prefixo: Word;
    Sufixo : Byte;
  end;

  PGIFFrame1= ^TGIFFrame1;
  TGIFFrame1= record
    Offset: Integer;
    Info  : TGIFInfo;
  end;

  TLZWTable= class
    protected
      Tabela : array[0..4097] of TCelula;
      Tamanho: Integer;
      Maximo : Word;
    public
      constructor Create;
      procedure   Initialize (AMax: Word);
      procedure   Add        (Prefix: Word; Suffix: Byte);
      function    Get        (Index: Word; var Suffix: Byte): Integer;
      function    Find       (Prefix: Word; Suffix: Byte)   : Integer;
  end;

  TGIFLZWDecoder= class
    private
      Count       : Integer;
      Offset      : Integer; // "Offset" na "Stream/Buffer" (em relação aos "bits")
      StartPos    : Integer;
      Dictionary  : TLZWTable;
      ClearCode   : Word;
      Code        : Word;
      CodeSize    : Word;
      EOFCode     : Word;
      FreeCode    : Word;    // Indica quando é que "CodeSize" será incrementado
      InitCodeSize: Word;
      InitFreeCode: Word;
      MaxCode     : Word;
      ReadMask    : Word;
    protected
      procedure GetNextCode;
      procedure Write (Value: Byte); virtual; abstract;
    public
      constructor Create (ACodeSize: Byte);
      destructor  Destroy; override;
      procedure   Execute (AStream: TMemoryStream; ACount: Integer);
  end;

  TGIFLZWDecoder_NotInterleaved= class (TGIFLZWDecoder)
    protected
      Height: Integer;
      Width : Integer;
      X, Y  : Integer;
      Line  : PLine;
      Bitmap: TBitmap;

      procedure Write (Value: Byte); override;
    public
      constructor Create (ABitmap: TBitmap; AWidth, AHeight: Integer; ACodeSize: Byte);
  end;

  TGIFLZWDecoder_Interleaved= class (TGIFLZWDecoder)
    protected
      Group : Byte;
      Height: Integer;
      Width : Integer;
      X, Y  : Integer;
      Line  : PLine;
      Bitmap: TBitmap;

      procedure Write (Value: Byte); override;
    public
      constructor Create (ABitmap: TBitmap; AWidth, AHeight: Integer; ACodeSize: Byte);
  end;

var
  gInitTable: array[0..257] of TCelula;





procedure DestroyPalette (var Palette: HPalette);

begin
  try
    if Palette <> 0 then begin
      DeleteObject (Palette);
      Palette:= 0;
    end;
  except
    Palette:= 0;
  end;
end;




//----------------------------------------------------------------------------------------------
constructor TLZWTable.Create;

begin
  inherited Create;

  Move (gInitTable[0], Tabela[0], SizeOf (gInitTable));
end;





procedure TLZWTable.Initialize (AMax: Word);

begin
  Maximo := AMax;
  Tamanho:= Maximo + 1;
  with Tabela[Maximo] do begin
    Prefixo:= 0;
    Sufixo := 0;
  end;
end;





procedure TLZWTable.Add (Prefix: Word; Suffix: Byte);

begin
  Tabela[Tamanho].Prefixo:= Prefix;
  Tabela[Tamanho].Sufixo := Suffix;
  Inc (Tamanho);
end;





function TLZWTable.Get (Index: Word; var Suffix: Byte): Integer;

begin
  if Index < Tamanho then begin
    Suffix:= Tabela[Index].Sufixo;
    Result:= Tabela[Index].Prefixo;
  end
  else
    Result:= -1;
end;





function TLZWTable.Find (Prefix: Word; Suffix: Byte): Integer;
var
  P: Integer;

begin
  if Prefix = 0 then
    Result:= Suffix+1
  else begin
    Result:= -1;
    for P:= Maximo to Tamanho-1 do
      if (Tabela[P].Prefixo = Prefix) and (Tabela[P].Sufixo = Suffix) then begin
        Result:= P;
        Exit;
      end;
  end;
end;




//----------------------------------------------------------------------------------------------
constructor TGIFLZWDecoder.Create (ACodeSize: Byte);

begin
  inherited Create;

  CodeSize    := ACodeSize;
  ClearCode   := 1 shl CodeSize;
  EOFCode     := ClearCode + 1;
  InitFreeCode:= ClearCode + 2;
  FreeCode    := InitFreeCode;
  CodeSize    := CodeSize + 1;
  InitCodeSize:= CodeSize;
  MaxCode     := 1 shl InitCodeSize;
  ReadMask    := MaxCode-1;
  Offset      := 0;
  Code        := 0;
  Dictionary  := TLZWTable.Create;
end;





destructor TGIFLZWDecoder.Destroy;

begin
  Dictionary.Free;
  
  inherited Destroy;
end;





procedure TGIFLZWDecoder.GetNextCode;
var
  Position: Integer;

begin
  Position:= Offset shr 3;
  if Count < CodeSize then
    Code:= EOFCode
  else begin
    if CodeSize >= 8 then
      Code:= (PInteger (StartPos + Position)^ shr (Offset and 7)) and ReadMask
    else
      Code:= (PWord (StartPos + Position)^ shr (Offset and 7)) and ReadMask;
    Inc (Offset, CodeSize);
    Dec (Count, CodeSize);
  end;  
end;





procedure TGIFLZWDecoder.Execute (AStream: TMemoryStream; ACount: Integer);
var
  Aux      : Byte;
  Character: Byte;
  Prefix   : Integer;
  Old      : Word;

 // Ocorre quando é encontrado um "ClearCode"
 procedure Reinicializar;

 begin
   CodeSize:= InitCodeSize;
   FreeCode:= InitFreeCode;
   MaxCode := 1 shl InitCodeSize;
   ReadMask:= MaxCode-1;
 end;

 // Para encontrar um valor no Dicionário deve-se percorrê-lo em ordem inversa
 procedure BuscarOcorrencia (CurrentPrefix: Integer);
 const
   cMax= $0FFF;

 var
   Buffer: array[0..cMax] of Byte;
   I, J  : Integer;

 begin
   for I:= cMax downto 0 do begin
     CurrentPrefix:= Dictionary.Get (CurrentPrefix, Character);
     Buffer[I]    := Character;
     if CurrentPrefix = 0 then
       Break;
   end;
   for J:= I to cMax do
     Write (Buffer[J]);
 end;

begin
  StartPos:= Integer (AStream.Memory) + AStream.Position;
  Count   := ACount shl 3; // Converte para bits
  while True do begin
    Old:= Code + 1;
    GetNextCode;
    if Code = EOFCode then
      Break
    else if Code = ClearCode then begin
      Reinicializar;
      Dictionary.Initialize (InitFreeCode);
      GetNextCode;
      if Code = EOFCode then
        Break;
      Write (Code);
    end
    else begin
      Prefix:= Dictionary.Get (Code+1, Character);
      if Prefix = 0 then
        Write (Character)
      else if Prefix > 0 then begin
        Aux:= Character;
        BuscarOcorrencia (Prefix);
        Write (Aux);
      end
      else begin
        BuscarOcorrencia (Old);
        Write (Character);
      end;
      Dictionary.Add (Old, Character);
      Inc (FreeCode);
      if (FreeCode >= MaxCode) and (CodeSize < 12) then begin
        Inc (CodeSize);
        MaxCode := MaxCode shl 1;
        ReadMask:= MaxCode-1;
      end;
    end;
  end;
end;




//----------------------------------------------------------------------------------------------
constructor TGIFLZWDecoder_NotInterleaved.Create (ABitmap: TBitmap; AWidth, AHeight: Integer; ACodeSize: Byte);

begin
  inherited Create (ACodeSize);

  Bitmap:= ABitmap;
  Width := AWidth;
  Height:= AHeight;
  Line  := Bitmap.ScanLine[0];
  X     := 0;
  Y     := 0;
end;





procedure TGIFLZWDecoder_NotInterleaved.Write (Value: Byte);

begin
  Line[X]:= Value;
  Inc (X);
  if X = Width then begin
    X:= 0;
    Inc (Y);
    if Y < Height then
      Line:= Bitmap.ScanLine[Y];
  end;
end;




//----------------------------------------------------------------------------------------------
constructor TGIFLZWDecoder_Interleaved.Create (ABitmap: TBitmap; AWidth, AHeight: Integer; ACodeSize: Byte);

begin
  inherited Create (ACodeSize);

  Bitmap:= ABitmap;
  Width := AWidth;
  Height:= AHeight;
  Line  := Bitmap.ScanLine[0];
  X     := 0;
  Y     := 0;
  Group := 1;
end;





procedure TGIFLZWDecoder_Interleaved.Write (Value: Byte);

begin
  Line[X]:= Value;
  Inc (X);
  if X = Width then begin
    X:= 0;
    Y:= Y + cYInc[Group];
    if Y >= Height then begin // Terminou o grupo
      Inc (Group);
      if Group > 4 then
        Exit; 
      Y:= cYLin[Group];
      if Y >= Height then
        Exit;
    end;
    Line:= Bitmap.ScanLine[Y];
  end;
end;




//----------------------------------------------------------------------------------------------
constructor TGIFDecoder.Create (AStream: TStream);

begin
  inherited Create;

  Count := 0;
  Stream:= AStream;
  Frames:= TList.Create;
end;





destructor TGIFDecoder.Destroy;

begin
  DestroyPalette (GlobalPalette);
  Frames.Free;

  inherited Destroy;
end;





procedure TGIFDecoder.Read (var Buffer; Count: Integer);
var
  Lidos: Integer;

begin
  Lidos:= Stream.Read (Buffer, Count);
  if Lidos <> Count then
    raise EInvalidImage.Create (Format ('GIF read error at %.8xH (%d byte(s) expected, but %d read)', [Stream.Position-Lidos, Count, Lidos]));
end;





procedure TGIFDecoder.ColorMapToPalette (var Palette: HPalette; PaletteLength: Word);
var
  Tripla: Integer;
  LogPal: TMaxLogPalette;

begin
  if PaletteLength > 0 then begin
    DestroyPalette (Palette);
    with LogPal do begin
      palVersion   := $0300;
      palNumEntries:= PaletteLength;
      for Tripla:= 0 to palNumEntries-1 do
        with palPalEntry[Tripla] do begin
          peRed  := GIFPalette[Tripla].Red;
          peGreen:= GIFPalette[Tripla].Green;
          peBlue := GIFPalette[Tripla].Blue;
          peFlags:= 0;
        end;
    end;
    Palette:= CreatePalette (PLogPalette (@LogPal)^);
  end;
end;





procedure TGIFDecoder.DumpPalette (PaletteLength: Word);

begin
  if PaletteLength > 0 then
    Read (GIFPalette, PaletteLength*SizeOf (TRGB));
end;





procedure TGIFDecoder.DumpScreenDescriptor;
var
  Header: TScreenDescriptor;

begin
  Read (Header, SizeOf (TScreenDescriptor));
  if (Header.Signature = 'GIF') and ((Header.Version = '87a') or (Header.Version = '89a')) then begin
    ScreenWidth         := Header.ScreenWidth;
    ScreenHeight        := Header.ScreenHeight;
    GIFBitsPerPixel     := (Header.PackedFields and 7) + 1;
    BackgroundColorIndex:= Header.BackgroundColorIndex;
    if (Header.PackedFields and 128) <> 0 then
      GlobalPaletteLength:= 1 shl GIFBitsPerPixel
    else
      GlobalPaletteLength:= 0;
  end
  else
    raise EUnsupportedImage.Create ('Unsupported file format !');
end;





procedure TGIFDecoder.DumpImageDescriptor;
var
  ImgDescriptor: TImageDescriptor;

begin
  Read (ImgDescriptor, SizeOf (TImageDescriptor));
  Info.Width     := ImgDescriptor.ImageWidth;
  Info.Height    := ImgDescriptor.ImageHeight;
  Info.Origin    := Point (ImgDescriptor.ImageLeft, ImgDescriptor.ImageTop);
  Info.Interlaced:= (ImgDescriptor.PackedFields and 64) <> 0;
  if (ImgDescriptor.PackedFields and 128) <> 0 then begin
    GIFBitsPerPixel   := (ImgDescriptor.PackedFields and 7) + 1;
    Info.PaletteLength:= 1 shl GIFBitsPerPixel;
  end
  else
    Info.PaletteLength:= 0;
end;





procedure TGIFDecoder.DumpGraphicControlExtension;
var
  GraphicExtension: TGraphicExtension;

begin
  Read (GraphicExtension, SizeOf (TGraphicExtension));
  Info.DelayTime            := GraphicExtension.DelayTime;
  Info.DisposalMethod       := (GraphicExtension.PackedFields shr 2) and 7;
  Info.Transparent          := (GraphicExtension.PackedFields and 1) <> 0;
  Info.TransparentColorIndex:= GraphicExtension.TransparentColorIndex;
end;





procedure TGIFDecoder.DumpCommentExtension;
var
  Size: Byte;

begin
  Read (Size, 1); // "String Length" ou "Block Terminator"
  if Size > 0 then begin
    SetLength (Info.Comment, Size);
    Read (Info.Comment[1], Size);
    DumpBlockTerminator;
  end;
end;





procedure TGIFDecoder.DumpApplicationExtension;
var
  Id  : Byte;
  Size: Byte;
  App : array[0..10] of Char;

begin
  Read (Size, 1); // 11
  Read (App[0], 11);
  Read (Size, 1); // "Data Size" ou "Block Terminator"
  if Size > 0 then begin
    if (App = 'NETSCAPE2.0') and (Size = 3) then begin
      Read (Id, 1);
      if Id = 1 then
        Read (Loops, 2)
      else
        Stream.Seek (2, soFromCurrent);
      DumpBlockTerminator;
    end
    else
      Stream.Seek (Word (Size) + 1, soFromCurrent); // "Data" + "Block Terminator"
  end;
end;





procedure TGIFDecoder.DumpExtension;
var
  ExtensionLabel: Byte;

begin
  Read (ExtensionLabel, 1);
  case ExtensionLabel of
    $F9: DumpGraphicControlExtension;
    $FE: DumpCommentExtension;
    $FF: DumpApplicationExtension;
  else
    DumpBlockTerminator;
  end;
end;





procedure TGIFDecoder.DumpBlockTerminator;
var
  BlockSize: Byte;

begin
  while Stream.Position < Stream.Size do begin
    Read (BlockSize, 1);
    if BlockSize = 0 then
      Exit
    else
      Stream.Seek (BlockSize, soFromCurrent);
  end;
end;




// Desempacota/Descompacta(LZW) a imagem
procedure TGIFDecoder.DumpImage (Width, Height: Integer; Interlaced: Boolean);
var
  BlockSize: Byte;
  BPP      : Byte;
  Count    : Integer;
  Buffer   : PByte;
  Decoder  : TGIFLZWDecoder;
  Raster   : TMemoryStream;

begin
  Read (BPP, 1);
  if BPP > 0 then begin
    if Interlaced then
      Decoder:= TGIFLZWDecoder_Interleaved.Create (Bitmap, Width, Height, BPP)
    else
      Decoder:= TGIFLZWDecoder_NotInterleaved.Create (Bitmap, Width, Height, BPP);
    try
      Raster:= TMemoryStream.Create;
      try
        GetMem (Buffer, 255);
        try
          Count:= Stream.Size-Stream.Position;
          while Count > 0 do begin
            Read (BlockSize, 1); 
            if BlockSize > 0 then begin
              Stream.Read (Buffer^, BlockSize);
              Raster.Write (Buffer^, BlockSize);
            end
            else
              Break;
            Dec (Count, BlockSize);
          end;
        finally
          FreeMem (Buffer);
        end;
        Raster.Seek (0, soFromBeginning);
        Decoder.Execute (Raster, Raster.Size);
      finally
        Raster.Free;
      end;
    finally
      Decoder.Free;
    end;
  end;  
end;




// Table-Based Image
procedure TGIFDecoder.SkipImage (FirstImageOnly: Boolean);

 procedure SkipImageData;
 var
   BlockSize: Byte;

 begin
   Stream.Seek (1, soFromCurrent); // LZW Minimum Code Size
   while Stream.Position < Stream.Size do begin
     Read (BlockSize, 1);
     if BlockSize = 0 then
       Break
     else
       Stream.Seek (BlockSize, soFromCurrent);
   end;
 end;

var
  Frame: PGIFFrame1;

begin
  DumpImageDescriptor;
  Frame       := New (PGIFFrame1);
  Frame.Offset:= Stream.Position;
  Frame.Info  := Info;
  Frames.Add (Frame);
  if not FirstImageOnly then begin
    if Info.PaletteLength > 0 then
      Stream.Seek (Info.PaletteLength*SizeOf (TRGB), soFromCurrent);
    SkipImageData;
  end;
  ClearInfo;
end;





procedure TGIFDecoder.ClearInfo;

begin
  with Info do begin
    Interlaced           := False;
    Transparent          := False;
    DisposalMethod       := 0;
    TransparentColorIndex:= 0;
    Height               := 0;
    Width                := 0;
    Comment              := '';
    Origin               := Point (0, 0);
    DelayTime            := 0;
    PaletteLength        := 0;
  end;
end;





procedure TGIFDecoder.Clear;
var
  I: Integer;

begin
  Count          := 0;
  Loops          := 0;
  TrailingComment:= '';
  ClearInfo;
  for I:= 0 to Frames.Count-1 do
    Dispose (PGIFFrame1 (Frames[I]));
  Frames.Clear;
end;





procedure TGIFDecoder.Load (FirstImageOnly: Boolean);
var
  Separator: Char;

begin
  Clear;
  if Stream.Size > 0 then begin
    DumpScreenDescriptor;
    DumpPalette (GlobalPaletteLength);
    if GlobalPaletteLength > 0 then begin
      ColorMapToPalette (GlobalPalette, GlobalPaletteLength);
      BackgroundColor:= GIFPalette[BackgroundColorIndex];
    end;
    while Stream.Position < Stream.Size do begin
      Read (Separator, 1);
      case Separator of
        ',': begin
               SkipImage (FirstImageOnly);
               if FirstImageOnly then
                 Break;
             end;
        '!': DumpExtension;
        ';': begin
               if Info.Comment <> '' then
                 TrailingComment:= Info.Comment;
               Break;
             end;
      else
        Break;         
      end;
    end;
    Count:= Frames.Count;
  end;
end;





procedure TGIFDecoder.GetFrame (AIndex: Integer; ABitmap: TBitmap; var AInfo: TGIFInfo);
var
  Palette: HPalette;

begin
  if (AIndex >= 0) and (AIndex < Frames.Count) and Assigned (ABitmap) then begin
    AInfo               := PGIFFrame1 (Frames[AIndex])^.Info;
    Bitmap              := ABitmap;
    Bitmap.Width        := AInfo.Width;
    Bitmap.Height       := AInfo.Height;
    Bitmap.PixelFormat  := pf8bit;
    Bitmap.IgnorePalette:= False;
    Stream.Seek (PGIFFrame1 (Frames[AIndex])^.Offset, soFromBeginning);
    if AInfo.PaletteLength > 0 then begin
      DumpPalette (AInfo.PaletteLength);
      ColorMapToPalette (Palette, AInfo.PaletteLength);
      Bitmap.Palette:= Palette;
    end
    else
      Bitmap.Palette:= CopyPalette (GlobalPalette);
    DumpImage (AInfo.Width, AInfo.Height, AInfo.Interlaced);
  end;
end;




//----------------------------------------------------------------------------------------------
constructor TGIFEncoder.Create (AStream: TStream);

begin
  inherited Create;

  Stream         := AStream;
  Bitmap         := nil;
  GlobalPalette  := 0;
  BitsPerPixel   := 8;
  TrailingComment:= '';
end;





destructor TGIFEncoder.Destroy;
const
  cTrailer: Byte= $3B;

begin
  if (TrailingComment <> '') and (Trim (TrailingComment) <> '') then begin
    WriteComment (TrailingComment);
    Stream.Write (cTrailer, 1);
  end;
  try
    if GlobalPalette <> 0 then
      DeleteObject (GlobalPalette);
  except
  end;

  inherited Destroy;
end;





procedure TGIFEncoder.Encode (AScreenWidth, AScreenHeight: Integer; ALoops: Word; ABackgroundColorIndex: Byte; AGlobalPalette: HPalette; ATrailingComment: String);
var
  Header: TScreenDescriptor;

begin
  Bitmap                     := nil;
  TrailingComment            := ATrailingComment;
  Header.Signature           := 'GIF';
  Header.Version             := '89a';
  Header.ScreenWidth         := AScreenWidth;
  Header.ScreenHeight        := AScreenHeight;
  Header.PackedFields        := BitsPerPixel-1;
  Header.BackgroundColorIndex:= ABackgroundColorIndex;
  Header.PixelAspectRatio    := 0;
  
  DestroyPalette (GlobalPalette);
  if AGlobalPalette <> 0 then begin
    Header.PackedFields:= Header.PackedFields or 128;
    GlobalPalette:= CopyPalette (AGlobalPalette);
  end;

  // "Header"
  Stream.Write (Header, SizeOf (TScreenDescriptor));

  // "Global Color Map"
  if GlobalPalette <> 0 then
    WritePalette (GlobalPalette, 1 shl BitsPerPixel);

  if ALoops > 0 then
    WriteLoops (ALoops);
end;





procedure TGIFEncoder.WriteLoops (Count: Word);
type
  TApplicationExtension= packed record
    ExtensionIntroducer: Byte;
    ExtensionLabel     : Byte;
    BlockSize          : Byte;
    App                : array[0..10] of Char;
    DataSize           : Byte;
    Id                 : Byte;
    Loops              : Word;
    BlockTerminator    : Word;
  end;

var
  ApplicationExtension: TApplicationExtension;

begin
  with ApplicationExtension do begin
    ExtensionIntroducer:= $21;
    ExtensionLabel     := $FF;
    BlockSize          := 11;
    App                := 'NETSCAPE2.0';
    DataSize           := 3;
    Id                 := 1;
    Loops              := Count;
    BlockTerminator    := 0; 
  end;
  Stream.Write (ApplicationExtension, SizeOf (TApplicationExtension));
end;





procedure TGIFEncoder.WriteComment (const Comment: String);
type
  TCommentExtension= packed record
    ExtensionIntroducer: Byte;
    ExtensionLabel     : Byte;
    BlockSize          : Byte;
  end;

var
  BlockTerminator : Byte;
  CommentExtension: TCommentExtension;

begin
  if (Comment <> '') and (Trim (Comment) <> '') then begin
    with CommentExtension do begin
      ExtensionIntroducer:= $21;
      ExtensionLabel     := $FE;
      if Length (Comment) <= 255 then
        BlockSize:= Length (Comment)
      else
        BlockSize:= 255;
    end;
    BlockTerminator:= 0;
    Stream.Write (CommentExtension, SizeOf (TCommentExtension));
    Stream.Write (Comment[1], CommentExtension.BlockSize);
    Stream.Write (BlockTerminator, 1);
  end;  
end;





procedure TGIFEncoder.AddImage (ABitmap: TBitmap; ALocalPalette: HPalette; ALeft, ATop: Integer);
var
  Separator    : Char;
  ImgDescriptor: TImageDescriptor;

begin
  if Assigned (Stream) and Assigned (ABitmap) and (not ABitmap.Empty) then begin
    Bitmap:= ABitmap;
    if not (Bitmap.PixelFormat in [{pf1bit, pf4bit,} pf8bit]) then
      //raise EInvalidImage.Create ('The Pixel Format must be 1bit or 4bit or 8bit !')
      raise EInvalidImage.Create ('The Pixel Format must be 8bit !')
    else begin
      ImgDescriptor.ImageLeft   := ALeft;
      ImgDescriptor.ImageTop    := ATop;
      ImgDescriptor.ImageWidth  := Bitmap.Width;
      ImgDescriptor.ImageHeight := Bitmap.Height;
      ImgDescriptor.PackedFields:= 0;
      Separator                 := ',';
      if ALocalPalette <> 0 then
        ImgDescriptor.PackedFields:= 128;                                 
      {case Bitmap.PixelFormat of
        pf1bit: BitsPerPixel:= 2;
        pf4bit: BitsPerPixel:= 4;
        pf8bit: BitsPerPixel:= 8;
      end;}
      ImgDescriptor.PackedFields:= ImgDescriptor.PackedFields + (BitsPerPixel-1);

      Stream.Write (Separator, 1);

      // "Image Descriptor"
      Stream.Write (ImgDescriptor, SizeOf (TImageDescriptor));

      // "Local Palette"
      if ALocalPalette <> 0 then
        WritePalette (ALocalPalette, 1 shl BitsPerPixel);

      // "Image"
      WriteImage;

      Separator:= ';';
      Stream.Write (Separator, 1);
      Stream.Seek (-1, soFromCurrent);
    end;
  end;
end;





procedure TGIFEncoder.Add (ABitmap: TBitmap; ALocalPalette: HPalette; ALeft, ATop: Integer; ADelayTime: Word; ADisposalMethod: Byte; ATransparent: Boolean; ATransparentColorIndex: Byte; const AComment: String);
var
  ExtensionIntroducer: Byte;
  ExtensionLabel     : Byte;
  Save1, Save2       : Integer;
  GraphicExtension   : TGraphicExtension;

begin
  if Assigned (Stream) and Assigned (ABitmap) and (not ABitmap.Empty) then begin
    // "Comment Extension"
    WriteComment (AComment);

    // "Graphic Extension"
    ExtensionIntroducer:= $21;
    ExtensionLabel     := $F9;
    Stream.Write (ExtensionIntroducer, 1);
    Stream.Write (ExtensionLabel, 1);

    // Alocando área para "GraphicExtension"
    Save1:= Stream.Position;
    Stream.Write (GraphicExtension, SizeOf (TGraphicExtension));

    // Salvando "Image"
    AddImage (ABitmap, ALocalPalette, ALeft, ATop);
    Save2:= Stream.Position;

    // Atualizando "GraphicExtension"
    GraphicExtension.BlockSize            := 4;
    GraphicExtension.PackedFields         := ADisposalMethod shl 2;
    GraphicExtension.DelayTime            := ADelayTime;
    GraphicExtension.TransparentColorIndex:= ATransparentColorIndex;
    GraphicExtension.BlockTerminator      := 0;
    if ATransparent then
      GraphicExtension.PackedFields:= GraphicExtension.PackedFields or 1;
    Stream.Seek (Save1, soFromBeginning);
    Stream.Write (GraphicExtension, SizeOf (TGraphicExtension));

    // Restaurando a posição
    Stream.Seek (Save2, soFromBeginning);
  end;
end;





procedure TGIFEncoder.WritePalette (Palette: HPalette; PaletteLength: Integer);
var
  Tripla : Integer;
  Entries: array[Byte] of TPaletteEntry;

begin
  FillChar (Entries, 256*SizeOf (TPaletteEntry), #0);
  if GetPaletteEntries (Palette, 0, PaletteLength, Entries) = 0 then
    if PaletteLength = 2 then
      FillChar (Entries[1], 3, #255)
    else
      GetPaletteEntries (GetStockObject (DEFAULT_PALETTE), 0, PaletteLength, Entries);
  for Tripla:= 0 to PaletteLength-1 do begin
    Stream.Write (Entries[Tripla].peRed, 1);
    Stream.Write (Entries[Tripla].peGreen, 1);
    Stream.Write (Entries[Tripla].peBlue, 1);
  end;
end;





procedure TGIFEncoder.WriteImage;
type
  PLine= ^TLine;
  TLine= array[0..0] of Byte;
  TMax = array[3..12] of Word;

const
  cMax2: TMax= (4, 12, 28, 60, 124, 252, 508, 1020, 2044, 4093);
  cMax4: TMax= (0, 00, 16, 48, 112, 240, 496, 1008, 2032, 4081);
  cMax8: TMax= (0, 00, 00, 00, 000, 000, 256, 0768, 1792, 3840); // Estes valores são assim por causa do PRIMEIRO ("Count" = 0) "ClearCode", depois do SEGUNDO "ClearCode" serão "(0, 00, 00, 00, 000, 000, 255, 0767, 1791, 3839)"

// LZW
var
  Character: Byte;
  Index    : Integer;
  Prefix   : Integer;
  Table    : TLZWTable;

// GIF
var
  ClearFlag   : Boolean;
  More        : Boolean;
  BlockSize   : Byte;
  Offset      : Integer;
  X, Y        : Integer;
  Block       : PLine;
  Line        : PLine;
  Max         : TMax;
  ClearCode   : Word;
  CodeSize    : Word;
  Count       : Word;
  EOFCode     : Word;
  FirstFree   : Word;
  InitCodeSize: Word;
  Mask        : Word;

 // Inicializar a compactação do GIF
 procedure Initialize;

 begin
   CodeSize    := BitsPerPixel;
   ClearCode   := 1 shl CodeSize;
   EOFCode     := ClearCode + 1;
   FirstFree   := ClearCode + 2;
   CodeSize    := CodeSize + 1;
   InitCodeSize:= CodeSize;
   Line        := Bitmap.ScanLine[0];
   More        := True;
   ClearFlag   := True;
   X           := 0;
   Y           := 0;
   Count       := 0;
   BlockSize   := 0;
   Offset      := 0;
   Mask        := $FFFF shr (16-CodeSize);
   FillChar (Block[0], 258, #0);
   case BitsPerPixel of
     2: Max:= cMax2;
     4: Max:= cMax4;
     8: Max:= cMax8;
   end;
 end;

 procedure Flush;

 begin
   if BlockSize > 0 then begin
     Stream.Write (BlockSize, 1);
     Stream.Write (Block[0], BlockSize);
     Move (Block[BlockSize], Block[0], 3);
     BlockSize:= 3;
     FillChar (Block[BlockSize], 258-3, #0);
     BlockSize:= 0;
   end;
 end;

 procedure ReadChar (var Value: Byte);

 begin
   Value:= Line[X];
   Inc (X);
   if X = Bitmap.Width then begin
     X:= 0;
     Inc (Y);
     if Y < Bitmap.Height then
       Line:= Bitmap.ScanLine[Y]
     else
       More:= False;
   end;
 end;

 procedure Write (Code: Word);

  procedure WriteCode (NewValue: Word);
  var
    Longo: Integer;
    Value: Word;

  begin
    Longo    := NewValue;
    BlockSize:= (Offset shr 3) mod 255;
    Move (Block[BlockSize], Value, 2);
    Longo:= Longo and $FFFF;
    Value:= Value and Mask;
    Longo:= (Longo shl (Offset and 7)) or Value;  // (X mod 8)  =  (X and 7)
    Move (Longo, Block[BlockSize], 3);
    Inc (Count);
    Inc (Offset, CodeSize);
    Inc (BlockSize);
    if (BlockSize = 255) or ((Offset shr 3) mod 255 = 0) then begin
      BlockSize:= 255;
      Flush;
    end;
  end;

 begin
   WriteCode (Code);
   if Count >= Max[CodeSize] then begin
     if CodeSize = 12 then begin
       WriteCode (ClearCode);
       CodeSize := InitCodeSize;
       ClearFlag:= True;
       Count    := 1;
     end
     else
       Inc (CodeSize);
     Mask:= $FFFF shr (16-CodeSize);
   end;
 end;

begin
  GetMem (Block, 258);
  try
    Table:= TLZWTable.Create;
    try
      // GIF
      Stream.Write (BitsPerPixel, 1);
      Initialize;
      Write (ClearCode);

      // LZW
      Prefix:= 0;
      while More do begin
        ReadChar (Character);
        if ClearFlag then begin
          Table.Initialize (FirstFree);
          ClearFlag:= False;
        end;
        Index:= Table.Find (Prefix, Character);
        if Index > 0 then // Está no dicionário ?
          Prefix:= Index
        else begin
          Write (Prefix-1);
          Table.Add (Prefix, Character);
          Prefix:= Character+1;
        end;
      end;
      Write (Prefix-1);

      // GIF
      Write (EOFCode);
      Write (0);
      Flush;
      Stream.Write (BlockSize, 1);
    finally
      Table.Free;
    end;
  finally
    FreeMem (Block);
  end;
end;




// ---------------------------------------------------------------------------------------------
function TGIF.IsValid (const FileName: String): Boolean;
var
  Header: TScreenDescriptor;
  Local : TStream;

begin
  Result:= False;
  if FileExists (FileName) then begin
    Local:= TFileStream.Create (FileName, fmOpenRead);
    try
      Result:= (Local.Read (Header, SizeOf (TScreenDescriptor)) = SizeOf (TScreenDescriptor)) and (Header.Signature = 'GIF') and ((Header.Version = '87a') or (Header.Version = '89a'));
    finally
      Local.Free;
    end;
  end;
end;





procedure TGIF.LoadFromStream (Stream: TStream);
var
  Decoder: TGIFDecoder;
  Info   : TGIFInfo;

begin
  if Stream.Size > 0 then begin
    Decoder:= TGIFDecoder.Create (Stream);
    try
      Decoder.Load (True);
      Decoder.GetFrame (0, TBitmap (Self), Info);
    finally
      Decoder.Free;
    end;
  end;
end;

var
  N: Word;

initialization
  with gInitTable[0] do begin
    Prefixo:= 0;
    Sufixo := 0;
  end;
  with gInitTable[257] do begin
    Prefixo:= 0;
    Sufixo := 0;
  end;
  for N:= 0 to 255 do
    with gInitTable[N+1] do begin
      Prefixo:= 0;
      Sufixo := N;
    end;
  TPicture.RegisterFileFormat ('GIF', 'GIF - Graphics Interchange Format', TGIF);
finalization
  TPicture.UnRegisterGraphicClass (TGIF);
end.
