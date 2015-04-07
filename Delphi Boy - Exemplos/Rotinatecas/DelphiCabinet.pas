// Wheberson Hudson Migueletti, em Brasília, 18 de abril de 1999.
// Tratamento de arquivos Windows Cabinet. 

unit DelphiCabinet;

interface

uses Windows, Classes, SysUtils;

const
  cCabSignature= $4643534D; // MSCF (Em ordem inversa)
  cCabVersion  = $0103;

type
{
  CAB FILE LAYOUT (Sven B. Schreiber, sbs@orgon.com)
  =================================================================
  (1) CAB_HEADER structure
  (2) Reserved area, if CAB_HEADER.flags & CAB_FLAG_RESERVE
  (3) Previous cabinet name, if CAB_HEADER.flags & CAB_FLAG_HASPREV
  (4) Previous disk name, if CAB_HEADER.flags & CAB_FLAG_HASPREV
  (5) Next cabinet name, if CAB_HEADER.flags & CAB_FLAG_HASNEXT
  (6) Next disk name, if CAB_HEADER.flags & CAB_FLAG_HASNEXT
  (7) CAB_FOLDER structures (n = CAB_HEADER.cFolders)
  (8) CAB_ENTRY structures / file names (n = CAB_HEADER.cFiles)
  (9) File data (offset = CAB_FOLDER.coffCabStart)
}

  TCabHeader= packed record
    Sig        : LongInt; // File signature 'MSCF'
    cSumHeader : LongInt; // Header checksum (0 if not used)
    cbCabinet  : LongInt; // Cabinet file size
    cSumFolders: LongInt; // Folders checksum (0 if not used)
    cOffFiles  : LongInt; // Offset of first CAB_ENTRY
    cSumFiles  : LongInt; // Files checksum (0 if not used)
    Version    : Word;    // Cabinet version
    cFolders   : Word;    // Number of folders
    cFiles     : Word;    // Number of files
    Flags      : Word;    // Cabinet flags
    SetID      : Word;    // Cabinet set id
    iCabinet   : Word;    // Zero-based cabinet number
  end;

  tCabFolder= packed record
    cOffCabStart: LongInt; // Offset of folder data
    cCFData     : Word;
    TypeCompress: Word;    // Compression type
  end;

  tCabEntry= packed record
    cbFile         : LongInt; // Uncompressed file size
    uOffFolderStart: LongInt; // File offset after decompression
    iFolder        : Word;    // File control id 
    Date           : Word;    // File date stamp, as used by DOS
    Time           : Word;    // File time stamp, as used by DOS
    Attribs        : Word;    // File attributes
  end;

  pInfoCabinet= ^tInfoCabinet;
  tInfoCabinet= record
    Descompactado: LongInt;
    Modificado   : TDateTime;
  end;

  TCabinet= class
    protected
      Stream: TStream;

      procedure Armazenar (Arquivo: String; Descompactado: LongInt; Data, Hora: Word);
    public
      Status: Boolean;
      Lista : TStringList;

      constructor Create;
      destructor  Destroy; override;
      function    ExtrairNomePath (const Completo: String; var Path: String): String;
      function    IsValid         (const FileName: String): Boolean;
      procedure   LoadFromFile    (const FileName: String);
  end;

implementation

const
  cSizeOfCabHeader= SizeOf (TCabHeader);





constructor TCabinet.Create;

begin
  inherited Create;

  Lista:= TStringList.Create;
end; // Create ()





destructor TCabinet.Destroy;

begin
  Lista.Free;

  inherited Destroy;
end; // Destroy ()





procedure TCabinet.Armazenar (Arquivo: String; Descompactado: LongInt; Data, Hora: Word);
var
  Aux     : LongInt;
  Info    : pInfoCabinet;
  DataHora: TDateTime;

begin
  try
    LongRec (Aux).Hi:= Data;
    LongRec (Aux).Lo:= Hora;
    DataHora        := FileDateToDateTime (Aux);
  except
    DataHora:= 0;
  end;
  New (Info);
  Info^.Descompactado:= Descompactado;
  Info^.Modificado   := DataHora;
  Lista.AddObject (Arquivo, TObject (Info));
end; // Armazenar ()





function TCabinet.ExtrairNomePath (const Completo: String; var Path: String): String;
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
end; // ExtrairNomePath ()





procedure TCabinet.LoadFromFile (const FileName: String);
var
  Header: TCabHeader;

 function CapturarHeader: Boolean;

 begin
   Stream.Read (Header, cSizeOfCabHeader);
   Status:= (Header.Sig = cCabSignature) and (Header.Version = cCabVersion) and (Header.cOffFiles > cSizeOfCabHeader);
   Result:= Status;
 end; // CapturarHeader ()

 procedure CapturarArquivos;
 var
   C      : Char;
   P      : Word;
   Arquivo: String;
   Entry  : tCabEntry;

 begin
   try
     Stream.Position:= Header.cOffFiles;
     for P:= 1 to Header.cFiles do begin
       Stream.Read (Entry, SizeOf (tCabEntry));
       Arquivo:= '';
       repeat
         Stream.Read (C, 1);
         Arquivo:= Arquivo + C;
       until C = #0;
       Armazenar (Arquivo, Entry.cbFile, Entry.Date, Entry.Time);
     end;
   except
     Status:= False;
   end;
 end; // CapturarArquivos ()

begin
  try
    Status:= False;
    Stream:= TMemoryStream.Create;
    TMemoryStream (Stream).LoadFromFile (FileName);
    Lista.Clear;
    if CapturarHeader then
      CapturarArquivos;
  finally
    Stream.Free;
  end;
end; // LoadFromFile ()





function TCabinet.IsValid (const FileName: String): Boolean;
var
  Header: TCabHeader;

begin
  Result:= False;
  Status:= False;
  if FileExists (Filename) then begin
    try
      Stream:= TFileStream.Create (FileName, fmOpenRead);
      Result:= (Stream.Read (Header, cSizeOfCabHeader) = cSizeOfCabHeader) and (Header.Sig = cCabSignature) and (Header.Version = cCabVersion) and (Header.cOffFiles > cSizeOfCabHeader);
      Status:= True;
    finally
      Stream.Free;
    end;
  end;
end; // IsValid ()

end.
