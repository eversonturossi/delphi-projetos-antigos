// Wheberson Hudson Migueletti, em Brasília, 10 de agosto de 1999.
// Para mostrar o conteúdo de arquivos ARJ

{ *********************************************************

  Structure of archive block (low order byte first):
  (by Robert K Jung)

  2  header id (comment and local file) = 0xEA60 or 60000U
  2  basic header size (from 'first_hdr_size' thru 'comment' below)
	     = first_hdr_size + strlen(filename) + 1 + strlen(comment) + 1
	     = 0 if end of archive

  1  first_hdr_size (size up to 'extra data')
  1  archiver version number
  1  minimum archiver version to extract
  1  host OS	 (0 = MSDOS, 1 = PRIMOS, 2 = UNIX, 3 = AMIGA, 4 = MACDOS)
  1  arj flags (0x01 = GARBLED_FLAG) indicates passworded file
               (0x02 = RESERVED)
               (0x04 = VOLUME_FLAG)  indicates continued file to next volume
               (0x08 = EXTFILE_FLAG) indicates file starting position field
               (0x10 = PATHSYM_FLAG) indicates path translated
  1  method    (0 = stored, 1 = compressed most ... 4 compressed fastest)
  1  file type (0 = binary, 1 = text, 2 = comment header)
  1  reserved
  4  date time stamp modified
  4  compressed size
  4  original size
  4  original file's CRC
  2  entryname position in filename
  2  file access mode
  2  host data (currently not used)
  ?  extra data
     4 bytes for extended file position when used
     (this is present when EXTFILE_FLAG is set)

  ?  filename (null-terminated)
  ?  comment	(null-terminated)

  4  basic header CRC

  2  1st extended header size (0 if none)
  ?  1st extended header (currently not used)
  4  1st extended header's CRC
  ...
  ?  compressed file

  ********************************************************* }


unit DelphiArj;

interface

uses Windows, Classes, SysUtils;

const
  cPATHSYM_FLAG= $10;

type
  TArjIdHeader= packed record
    Id                    : Word;  // EA60h
    Size                  : Word;  // Basic header size (0 if end of archive or first_hdr_size + strlen(filename) + 1 + strlen(comment) + 1)
  end;
  TArjHeader= packed record
    FirstHeaderSize       : Byte;  // Size up to and including 'extra data'
    ArchiverVersion       : Byte;  // Archiver version number
    MinimumArchiverVersion: Byte;  // Minimum version needed to extract
    HostOS                : Byte;  // Host OS (0-MS-DOS, 1-PRIMOS, 2-UNIX, 3-AMIGA, 4-MAC, 5-OS/2, 6-APPLE GS, 7-ATARI ST, 8-NeXT, 9-VAX VMS)
    Flags                 : Byte;  // 0-no password/password, 1-reserved, 2-file continues on next disk, 3-file start position field is available, 4-path translation ( "\" to "/" )
    CompressionMethod     : Byte;  // 0-stored, 1-compressed most, 2-compressed, 3-compressed faster, 4-compressed fastest (Methods 1 to 3 use Lempel-Ziv 77 sliding window with static Huffman encoding, method 4 uses Lempel-Ziv 77 sliding window with pointer/length unary encoding)
    FileType              : Byte;  // 0-binary, 1-7-bit text, 2-comment header, 3-directory, 4-volume label
    Reserved              : Byte;  // Reserved
    DateTimeDOS           : DWORD; // Date/Time of original file in MS-DOS format
    CompressedSize        : DWORD; // Compressed size of file
    OriginalSize          : DWORD; // Original size of file
    CRC                   : DWORD; // Original file's CRC-32
    FilespecPosition      : Word;  // Filespec position in filename
    FileAttributes        : Word;  // File attributes
    HostData              : Word;  // Host data (currently not used)
  end;
  PInfoArj= ^TInfoArj;
  TInfoArj= record
    Attributos   : Word;
    Descompactado: DWORD;
    Compactado   : DWORD;
    CRC          : DWORD;
    Modificado   : TDateTime;
  end;
  TArj= class
    protected
      Stream: TStream;
      Header: TArjHeader;
      Atual : record
                Arquivo: String;
                Info   : TInfoArj;
              end;

      function CapturarHeader: Boolean;
      function PularArquivo: Boolean;
      function Armazenar: Boolean;
      function CopiarNomeArquivo (Nome: PChar): String;
    public
      Status: Boolean;
      Lista : TStringList;

      constructor Create;
      destructor  Destroy; override;
      function    Buscar          (Posicao: Integer): TInfoArj;
      function    ExtrairNomePath (const Completo: String; var Path: String): String;
      function    IsValid         (const FileName: String): Boolean;
      procedure   LoadFromFile    (const FileName: String);
  end;


implementation

const
  cSizeOfArjIdHeader= SizeOf (TArjIdHeader);





constructor TArj.Create;

begin
  inherited Create;

  Lista:= TStringList.Create;
end;





destructor TArj.Destroy;

begin
  Lista.Free;

  inherited Destroy;
end;





function TArj.Buscar (Posicao: Integer): TInfoArj;

begin
  if (Posicao >= 0) and (Posicao < Lista.Count) then
    Result:= PInfoArj (Lista.Objects[Posicao])^;
end;




// Para armazenar na LISTA o HEADER atual
function TArj.Armazenar: Boolean;
var
  Novo: PInfoArj;

begin
  Status:= False;
  try
    New (Novo);
    Novo^:= Atual.Info;
    Lista.AddObject (Atual.Arquivo, TObject (Novo));
    Status:= True;
  finally
    Result:= Status;
  end;
end; 




// Pula o arquivo compactado
function TArj.PularArquivo: Boolean;

begin
  Status:= False;
  try
    Stream.Seek (Header.CompressedSize, soFromCurrent);
    Status:= True;
  finally
    Result:= Status;
  end;
end;





function TArj.CopiarNomeArquivo (Nome: PChar): String;
var
  P: Integer;

begin
  Result:= StrPas (Nome);
  if Header.Flags and cPATHSYM_FLAG <> 0 then
    for P:= 1 to Length (Result) do
      if Result[P] = '/' then
        Result[P]:= '\';
end;





function TArj.ExtrairNomePath (const Completo: String; var Path: String): String;
var
  K, P: Integer;

begin
  P:= 0;
  for K:= Length (Completo) downto 1 do
    if (Completo[K] = '\') or (Completo[K] = '/') then begin
      P:= K;
      Break;
    end;
  Result:= Copy (Completo, P+1, Length (Completo)-P);
  if P > 0 then
    Path:= Copy (Completo, 1, P)
  else
    Path:= '';
end;





function TArj.CapturarHeader: Boolean;
const
  cFileNameMax= 512;
  cCommentMax = 2048;
  
var
  ExtHeaderSize: Word;
  Inicio       : Word;
  HeaderCRC    : DWORD;
  Comment      : PChar;
  FileName     : PChar;
  Buffer       : array[0..cFileNameMax+cCommentMax+2] of Char;
  HeaderId     : TArjIdHeader;

begin
  Result:= False;
  try
    Stream.Read (HeaderId, cSizeOfArjIdHeader);
    Status:= HeaderId.Id = $EA60;
    if Status and (HeaderId.Size > 0) then begin
      Status:= False;
      Stream.Read (Header, SizeOf (TArjHeader));
      Stream.Read (Buffer, HeaderId.Size-SizeOf (TArjHeader));
      Stream.Read (HeaderCRC, 4);
      while True do begin
        Stream.Read (ExtHeaderSize, 2);
        if ExtHeaderSize = 0 then
          Break
        else
          Stream.Seek (ExtHeaderSize+2, soFromCurrent);
      end;
      try
        FileName:= StrAlloc (cFileNameMax+1);
        Comment := StrAlloc (cCommentMax+1);
        Inicio  := Header.FirstHeaderSize-SizeOf (TArjHeader);
        StrLCopy (FileName, @Buffer[Inicio], cFileNameMax);
        StrLCopy (Comment, @Buffer[Inicio+StrLen (FileName)+1], cCommentMax);
        Atual.Arquivo           := CopiarNomeArquivo (FileName);
        Atual.Info.Attributos   := Header.FileAttributes;
        Atual.Info.Descompactado:= Header.OriginalSize;
        Atual.Info.Compactado   := Header.CompressedSize;
        Atual.Info.CRC          := Header.CRC;
        try
          Atual.Info.Modificado:= FileDateToDateTime (Header.DateTimeDOS);
        except
          Atual.Info.Modificado:= 0;
        end;
        Status:= True;
      finally
        StrDispose (FileName);
        StrDispose (Comment);
      end;
      Result:= Status;
    end;
  except
    Status:= False;
  end;
end;





function TArj.IsValid (const FileName: String): Boolean;
var
  HeaderId: TArjIdHeader;

begin
  Result:= False;
  Status:= False;
  if FileExists (Filename) then begin
    try
      Stream:= TFileStream.Create (FileName, fmOpenRead);
      Result:= (Stream.Read (HeaderId, cSizeOfArjIdHeader) = cSizeOfArjIdHeader) and (HeaderId.Id = $EA60);
      Status:= True;
    finally
      Stream.Free;
    end;
  end;
end; // IsValid ()





procedure TArj.LoadFromFile (const FileName: String);

begin
  Status:= False;
  try
    Stream:= TMemoryStream.Create;
    TMemoryStream (Stream).LoadFromFile (FileName);
    Lista.Clear;

    CapturarHeader; // Descarta o primeiro HEADER
    while CapturarHeader and PularArquivo and Armazenar do begin
    end;

  finally
    Stream.Free;
  end;
end;

end.

// Final do Arquivo