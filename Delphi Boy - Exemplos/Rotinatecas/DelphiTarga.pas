// Wheberson Hudson Migueletti, em Brasília, 10 de abril de 1999.
// Internet   : http://www.geocities.com/whebersite
// E-mail     : whebersite@zipmail.com.br
// Atualização: 17/04/2000

unit DelphiTarga;

interface

uses Windows, SysUtils, Classes, Graphics, DelphiImage;

type
  TTargaCompression= (ctgacUncompressed, ctgacRLE);

  PTargaHeader= ^TTargaHeader;
  TTargaHeader= packed record
    LengthIdentification: Byte;
    ColorMapType        : Byte;
    ImageTypeCode       : Byte;
    ColorMapOrigin      : Word;
    ColorMapLength      : Word;
    ColorMapEntrySize   : Byte;
    XOrigin             : Word;
    YOrigin             : Word;
    Width               : Word;
    Height              : Word;
    PixelSize           : Byte;
    Descriptor          : Byte;
  end;

  TTargaEncoder= class
    private
      Buffer: array[0..(128*4)-1] of Byte;
      Old   : Integer;
      Count : Integer;
    protected
      Bytes        : Byte;
      BitsPerPixel : Integer;
      BytesPerLine : Integer;
      PaletteLength: Integer;
      Stream       : TStream;

      procedure Flush;
      procedure WriteValue (Count: Byte);
      procedure WriteBuffer (Count: Byte);
      procedure EncodeValue (Current: Integer);
      procedure WritePalette (Bitmap: TBitmap);
      procedure WriteImage_Uncompressed (Bitmap: TBitmap);
      procedure WriteImage_RLE (Bitmap: TBitmap);
    public
      constructor Create (AStream: TStream); 
      procedure   Encode (Bitmap: TBitmap; Compression: TTargaCompression; Comment: String);
  end;

  TTarga= class (TBitmap)
    private
      Altura, Largura: Integer;
    protected
      IsBottomUp      : Boolean;
      IsInterlaced    : Boolean;
      DataType        : Byte;
      PaletteEntrySize: Byte;
      PaletteOrigin   : Byte;
      Bytes           : Integer;
      Pixel           : Integer;
      X, Y            : Integer;
      Line            : PByteArray;
      LogPalette      : TMaxLogPalette;
      Stream          : TStream;
      PaletteLength   : Word;

      procedure Read (var Buffer; Count: Integer);
      procedure WritePixel1;
      procedure WritePixel2;
      procedure DumpHeader;
      procedure DumpUncompressed;
      procedure DumpRLE;
      procedure DumpPalette;
      procedure ReadStream (AStream: TStream);
    public
      Identification: String;
      Compression   : TTargaCompression;

      //function  IsValid        (const FileName: String): Boolean; override;
      procedure LoadFromStream (Stream: TStream); override;
      procedure LoadFromFile   (const FileName: String); override;
  end;

implementation

const
  cMask= $80;





constructor TTargaEncoder.Create (AStream: TStream);

begin
  inherited Create;

  Stream:= AStream;
end;





procedure TTargaEncoder.Encode (Bitmap: TBitmap; Compression: TTargaCompression; Comment: String);
var
  BitmapInfo: Windows.TBitmap;
  Header    : TTargaHeader;

begin
  if not Bitmap.Empty then begin
    GetObject (Bitmap.Handle, SizeOf (Windows.TBitmap), @BitmapInfo);
    BitsPerPixel := BitmapInfo.bmBitsPixel;
    BytesPerLine := Bitmap.Width*BitsPerPixel shr 3;
    PaletteLength:= 0;
    Bytes        := BitsPerPixel shr 3;
    if BitsPerPixel <= 8 then begin
      PaletteLength:= 1 shl BitsPerPixel;
      Bytes        := 1;
    end;

    FillChar (Header, SizeOf (TTargaHeader), #0);
    with Header do begin
      LengthIdentification:= Length (Comment);
      ColorMapLength      := PaletteLength;
      Width               := Bitmap.Width;
      Height              := Bitmap.Height;
      PixelSize           := BitsPerPixel;
      Descriptor          := 32;
      if PaletteLength > 0 then begin
        ColorMapType     := 1;
        ColorMapEntrySize:= 24;
      end;  
      case BitsPerPixel of
        1   : case Compression of
                ctgacUncompressed: ImageTypeCode:= 03;
                ctgacRLE         : ImageTypeCode:= 11;
              end;
        4, 8: case Compression of
                ctgacUncompressed: ImageTypeCode:= 01;
                ctgacRLE         : ImageTypeCode:= 09;
              end;
        24  : case Compression of
                ctgacUncompressed: ImageTypeCode:= 02;
                ctgacRLE         : ImageTypeCode:= 10;
              end;
        else
          raise EUnsupportedImage.Create ('Unsupported pixel format');
      end;
    end;
    Stream.Write (Header, SizeOf (TTargaHeader));

    if Comment <> '' then
      Stream.Write (Comment[1], Length (Comment));

    WritePalette (Bitmap);
    
    case Compression of
      ctgacUncompressed: WriteImage_Uncompressed (Bitmap);
      ctgacRLE         : WriteImage_RLE (Bitmap);
    end;
  end;
end;





procedure TTargaEncoder.WritePalette (Bitmap: TBitmap);
var
  SaveIgnorePalette: Boolean;
  I                : Byte;
  Palette          : array[Byte] of TPaletteEntry;

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
    for I:= 0 to PaletteLength-1 do begin
      Stream.Write (Palette[I].peBlue, 1);
      Stream.Write (Palette[I].peGreen, 1);
      Stream.Write (Palette[I].peRed, 1);
    end;
  end;
end;





procedure TTargaEncoder.WriteValue (Count: Byte);

begin
  Stream.Write (Count, 1);
  Stream.Write (Old, Bytes);
end;





procedure TTargaEncoder.WriteBuffer (Count: Byte);

begin
  Stream.Write (Count, 1);
  Stream.Write (Buffer[0], (Count+1)*Bytes);
end;





procedure TTargaEncoder.EncodeValue (Current: Integer);

begin
  if Current = Old then begin
    if (Count > 0) and (Count <= 127) then begin // Tem algo no "Buffer"
      WriteBuffer (Count-1);
      Count:= 0;
    end;
    Inc (Count);
    Count:= Count or cMask; // Para garantir que será um valor acima de "cMask"
    if Count = 255 then begin
      WriteValue (Count);
      Count:= -1;
    end;
  end
  else begin
    if (Count >= 128) and (Count <= 255) then begin
      WriteValue (Count);
      Count:= -1;
    end;
    Inc (Count);
    Move (Current, Buffer[Count*Bytes], Bytes);
    if Count = 127 then begin
      WriteBuffer (Count);
      Count:= -1;
    end;
    Old:= Current;
  end;
end;





procedure TTargaEncoder.Flush;

begin
  if (Count >= 128) and (Count <= 255) then
    WriteValue (Count)
  else if Count >= 0 then
    WriteBuffer (Count);
  Count:= -1;
end;





procedure TTargaEncoder.WriteImage_Uncompressed (Bitmap: TBitmap);
type
  PLine= ^TLine;
  TLine= array[0..0] of Byte;

var
  X, Y: Integer;
  Line: PLine;

begin
  for Y:= 0 to Bitmap.Height-1 do begin
    Line:= Bitmap.ScanLine[Y];
    Stream.Write (Line[0], BytesPerLine);
  end;
end;





procedure TTargaEncoder.WriteImage_RLE (Bitmap: TBitmap);
type
  PLine= ^TLine;
  TLine= array[0..0] of Byte;

var
  Pixel: Integer;
  X, Y : Integer;
  Line : PLine;

begin
  Count:= 0;
  Line := Bitmap.ScanLine[0];
  Move (Line[0], Old, Bytes);
  Move (Old, Buffer[0], Bytes);
  for X:= 1 to Bitmap.Width-1 do begin
    Move (Line[X*Bytes], Pixel, Bytes);
    EncodeValue (Pixel);
  end;
  for Y:= 1 to Bitmap.Height-1 do begin
    Line:= Bitmap.ScanLine[Y];
    for X:= 0 to Bitmap.Width-1 do begin
      Move (Line[X*Bytes], Pixel, Bytes);
      EncodeValue (Pixel);
    end;
  end;
  Flush;
end;




//----------------------------------------------------------------------------------------------
procedure TTarga.Read (var Buffer; Count: Integer);
var
  Lidos: Integer;

begin
  Lidos:= Stream.Read (Buffer, Count);
  if Lidos <> Count then
    raise EInvalidImage.Create (Format ('TGA read error at %.8xH (%d byte(s) expected, but %d read)', [Stream.Position-Lidos, Count, Lidos]));
end;





procedure TTarga.DumpHeader;
var
  Header: TTargaHeader;

begin
  Read (Header, SizeOf (TTargaHeader));
  with Header do begin
    Self.Width      := Width;
    Self.Height     := Height;
    Largura         := Width;
    Altura          := Height;
    Identification  := '';
    DataType        := ImageTypeCode;
    IsBottomUp      := (Descriptor and 32) = 0; // Cabeça-para-baixo
    IsInterlaced    := (Descriptor shr 6) <> 0;
    Bytes           := 1;
    IgnorePalette   := PixelSize > 8;
    PaletteEntrySize:= ColorMapEntrySize;
    PaletteOrigin   := ColorMapOrigin;
    PaletteLength   := 0;
    with LogPalette do
      palNumEntries:= 0;
    case PixelSize of
      16: begin
            Bytes      := 2;
            PixelFormat:= pf15bit;
          end;
      24: begin
            Bytes      := 3;
            PixelFormat:= pf24bit;
          end;
      32: begin
            Bytes      := 4;
            PixelFormat:= pf32bit;
          end;
    else if PixelSize <= 8 then
      with LogPalette do begin
        PixelFormat  := pf8bit;
        PaletteLength:= ColorMapLength;
        palNumEntries:= ColorMapLength;
        palVersion   := $0300;
        FillChar (palPalEntry[0], 256, #0);
        if PaletteLength = 0 then
          palNumEntries:= 1 shl PixelSize;
      end;
    end;
    if LengthIdentification > 0 then begin
      SetLength (Identification, LengthIdentification);
      Stream.Read (Identification[1], LengthIdentification);
    end;
    if ImageTypeCode in [9, 10, 11] then
      Compression:= ctgacRLE
    else
      Compression:= ctgacUncompressed;
    if not (not IsInterlaced and (ImageTypeCode in [1, 2, 3, 9, 10, 11]) and (PixelSize in [8, 16, 24, 32])) then
      raise EUnsupportedImage.Create ('Unsupported pixel format !');
  end;
end;





procedure TTarga.DumpPalette;
type
  TRGBType = (Blue, Green, Red, Attr);
  TRGBColor= array[TRGBType] of Byte;

var
  P    : Integer;
  RGB  : TRGBColor;
  Color: Word;

begin
  if LogPalette.palNumEntries > 0 then begin
    if PaletteLength > 0 then
      case PaletteEntrySize of
        16: for P:= 0 to PaletteLength-1 do begin
              Read (Color, 2);
              with LogPalette.palPalEntry[PaletteOrigin + P] do begin
                peRed  := (Color and $1F) shl 3;
                peGreen:= ((Color shr 5) and $1F) shl 3;
                peBlue := ((Color shr 10) and $1F) shl 3;
              end;
            end;
        24: for P:= 0 to PaletteLength-1 do begin
              Read (RGB, 3);
              with LogPalette.palPalEntry[PaletteOrigin + P] do begin
                peRed  := RGB[Red];
                peGreen:= RGB[Green];
                peBlue := RGB[Blue];
              end;
            end;
        32: for P:= 0 to PaletteLength-1 do begin
              Read (RGB, 4);
              with LogPalette.palPalEntry[PaletteOrigin + P] do begin
                peRed  := RGB[Red];
                peGreen:= RGB[Green];
                peBlue := RGB[Blue];
                peFlags:= RGB[Attr];
              end;
            end;
      end
    else if DataType in [3, 11] then // B & W
      with LogPalette do
        for P:= 0 to palNumEntries-1 do
          with palPalEntry[P] do begin
            peRed  := P;
            peGreen:= P;
            peBlue := P;
          end
    else
      with LogPalette do
        GetPaletteEntries (GetStockObject (DEFAULT_PALETTE), 0, palNumEntries, palPalEntry);
    Palette:= CreatePalette (PLogPalette (@LogPalette)^);
  end;
end;





procedure TTarga.WritePixel1;

begin
  Move (Pixel, Line[X*Bytes], Bytes);
  Inc (X);
  if X = Largura then begin
    X:= 0;
    Inc (Y);
    if Y < Altura then
      Line:= ScanLine[Y];
  end;
end;





procedure TTarga.WritePixel2;

begin
  Move (Pixel, Line[X*Bytes], Bytes);
  Inc (X);
  if X = Largura then begin
    X:= 0;
    Dec (Y);
    if Y >= 0 then
      Line:= ScanLine[Y];
  end;
end;

// BitsPerPixel = 32, Cada pixel ocupa 4 bytes (Red Blue Green Attribute)
// BitsPerPixel = 24, Cada pixel ocupa 3 bytes (Red Blue Green)
// BitsPerPixel = 16, Cada pixel ocupa 2 bytes (ARRRRGG GGGBBBBB)
// BitsPerPixel = 08, Cada pixel ocupa 1 byte
procedure TTarga.DumpUncompressed;

begin
  X:= 0;
  if IsBottomUp then begin
    Y   := Altura-1;
    Line:= ScanLine[Y];
    while Y >= 0 do begin
      Read (Pixel, Bytes);
      WritePixel2;
    end;
  end
  else begin
    Y   := 0;
    Line:= ScanLine[Y];
    while Y < Altura do begin
      Read (Pixel, Bytes);
      WritePixel1;
    end;
  end;
end;





procedure TTarga.DumpRLE;
var
  PacketHeader: Byte;
  I, Max      : Integer;

begin
  X:= 0;
  if IsBottomUp then begin
    Y   := Altura-1;
    Line:= ScanLine[Y];
    while Y >= 0 do begin
      Read (PacketHeader, 1);
      Max:= PacketHeader and $7F;
      if PacketHeader and $80 <> 0 then begin
        Read (Pixel, Bytes);
        for I:= 0 to Max do
          WritePixel2;
      end
      else
        for I:= 0 to Max do begin
          Read (Pixel, Bytes);
          WritePixel2;
        end;
    end;
  end
  else begin
    Y   := 0;
    Line:= ScanLine[Y];
    while Y < Altura do begin
      Read (PacketHeader, 1);
      Max:= PacketHeader and $7F;
      if PacketHeader and $80 <> 0 then begin
        Read (Pixel, Bytes);
        for I:= 0 to Max do
          WritePixel1;
      end
      else
        for I:= 0 to Max do begin
          Read (Pixel, Bytes);
          WritePixel1;
        end;
    end;
  end;
end;





procedure TTarga.ReadStream (AStream: TStream);

begin
  Stream:= AStream;
  if Stream.Size > 0 then begin
    DumpHeader;
    DumpPalette;
    if Compression = ctgacRLE then
      DumpRLE
    else
      DumpUncompressed;
  end;
end;





procedure TTarga.LoadFromStream (Stream: TStream);

begin
  if Assigned (Stream) then
    ReadStream (Stream);
end;





procedure TTarga.LoadFromFile (const FileName: String);
var
  Stream: TStream;

begin
  Stream:= TMemoryStream.Create;
  try
    TMemoryStream (Stream).LoadFromFile (FileName);
    Stream.Seek (0, soFromBeginning);
    ReadStream (Stream);
  finally
    Stream.Free;;
  end;
end;

initialization
  TPicture.RegisterFileFormat ('TGA', 'TGA - Targa', TTarga);
finalization
  TPicture.UnRegisterGraphicClass (TTarga);
end.
