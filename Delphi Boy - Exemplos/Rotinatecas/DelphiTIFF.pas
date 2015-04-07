// Wheberson Hudson Migueletti, em Brasília.
// Internet  : http://www.geocities.com/whebersite
// E-mail    : whebersite@zipmail.com.br
// Referência: [1] TIFF - Revision 6.0
//                 http://home.earthlink.net/~ritter/tiff
//                 http://www.adobe.com/Support/TechNotes.html
//             [2] Converting a RGB color to a CMYK color
//                 http://community.borland.com/delphi/article/1,1410,17948,00.html
// Para ler/gravar arquivos ".tif" (TIFF - Tag(ged) Image File Format)
//
// Pendências:
// * CCITT 1D, Group 3 Fax, Group 4 Fax
// * CMYK: DotRange (Alterar um DotRange de uma imagem conhecida)
// * Gerar uma imagem RGB com BlackWhiteReference diferente do default
// * Quadric surfaces
// * Transparency Mask
// * HalftoneHints
// * FillOrder
// * Threshholding

unit DelphiTIFF;

interface

uses Windows, SysUtils, Classes, Graphics, Math, DelphiMat;

type
  TTIFFCompression= (ctiffcNone, ctiffcCCITT1D, ctiffcGroup3Fax, ctiffcGroup4Fax, ctiffcLZW, ctiffcJPEG, ctiffcPackBits, ctiffcUnknown);

  TTIFFSingleArray= array[0..2] of Single;

  // TRational = Numerator/Denominator
  TTIFFRational= packed record
    Numerator  : Integer;
    Denominator: Integer;
  end;

  TTIFFImageFileHeader= packed record
    ByteOrder: Word;    // II ou MM
    Version  : Word;    // 42 ($2A)
    Offset   : Integer; // Posição do primeiro "Image File Directory" no arquivo
  end;

  // IFD
  TTIFFImageFileDirectory= packed record
    Tag          : Word;
    TypeField    : Word;
    Count        : Integer;
    ValueOrOffset: Integer; // Pode ser um dado ou uma posição no arquivo
  end;

  TTIFFEncoder= class
    protected
      BitsPerPixel         : Integer;
      NextIFD              : Integer;
      NextIFDOffset        : Integer;
      RowsPerStrip         : Integer;
      StripByteCountsOffset: Integer;
      StripOffsetsOffset   : Integer;
      TIFFBytesPerLine     : Integer;
      StripByteCounts      : TList;

      procedure CalcBlocksSize       (Count: Integer; BlockSize: Integer);
      procedure WriteSamplesPerPixel (Offset: Integer; Count: Byte);
      procedure WriteTxt             (Offset: Integer; const Value: String);
      procedure WritePalette         (Bitmap: TBitmap; Offset: Integer; PaletteLength: Integer);
      procedure WriteList            (Offset: Integer; List: TList);
      procedure WriteImage           (Bitmap: TBitmap; Compression: TTIFFCompression);
      procedure WriteImage_LZW       (Input: TMemoryStream; Size: Integer);
      procedure WriteImage_PackBits  (Input: TMemoryStream; Size: Integer);
    public
      Stream: TStream;

      constructor Create (AStream: TStream);
      destructor  Destroy; override;
      procedure   Add (Bitmap: TBitmap; Compression: TTIFFCompression; const ImageDescription, Software, Artist: String);
  end;

  TTIFFDecoder= class
    private
      function GetCount: Integer;
    protected
      HorDiff             : Boolean;
      IsII                : Boolean;
      LumaBlue            : Double; // YCbCr
      LumaGreen           : Double; // YCbCr
      LumaRed             : Double; // YCbCr
      GetDouble           : function (Value: Double): Double;
      GetInteger          : function (Value: Integer): Integer;
      GetRational         : function (Value: TTIFFRational): TTIFFRational;
      GetWord             : function (Value: Word): Word;
      LuminanceCodingRange: Integer; // Y CodingRange (YCbCr)
      RowsPerStrip        : Integer;
      Start               : Integer;
      Artist              : String;
      Description         : String;
      Software            : String;
      Bitmap              : TBitmap;
      IFDOffsets          : TList;
      StripByteCounts     : TList;
      StripOffsets        : TList;
      LogPalette          : TMaxLogPalette;
      Compression         : TTIFFCompression;
      BlackWhiteDiff      : TTIFFSingleArray; // RGB/YCbCr
      ReferenceBlack      : TTIFFSingleArray; // RGB/YCbCr
      Stream              : TStream;
      Orientation         : Word;
      Photometric         : Word;
      PlanarConfiguration : Word;
      YCbCrSubsampleHoriz : Word; // YCbCr
      YCbCrSubsampleVert  : Word; // YCbCr

      procedure Read (var Buffer; Count: Integer);
      procedure Seek (Offset: Integer; Origin: Word);
      procedure DumpHeader;
      procedure DumpDirectory;
      procedure DumpImage_Uncompressed;
      procedure DumpImage_PackBits;
      procedure DumpImage_LZW;
      procedure DumpImage;
    public
      constructor Create (AStream: TStream);
      destructor  Destroy; override;
      procedure   Load (AFirstImageOnly: Boolean);
      procedure   Get (AIndex: Integer; ABitmap: TBitmap; var ADescription, ASoftware, AArtist: String);
      property    Count: Integer read GetCount;
  end;

  TTIFF= class (TBitmap)
    protected
      procedure ReadStream (AStream: TStream);
    public
      Artist     : String;
      Description: String;
      Software   : String;

      function  IsValid        (const FileName: String): Boolean;
      procedure LoadFromStream (Stream: TStream); override;
  end;

implementation

uses DelphiImage;

// Field Types
const
  cftBYTE     = 01; // 8-bit unsigned integer
  cftASCII    = 02; // 8-bit byte that contains a 7-bit ASCII code; the last byte must be NUL (binary zero)
  cftSHORT    = 03; // 16-bit (2-byte) unsigned integer
  cftLONG     = 04; // 32-bit (4-byte) unsigned integer
  cftRATIONAL = 05; // Two LONGs: the first represents the numerator of a fraction; the second, the denominator
  cftSBYTE    = 06; // An 8-bit signed (twos-complement) integer
  cftUNDEFINED= 07; // An 8-bit byte that may contain anything, depending on the definition of the field
  cftSSHORT   = 08; // A 16-bit (2-byte) signed (twos-complement) integer
  cftSLONG    = 09; // A 32-bit (4-byte) signed (twos-complement) integer
  cftSRATIONAL= 10; // Two SLONG’s: the first represents the numerator of a fraction, the second the denominator
  cftFLOAT    = 11; // Single precision (4-byte) IEEE format
  cftDOUBLE   = 12; // Double precision (8-byte) IEEE format

// PhotometricInterpretation
const
  cpiWhiteIsZero     = 0;
  cpiBlackIsZero     = 1;
  cpiRGB             = 2;
  cpiRGBPalette      = 3;
  cpiTransparencyMask= 4;
  cpiCMYK            = 5;
  cpiYCbCr           = 6;
  cpiCIELab          = 8;

// LZW
const
  cClearCode       : Word= 256;
  cEndOfInformation: Word= 257;
  cFreeCode        : Word= 258;
  cInitCodeSize    : Word= 009;

// RGB (Bitmap)
const
  cBlue = 0;
  cGreen= 1;
  cRed  = 2;
  cAttr = 3;

const
  cBlockSize= 32768;

type
  TCelula= packed record
    Prefixo: Word;
    Sufixo : Byte;
  end;

  PLine= ^TLine;
  TLine= array[0..0] of Byte;

  PLine4= ^TLine4;
  TLine4= array[0..3] of Byte;

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

  TTIFFYCbCr= array[0..15+1+1] of Byte; // Y0..Y15, Cb, Cr

  TTIFFImageDecoder= class
    protected
      CbIndex       : Byte;
      CrIndex       : Byte;
      LumaBlue      : Double;
      LumaGreen     : Double;
      LumaRed       : Double;
      BitsPerPixel  : Integer;
      BMPWidthLine  : Integer;
      Height        : Integer;
      PixelSize     : Integer;
      RowsPerStrip  : Integer;
      TIFFWidthLine : Integer;
      Width         : Integer;
      X, Y          : Integer;
      CMYKLine      : PLine;
      Line          : PLine;
      Plane         : PLine;
      RGB           : PLine4;
      Start         : Pointer;
      Component     : ShortInt;
      Bitmap        : TBitmap;
      Stream        : TStream;
      BlackWhiteDiff: TTIFFSingleArray;
      ReferenceBlack: TTIFFSingleArray;
      YCbCr         : TTIFFYCbCr;

      function  GetScanLine (Row: Integer): Pointer;
      procedure YCbCrToRGB (YIndex: Byte);
    public
      constructor Create (ABitmap: TBitmap; AStream: TStream);
      destructor  Destroy; override;
      procedure   Execute (ACount: Integer); virtual; abstract;
  end;

  TTIFFDecoder_08b= class (TTIFFImageDecoder)
    public
      procedure Execute (ACount: Integer); override;
  end;

  TTIFFDecoder_08b_HorDiff= class (TTIFFImageDecoder)
    public
      procedure Execute (ACount: Integer); override;
  end;

  TTIFFDecoder_24b= class (TTIFFImageDecoder)
    public
      procedure Execute (ACount: Integer); override;
  end;

  TTIFFDecoder_24b_Planar2= class (TTIFFImageDecoder)
    public
      procedure Execute (ACount: Integer); override;
  end;

  TTIFFDecoder_CMYK= class (TTIFFImageDecoder)
    protected
      CMYKWidthLine: Integer;
      CMYKLine     : PLine;
    public
      constructor Create (ABitmap: TBitmap; AStream: TStream);
      destructor  Destroy; override;
      procedure   Execute (ACount: Integer); override;
  end;

  TTIFFDecoder_CIELab= class (TTIFFImageDecoder)
    protected
      LabLine: PLine;
    public
      constructor Create (ABitmap: TBitmap; AStream: TStream);
      destructor  Destroy; override;
      procedure   Execute (ACount: Integer); override;
  end;

  TTIFFDecoder_YCbCr= class (TTIFFImageDecoder)
    protected
      State  : Byte; // Y, Cb, Cr, Output
      YHeight: Byte; // 1, 2, 4
      YLength: Byte; // 1, 4, 16
      YWidth : Byte; // 1, 2, 4
      Index  : Integer;

      procedure Write (const Value);
    public
      constructor Create  (ABitmap: TBitmap; AStream: TStream; ALumaRed, ALumaGreen, ALumaBlue: Double; AReferenceBlack, ABlackWhiteDiff: TTIFFSingleArray; AYWidth, AYHeight: Byte);
      procedure   Execute (ACount: Integer); override;
  end;

  TTIFFPackBitsDecoder= class (TTIFFImageDecoder)
    protected
      procedure UnpackLine (Line: PLine; Count: Integer);
    public
      constructor Create (ABitmap: TBitmap; AStream: TStream; ARowsPerStrip: Integer);
  end;

  TTIFFPackBitsDecoder_08b= class (TTIFFPackBitsDecoder)
    public
      procedure Execute (ACount: Integer); override;
  end;

  TTIFFPackBitsDecoder_08b_HorDiff= class (TTIFFPackBitsDecoder)
    public
      procedure Execute (ACount: Integer); override;
  end;

  TTIFFPackBitsDecoder_24b= class (TTIFFPackBitsDecoder)
    public
      procedure Execute (ACount: Integer); override;
  end;

  TTIFFPackBitsDecoder_24b_Planar2= class (TTIFFPackBitsDecoder)
    public
      procedure Execute (ACount: Integer); override;
  end;

  TTIFFPackBitsDecoder_CMYK= class (TTIFFPackBitsDecoder)
    protected
      CMYKWidthLine: Integer;
      CMYKLine     : PLine;
    public
      constructor Create (ABitmap: TBitmap; AStream: TStream; ARowsPerStrip: Integer); 
      destructor  Destroy; override;
      procedure   Execute (ACount: Integer); override;
  end;

  TTIFFPackBitsDecoder_CIELab= class (TTIFFPackBitsDecoder)
    protected
      LabLine: PLine;
    public
      constructor Create (ABitmap: TBitmap; AStream: TStream; ARowsPerStrip: Integer);
      destructor  Destroy; override;
      procedure   Execute (ACount: Integer); override;
  end;

  TTIFFLZWDecoder= class (TTIFFImageDecoder)
    private
      EndPos    : Integer;
      Offset    : Integer; // "Offset" na "Stream" (em relação aos "bits")
      StartPos  : Integer;
      Dictionary: TLZWTable;
      Code      : Word;
      CodeSize  : Word;
      Disp      : Word;
      FreeCode  : Word;    // Indica quando é que "CodeSize" será incrementado
      MaxCode   : Word;
      ReadMask  : Word;
    protected
      procedure GetNextCode; virtual;
      procedure Write (const Value); virtual; abstract;
    public
      constructor Create (ABitmap: TBitmap; AStream: TStream);
      destructor  Destroy; override;
      procedure   Execute (ACount: Integer); override;
  end;

  TTIFFLZWDecoder_08b= class (TTIFFLZWDecoder)
    protected
      procedure Write (const Value); override;
  end;

  TTIFFLZWDecoder_08b_HorDiff= class (TTIFFLZWDecoder)
    protected
      procedure Write (const Value); override;
  end;

  TTIFFLZWDecoder_24b= class (TTIFFLZWDecoder)
    protected
      procedure Write (const Value); override;
  end;

  TTIFFLZWDecoder_24b_Planar2= class (TTIFFLZWDecoder)
    protected
      E: Integer;

      procedure Write (const Value); override;
    public
      constructor Create (ABitmap: TBitmap; AStream: TStream);
  end;

  TTIFFLZWDecoder_YCbCr= class (TTIFFLZWDecoder)
    protected
      State  : Byte; // Y, Cb, Cr, Output
      YHeight: Byte; // 1, 2, 4
      YLength: Byte; // 1, 4, 16
      YWidth : Byte; // 1, 2, 4
      Index  : Integer;

      procedure Write (const Value); override;
    public
      constructor Create (ABitmap: TBitmap; AStream: TStream; ALumaRed, ALumaGreen, ALumaBlue: Double; AReferenceBlack, ABlackWhiteDiff: TTIFFSingleArray; AYWidth, AYHeight: Byte);
  end;

  TTIFFLZWDecoder_CMYK= class (TTIFFLZWDecoder)
    protected
      CMYKWidthLine: Integer;
      CMYKLine     : PLine;

      procedure Write (const Value); override;
    public
      constructor Create (ABitmap: TBitmap; AStream: TStream);
      destructor  Destroy; override;
  end;

  TTIFFLZWDecoder_CIELab= class (TTIFFLZWDecoder)
    protected
      LabLine: PLine;

      procedure Write (const Value); override;
    public
      constructor Create (ABitmap: TBitmap; AStream: TStream);
      destructor  Destroy; override;
  end;

var
  gInitTable   : array[0..257] of TCelula;
  Swap32       : function  (Value: Integer): Integer;
  LabToRGBLine : procedure (LabLine, RGBLine: PLine; Count: Integer);
  CMYKToRGBLine: procedure (CMYKLine, RGBLine: PLine; Count, PixelSize: Integer);
  Line2ToLine1 : procedure (Buffer, Line: PLine; Count, EndPos, PixelSize: Integer);
  SwapLine     : procedure (Line: PLine; Count, PixelSize: Integer);
  UndoHorDiff  : procedure (Line: PLine; Count, PixelSize: Integer);





function Swap16 (Value: Word): Word;

begin
  Result:= Swap (Value);
end;





function Swap32_I486 (Value: Integer): Integer; assembler;

asm
  BSWAP EAX // 80486 ou superior
end;





function Swap32_I386 (Value: Integer): Integer;

begin
  LongRec (Result).Lo:= Swap (LongRec (Value).Hi);
  LongRec (Result).Hi:= Swap (LongRec (Value).Lo);
end;





function SwapDouble (Value: Double): Double;
type
  T64Bit= packed record
    Lo, Hi: Integer;
  end;

begin
  T64Bit (Result).Lo:= Swap32 (T64Bit (Value).Hi);
  T64Bit (Result).Hi:= Swap32 (T64Bit (Value).Lo);
end;





function SwapRational (Value: TTIFFRational): TTIFFRational;

begin
  with Result do begin
    Numerator  := Swap32 (Value.Numerator);
    Denominator:= Swap32 (Value.Denominator);
  end;
end;





procedure SwapLine_1 (Line: PLine; Count, PixelSize: Integer);
var
  Temp: Byte;
  C, X: Integer;

begin
  X:= 0;
  while X < Count do begin
    C      := X + 2;
    Temp   := Line[X];
    Line[X]:= Line[C];
    Line[C]:= Temp;
    Inc (X, PixelSize);
  end;
end;





procedure SwapLine_2 (Line: PLine; Count, PixelSize: Integer);

begin
  UndoHorDiff (Line, Count, PixelSize);
  SwapLine_1 (Line, Count, PixelSize);
end;




// Transforma uma linha "PlanarConfiguration = 2" para "PlanarConfiguration = 1"
procedure Line2ToLine1_1 (Buffer, Line: PLine; Count, EndPos, PixelSize: Integer);
var
  X: Integer;

begin
  for X:= Count-1 downto 0 do begin
    Line[EndPos]:= Buffer[X];
    Dec (EndPos, PixelSize);
  end;
end;





procedure Line2ToLine1_2 (Buffer, Line: PLine; Count, EndPos, PixelSize: Integer);

begin
  UndoHorDiff (Buffer, Count, 1);
  Line2ToLine1_2 (Buffer, Line, Count, EndPos, PixelSize);
end;





procedure CMYKToRGBLine_1 (CMYKLine, RGBLine: PLine; Count, PixelSize: Integer);

 // Adapted from [2]
 procedure CMYKToRGB (CMYK, RGB: PLine4);
 const
   cC= 0;
   cM= 1;
   cY= 2;
   cK= 3;

 var
   S: Integer;

 begin
   S:= CMYK[cC] + CMYK[cK];
   if S < 255 then
     RGB[cRed]:= 255 - S
   else
     RGB[cRed]:= 0;
   S:= CMYK[cM] + CMYK[cK];
   if S < 255 then
     RGB[cGreen]:= 255 - S
   else
     RGB[cGreen]:= 0;
   S:= CMYK[cY] + CMYK[cK];
   if S < 255 then
     RGB[cBlue]:= 255 - S
   else
     RGB[cBlue]:= 0;
 end;

var
  I, X: Integer;

begin
  X:= 0;
  for I:= 0 to Count-1 do begin
    CMYKToRGB (@CMYKLine[I shl 2], @RGBLine[X]);
    Inc (X, PixelSize);
  end;
end;





procedure CMYKToRGBLine_2 (CMYKLine, RGBLine: PLine; Count, PixelSize: Integer);

begin
  UndoHorDiff (CMYKLine, Count shl 2, 4);
  CMYKToRGBLine_1 (CMYKLine, RGBLine, Count, PixelSize);
end;





procedure LabToRGBLine_1 (LabLine, RGBLine: PLine; Count: Integer);
 // L ->    0..+255
 // A -> -127..+127
 // B -> -127..+127
 procedure LabToRGB (Lab, RGB: PLine4);
 const
   cL = 0;
   cA = 1;
   cB = 2;

   // D65
   cXN= 95.04;
   cYN= 100.0;
   cZN= 108.89;

  function Convert (Value: Double): Byte;

  begin
    if Value > 255 then
      Result:= 255
    else if Value < 0 then
      Result:= 0
    else
      Result:= Round (Value);
  end;

 var
   A, B, P: Double;
   X, Y, Z: Double;

 begin
   // LAB -> XYZ
   if Lab[cL] <= (0.008856*903.3) then begin  // (Y/YN) <= 0.008856
     Y:= (cYN*Lab[cL])/903.3;
     X:= cXN*((Y/cYN)+(ShortInt (Lab[cA])/3893.5));
     Z:= cZN*((Y/cYN)-(ShortInt (Lab[cB])/1557.4));
   end
   else begin
     P:= (Lab[cL] + 16)/116;
     A:= P + ShortInt (Lab[cA])/500;
     B:= P - ShortInt (Lab[cB])/200;
     X:= cXN*A*A*A;
     Y:= cYN*P*P*P;
     Z:= cZN*B*B*B;
   end;

   // XYZ -> RGB
   RGB[cRed]  := Convert ( X*1.910374 - Y*0.533769 - Z*0.289132);
   RGB[cGreen]:= Convert (-X*0.984444 + Y*1.998520 - Z*0.027851);
   RGB[cBlue] := Convert ( X*0.058482 - Y*0.118724 + Z*0.901745);
 end;

var
  I, X: Integer;

begin
  X:= 0;
  for I:= 0 to Count-1 do begin
    LabToRGB (@LabLine[X], @RGBLine[X]);
    Inc (X, 3);
  end;
end;





procedure LabToRGBLine_2 (LabLine, RGBLine: PLine; Count: Integer);

begin
  UndoHorDiff (LabLine, Count*3, 3);
  LabToRGBLine_1 (LabLine, RGBLine, Count);
end;





function GetDouble_II (Value: Double): Double;

begin
  Result:= Value;
end;





function GetInteger_II (Value: Integer): Integer;

begin
  Result:= Value;
end;





function GetRational_II (Value: TTIFFRational): TTIFFRational;

begin
  Result:= Value;
end;





function GetWord_II (Value: Word): Word;

begin
  Result:= Value;
end;





procedure UndoHorDiff4b (Line: PLine; Count, PixelSize: Integer);
var
  H, L: Byte;
  X   : Integer;

begin
  Line[0]:= (Line[0] and $F0) or ((Line[0] shr 4) + (Line[0] and $0F));
  for X:= 1 to Count-1 do begin
    H      := (Line[X-1] and $0F) + (Line[X] shr 4);
    L      := H + (Line[X] and $0F);
    Line[X]:= (H shl 4) or (L and $0F);
  end;
end;





procedure UndoHorDiff8b24b32b (Line: PLine; Count, PixelSize: Integer);
var
  X: Integer;

begin
  for X:= PixelSize to Count-1 do
    Inc (Line[X], Line[X-PixelSize]);
end;





procedure SetOrientation (Bitmap: TBitmap; Orientation: Word);
var
  BPP      : Byte;
  PixelSize: Byte;
  Height   : Integer;
  Width    : Integer;

 procedure ExchangeColumns (Line: PLine);

  procedure Exchange (A, B: Integer);
  var
    Temp: array[0..3] of Byte;

  begin
    A:= A*PixelSize;
    B:= B*PixelSize;
    Move (Line[A], Temp[0], PixelSize);
    Move (Line[B], Line[A], PixelSize);
    Move (Temp[0], Line[B], PixelSize);
  end;

  var
    X: Integer;

 begin
   for X:= 0 to (Bitmap.Width div 2)-1 do
     Exchange (X, Bitmap.Width-X-1);
 end;

 procedure ExchangeRows (Columns: Boolean);
 var
   Buffer: PLine;

  procedure Exchange (A, B: Integer);

  begin
    Move (PLine (Bitmap.ScanLine[A])[0], Buffer[0], Width);
    Move (PLine (Bitmap.ScanLine[B])[0], PLine (Bitmap.ScanLine[A])[0], Width);
    Move (Buffer[0], PLine (Bitmap.ScanLine[B])[0], Width);
    if Columns then begin
      ExchangeColumns (Bitmap.ScanLine[A]);
      ExchangeColumns (Bitmap.ScanLine[B]);
    end;
  end;

 var
   Y: Integer;

 begin
   GetMem (Buffer, Width);
   try
     for Y:= 0 to (Height div 2)-1 do
       Exchange (Y, Height-Y-1);
     if Columns and (Height mod 2 <> 0) then
       ExchangeColumns (Bitmap.ScanLine[Height div 2]);
   finally
     FreeMem (Buffer);
   end;
 end;

 procedure ExchangeCoords;
 type
   PLine24= ^TLine24;
   PLine32= ^TLine32;
   TLine24= array[0..0] of TRGBTriple;
   TLine32= array[0..0] of TRGBQuad;

 var
   Aux08  : Byte;
   X, Y   : Integer;
   ILine08: PLine;
   OLine08: PLine;
   ILine24: PLine24;
   OLine24: PLine24;
   ILine32: PLine32;
   OLine32: PLine32;
   Input  : TBitmap;
   Aux24  : TRGBTriple;
   Aux32  : TRGBQuad;

 begin
   Input:= TBitmap.Create;
   try
     Input.Assign (Bitmap);
     Bitmap.Assign (nil);
     Bitmap.Width      := Abs (Input.Height);
     Bitmap.Height     := Input.Width;
     Bitmap.PixelFormat:= Input.PixelFormat;
     Bitmap.Palette    := CopyPalette (Input.Palette);
     Width             := BytesPerScanline (Bitmap.Width, BPP, 32);
     Height            := Abs (Bitmap.Height);
     case BPP of
       24: for Y:= Abs (Input.Height)-1 downto 0 do begin
             ILine24:= Input.ScanLine[Y];
             for X:= 0 to Input.Width-1 do begin
               Aux24     := ILine24[X];
               OLine24   := Bitmap.ScanLine[X];
               OLine24[Y]:= Aux24;
             end;
           end;
       32: for Y:= Abs (Input.Height)-1 downto 0 do begin
             ILine32:= Input.ScanLine[Y];
             for X:= 0 to Input.Width-1 do begin
               Aux32     := ILine32[X];
               OLine32   := Bitmap.ScanLine[X];
               OLine32[Y]:= Aux32;
             end;
           end;
     else
       for Y:= Abs (Input.Height)-1 downto 0 do begin
         ILine08:= Input.ScanLine[Y];
         for X:= 0 to Input.Width-1 do begin
           Aux08     := ILine08[X];
           OLine08   := Bitmap.ScanLine[X];
           OLine08[Y]:= Aux08;
         end;
       end;
     end;
   finally
     Input.Free;
   end;
 end;

 procedure Set2;
 var
   Y: Integer;

 begin
   for Y:= 0 to Height-1 do
     ExchangeColumns (Bitmap.ScanLine[Y]);
 end;

 procedure Set3;

 begin
   ExchangeRows (True);
 end;

 procedure Set4;

 begin
   ExchangeRows (False);
 end;

 procedure Set5;

 begin
   ExchangeCoords;
 end;

 procedure Set6;
 var
   Y: Integer;

 begin
   ExchangeCoords;
   for Y:= 0 to Height-1 do
     ExchangeColumns (Bitmap.ScanLine[Y]);
 end;

 procedure Set7;

 begin
   ExchangeCoords;
   ExchangeRows (True);
 end;

 procedure Set8;

 begin
   ExchangeCoords;
   ExchangeRows (False);
 end;

var
  BitmapInfo: Windows.TBitmap;

begin
  if Orientation <> 1 then begin
    GetObject (Bitmap.Handle, SizeOf (Windows.TBitmap), @BitmapInfo);
    if BitmapInfo.bmBitsPixel >= 8 then
      BPP:= BitmapInfo.bmBitsPixel
    else begin
      Bitmap.PixelFormat:= pf24bit;
      BPP               := 24;
    end;
    PixelSize:= BPP shr 3;
    Width    := BytesPerScanline (Bitmap.Width, BPP, 32);
    Height   := Abs (Bitmap.Height);
    if PixelSize = 0 then
      Inc (PixelSize);
    case Orientation of
      2: Set2; // (Right, Top)
      3: Set3; // (Right, Bottom)
      4: Set4; // (Left, Bottom)
      5: Set5; // (Top, Left)
      6: Set6; // (Top, Right)
      7: Set7; // (Bottom, Right)
      8: Set8; // (Bottom, Left)
    end;
  end;
end;





procedure CMYKToRGBImage (Bitmap: TBitmap);
var
  Size : Integer;
  Y    : Integer;
  Line1: PLine;
  Line2: PLine;

begin
  Size:= Bitmap.Width shl 2;
  GetMem (Line2, Size);
  try
    for Y:= 0 to Abs (Bitmap.Height)-1 do begin
      Line1:= Bitmap.ScanLine[Y];
      CMYKToRGBLine (Line1, Line2, Bitmap.Width, 4);
      Move (Line2[0], Line1[0], Size);
    end;
  finally
    FreeMem (Line2);
  end;
end;





procedure LabToRGBImage (Bitmap: TBitmap);
var
  Size : Integer;
  Y    : Integer;
  Line1: PLine;
  Line2: PLine;

begin
  Size:= Bitmap.Width*3;
  GetMem (Line2, Size);
  try
    for Y:= 0 to Abs (Bitmap.Height)-1 do begin
      Line1:= Bitmap.ScanLine[Y];
      LabToRGBLine (Line1, Line2, Bitmap.Width);
      Move (Line2[0], Line1[0], Size);
    end;
  finally
    FreeMem (Line2);
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
constructor TTIFFImageDecoder.Create (ABitmap: TBitmap; AStream: TStream);
const
  cBitsPerPixel: array[pf1bit..pf32bit] of Integer= (01, 04, 08, 16, 16, 24, 32);

begin
  inherited Create;

  if ABitmap.PixelFormat in [pfDevice, pfCustom] then
    raise Exception.Create ('TIFF: Decoder Error !');
  Bitmap       := ABitmap;
  Stream       := AStream;
  Width        := Bitmap.Width;
  Height       := Bitmap.Height;
  Start        := Bitmap.ScanLine[Height-1];
  Line         := Bitmap.ScanLine[0];
  X            := 0;
  Y            := 0;
  Plane        := nil;
  BitsPerPixel := cBitsPerPixel[Bitmap.PixelFormat];
  TIFFWidthLine:= (Width*BitsPerPixel + 7) shr 3;
  BMPWidthLine := BytesPerScanline (Width, BitsPerPixel, 32);
  PixelSize    := BitsPerPixel shr 3;
  Component    := PixelSize-1;
  GetMem (Plane, Width);
end;





destructor TTIFFImageDecoder.Destroy;

begin
  FreeMem (Plane);

  inherited Destroy;
end;





function TTIFFImageDecoder.GetScanLine (Row: Integer): Pointer;

begin
  Integer (Result):= Integer (Start) + (Height-Row-1)*BMPWidthLine;
end;





procedure TTIFFImageDecoder.YCbCrToRGB (YIndex: Byte);
var
  DB, DG, DR  : Double;
  DCb, DCr, DY: Double;

 function Range (Value: Integer): Byte;

 begin
   if Value < 0 then
     Result:= 0
   else if Value > 255 then
     Result:= 255
   else
     Result:= Value;
 end;

begin
  DY         := (YCbCr[YIndex ]-ReferenceBlack[0])*BlackWhiteDiff[0];
  DCb        := (YCbCr[CbIndex]-ReferenceBlack[1])*BlackWhiteDiff[1];
  DCr        := (YCbCr[CrIndex]-ReferenceBlack[2])*BlackWhiteDiff[2];

  DR         := DCr*(2 - 2*LumaRed) + DY;
  DB         := DCb*(2 - 2*LumaBlue) + DY;
  DG         := (DY - LumaBlue*DB - LumaRed*DR)/LumaGreen;

  RGB[cRed]  := Range (Round (DR));
  RGB[cGreen]:= Range (Round (DG));
  RGB[cBlue] := Range (Round (DB));
end;




//----------------------------------------------------------------------------------------------
procedure TTIFFDecoder_08b.Execute (ACount: Integer);
var
  F, I: Integer;

begin
  ACount:= ACount div TIFFWidthLine;
  F     := Y+ACount;
  if F >= Height then
    F:= Height-1;
  for I:= Y to F do begin
    Line:= GetScanLine (I);
    Stream.Read (Line[0], TIFFWidthLine); // Lê uma linha
  end;
  Y:= F;
end;




//----------------------------------------------------------------------------------------------
procedure TTIFFDecoder_08b_HorDiff.Execute (ACount: Integer);
var
  F, I: Integer;

begin
  ACount:= ACount div TIFFWidthLine;
  F     := Y+ACount;
  if F >= Height then
    F:= Height-1;
  for I:= Y to F do begin
    Line:= GetScanLine (I);
    Stream.Read (Line[0], TIFFWidthLine); // Lê uma linha
    UndoHorDiff (Line, TIFFWidthLine, PixelSize);
  end;
  Y:= F;
end;




//----------------------------------------------------------------------------------------------
procedure TTIFFDecoder_24b.Execute (ACount: Integer);
var
  F, I: Integer;

begin
  ACount:= ACount div TIFFWidthLine;
  F     := Y+ACount;
  if F >= Height then
    F:= Height-1;
  for I:= Y to F do begin
    Line:= GetScanLine (I);
    Stream.Read (Line[0], TIFFWidthLine); // Lê uma linha
    SwapLine (Line, TIFFWidthLine, PixelSize);
  end;
  Y:= F;
end;




//----------------------------------------------------------------------------------------------
procedure TTIFFDecoder_24b_Planar2.Execute (ACount: Integer);
var
  E, F, I: Integer;

begin
  if Component >= 0 then begin
    ACount:= ACount div Width;
    E     := Width*PixelSize + Component - PixelSize;
    F     := Y+ACount;
    if F >= Height then
      F:= Height-1;
    for I:= Y to F do begin
      Stream.Read (Plane[0], Width); // Lê uma linha
      Line2ToLine1 (Plane, GetScanLine (I), Width, E, PixelSize);
    end;
    if F < Height-1 then
      Y:= F
    else begin
      Dec (Component);
      Y:= 0;
    end;
  end;
end;




//----------------------------------------------------------------------------------------------
constructor TTIFFDecoder_CMYK.Create (ABitmap: TBitmap; AStream: TStream);

begin
  inherited Create (ABitmap, AStream);

  CMYKWidthLine:= Bitmap.Width shl 2;
  GetMem (CMYKLine, CMYKWidthLine);
end;





destructor TTIFFDecoder_CMYK.Destroy;

begin
  FreeMem (CMYKLine);

  inherited Destroy;
end;





procedure TTIFFDecoder_CMYK.Execute (ACount: Integer);
var
  F, I: Integer;

begin
  ACount:= ACount div CMYKWidthLine;
  F     := Y+ACount;
  if F >= Height then
    F:= Height-1;
  for I:= Y to F do begin
    Stream.Read (CMYKLine[0], CMYKWidthLine);
    CMYKToRGBLine (CMYKLine, GetScanLine (I), Width, PixelSize);
  end;
  Y:= F;
end;




//----------------------------------------------------------------------------------------------
constructor TTIFFDecoder_CIELab.Create (ABitmap: TBitmap; AStream: TStream);

begin
  inherited Create (ABitmap, AStream);

  GetMem (LabLine, TIFFWidthLine);
end;





destructor TTIFFDecoder_CIELab.Destroy;

begin
  FreeMem (LabLine);

  inherited Destroy;
end;





procedure TTIFFDecoder_CIELab.Execute (ACount: Integer);
var
  F, I: Integer;

begin
  ACount:= ACount div TIFFWidthLine;
  F     := Y+ACount;
  if F >= Height then
    F:= Height-1;
  for I:= Y to F do begin
    Stream.Read (LabLine[0], TIFFWidthLine);
    LabToRGBLine (LabLine, GetScanLine (I), Width);
  end;
  Y:= F;
end;




//----------------------------------------------------------------------------------------------
constructor TTIFFDecoder_YCbCr.Create (ABitmap: TBitmap; AStream: TStream; ALumaRed, ALumaGreen, ALumaBlue: Double; AReferenceBlack, ABlackWhiteDiff: TTIFFSingleArray; AYWidth, AYHeight: Byte);

begin
  inherited Create (ABitmap, AStream);

  LumaRed       := ALumaRed;
  LumaGreen     := ALumaGreen;
  LumaBlue      := ALumaBlue;
  ReferenceBlack:= AReferenceBlack;
  BlackWhiteDiff:= ABlackWhiteDiff;
  YWidth        := AYWidth;
  YHeight       := AYHeight;
  YLength       := YWidth*YHeight;
  CbIndex       := YLength;
  CrIndex       := CbIndex + 1;
  Width         := Bitmap.Width*3;
  Index         := 0;
end;





procedure TTIFFDecoder_YCbCr.Execute (ACount: Integer);
var
  Value: Byte;
  K    : Integer;

begin
  for K:= 1 to ACount do begin
    Stream.Read (Value, 1);
    Write (Value);
  end;
end;

// Y      -> Luminance
// Cb, Cr -> Chrominance
// (Y00..YMN Cb Cr)[0], (Y00..YMN Cb Cr)[1], (Y00..YMN Cb Cr)[2] ...
// Onde, M="YCbCrSubsampleHoriz" e N= "YCbCrSubsampleVert"
procedure TTIFFDecoder_YCbCr.Write (const Value);
var
  I, J: SmallInt;

begin
  YCbCr[Index]:= Byte (Value);
  Inc (Index);
  if Index > CrIndex then begin
    Index:= 0;
    for J:= 0 to YWidth-1 do begin
      for I:= 0 to YHeight-1 do begin
        //if Y+I < Height then // "YWidth:= 0" torna esta comparação desnecessária
          Line:= GetScanLine (Y+I);
        RGB:= @Line[X];
        YCbCrToRGB (J + I*YWidth);
      end;
      Inc (X, 3);
      if X = Width then begin
        X:= 0;
        Inc (Y, YHeight);
        if Y+YHeight >= Height then begin
          YHeight:= Height-Y;
          if YHeight = 0 then begin
            YWidth:= 0;
            Exit;
          end;
        end;
      end;
    end;
  end;
end;




//----------------------------------------------------------------------------------------------
constructor TTIFFPackBitsDecoder.Create (ABitmap: TBitmap; AStream: TStream; ARowsPerStrip: Integer);

begin
  inherited Create (ABitmap, AStream);

  RowsPerStrip:= ARowsPerStrip;
end;





procedure TTIFFPackBitsDecoder.UnpackLine (Line: PLine; Count: Integer);
var
  B   : Byte;
  N, P: Integer;
  S   : ShortInt;

begin
  P:= 0;
  while P < Count do begin
    Stream.Read (S, 1);
    N:= S;
    if N in [0..127] then begin
      Inc (N);
      Stream.Read (Line[P], N);
    end
    else if (N >= -127) and (N <= -1) then begin
      N:= Abs (N) + 1;
      Stream.Read (B, 1);
      if P+N <= Count then
        FillChar (Line[P], N, B)
      else
        FillChar (Line[P], Count-P, B);
    end;
    Inc (P, N);
  end;
end;




//----------------------------------------------------------------------------------------------
procedure TTIFFPackBitsDecoder_08b.Execute (ACount: Integer);
var
  F, I: Integer;

begin
  F:= Y+RowsPerStrip;
  if F >= Height then
    F:= Height-1;
  for I:= Y to F do
    UnpackLine (GetScanLine (I), TIFFWidthLine);
  Y:= F;  
end;




//----------------------------------------------------------------------------------------------
procedure TTIFFPackBitsDecoder_08b_HorDiff.Execute (ACount: Integer);
var
  F, I: Integer;

begin
  F:= Y+RowsPerStrip;
  if F >= Height then
    F:= Height-1;
  for I:= Y to F do begin
    Line:= GetScanLine (I);
    UnpackLine (Line, TIFFWidthLine);
    UndoHorDiff (Line, TIFFWidthLine, 1);
  end;
  Y:= F;  
end;




//----------------------------------------------------------------------------------------------
procedure TTIFFPackBitsDecoder_24b.Execute (ACount: Integer);
var
  F, I: Integer;

begin
  F:= Y+RowsPerStrip;
  if F >= Height then
    F:= Height-1;
  for I:= Y to F do begin
    Line:= GetScanLine (I);
    UnpackLine (Line, TIFFWidthLine);
    SwapLine (Line, TIFFWidthLine, PixelSize);
  end;
  Y:= F;
end;




//----------------------------------------------------------------------------------------------
procedure TTIFFPackBitsDecoder_24b_Planar2.Execute (ACount: Integer);
var
  E, F, I: Integer;

begin
  if Component >= 0 then begin
    E:= Width*PixelSize + Component - PixelSize;
    F:= Y+RowsPerStrip;
    if F >= Height then
      F:= Height-1;
    for I:= Y to F do begin
      UnpackLine (Plane, Width);
      Line2ToLine1 (Plane, GetScanLine (I), Width, E, PixelSize);
    end;
    if F < Height-1 then
      Y:= F
    else begin
      Dec (Component);
      Y:= 0;
    end;
  end;
end;




//----------------------------------------------------------------------------------------------
constructor TTIFFPackBitsDecoder_CMYK.Create (ABitmap: TBitmap; AStream: TStream; ARowsPerStrip: Integer);

begin
  inherited Create (ABitmap, AStream, ARowsPerStrip);

  CMYKWidthLine:= (Width*32 + 7) shr 3;
  GetMem (CMYKLine, CMYKWidthLine);
end;





destructor TTIFFPackBitsDecoder_CMYK.Destroy;

begin
  FreeMem (CMYKLine);

  inherited Destroy;
end;





procedure TTIFFPackBitsDecoder_CMYK.Execute (ACount: Integer);
var
  F, I: Integer;

begin
  F:= Y+RowsPerStrip;
  if F >= Height then
    F:= Height-1;
  for I:= Y to F do begin
    UnpackLine (CMYKLine, CMYKWidthLine);
    CMYKToRGBLine (CMYKLine, GetScanLine (I), Width, PixelSize);
  end;
  Y:= F;
end;




//----------------------------------------------------------------------------------------------
constructor TTIFFPackBitsDecoder_CIELab.Create (ABitmap: TBitmap; AStream: TStream; ARowsPerStrip: Integer);

begin
  inherited Create (ABitmap, AStream, ARowsPerStrip);

  GetMem (LabLine, TIFFWidthLine);
end;





destructor TTIFFPackBitsDecoder_CIELab.Destroy;

begin
  FreeMem (LabLine);

  inherited Destroy;
end;





procedure TTIFFPackBitsDecoder_CIELab.Execute (ACount: Integer);
var
  F, I: Integer;

begin
  F:= Y+RowsPerStrip;
  if F >= Height then
    F:= Height-1;
  for I:= Y to F do begin
    UnpackLine (LabLine, TIFFWidthLine);
    LabToRGBLine (LabLine, GetScanLine (I), Width);
  end;
  Y:= F;
end;




//----------------------------------------------------------------------------------------------
constructor TTIFFLZWDecoder.Create (ABitmap: TBitmap; AStream: TStream);

begin
  inherited Create (ABitmap, AStream);

  Dictionary:= TLZWTable.Create;
end;





destructor TTIFFLZWDecoder.Destroy;

begin
  Dictionary.Free;

  inherited Destroy;
end;





procedure TTIFFLZWDecoder.Execute (ACount: Integer);
var
  Aux      : Byte;
  Character: Byte;
  Prefix   : Integer;
  Old      : Word;

 // Ocorre quando é encontrado um "ClearCode"
 procedure Reinicializar;

 begin
   CodeSize:= cInitCodeSize;
   FreeCode:= cFreeCode;
   MaxCode := 1 shl cInitCodeSize;
   ReadMask:= MaxCode-1;
   Disp    := 32-CodeSize;
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
  StartPos:= Integer (TMemoryStream (Stream).Memory) + Stream.Position;
  EndPos  := ACount-1;
  Offset  := 0;
  Code    := 0;
  Reinicializar;
  while True do begin
    Old:= Code + 1;
    GetNextCode;
    if Code = cEndOfInformation then
      Break
    else if Code = cClearCode then begin
      Reinicializar;
      Dictionary.Initialize (cFreeCode);
      GetNextCode;
      if Code = cEndOfInformation then
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
    end;
  end;
end;





procedure TTIFFLZWDecoder.GetNextCode;
var
  Position: Integer;

begin
  Position:= Offset shr 3;
  if Position > EndPos then
    Code:= cEndOfInformation
  else begin
    // Tentar tirar o "Swap32"
    Code:= (Swap32 (PInteger (StartPos + Position)^) shr (Disp-(Offset and 7))) and ReadMask;
    Inc (Offset, CodeSize);
    Inc (FreeCode);
    if FreeCode >= MaxCode then begin
      Inc (CodeSize);
      MaxCode := MaxCode shl 1;
      ReadMask:= MaxCode-1;
      Disp    := 32-CodeSize;
    end;
  end;
end;




//----------------------------------------------------------------------------------------------
procedure TTIFFLZWDecoder_08b.Write (const Value);

begin
  Line[X]:= Byte (Value);
  Inc (X);
  if X = TIFFWidthLine then begin
    X:= 0;
    Inc (Y);
    if Y < Height then
      Line:= GetScanLine (Y);
  end;
end;




//----------------------------------------------------------------------------------------------
procedure TTIFFLZWDecoder_08b_HorDiff.Write (const Value);

begin
  Line[X]:= Byte (Value);
  Inc (X);
  if X = TIFFWidthLine then begin
    X:= 0;
    Inc (Y);
    UndoHorDiff (Line, TIFFWidthLine, 1);
    if Y < Height then
      Line:= GetScanLine (Y);
  end;
end;




//----------------------------------------------------------------------------------------------
procedure TTIFFLZWDecoder_24b.Write (const Value);

begin
  Line[X]:= Byte (Value);
  Inc (X);
  if X >= TIFFWidthLine then begin
    SwapLine (Line, TIFFWidthLine, PixelSize);
    X:= 0;
    Inc (Y);
    if Y < Height then
      Line:= GetScanLine (Y);
  end;
end;




//----------------------------------------------------------------------------------------------
constructor TTIFFLZWDecoder_24b_Planar2.Create (ABitmap: TBitmap; AStream: TStream);

begin
  inherited Create (ABitmap, AStream);

  E:= Width*PixelSize + Component - PixelSize;
end;





procedure TTIFFLZWDecoder_24b_Planar2.Write (const Value);

begin
  Plane[X]:= Byte (Value);
  Inc (X);
  if X >= Width then begin
    X:= 0;
    Inc (Y);
    if Y < Height then
      Line2ToLine1 (Plane, GetScanLine (Y), Width, E, PixelSize)
    else begin
      Dec (Component);
      Y:= 0;
      E:= Width*PixelSize + Component - PixelSize;
    end;
  end;
end;  




//----------------------------------------------------------------------------------------------
constructor TTIFFLZWDecoder_YCbCr.Create (ABitmap: TBitmap; AStream: TStream; ALumaRed, ALumaGreen, ALumaBlue: Double; AReferenceBlack, ABlackWhiteDiff: TTIFFSingleArray; AYWidth, AYHeight: Byte);

begin
  inherited Create (ABitmap, AStream);

  LumaRed       := ALumaRed;
  LumaGreen     := ALumaGreen;
  LumaBlue      := ALumaBlue;
  ReferenceBlack:= AReferenceBlack;
  BlackWhiteDiff:= ABlackWhiteDiff;
  YWidth        := AYWidth;
  YHeight       := AYHeight;
  YLength       := YWidth*YHeight;
  CbIndex       := YLength;
  CrIndex       := CbIndex + 1;
  Width         := Bitmap.Width*3;
  Index         := 0;
end;

// Y      -> Luminance
// Cb, Cr -> Chrominance
// (Y00..YMN Cb Cr)[0], (Y00..YMN Cb Cr)[1], (Y00..YMN Cb Cr)[2] ...
// Onde, M="YCbCrSubsampleHoriz" e N= "YCbCrSubsampleVert"
procedure TTIFFLZWDecoder_YCbCr.Write (const Value);
var
  I, J: SmallInt;

begin
  YCbCr[Index]:= Byte (Value);
  Inc (Index);
  if Index > CrIndex then begin
    Index:= 0;
    for J:= 0 to YWidth-1 do begin
      for I:= 0 to YHeight-1 do begin
        //if Y+I < Height then // "YWidth:= 0" torna esta comparação desnecessária
          Line:= GetScanLine (Y+I);
        RGB:= @Line[X];
        YCbCrToRGB (J + I*YWidth);
      end;
      Inc (X, 3);
      if X = Width then begin
        X:= 0;
        Inc (Y, YHeight);
        if Y+YHeight >= Height then begin
          YHeight:= Height-Y;
          if YHeight = 0 then begin
            YWidth:= 0;
            Exit;
          end;
        end;
      end;
    end;
  end;
end;




//----------------------------------------------------------------------------------------------
constructor TTIFFLZWDecoder_CMYK.Create (ABitmap: TBitmap; AStream: TStream);

begin
  inherited Create (ABitmap, AStream);

  CMYKWidthLine:= Bitmap.Width shl 2;
  GetMem (CMYKLine, CMYKWidthLine);
end;





destructor TTIFFLZWDecoder_CMYK.Destroy;

begin
  FreeMem (CMYKLine);

  inherited Destroy;
end;





procedure TTIFFLZWDecoder_CMYK.Write (const Value);

begin
  CMYKLine[X]:= Byte (Value);
  Inc (X);
  if X >= CMYKWidthLine then begin
    CMYKToRGBLine (CMYKLine, Line, Width, PixelSize);
    X:= 0;
    Inc (Y);
    if Y < Height then
      Line:= GetScanLine (Y);
  end;
end;




//----------------------------------------------------------------------------------------------
constructor TTIFFLZWDecoder_CIELab.Create (ABitmap: TBitmap; AStream: TStream);

begin
  inherited Create (ABitmap, AStream);

  GetMem (LabLine, TIFFWidthLine); // Refazer: Acabar com "LabLine" e utilzar o "Line" 
end;





destructor TTIFFLZWDecoder_CIELab.Destroy;

begin
  FreeMem (LabLine);

  inherited Destroy;
end;





procedure TTIFFLZWDecoder_CIELab.Write (const Value);

begin
  LabLine[X]:= Byte (Value);
  Inc (X);
  if X >= TIFFWidthLine then begin
    LabToRGBLine (LabLine, Line, Width);
    X:= 0;
    Inc (Y);
    if Y < Height then
      Line:= GetScanLine (Y);
  end;
end;




//----------------------------------------------------------------------------------------------
constructor TTIFFEncoder.Create (AStream: TStream);

begin
  inherited Create;

  Stream         := AStream;
  StripByteCounts:= TList.Create;
  NextIFD        := 0;
  NextIFDOffset  := 0;
end;





destructor TTIFFEncoder.Destroy;

begin
  StripByteCounts.Free;

  inherited Destroy;
end;





procedure TTIFFEncoder.CalcBlocksSize (Count: Integer; BlockSize: Integer);

begin
  StripByteCounts.Clear;
  if Count <= BlockSize then
    StripByteCounts.Add (Pointer (Count))
  else
    while Count > 0 do begin
      if Count < BlockSize then
        BlockSize:= Count;
      StripByteCounts.Add (Pointer (BlockSize));
      Dec (Count, BlockSize);
    end;
end;





procedure TTIFFEncoder.Add (Bitmap: TBitmap; Compression: TTIFFCompression; const ImageDescription, Software, Artist: String);
const
  cCompression: array[TTIFFCompression] of Word= (1, 2, 3, 4, 5, 6, 32773, 0);
  cNextIFD    : Integer                        = 0;

 procedure WriteEntry (ATag, ATypeField: Word; ACount, AValueOrOffset: Integer);
 var
   Directory: TTIFFImageFileDirectory;

 begin
   with Directory do begin
     Tag          := ATag;
     TypeField    := ATypeField;
     Count        := ACount;
     ValueOrOffset:= AValueOrOffset;
   end;
   Stream.Write (Directory, SizeOf (TTIFFImageFileDirectory));
 end;

 function ConvertString (const S: String): Integer;

 begin
   case Length (S) of
     1: Result:= ((Ord (S[1]) shl 24)) and $FF000000;
     2: Result:= ((Ord (S[1]) shl 24) or (Ord (S[2]) shl 16)) and $FFFF0000;
     3: Result:= ((Ord (S[1]) shl 24) or (Ord (S[2]) shl 16) or (Ord (S[3]) shl 8)) and $FFFFFF00;
   end;
 end;

 procedure WriteNextIFD;
 var
   Save  : Integer;
   Header: TTIFFImageFileHeader;

 begin
   if NextIFD <> 0 then begin
     Save:= Stream.Position;
     try
       Stream.Seek (NextIFDOffset, soFromBeginning);
       Stream.Write (NextIFD, 4);
     finally
       Stream.Seek (Save, soFromBeginning);
     end;
   end
   else begin
     // TIFFHeader
     with Header do begin
       ByteOrder:= $4949;
       Version  := $002A;
       Offset   := Stream.Position + SizeOf (TTIFFImageFileHeader);
     end;
     Stream.Write (Header, SizeOf (TTIFFImageFileHeader));
   end;
 end;

type
  TOffsets= record
    Artist         : Integer;
    BitsPerSample  : Integer;
    Description    : Integer;
    Palette        : Integer;
    Software       : Integer;
    StripByteCounts: Integer;
    StripOffsets   : Integer;
  end;

var
  FirstFreePosition: Integer;
  PaletteLength    : Integer;
  Offsets          : TOffsets;
  BitmapInfo       : Windows.TBitmap;
  EntryCount       : Word;
  SamplesPerPixel  : Word;

begin
  if not Bitmap.Empty then begin
    // Amarra com o "Image File Directory" anterior, caso exista; senão grava o "Header"
    WriteNextIFD;

    // Informações básicas
    GetObject (Bitmap.Handle, SizeOf (Windows.TBitmap), @BitmapInfo);
    BitsPerPixel    := BitmapInfo.bmBitsPixel;
    SamplesPerPixel := BitsPerPixel div 8;
    PaletteLength   := 1 shl BitsPerPixel;
    TIFFBytesPerLine:= (Bitmap.Width*BitsPerPixel + 7) shr 3;
    RowsPerStrip    := 1;
    if SamplesPerPixel = 0 then
      Inc (SamplesPerPixel);
    if not (BitsPerPixel in [1, 4, 8, 24, 32]) then
      raise Exception.Create ('Unsupported Pixel Format !');

    // Calcula o tamanho dos blocos
    if TIFFBytesPerLine >= cBlockSize then
      CalcBlocksSize (Bitmap.Height*TIFFBytesPerLine, TIFFBytesPerLine)
    else begin
      RowsPerStrip:= cBlockSize div TIFFBytesPerLine; // Para garantir que "BlockSize" será múltiplo de "TIFFBytesPerLine"
      if RowsPerStrip > Abs (Bitmap.Height) then
        RowsPerStrip:= Abs (Bitmap.Height);
      CalcBlocksSize (Abs (Bitmap.Height)*TIFFBytesPerLine, TIFFBytesPerLine*RowsPerStrip);
    end;

    // EntryCount
    EntryCount:= 10;
    if ImageDescription <> '' then
      Inc (EntryCount);
    if Software <> '' then
      Inc (EntryCount);
    if Artist <> '' then
      Inc (EntryCount);
    Stream.Write (EntryCount, 2);

    // Offsets
    FirstFreePosition:= Stream.Position + EntryCount*SizeOf (TTIFFImageFileDirectory) + 4; // 4 -> Endereço do próximo "Image File Directory"
    FillChar (Offsets, SizeOf (TOffsets), #0);
    if BitsPerPixel <= 8 then
      Offsets.BitsPerSample:= BitsPerPixel
    else begin
      Offsets.BitsPerSample:= FirstFreePosition;
      Inc (FirstFreePosition, SamplesPerPixel*2);
    end;
    if ImageDescription <> '' then begin
      Offsets.Description:= FirstFreePosition;
      Inc (FirstFreePosition, Length (ImageDescription) + 1);
    end;
    if Software <> '' then begin
      Offsets.Software:= FirstFreePosition;
      Inc (FirstFreePosition, Length (Software) + 1);
    end;
    if Artist <> '' then begin
      Offsets.Artist:= FirstFreePosition;
      Inc (FirstFreePosition, Length (Artist) + 1);
    end;
    if BitsPerPixel <= 8 then begin
      Offsets.Palette := FirstFreePosition;
      Inc (FirstFreePosition, PaletteLength*3*2);
    end;
    if StripByteCounts.Count = 1 then begin
      Offsets.StripByteCounts:= Integer (StripByteCounts[0]);
      Offsets.StripOffsets   := FirstFreePosition;
    end
    else begin
      Offsets.StripByteCounts:= FirstFreePosition;
      Offsets.StripOffsets   := Offsets.StripByteCounts + StripByteCounts.Count*4;
    end;

    // ImageWidth
    WriteEntry ($100, cftLONG, 1, Bitmap.Width);

    // ImageLength
    WriteEntry ($101, cftLONG, 1, Abs (Bitmap.Height));

    // BitsPerSample
    WriteEntry ($102, cftSHORT, SamplesPerPixel, Offsets.BitsPerSample);

    // Method
    WriteEntry ($103, cftSHORT, 1, cCompression[Compression]);

    // PhotometricInterpretation
    if BitsPerPixel <= 8 then
      WriteEntry ($106, cftSHORT, 1, cpiRGBPalette)
    else
      WriteEntry ($106, cftSHORT, 1, cpiRGB);

    // ImageDescription
    if ImageDescription <> '' then
      if Length (ImageDescription) <= 3 then
        WriteEntry ($10E, cftASCII, Length (ImageDescription) + 1, ConvertString (ImageDescription))
      else
        WriteEntry ($10E, cftASCII, Length (ImageDescription) + 1, Offsets.Description);

    // StripOffsets
    WriteEntry ($111, cftLONG, StripByteCounts.Count, Offsets.StripOffsets);
    if StripByteCounts.Count = 1 then
      StripOffsetsOffset:= Stream.Position-4
    else
      StripOffsetsOffset:= Offsets.StripOffsets;

    // SamplesPerPixel
    WriteEntry ($115, cftSHORT, 1, SamplesPerPixel);

    // RowsPerStrip
    WriteEntry ($116, cftLONG, 1, RowsPerStrip);

    // StripByteCounts
    WriteEntry ($117, cftLONG, StripByteCounts.Count, Offsets.StripByteCounts);
    if StripByteCounts.Count = 1 then
      StripByteCountsOffset:= Stream.Position-4
    else
      StripByteCountsOffset:= Offsets.StripByteCounts;

    // PlanarConfiguration
    if BitsPerPixel > 8 then
      WriteEntry ($11C, cftSHORT, 1, 1);

    // Software
    if Software <> '' then
      if Length (Software) <= 3 then
        WriteEntry ($131, cftASCII, Length (Software) + 1, ConvertString (Software))
      else
        WriteEntry ($131, cftASCII, Length (Software) + 1, Offsets.Software);

    // Artist
    if Artist <> '' then
      if Length (Artist) <= 3 then
        WriteEntry ($13B, cftASCII, Length (Artist) + 1, ConvertString (Artist))
      else
        WriteEntry ($13B, cftASCII, Length (Artist) + 1, Offsets.Artist);

    // ColorMap
    if BitsPerPixel <= 8 then
      WriteEntry ($140, cftSHORT, PaletteLength*3, Offsets.Palette);

    // Finaliza o "Image File Directory"
    NextIFDOffset:= Stream.Position;
    Stream.Write (cNextIFD, 4);

    // Grava o que não coube em 4 bytes
    if SamplesPerPixel > 1 then
      WriteSamplesPerPixel (Offsets.BitsPerSample, SamplesPerPixel);
    if Length (ImageDescription) > 3 then
      WriteTxt (Offsets.Description, ImageDescription);
    if Length (Software) > 3 then
      WriteTxt (Offsets.Software, Software);
    if Length (Artist) > 3 then
      WriteTxt (Offsets.Artist, Artist);
    if BitsPerPixel <= 8 then
      WritePalette (Bitmap, Offsets.Palette, PaletteLength);
    if StripByteCounts.Count > 1 then begin
      WriteList (Offsets.StripByteCounts, StripByteCounts);
      WriteList (Offsets.StripOffsets, StripByteCounts);
    end;

    // Grava a imagem
    WriteImage (Bitmap, Compression);

    // Próxima posição livre
    NextIFD:= Stream.Position;
  end;
end;





procedure TTIFFEncoder.WriteSamplesPerPixel (Offset: Integer; Count: Byte);
const
  cSamplesPerPixel: array[0..3] of Word= (8, 8, 8, 8);

begin
  with Stream do begin
    Seek (Offset, soFromBeginning);
    Write (cSamplesPerPixel[0], Count*2);
  end;  
end;





procedure TTIFFEncoder.WriteTxt (Offset: Integer; const Value: String);
const
  cNull: Char= #0;
  
begin
  with Stream do begin
    Seek (Offset, soFromBeginning);
    Write (Value[1], Length (Value));
    Write (cNull, 1);
  end;  
end;





procedure TTIFFEncoder.WritePalette (Bitmap: TBitmap; Offset: Integer; PaletteLength: Integer);
var
  SaveIgnorePalette: Boolean;
  Color            : Word;
  Tripla           : Integer;
  Palette          : array[Byte] of TPaletteEntry;

begin
  FillChar (Palette, 256*SizeOf (TPaletteEntry), #0);
  SaveIgnorePalette:= Bitmap.IgnorePalette;
  try
    Bitmap.IgnorePalette:= False; // Do contrário pode vir uma paleta vazia !!!
    if GetPaletteEntries (Bitmap.Palette, 0, PaletteLength, Palette) = 0 then
      if PaletteLength = 2 then
        FillChar (Palette[1], 3, #255)
      else
        GetPaletteEntries (GetStockObject (DEFAULT_PALETTE), 0, PaletteLength, Palette);
    Stream.Seek (Offset, soFromBeginning);
    for Tripla:= 0 to PaletteLength-1 do begin
      Color:= Swap (Palette[Tripla].peRed and $FF);
      Stream.Write (Color, 2);
    end;
    for Tripla:= 0 to PaletteLength-1 do begin
      Color:= Swap (Palette[Tripla].peGreen and $FF);
      Stream.Write (Color, 2);
    end;
    for Tripla:= 0 to PaletteLength-1 do begin
      Color:= Swap (Palette[Tripla].peBlue and $FF);
      Stream.Write (Color, 2);
    end;
  finally
    Bitmap.IgnorePalette:= SaveIgnorePalette;
  end;
end;





procedure TTIFFEncoder.WriteList (Offset: Integer; List: TList);
var
  I, Value: Integer;

begin
  Stream.Seek (Offset, soFromBeginning);
  for I:= 0 to List.Count-1 do begin
    Value:= Integer (List[I]);
    Stream.Write (Value, 4);
  end;
end;





procedure TTIFFEncoder.WriteImage (Bitmap: TBitmap; Compression: TTIFFCompression);
var
  Size  : Integer;
  Output: TMemoryStream;

 procedure WriteValue (var Offset: Integer; Value: Integer);
 var
   Save: Integer;

 begin
   Save:= Stream.Position;
   try
     Stream.Seek (Offset, soFromBeginning);
     Stream.Write (Value, 4);
     Inc (Offset, 4);
   finally
     Stream.Seek (Save, soFromBeginning);
   end;
 end;

 procedure WriteBlock;
 var
   Save: Integer;

 begin
   Save:= Stream.Position;
   WriteValue (StripOffsetsOffset, Save);
   case Compression of
     ctiffcLZW     : WriteImage_LZW (Output, Output.Size);
     ctiffcNone    : Stream.CopyFrom (Output, Output.Size);
     ctiffcPackBits: WriteImage_PackBits (Output, Output.Size);
   end;
   WriteValue (StripByteCountsOffset, Stream.Position-Save);
 end;

var
  PixelSize: Byte;
  Count    : Integer;
  F, I, J  : Integer;
  X        : Integer;
  Y        : Integer;
  Line     : PLine;

begin
  Output:= TMemoryStream.Create;
  try
    Y:= 0;
    if Bitmap.PixelFormat in [pf24bit, pf32bit] then begin
      PixelSize:= BitsPerPixel shr 3;
      for I:= 0 to StripByteCounts.Count-1 do begin
        Count:= Integer (StripByteCounts[I]);
        if Count <> Output.Size then
          Output.SetSize (Count);
        Output.Seek (0, soFromBeginning);
        Line:= Output.Memory;
        while Count > 0 do begin
          Output.Write (PLine (Bitmap.ScanLine[Y])[0], TIFFBytesPerLine);
          SwapLine_1 (Line, TIFFBytesPerLine, PixelSize);
          Inc (Line, TIFFBytesPerLine);
          Dec (Count, TIFFBytesPerLine);
          Inc (Y);
        end;
        Output.Seek (0, soFromBeginning);
        WriteBlock;
      end;
    end
    else
      for I:= 0 to StripByteCounts.Count-1 do begin
        Count:= Integer (StripByteCounts[I]);
        if Count <> Output.Size then
          Output.SetSize (Count);
        Output.Seek (0, soFromBeginning);
        while Count > 0 do begin
          Output.Write (PLine (Bitmap.ScanLine[Y])[0], TIFFBytesPerLine);
          Dec (Count, TIFFBytesPerLine);
          Inc (Y);
        end;
        Output.Seek (0, soFromBeginning);
        WriteBlock;
      end;
  finally
    Output.Free;
  end;
end;





procedure TTIFFEncoder.WriteImage_LZW (Input: TMemoryStream; Size: Integer);
var
  Bits      : Byte;
  Character : Byte;
  Index     : Integer;
  Offset    : Integer;
  Old       : Integer;
  Prefix    : Integer;
  Dictionary: TLZWTable;
  CodeSize  : Word;
  FreeCode  : Word;
  MaxCode   : Word;

 procedure Initialize;

 begin
   CodeSize:= cInitCodeSize;
   FreeCode:= cFreeCode;
   MaxCode := 1 shl cInitCodeSize;
   Dictionary.Initialize (cFreeCode);
 end;

 procedure Write (NewCode: Integer);

  procedure WriteCode (Code: Integer);
  var
    Bytes: Byte;
    Mod8 : Byte;
    SL   : Byte;

  begin
    Mod8 := Offset and 7;
    SL   := 32 - Mod8 - CodeSize;
    Bits := Mod8 + CodeSize;
    Bytes:= Bits shr 3;
    Code := Old or (Code shl SL);
    Old  := Code shl (Bytes shl 3);
    Code := Swap32 (Code);
    Stream.Write (Code, Bytes);
    Inc (Offset, CodeSize);
    Inc (FreeCode);
  end;

 begin
   WriteCode (NewCode);
   if FreeCode >= MaxCode then
     if CodeSize = 12 then begin
       WriteCode (cClearCode);
       Initialize;
     end
     else begin
       Inc (CodeSize);
       MaxCode:= 1 shl CodeSize;
       if CodeSize = 12 then
         Dec (MaxCode);
     end;
 end;

 procedure Flush;

 begin
   if Bits and 7 <> 0 then begin
     Old:= Swap32 (Old);
     Stream.Write (Old, 1);
   end;
 end;

begin
  Dictionary:= TLZWTable.Create;
  try
    Offset:= 0;
    Prefix:= 0;
    Old   := 0;
    Initialize;
    Write (cClearCode);
    Initialize;
    while Size > 0 do begin
      Input.Read (Character, 1);
      Index:= Dictionary.Find (Prefix, Character);
      if Index > 0 then // Está no dicionário ?
        Prefix:= Index
      else begin
        Dictionary.Add (Prefix, Character);
        Write (Prefix-1);
        Prefix:= Character+1;
      end;
      Dec (Size);
    end;
    Write (Prefix-1);
    Write (cEndOfInformation);
    Flush;
  finally
    Dictionary.Free;
  end;
end;





procedure TTIFFEncoder.WriteImage_PackBits (Input: TMemoryStream; Size: Integer);
const
  cEstouro= 256;

var
  Old   : Byte;
  Count : Integer;
  Buffer: array[0..127] of Byte;

 procedure WriteValue (Count: ShortInt);

 begin
   Stream.Write (Count, 1);
   Stream.Write (Old, 1);
 end;

 procedure WriteBuffer (Count: Byte);

 begin
   Stream.Write (Count, 1);
   Stream.Write (Buffer[0], Count+1);
 end;

 procedure EncodeValue (Current: Byte);

 begin
   if (Current = Old) and (Count <> cEstouro) then begin
     if (Count > 0) and (Count <= 127) then begin // Tem algo no "Buffer"
       WriteBuffer (Count-1);
       Count:= 0;
     end;
     Dec (Count);
     if Count = -127 then begin
       WriteValue (Count);
       Count:= cEstouro;
     end;
   end
   else begin
     if Count = cEstouro then
       Count:= -1
     else if (Count >= -127) and (Count <= -1) then begin // Tem algo repetido
       WriteValue (Count);
       Count:= -1;
     end;
     Inc (Count);
     Buffer[Count]:= Current;
     if Count = 127 then begin
       WriteBuffer (Count);
       Count:= cEstouro;
     end;
     Old:= Current;
   end;
 end;

 procedure Flush;

 begin
   if (Count >= -127) and (Count <= -1) then // Tem algo repetido
     WriteValue (Count)
   else if Count in [0..127] then
     WriteBuffer (Count);
   Count:= cEstouro;
 end;

var
  X   : Integer;
  Line: PLine;

begin
  Line:= Input.Memory;
  while Size > 0 do begin
    Count    := 0;
    Old      := Line[0];
    Buffer[0]:= Old;
    for X:= 1 to TIFFBytesPerLine-1 do
      EncodeValue (Line[X]);
    Flush;
    Inc (Line, TIFFBytesPerLine);
    Dec (Size, TIFFBytesPerLine);
  end;
end;




//----------------------------------------------------------------------------------------------
constructor TTIFFDecoder.Create (AStream: TStream);

begin
  inherited Create;

  Stream         := AStream;
  IFDOffsets     := TList.Create;
  StripOffsets   := TList.Create;
  StripByteCounts:= TList.Create;
end;





destructor TTIFFDecoder.Destroy;

begin
  IFDOffsets.Free;
  StripOffsets.Free;
  StripByteCounts.Free;

  inherited Destroy;
end;





function TTIFFDecoder.GetCount: Integer;

begin
  Result:= IFDOffsets.Count;
end;





procedure TTIFFDecoder.Read (var Buffer; Count: Integer);
var
  Lidos: Integer;

begin
  Lidos:= Stream.Read (Buffer, Count);
  if Lidos <> Count then
    raise EInvalidImage.Create (Format ('TIFF read error at %.8xH (%d byte(s) expected, but %d read)', [Stream.Position-Lidos, Count, Lidos]));
end;





procedure TTIFFDecoder.Seek (Offset: Integer; Origin: Word);

begin
  Inc (Offset, Start);
  Stream.Seek (Offset, Origin);
end;





procedure TTIFFDecoder.DumpHeader;
var
  Header: TTIFFImageFileHeader;

begin
  Read (Header, SizeOf (TTIFFImageFileHeader));
  with Header do begin
    IsII:= ByteOrder = $4949;
    if IsII then begin
      GetDouble  := GetDouble_II;
      GetInteger := GetInteger_II;
      GetRational:= GetRational_II;
      GetWord    := GetWord_II;
    end
    else begin
      GetDouble  := SwapDouble;
      GetInteger := Swap32;
      GetRational:= SwapRational;
      GetWord    := Swap16;
    end;
    ByteOrder:= GetWord (ByteOrder);
    Version  := GetWord (Version);
    Offset   := GetInteger (Offset);
    if not ((Offset >= SizeOf (TTIFFImageFileHeader)) and ((ByteOrder = $4949) and (Version = $002A)) or ((ByteOrder = $4D4D) and (Version = $002A))) then
      raise Exception.Create ('Unsupported file format !');
    IFDOffsets.Add (Pointer (Offset));
  end;
end;





procedure TTIFFDecoder.DumpDirectory;
const
  cChrominanceCodingRange= 127; // Cb, Cr CodingRange

var
  IsMonochrome       : Boolean;
  BitsPerPixel       : Integer;
  FirstValue         : Integer;
  P                  : Integer;
  BitsPerSample      : TList;
  ReferenceBlackWhite: TList;
  YCbCrCoefficients  : TList;
  YCbCrSubSampling   : TList;
  Directory          : TTIFFImageFileDirectory;
  EntryCount         : Word;
  FillOrder          : Word;
  Threshholding      : Word;

 procedure GetFirstValue;

 begin
   with Directory do
     case TypeField of
       cftASCII, cftBYTE, cftSBYTE, cftUNDEFINED: if IsII then
                                                    FirstValue:= LongRec (ValueOrOffset).Lo and $FF
                                                  else
                                                    FirstValue:= LongRec (ValueOrOffset).Hi and $FF;
       cftSHORT, cftSSHORT                      : if IsII then
                                                    FirstValue:= LongRec (ValueOrOffset).Lo
                                                  else
                                                    FirstValue:= LongRec (ValueOrOffset).Hi;
     else
       FirstValue:= ValueOrOffset;
     end;
 end;

 procedure GetCompression;

 begin
   case FirstValue of
     00001: Compression:= ctiffcNone;
     00002: Compression:= ctiffcCCITT1D;
     00003: Compression:= ctiffcGroup3Fax;
     00004: Compression:= ctiffcGroup4Fax;
     00005: Compression:= ctiffcLZW;
     00006: Compression:= ctiffcJPEG;
     32773: Compression:= ctiffcPackBits;
   else
     Compression:= ctiffcUnknown;
   end;
 end;

 procedure GetList (List: TList; const Msg: String);
 var
   I   : Integer;
   Save: Integer;
   V32b: Integer;
   V16b: Word;
   V64b: TTIFFRational;

 begin
   List.Clear;
   if Directory.TypeField in [cftLONG, cftSHORT, cftRATIONAL] then begin
     if Directory.Count = 1 then
       List.Add (Pointer (FirstValue))
     else if (Directory.Count = 2) and (Directory.TypeField = cftSHORT) then begin
       if IsII then begin
         List.Add (Pointer (LongRec (Directory.ValueOrOffset).Lo));
         List.Add (Pointer (LongRec (Directory.ValueOrOffset).Hi));
       end
       else begin
         List.Add (Pointer (LongRec (Directory.ValueOrOffset).Hi));
         List.Add (Pointer (LongRec (Directory.ValueOrOffset).Lo));
       end;
     end
     else begin
       Save:= Stream.Position;
       try
         Seek (Directory.ValueOrOffset, soFromBeginning);
         for I:= 1 to Directory.Count do
           case Directory.TypeField of
             cftLONG    : begin
                            Read (V32b, 4);
                            List.Add (Pointer (GetInteger (V32b)));
                          end;
             cftSHORT   : begin
                            Read (V16b, 2);
                            List.Add (Pointer (GetWord (V16b)));
                          end;
             cftRATIONAL: begin
                            Read (V64b, 8);
                            V64b:= GetRational (V64b);
                            List.Add (Pointer (V64b.Numerator));
                            List.Add (Pointer (V64b.Denominator));
                          end;
           end;
       finally
         Seek (Save, soFromBeginning);
       end;
     end;
   end
   else
     raise Exception.Create (Msg);
 end;

 function GetTxt: String;
 type
   TStr4= array[0..3] of Char;

 var
   Save: Integer;

 begin
   if Directory.Count <= 0 then
     Result:= ''
   else begin
     SetLength (Result, Directory.Count);
     if Directory.Count <= 4 then
       Result:= TStr4 (Directory.ValueOrOffset)
     else begin
       Save:= Stream.Position;
       try
         Seek (Directory.ValueOrOffset, soFromBeginning);
         Read (Result[1], Directory.Count);
       finally
         Seek (Save, soFromBeginning);
       end;
     end;
     SetLength (Result, Directory.Count-1);
   end;
 end;

 // Sequência dos blocos: "Red" -> "Green" -> "Blue"
 procedure GetPalette;
 var
   I   : Integer;
   Save: Integer;
   C   : Word;

 begin
   Save:= Stream.Position;
   try
     Seek (Directory.ValueOrOffset, soFromBeginning);
     with LogPalette do begin
       palNumEntries:= Directory.Count div 3;
       for I:= 0 to palNumEntries-1 do begin
         Read (C, 2);
         C:= GetWord (C);
         if LongBool (Hi (C)) then
           palPalEntry[I].peRed:= Hi (C)
         else
           palPalEntry[I].peRed:= C;
         palPalEntry[I].peFlags:= 0;
       end;
       for I:= 0 to palNumEntries-1 do begin
         Read (C, 2);
         C:= GetWord (C);
         if LongBool (Hi (C)) then
           palPalEntry[I].peGreen:= Hi (C)
         else
           palPalEntry[I].peGreen:= C;
       end;
       for I:= 0 to palNumEntries-1 do begin
         Read (C, 2);
         C:= GetWord (C);
         if LongBool (Hi (C)) then
           palPalEntry[I].peBlue:= Hi (C)
         else
           palPalEntry[I].peBlue:= C;
       end;
     end;
   finally
     Seek (Save, soFromBeginning);
   end;
 end;

 procedure MakePalette;
 var
   I: Integer;

 begin
   with LogPalette do
     if Photometric = 0 then
       for I:= 0 to palNumEntries-1 do begin
         palPalEntry[I].peRed  := palNumEntries-I-1;
         palPalEntry[I].peGreen:= palNumEntries-I-1;
         palPalEntry[I].peBlue := palNumEntries-I-1;
         palPalEntry[I].peFlags:= 0;
       end
     else
       for I:= 0 to palNumEntries-1 do begin
         palPalEntry[I].peRed  := I;
         palPalEntry[I].peGreen:= I;
         palPalEntry[I].peBlue := I;
         palPalEntry[I].peFlags:= 0;
       end;
 end;

var
  ImageLength, ImageWidth: Integer;

begin
  Read (EntryCount, 2);
  EntryCount              := GetWord (EntryCount);
  Artist                  := '';
  Description             := '';
  Software                := '';
  HorDiff                 := False;
  YCbCrSubsampleVert      := 2;
  YCbCrSubsampleHoriz     := 2;
  BitsPerPixel            := 1;
  FillOrder               := 1;
  Orientation             := 1;
  PlanarConfiguration     := 1;
  Threshholding           := 1;
  LumaRed                 := 299/1000;
  LumaGreen               := 587/1000;
  LumaBlue                := 114/1000;
  Photometric             := 0;
  ImageWidth              := 0;
  ImageLength             := 0;
  RowsPerStrip            := 0;
  LogPalette.palNumEntries:= 0;
  LogPalette.palVersion   := $0300;
  YCbCrCoefficients       := TList.Create;
  try
    YCbCrSubSampling:= TList.Create;
    try
      ReferenceBlackWhite:= TList.Create;
      try
        BitsPerSample:= TList.Create;
        try
          for P:= 1 to EntryCount do begin
            Read (Directory, SizeOf (TTIFFImageFileDirectory));
            with Directory do begin
              Tag          := GetWord (Tag);
              TypeField    := GetWord (TypeField);
              Count        := GetInteger (Count);
              ValueOrOffset:= GetInteger (ValueOrOffset);
              GetFirstValue;
              case Tag of
                $100: ImageWidth:= FirstValue;
                $101: ImageLength:= FirstValue;
                $102: GetList (BitsPerSample, 'TIFF: Unsupported "BitsPerSample" !');
                $103: GetCompression;
                $106: Photometric:= FirstValue;
                $107: Threshholding:= FirstValue;
                $10A: FillOrder:= FirstValue;
                $10E: Description:= GetTxt;
                $111: GetList (StripOffsets, 'TIFF: Unsupported "StripOffsets" !');
                $112: Orientation:= FirstValue;
                $116: RowsPerStrip:= FirstValue;
                $117: GetList (StripByteCounts, 'TIFF: Unsupported "StripByteCounts" !');
                $11C: PlanarConfiguration:= FirstValue;
                $131: Software:= GetTxt;
                $13B: Artist:= GetTxt;
                $13D: HorDiff:= FirstValue = 2;
                $140: GetPalette;
                $211: GetList (YCbCrCoefficients, 'TIFF: Unsupported "YCbCrCoefficients" !');
                $212: GetList (YCbCrSubSampling, 'TIFF: Unsupported "YCbCrSubSampling" !');
                $214: GetList (ReferenceBlackWhite, 'TIFF: Unsupported "ReferenceBlackWhite" !');
              end;
            end;
          end;
          if BitsPerSample.Count > 0 then begin
            BitsPerPixel:= 0;
            for P:= 0 to BitsPerSample.Count-1 do
              Inc (BitsPerPixel, Integer (BitsPerSample[P]));
            if (BitsPerSample.Count > 4) or ((BitsPerPixel <= 8) and (BitsPerSample.Count > 1)) then
              raise Exception.Create ('TIFF: Unsupported Pixel Format !');
          end;
          case BitsPerPixel of
            01: Bitmap.PixelFormat:= pf1bit;
            04: Bitmap.PixelFormat:= pf4bit;
            08: Bitmap.PixelFormat:= pf8bit;
            24: Bitmap.PixelFormat:= pf24bit;
            32: if Photometric = cpiCMYK then
                  Bitmap.PixelFormat:= pf24bit
                else
                  Bitmap.PixelFormat:= pf32bit;
          end;
          if BitsPerPixel <= 8 then
            LuminanceCodingRange:= (1 shl BitsPerPixel)-1
          else
            LuminanceCodingRange:= 255;
          if Photometric = cpiYCbCr then begin
            ReferenceBlack[0]:= 0.0;
            BlackWhiteDiff[0]:= 1.0;
            for P:= 1 to 2 do begin
              ReferenceBlack[P]:= 128.0;
              BlackWhiteDiff[P]:= 1.0;
            end;
          end
          else begin
            for P:= 0 to 2 do
              ReferenceBlack[P]:= 0.0;
            for P:= 0 to 2 do
              BlackWhiteDiff[P]:= LuminanceCodingRange;
          end;
          if YCbCrSubSampling.Count > 0 then
            if (YCbCrSubSampling.Count = 2) and (Integer (YCbCrSubSampling[0]) in [1, 2, 4]) and (Integer (YCbCrSubSampling[1]) in [1, 2, 4]) then begin
              YCbCrSubsampleHoriz:= Integer (YCbCrSubSampling[0]);
              YCbCrSubsampleVert := Integer (YCbCrSubSampling[1]);
            end
            else
              raise Exception.Create ('TIFF: Unsupported "YCbCrSubSampling" !');
          if YCbCrCoefficients.Count > 0 then
            if YCbCrCoefficients.Count = 6 then begin
              if Integer (YCbCrCoefficients[1]) <> 0 then
                LumaRed:= Integer (YCbCrCoefficients[0])/Integer (YCbCrCoefficients[1]);
              if Integer (YCbCrCoefficients[3]) <> 0 then begin
                LumaGreen:= Integer (YCbCrCoefficients[2])/Integer (YCbCrCoefficients[3]);
                if LumaGreen = 0 then
                  LumaGreen:= 1;
              end;
              if Integer (YCbCrCoefficients[5]) <> 0 then
                LumaBlue:= Integer (YCbCrCoefficients[4])/Integer (YCbCrCoefficients[5]);
            end
            else
              raise Exception.Create ('TIFF: Unsupported "YCbCr Coefficients" !');
          if ReferenceBlackWhite.Count > 0 then
            if ReferenceBlackWhite.Count = 12 then begin
              if Integer (ReferenceBlackWhite[1]) <> 0 then
                ReferenceBlack[0]:= Integer (ReferenceBlackWhite[0])/Integer (ReferenceBlackWhite[1]);
              if Integer (ReferenceBlackWhite[3]) <> 0 then
                BlackWhiteDiff[0]:= LuminanceCodingRange/((Integer (ReferenceBlackWhite[2])/Integer (ReferenceBlackWhite[3]))-ReferenceBlack[0]);

              if Integer (ReferenceBlackWhite[5]) <> 0 then
                ReferenceBlack[1]:= Integer (ReferenceBlackWhite[4])/Integer (ReferenceBlackWhite[5]);
              if Integer (ReferenceBlackWhite[7]) <> 0 then
                BlackWhiteDiff[1]:= cChrominanceCodingRange/((Integer (ReferenceBlackWhite[6])/Integer (ReferenceBlackWhite[7]))-ReferenceBlack[1]);

              if Integer (ReferenceBlackWhite[9]) <> 0 then
                ReferenceBlack[2]:= Integer (ReferenceBlackWhite[8])/Integer (ReferenceBlackWhite[9]);
              if Integer (ReferenceBlackWhite[11]) <> 0 then
                BlackWhiteDiff[2]:= cChrominanceCodingRange/((Integer (ReferenceBlackWhite[10])/Integer (ReferenceBlackWhite[11]))-ReferenceBlack[2]);
            end
            else
              raise Exception.Create ('TIFF: Unsupported "ReferenceBlackWhite" !');
        finally
          BitsPerSample.Free;
        end;
      finally
        ReferenceBlackWhite.Free;
      end;
    finally
      YCbCrSubSampling.Free;
    end;
  finally
    YCbCrCoefficients.Free;
  end;
  IsMonochrome:= (LogPalette.palNumEntries = 0) and (BitsPerPixel <= 8);
  if IsMonochrome then begin
    LogPalette.palNumEntries:= 1 shl BitsPerPixel;
    MakePalette;
  end;
  if BitsPerPixel <= 8 then
    PlanarConfiguration:= 1;
  if StripByteCounts.Count = 0 then
    StripByteCounts.Add (Pointer (((ImageWidth*BitsPerPixel + 7) shr 3)*ImageLength));
  if StripByteCounts.Count <> StripOffsets.Count then
    raise Exception.Create ('TIFF: Invalid "StripOffsets|StripByteCounts" !')
  else if (Compression in [ctiffcPackBits]) and (Photometric = cpiYCbCr) then
    raise Exception.Create ('TIFF: Invalid "Compression|PhotometricInterpretation" !')
  else if FillOrder <> 1 then
    raise Exception.Create ('TIFF: Unsupported "FillOrder" !')
  else if not (Compression in [ctiffcLZW, ctiffcNone, ctiffcPackBits]) then
    raise Exception.Create ('TIFF: Unsupported "Compression" !')
  else if Threshholding <> 1 then
    raise Exception.Create ('TIFF: Unsupported "Threshholding" !')
  else
    case BitsPerPixel of
      1   : if not (Photometric in [cpiBlackIsZero, cpiRGBPalette, cpiWhiteIsZero]) then
              raise Exception.Create ('TIFF: Unsupported "PixelFormat|PhotometricInterpretation" !')
            else if HorDiff then
              raise Exception.Create ('TIFF: Unsupported "PixelFormat|Predictor" !');
      4, 8: if not (Photometric in [cpiBlackIsZero, cpiRGBPalette, cpiWhiteIsZero]) then
              raise Exception.Create ('TIFF: Unsupported "PixelFormat|PhotometricInterpretation" !');
      24  : if not (Photometric in [cpiCIELab, cpiRGB, cpiYCbCr]) then
              raise Exception.Create ('TIFF: Unsupported "PixelFormat|PhotometricInterpretation" !')
            else if HorDiff and (Photometric = cpiYCbCr) then
              raise Exception.Create ('TIFF: Unsupported "PhotometricInterpretation|Predictor" !')
            else if (PlanarConfiguration = 2) and (Photometric = cpiYCbCr) then
              raise Exception.Create ('TIFF: Unsupported "PhotometricInterpretation|PlanarConfiguration" !');
      32  : if not (Photometric in [cpiCMYK, cpiRGB]) then
              raise Exception.Create ('TIFF: Unsupported "PixelFormat|PhotometricInterpretation" !');
    else
      raise Exception.Create ('TIFF: Unsupported Pixel Format !');
    end;
  if LogPalette.palNumEntries > 0 then
    Bitmap.Palette:= CreatePalette (PLogPalette (@LogPalette)^);
  if HorDiff and (BitsPerPixel >= 4) then begin
    CMYKToRGBLine:= CMYKToRGBLine_2;
    LabToRGBLine := LabToRGBLine_2;
    Line2ToLine1 := Line2ToLine1_2;
    SwapLine     := SwapLine_2;
  end
  else begin
    CMYKToRGBLine:= CMYKToRGBLine_1;
    LabToRGBLine := LabToRGBLine_1;
    Line2ToLine1 := Line2ToLine1_1;
    SwapLine     := SwapLine_1;
  end;
  if BitsPerPixel = 4 then
    UndoHorDiff:= UndoHorDiff4b
  else
    UndoHorDiff:= UndoHorDiff8b24b32b;
  Bitmap.Width := ImageWidth;
  Bitmap.Height:= ImageLength;
end;



// TIFF24bit: R-G-B   --> BMP24bit: B-G-R
// TIFF32bit: R-G-B-A --> BMP32bit: B-G-R-A
procedure TTIFFDecoder.DumpImage_Uncompressed;
var
  I      : Integer;
  Decoder: TTIFFImageDecoder;

begin
  if (PlanarConfiguration = 2) and (Bitmap.PixelFormat in [pf24bit, pf32bit]) then begin
    if Photometric = cpiCMYK then
      Bitmap.PixelFormat:= pf32bit;
    Decoder:= TTIFFDecoder_24b_Planar2.Create (Bitmap, Stream);
  end
  else
    case Photometric of
      cpiCIELab: Decoder:= TTIFFDecoder_CIELab.Create (Bitmap, Stream);
      cpiCMYK  : Decoder:= TTIFFDecoder_CMYK.Create (Bitmap, Stream);
      cpiYCbCr : Decoder:= TTIFFDecoder_YCbCr.Create (Bitmap, Stream, LumaRed, LumaGreen, LumaBlue, ReferenceBlack, BlackWhiteDiff, YCbCrSubsampleHoriz, YCbCrSubsampleVert);
    else
      if Bitmap.PixelFormat in [pf24bit, pf32bit] then
        Decoder:= TTIFFDecoder_24b.Create (Bitmap, Stream)
      else if HorDiff then
        Decoder:= TTIFFDecoder_08b_HorDiff.Create (Bitmap, Stream)
      else
        Decoder:= TTIFFDecoder_08b.Create (Bitmap, Stream);
    end;
  try
    for I:= 0 to StripOffsets.Count-1 do begin
      Seek (Integer (StripOffsets[I]), soFromBeginning);
      Decoder.Execute (Integer (StripByteCounts[I]));
    end;
  finally
    Decoder.Free;
  end;
  if PlanarConfiguration = 2 then
    case Photometric of
      cpiCIELab: LabToRGBImage (Bitmap);
      cpiCMYK  : begin
                   CMYKToRGBImage (Bitmap);
                   Bitmap.PixelFormat:= pf24bit;
                 end;
    end;
end;





procedure TTIFFDecoder.DumpImage_PackBits;
var
  Buffer: TStream;

 procedure Seek (Offset, Count: Integer; Origin: Word);
 var
   Lidos: Integer;

 begin
   Stream.Seek (Offset, Origin);
   if Buffer <> Stream then begin
     if Count <> Buffer.Size then
       TMemoryStream (Buffer).SetSize (Count);
     Buffer.Seek (0, soFromBeginning);
     try
       Lidos:= Buffer.CopyFrom (Stream, Count);
       Buffer.Seek (0, soFromBeginning);
     except
       raise EInvalidImage.Create (Format ('TIFF read error at %.8xH (%d byte(s) expected, but %d read)', [Stream.Position-Lidos, Count, Lidos]));
     end;
   end;
 end;

 procedure Dump;
 var
   I      : Integer;
   Decoder: TTIFFImageDecoder;

 begin
   if (PlanarConfiguration = 2) and (Bitmap.PixelFormat in [pf24bit, pf32bit]) then begin
     if Photometric = cpiCMYK then
       Bitmap.PixelFormat:= pf32bit;
     Decoder:= TTIFFPackBitsDecoder_24b_Planar2.Create (Bitmap, Stream, RowsPerStrip);
   end
   else
     case Photometric of
       cpiCIELab: Decoder:= TTIFFPackBitsDecoder_CIELab.Create (Bitmap, Buffer, RowsPerStrip);
       cpiCMYK  : Decoder:= TTIFFPackBitsDecoder_CMYK.Create (Bitmap, Buffer, RowsPerStrip);
     else
       if Bitmap.PixelFormat in [pf24bit, pf32bit] then
         Decoder:= TTIFFPackBitsDecoder_24b.Create (Bitmap, Buffer, RowsPerStrip)
       else if HorDiff then
         Decoder:= TTIFFPackBitsDecoder_08b_HorDiff.Create (Bitmap, Buffer, RowsPerStrip)
       else
         Decoder:= TTIFFPackBitsDecoder_08b.Create (Bitmap, Buffer, RowsPerStrip);
     end;
   try
     for I:= 0 to StripOffsets.Count-1 do begin
       Seek (Integer (StripOffsets[I]), Integer (StripByteCounts[I]), soFromBeginning);
       Decoder.Execute (Integer (StripByteCounts[I]));
     end;
   finally
     Decoder.Free;
   end;
   if PlanarConfiguration = 2 then
     case Photometric of
       cpiCIELab: LabToRGBImage (Bitmap);
       cpiCMYK  : begin
                    CMYKToRGBImage (Bitmap);
                    Bitmap.PixelFormat:= pf24bit;
                  end;
     end;
 end;

begin
  if Stream is TFileStream then begin
    Buffer:= TMemoryStream.Create;
    try
      Dump;
    finally
      Buffer.Free;
    end;
  end
  else begin
    Buffer:= Stream;
    Dump;
  end;
end;





procedure TTIFFDecoder.DumpImage_LZW;
var
  Buffer: TStream;

 procedure Seek (Offset, Count: Integer; Origin: Word);
 var
   Lidos: Integer;

 begin
   Stream.Seek (Offset, Origin);
   if Buffer <> Stream then begin
     if Count > Buffer.Size then
       TMemoryStream (Buffer).SetSize (Count);
     Buffer.Seek (0, soFromBeginning);
     try
       Lidos:= Buffer.CopyFrom (Stream, Count);
       Buffer.Seek (0, soFromBeginning);
     except
       raise EInvalidImage.Create (Format ('TIFF read error at %.8xH (%d byte(s) expected, but %d read)', [Stream.Position-Lidos, Count, Lidos]));
     end;
   end;
 end;

 procedure Dump;
 var
   I      : Integer;
   Decoder: TTIFFImageDecoder;

 begin
   if (PlanarConfiguration = 2) and (Bitmap.PixelFormat in [pf24bit, pf32bit]) then begin
     if Photometric = cpiCMYK then
       Bitmap.PixelFormat:= pf32bit;
     Decoder:= TTIFFLZWDecoder_24b_Planar2.Create (Bitmap, Buffer);
   end
   else
     case Photometric of
       cpiCIELab: Decoder:= TTIFFLZWDecoder_CIELab.Create (Bitmap, Buffer);
       cpiCMYK  : Decoder:= TTIFFLZWDecoder_CMYK.Create (Bitmap, Buffer);
       cpiYCbCr : Decoder:= TTIFFLZWDecoder_YCbCr.Create (Bitmap, Buffer, LumaRed, LumaGreen, LumaBlue, ReferenceBlack, BlackWhiteDiff, YCbCrSubsampleHoriz, YCbCrSubsampleVert);
     else
       if Bitmap.PixelFormat in [pf24bit, pf32bit] then
         Decoder:= TTIFFLZWDecoder_24b.Create (Bitmap, Buffer)
       else if HorDiff then
         Decoder:= TTIFFLZWDecoder_08b_HorDiff.Create (Bitmap, Buffer)
       else
         Decoder:= TTIFFLZWDecoder_08b.Create (Bitmap, Buffer);
     end;
   try
     for I:= 0 to StripOffsets.Count-1 do begin
       Seek (Integer (StripOffsets[I]), Integer (StripByteCounts[I]), soFromBeginning);
       Decoder.X:= 0;
       Decoder.Execute (Integer (StripByteCounts[I]));
     end;
   finally
     Decoder.Free;
   end;
   if PlanarConfiguration = 2 then
     case Photometric of
       cpiCIELab: LabToRGBImage (Bitmap);
       cpiCMYK  : begin
                    CMYKToRGBImage (Bitmap);
                    Bitmap.PixelFormat:= pf24bit;
                  end;
     end;
 end;

begin
  if Stream is TFileStream then begin
    Buffer:= TMemoryStream.Create;
    try
      Dump;
    finally
      Buffer.Free;
    end;
  end
  else begin
    Buffer:= Stream;
    Dump;
  end;
end;





procedure TTIFFDecoder.DumpImage;

begin
  case Compression of
    ctiffcLZW     : DumpImage_LZW;
    ctiffcNone    : DumpImage_Uncompressed;
    ctiffcPackBits: DumpImage_PackBits;
  end;
end;





procedure TTIFFDecoder.Load (AFirstImageOnly: Boolean);
var
  Offset    : Integer;
  EntryCount: Word;

begin
  IFDOffsets.Clear;
  if Assigned (Stream) and (Stream.Position < Stream.Size) then begin
    Start:= Stream.Position;
    DumpHeader;
    if not AFirstImageOnly then
      while True do begin
        Seek (Integer (IFDOffsets[Count-1]), soFromBeginning);
        Read (EntryCount, 2);
        EntryCount:= GetWord (EntryCount);
        Seek (EntryCount*SizeOf (TTIFFImageFileDirectory), soFromCurrent);
        if Stream.Position < Stream.Size then begin
          Read (Offset, 4);
          Offset:= GetInteger (Offset);
          if (Offset = 0) or (Offset > Stream.Size) then
            Break
          else
            IFDOffsets.Add (Pointer (Offset));
        end
        else
          Break;    
      end;
  end;
end;





procedure TTIFFDecoder.Get (AIndex: Integer; ABitmap: TBitmap; var ADescription, ASoftware, AArtist: String);

begin
  Bitmap:= ABitmap;
  if Assigned (ABitmap) and (AIndex >= 0) and (AIndex < Count) then begin
    StripOffsets.Clear;
    StripByteCounts.Clear;
    Seek (Integer (IFDOffsets[AIndex]), soFromBeginning);
    DumpDirectory;
    DumpImage;
    SetOrientation (Bitmap, Orientation);
    ADescription:= Description;
    ASoftware   := Software;
    AArtist     := Artist;
  end;
end;




//----------------------------------------------------------------------------------------------
procedure TTIFF.ReadStream (AStream: TStream);

begin
  with TTIFFDecoder.Create (AStream) do
    try
      Load (True);
      Get (0, Self, Description, Software, Artist);
    finally
      Free;
    end;
end;





function TTIFF.IsValid (const FileName: String): Boolean;
var
  Local : TStream;
  Header: TTIFFImageFileHeader;

begin
  Result:= False;
  if FileExists (FileName) then begin
    Local:= TFileStream.Create (FileName, fmOpenRead);
    try
      Result:= (Local.Read (Header, SizeOf (TTIFFImageFileHeader)) = SizeOf (TTIFFImageFileHeader)) and
               (((Header.ByteOrder = $4949) and (Header.Version = $002A)) or
                ((Header.ByteOrder = $4D4D) and (Header.Version = $2A00)));
    finally
      Local.Free;
    end;
  end;
end;





procedure TTIFF.LoadFromStream (Stream: TStream);

begin
  if Assigned (Stream) then
    ReadStream (Stream);
end;

var
  N      : Word;
  SysInfo: TSystemInfo;

initialization
  with gInitTable[0] do begin
    Prefixo:= 0;
    Sufixo := 0;
  end;
  with gInitTable[cEndOfInformation] do begin
    Prefixo:= 0;
    Sufixo := 0;
  end;
  for N:= 0 to 255 do
    with gInitTable[N+1] do begin
      Prefixo:= 0;
      Sufixo := N;
    end;
  TPicture.RegisterFileFormat ('TIF', 'TIFF - Tag Image File Format', TTIFF);
  TPicture.RegisterFileFormat ('TIFF', 'TIFF - Tag Image File Format', TTIFF);
  GetSystemInfo (SysInfo);
  if SysInfo.wProcessorLevel = 3 then
    Swap32:= Swap32_I386
  else
    Swap32:= Swap32_I486;
finalization
  TPicture.UnRegisterGraphicClass (TTIFF);
end.
