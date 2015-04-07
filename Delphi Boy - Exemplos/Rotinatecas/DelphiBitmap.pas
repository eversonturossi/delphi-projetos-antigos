// Wheberson Hudson Migueletti, em Brasília, 11 de dezembro de 1998.

unit DelphiBitmap;

interface

uses Windows, SysUtils, Classes, Graphics, DelphiImage;

type
  TBitmap= class (DelphiImage.TImage)
    protected
      Bitmap: Graphics.TBitmap;
      Stream: TStream;
    public
      constructor Create; override;
      destructor  Destroy; override;
      procedure   Clear;
      procedure   AssignTo     (Dest: TPersistent); override;
      function    IsValid      (const FileName: String): Boolean; override;
      procedure   LoadFromFile (const FileName: String); override;
  end;

implementation

const
  cBMP= $4D42;





constructor TBitmap.Create;

begin
  inherited Create;

  Stream:= TMemoryStream.Create;
  Bitmap:= Graphics.TBitmap.Create;
end;





destructor TBitmap.Destroy;

begin
  Stream.Free;
  Bitmap.Free;

  inherited Destroy;
end;





procedure TBitmap.Clear;

begin
  TMemoryStream (Stream).Clear;
  Bitmap.Free;
  Bitmap:= Graphics.TBitmap.Create;
end;





procedure TBitmap.AssignTo (Dest: TPersistent);

begin
  if Dest is Graphics.TBitmap then begin
    //TBitmap (Dest).Assign (Bitmap)
    Stream.Seek (0, soFromBeginning);
    Graphics.TBitmap (Dest).LoadFromStream (Stream);
  end
  else
    inherited AssignTo (Dest);
end;





function TBitmap.IsValid (const FileName: String): Boolean;
var
  Local : TStream;
  Header: TBitmapFileHeader;

begin
  Result:= False;
  if FileExists (FileName) then begin
    Local:= TFileStream.Create (FileName, fmOpenRead);
    try
      Result:= (Local.Read (Header, cSizeOfBitmapFileHeader) = cSizeOfBitmapFileHeader) and (Header.bfType = cBMP);
    finally
      Local.Free;
    end;
  end;
end;





procedure TBitmap.LoadFromFile (const FileName: String);
var
  FileHeader: TBitmapFileHeader;
  InfoHeader: TBitmapInfoHeader;

begin
  Clear;
  TMemoryStream (Stream).LoadFromFile (FileName);
  Stream.Seek (0, soFromBeginning);
  if (Stream.Read (FileHeader, cSizeOfBitmapFileHeader) = cSizeOfBitmapFileHeader) and (FileHeader.bfType = cBMP) then begin
    Stream.Read (InfoHeader, cSizeOfBitmapInfoHeader);
    Stream.Seek (0, soFromBeginning);
    Bitmap.LoadFromStream (Stream);
    Width       := Bitmap.Width;
    Height      := Bitmap.Height;
    BitsPerPixel:= InfoHeader.biBitCount;
  end;
end;

end.
