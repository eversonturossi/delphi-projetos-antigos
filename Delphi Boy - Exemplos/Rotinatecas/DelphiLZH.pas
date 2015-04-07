{ Wheberson Hudson Migueletti, em Brasília, 29 de março de 2000.
  Mostrar os arquivos contidos em um ".lzh", geralmente gerados por "LHA.exe/LHArc.exe"

  File 1
     [File Header]
     [CRC]
     [Compressed data]

  File 2
     [File Header]
     [CRC]
     [Compressed data]
  .
  .
  .
  File n
     [File Header]
     [CRC]
     [Compressed data]

  0 (End)
}

unit DelphiLZH;

interface

uses Windows, Classes, SysUtils;

type
  PLZHInfo= ^TLZHInfo;
  TLZHInfo= record
    Attributes      : Byte;
    CRC             : Word;
    CompressedSize  : Integer;
    UncompressedSize: Integer;
    DateTime        : TDateTime;
  end;

  PLZHHeader= ^TLZHHeader;
  TLZHHeader= packed record
    HeaderSize      : Byte;
    Checksum        : Byte;
    Id              : array[0..2] of Char;
    Method          : array[0..1] of Char;
    CompressedSize  : DWORD;
    UncompressedSize: DWORD;
    FileTime        : DWORD;
    Attributes      : Byte;
    Level           : Byte; 
    FileNameLength  : Byte;
  end;

  TLZH= class
    protected
      Stream: TStream;
    public
      List: TStringList;

      constructor Create; virtual;
      destructor  Destroy; override;
      function    GetInfo (Index: Integer): TLZHInfo;
      function    IsValid (const FileName: String): Boolean;
      procedure   LoadFromFile (const FileName: String); virtual;
  end;

implementation





constructor TLZH.Create;

begin
  inherited Create;

  List:= TStringList.Create;
end;





destructor TLZH.Destroy;

begin
  List.Free;

  inherited Destroy;
end;





function TLZH.GetInfo (Index: Integer): TLZHInfo;

begin
  if (Index >= 0) and (Index < List.Count) then
    Result:= PLZHInfo (List.Objects[Index])^;
end;





function TLZH.IsValid (const FileName: String): Boolean;
var
  Header: TLZHHeader;

begin
  Result:= False;
  if FileExists (Filename) then begin
    try
      Stream:= TFileStream.Create (FileName, fmOpenRead);
      Stream.Read (Header, SizeOf (TLZHHeader));
      Result:= (Header.HeaderSize > 0) and (Header.Level in [0, 1]) and ((Header.Id = '-lz') or (Header.Id = '-lh'));
    finally
      Stream.Free;
    end;
  end;
end;





procedure TLZH.LoadFromFile (const FileName: String);
var
  CRC16       : Word;
  SavePosition: Integer;
  CurrentName : String;
  Info        : PLZHInfo;
  Header      : TLZHHeader;

begin
  if FileExists (FileName) then begin
    Stream:= TMemoryStream.Create;
    try
      List.Clear;
      TMemoryStream (Stream).LoadFromFile (FileName);
      while Stream.Position < Stream.Size do begin
        SavePosition:= Stream.Position;
        Stream.Read (Header, SizeOf (TLZHHeader));
        if (Header.HeaderSize > 0) and (Header.Level in [0, 1]) and ((Header.Id = '-lz') or (Header.Id = '-lh')) then begin
          SetLength (CurrentName, Header.FileNameLength);
          Stream.Read (CurrentName[1], Header.FileNameLength);
          Stream.Read (CRC16, 2);
          New (Info);
          with Header do begin
            Info^.CompressedSize  := CompressedSize;
            Info^.UncompressedSize:= UncompressedSize;
            Info^.DateTime        := FileDateToDateTime (FileTime);
            Info^.Attributes      := Attributes;
            Info^.CRC             := CRC16;
          end;
          List.AddObject (CurrentName, TObject (Info));
        end
        else
          Break;
        Stream.Seek (SavePosition + Header.CompressedSize + 2 + Header.HeaderSize, soFromBeginning);
      end;
    finally
      Stream.Free;
    end
  end;
end;

end.
