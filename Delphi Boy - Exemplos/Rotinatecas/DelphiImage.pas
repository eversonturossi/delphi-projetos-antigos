// Wheberson Hudson Migueletti, em Brasília, 21 de setembro de 1999.
// Internet: http://www.geocities.com/whebersite
// E-mail  : whebersite@zipmail.com.br

unit DelphiImage;

interface

uses Windows, SysUtils, Classes, Graphics, Printers;

const
  cSizeOfBitmapInfoHeader= SizeOf (TBitmapInfoHeader);
  cSizeOfBitmapFileHeader= SizeOf (TBitmapFileHeader);
  cSizeOfRGBQuad         = SizeOf (TRGBQuad);

type
  TEnquadramento= (cteNunca, cteQuandoNecessario, cteSempre);
  EInvalidImage= class (Exception);
  EUnsupportedImage= class (Exception);
  PImgArray= ^TImgArray;
  TImgArray= array[0..0] of Byte;
  PPalette= ^TPalette;
  TPalette= array[0..0] of TRGBQuad;
  PRGB= ^TRGB;
  TRGB= packed record
    Red  : Byte;
    Green: Byte;
    Blue : Byte;
  end;
  TImage= class (TPersistent)
    private
      _ImageSize  : DWORD;
      _PaletteSize: Integer;
    protected
      BytesPerLine : Integer;     // "Bytes" por linha do "bitmap"
      PaletteLength: Integer;     // Dimensão da paleta (0 a 256)
      Palette      : PPalette;
      Image        : PImgArray;   // "Array" para conter "Image"

      procedure AllocImage (AWidth, AHeight, ABitsPerPixel, APaletteLength: Integer);
      procedure AssignToBitmap (Bitmap: TBitmap);
      property  ImageSize  : DWORD   read _ImageSize;   // Tamanho do "array" que contém "Image"
      property  PaletteSize: Integer read _PaletteSize; // Tamanho do "array" que contém "Palette"
    public
      BitsPerPixel: Integer;
      Height      : Integer;
      Width       : Integer;

      constructor Create; virtual;
      procedure   FreeImage;
      function    IsValid (const FileName: String): Boolean; virtual; abstract;
      procedure   LoadFromStream (Stream: TStream); virtual; abstract;
      procedure   SaveToStream (Stream: TStream); virtual; abstract;
      procedure   LoadFromFile (const FileName: String); virtual; abstract;
      procedure   SaveToFile (const FileName: String); virtual; abstract;
  end;

function  BytesPerScanline  (PixelsPerScanline, BitsPerPixel, Alignment: Integer): Integer;
function  ColorToRGB        (Color: TColor): TRGB;
function  RGBToColor        (RGB: TRGB): TColor;
function  Enquadrar         (LarguraEntrada, AlturaEntrada: Integer; Largura, Altura: Integer; Centralizado: Boolean): TRect;
procedure DimensionarBitmap (Entrada: TBitmap; Saida: TBitmap; Largura, Altura: Integer; Enquadramento: TEnquadramento; DimensionarTotalmente, Centralizar: Boolean; Cor: TColor);
procedure PrintBitmap       (Bitmap: TBitmap; Center: Boolean);

implementation




// Borland
function BytesPerScanline (PixelsPerScanline, BitsPerPixel, Alignment: Integer): Integer;

begin
  Dec (Alignment);
  Result:= ((PixelsPerScanline * BitsPerPixel) + Alignment) and not Alignment;
  Result:= Result shr 3;
end;





function ColorToRGB (Color: TColor): TRGB;

begin
  with Result do begin
    Red  := GetRValue (Color);
    Green:= GetGValue (Color);
    Blue := GetBValue (Color);
  end;
end;





function RGBToColor (RGB: TRGB): TColor;

begin
  with RGB do
    Result:= Windows.RGB (Red, Green, Blue);
end;





function Enquadrar (LarguraEntrada, AlturaEntrada: Integer; Largura, Altura: Integer; Centralizado: Boolean): TRect;

begin
  with Result do begin
    if LarguraEntrada > Largura then begin
      AlturaEntrada := Round (AlturaEntrada*(Largura/LarguraEntrada));
      LarguraEntrada:= Largura;
    end;
    if AlturaEntrada > Altura then begin
      LarguraEntrada:= Round (LarguraEntrada*(Altura/AlturaEntrada));
      AlturaEntrada := Altura;
    end;
    if Centralizado then begin
      Left  := (Largura div 2) - (LarguraEntrada div 2);
      Top   := (Altura  div 2) - (AlturaEntrada div 2);
      Right := (Left + LarguraEntrada) - 1;
      Bottom:= (Top  + AlturaEntrada)  - 1;
    end
    else begin
      Left  := 0;
      Top   := 0;
      Right := LarguraEntrada-1;
      Bottom:= AlturaEntrada-1;
    end;
  end;
end;





procedure DimensionarBitmap (Entrada: TBitmap; Saida: TBitmap; Largura, Altura: Integer; Enquadramento: TEnquadramento; DimensionarTotalmente, Centralizar: Boolean; Cor: TColor);
var
  NovaAltura : Integer;
  NovaLargura: Integer;
  SaveColor  : TColor;
  R          : TRect;

begin
  if Assigned (Entrada) and Assigned (Saida) then begin
    try
      with Saida do
        if Enquadramento = cteQuandoNecessario then
          with Canvas do begin
            SaveColor  := Brush.Color;
            Brush.Color:= Cor;
            try
              if DimensionarTotalmente then begin
                R     := Enquadrar (Entrada.Width, Entrada.Height, Largura, Altura, Centralizar);
                Width := Largura;
                Height:= Altura;
              end
              else begin
                R     := Enquadrar (Entrada.Width, Entrada.Height, Largura, Altura, False);
                Width := (R.Right-R.Left) + 1;
                Height:= (R.Bottom-R.Top) + 1;
              end;
              FillRect (Rect (0, 0, Width, Height));
              Inc (R.Right);
              Inc (R.Bottom);
              StretchDraw (R, Entrada);
            finally
              Brush.Color:= SaveColor;
            end;
          end
        else if Enquadramento = cteSempre then
          with Canvas do begin
            SaveColor  := Brush.Color;
            Brush.Color:= Cor;
            try
              NovaLargura:= Entrada.Width;
              NovaAltura := Entrada.Height;
              if NovaLargura > Largura then begin
                NovaAltura := Round (NovaAltura*(Largura/NovaLargura));
                NovaLargura:= Largura;
                if NovaAltura > Altura then begin
                  NovaLargura:= Round (NovaLargura*(Altura/NovaAltura));
                  NovaAltura := Altura;
                end;
              end
              else begin
                NovaLargura:= Round (NovaLargura*(Altura/NovaAltura));
                NovaAltura := Altura;
                if NovaLargura > Largura then begin
                  NovaAltura := Round (NovaAltura*(Largura/NovaLargura));
                  NovaLargura:= Largura;
                end;
              end;
              if DimensionarTotalmente then begin
                Saida.Width := Largura;
                Saida.Height:= Altura;
                R           := Enquadrar (NovaLargura, NovaAltura, Largura, Altura, Centralizar);
              end
              else begin
                Saida.Width := NovaLargura;
                Saida.Height:= NovaAltura;
                R           := Rect (0, 0, NovaLargura, NovaAltura);
              end;
              Inc (R.Right);
              Inc (R.Bottom);
              Saida.Canvas.StretchDraw (R, Entrada);
            finally
              Brush.Color:= SaveColor;
            end;
          end
        else begin
          Width := Largura;
          Height:= Altura;
          if (Entrada.Width < Largura) or (Entrada.Height < Altura) then begin
            if DimensionarTotalmente then
              with Canvas do begin
                SaveColor  := Brush.Color;
                Brush.Color:= Cor;
                try
                  FillRect (Rect (0, 0, Width, Height));
                  if Centralizar then
                    Draw ((Largura div 2)-(Entrada.Width div 2), (Altura div 2)-(Entrada.Height div 2), Entrada)
                  else
                    Draw (0, 0, Entrada);
                finally
                  Brush.Color:= SaveColor;
                end;
              end
            else begin
              if Entrada.Width < Largura then
                Width:= Entrada.Width;
              if Entrada.Height < Altura then
                Height:= Entrada.Height;
              Canvas.Draw (0, 0, Entrada);
            end;
          end
          else
            Canvas.Draw (0, 0, Entrada);
        end;
    except
    end;
  end;
end;





procedure PrintBitmap (Bitmap: TBitmap; Center: Boolean);
var
  RazaoX, RazaoY: Real;

 procedure CalcularProporcoes;
 var
   DC: HDC;

 begin
   DC:= GetDC (0);
   try
     RazaoX:= GetDeviceCaps (Printer.Handle, LOGPIXELSX)/GetDeviceCaps (DC, LOGPIXELSX);
     RazaoY:= GetDeviceCaps (Printer.Handle, LOGPIXELSY)/GetDeviceCaps (DC, LOGPIXELSY);
   finally
     ReleaseDC (0, DC);
   end;
 end;

 procedure Imprimir (DestRect: TRect);
 var
   HeaderSize  : DWord;
   ImageSize   : DWord;
   BitmapHeader: PBitmapInfo;
   BitmapImage : Pointer;

 begin
   GetDIBSizes (Bitmap.Handle, HeaderSize, ImageSize);
   GetMem (BitmapHeader, HeaderSize);
   try
     GetMem (BitmapImage, ImageSize);
     try
       GetDIB (Bitmap.Handle, Bitmap.Palette, BitmapHeader^, BitmapImage^);
       StretchDIBits (Printer.Canvas.Handle, DestRect.Left, DestRect.Top, DestRect.Right - DestRect.Left, DestRect.Bottom - DestRect.Top, 0, 0, Bitmap.Width, Bitmap.Height, BitmapImage, TBitmapInfo (BitmapHeader^), DIB_RGB_COLORS, SRCCOPY);
     finally
       FreeMem (BitmapImage);
     end;
   finally
     FreeMem (BitmapHeader);
   end;
 end;

begin
  if Assigned (Bitmap) then begin
    Printer.BeginDoc;
    try
      CalcularProporcoes;
      Imprimir (Enquadrar (Round (RazaoX*Bitmap.Width), Round (RazaoY*Bitmap.Height), Printer.PageWidth, Printer.PageHeight, Center));
    finally
      Printer.EndDoc;
    end;
  end;
end;




//----------------------------------------------------------------------------------------------
constructor TImage.Create;

begin
  inherited Create;

  Image        := nil;
  Palette      := nil;
  _ImageSize   := 0;
  _PaletteSize := 0;
  PaletteLength:= 0;
  Width        := 0;
  Height       := 0;
  BitsPerPixel := 0;
  BytesPerLine := 0;
end;





procedure TImage.AllocImage (AWidth, AHeight, ABitsPerPixel, APaletteLength: Integer);

begin
  Width        := Abs (AWidth);
  Height       := Abs (AHeight);
  BitsPerPixel := ABitsPerPixel;
  PaletteLength:= APaletteLength;
  BytesPerLine := BytesPerScanLine (Width, BitsPerPixel, 32);
  _ImageSize   := BytesPerLine*Height;
  _PaletteSize := PaletteLength*cSizeofRGBQuad;
  if ImageSize > 0 then
    GetMem (Image, ImageSize);
  if PaletteSize > 0 then
    GetMem (Palette, PaletteSize);
end;





procedure TImage.FreeImage;

begin
  if ImageSize > 0 then begin
    FreeMem (Image, ImageSize);
    _ImageSize:= 0;
    Image     := nil;
  end;
  if PaletteSize > 0 then begin
    FreeMem (Palette, PaletteSize);
    _PaletteSize:= 0;
    Palette     := nil;
  end;
end;





procedure TImage.AssignToBitmap (Bitmap: TBitmap);
var
  DIBSize: Integer;
  DIB    : PBitmapInfo;
  BFH    : TBitmapFileHeader;
  BIH    : TBitmapInfoHeader;
  Stream : TStream;

begin
  if ImageSize > 0 then begin
    if not Assigned (Bitmap) then
      Bitmap:= TBitmap.Create;
    Stream:= TMemoryStream.Create;
    try
      with BFH do begin
        bfType     := $4D42;
        bfOffBits  := cSizeOfBitmapFileHeader + cSizeOfBitmapInfoHeader;
        bfReserved1:= 0;
        bfReserved2:= 0;
        if BitsPerPixel <= 8 then
          Inc (bfOffBits, PaletteLength*cSizeOfRGBQuad);
        bfSize:= bfOffBits + ImageSize;
      end;
      FillChar (BIH, cSizeOfBitmapInfoHeader, #0);
      with BIH do begin
        biSize        := cSizeOfBitmapInfoHeader;
        biWidth       := Width;
        biHeight      := Height;
        biPlanes      := 1;
        biBitCount    := BitsPerPixel;
        biCompression := BI_RGB;
        biSizeImage   := ImageSize;
        biClrUsed     := PaletteLength;
        biClrImportant:= biClrUsed;
      end;
      Stream.WriteBuffer (BFH, cSizeOfBitmapFileHeader);
      Stream.WriteBuffer (BIH, cSizeOfBitmapInfoHeader);
      if PaletteLength > 0 then
        Stream.WriteBuffer (Palette^, PaletteLength*cSizeOfRGBQuad);
      Stream.WriteBuffer (Image^, ImageSize);
      Stream.Seek (0, soFromBeginning);
      Bitmap.LoadFromStream (Stream);
    finally
      Stream.Free;
    end;
  end;
end;

end.
