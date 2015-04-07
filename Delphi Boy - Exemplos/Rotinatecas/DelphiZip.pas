// Wheberson Hudson Migueletti, em Brasília, 1999.
// Para mostrar o conteúdo de arquivos ZIP

unit DelphiZip;

interface

uses Windows, Classes, SysUtils;

const
  cLocal_File_Header_Signature  = $04034B50;
  cCentral_File_Header_Signature= $02014B50;
  cEnd_Central_Dir_Signature    = $06054B50;

type
  Local_File_Header= packed record
    Version_Needed_To_Extract: Word;
    General_Purpose_Bit_Flag : Word;
    Compression_Method       : Word;
    Last_Mod_File_Time       : Word;
    Last_Mod_File_Date       : Word;
    Crc32                    : LongInt;
    Compressed_Size          : LongInt;
    Uncompressed_Size        : LongInt;
    Filename_Length          : Word;
    Extra_Field_Length       : Word;
  end;

  Central_Directory_File_Header= packed record
    Version_Made_By             : Word;
    Version_Needed_To_Extract   : Word;
    General_Purpose_Bit_Flag    : Word;
    Compression_Method          : Word;
    Last_Mod_File_Time          : Word;
    Last_Mod_File_Date          : Word;
    Crc32                       : LongInt;
    Compressed_Size             : LongInt;
    Uncompressed_Size           : LongInt;
    Filename_Length             : Word;
    Extra_Field_Length          : Word;
    File_Comment_Length         : Word;
    Disk_Number_Start           : Word;
    Internal_File_Attributes    : Word;
    External_File_Attributes    : LongInt;
    Relative_Offset_Local_Header: LongInt;
  end;

  End_Central_Dir_Record= packed record
    Number_This_Disk                        : Word;
    Number_Disk_With_Start_Central_Directory: Word;
    Total_Entries_Central_Dir_On_This_Disk  : Word;
    Total_Entries_Central_Dir               : Word;
    Size_Central_Directory                  : LongInt;
    Offset_Start_Central_Directory          : LongInt;
    Zipfile_Comment_Length                  : Word;
  end;

  PInfoZip= ^TInfoZip;
  TInfoZip= record
    Descompactado: LongInt;
    Compactado   : LongInt;
    Modificado   : TDateTime;
  end;

  TZip= class
    protected
      Stream: TStream;

      function Armazenar (Arquivo: String; Descompactado, Compactado: LongInt; Data, Hora: Word): Boolean;
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

type
  PBuffer= ^TBuffer;
  TBuffer= array[1..1] of Char;





function Converter (Buffer: PBuffer; Tamanho: Integer): String;
var
  K: Integer;

begin
  SetLength (Result, Tamanho);
  for K:= 1 to Tamanho do
    Result[K]:= Buffer^[K];
end; // Converter ()





constructor TZip.Create;

begin
  inherited Create;

  Lista:= TStringList.Create;
end; // Create ()





destructor TZip.Destroy;

begin
  Lista.Free;

  inherited Destroy;
end; // Destroy ()





function TZip.ExtrairNomePath (const Completo: String; var Path: String): String;
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





function TZip.Armazenar (Arquivo: String; Descompactado, Compactado: LongInt; Data, Hora: Word): Boolean;
var
  Aux     : LongInt;
  Info    : PInfoZip;
  DataHora: TDateTime;

begin
  Status:= False;
  try
    try
      LongRec (Aux).Hi:= Data;
      LongRec (Aux).Lo:= Hora;
      DataHora        := FileDateToDateTime (Aux);
    except
      DataHora:= 0;
    end;
    New (Info);
    Info^.Descompactado:= Descompactado;
    Info^.Compactado   := Compactado;
    Info^.Modificado   := DataHora;
    Lista.AddObject (Arquivo, TObject (Info));
    Status:= True;
  finally
    Result:= Status;
  end;
end; // Armazenar ()





function TZip.IsValid (const FileName: String): Boolean;
var
  Signature: LongInt;

begin
  Result:= False;
  Status:= False;
  if FileExists (Filename) then begin
    try
      Stream:= TFileStream.Create (FileName, fmOpenRead);
      Result:= (Stream.Read (Signature, SizeOf (LongInt)) = SizeOf (LongInt)) and (Signature = cLocal_File_Header_Signature);
      Status:= True;
    finally
      Stream.Free;
    end;
  end;
end; // IsValid ()





procedure TZip.LoadFromFile (const FileName: String);
var
  Signature: LongInt;

 procedure CapturarLocalFileHeader;
 var
   Local: Local_File_Header;

 begin
   try
     Stream.Read (Local, SizeOf (Local_File_Header));
     with Local do
       Stream.Seek (Compressed_Size + Filename_Length + Extra_Field_Length, soFromCurrent);
   except
     Status:= False;
   end;
 end; // CapturarLocalFileHeader ()

 procedure CapturarCentralFileHeader;
 var
   Buffer : PBuffer;
   Central: Central_Directory_File_Header;

 begin
   Status:= False;
   try
     Stream.Read (Central, SizeOf (Central_Directory_File_Header));
   except
     Exit;
   end;
   with Central do begin
     try
       GetMem (Buffer, Filename_Length);
       Stream.Read (Buffer^, Filename_Length);
       if Armazenar (Converter (Buffer, Filename_Length), Uncompressed_Size, Compressed_Size, Last_Mod_File_Date, Last_Mod_File_Time) then begin
         Stream.Seek (Extra_Field_Length + File_Comment_Length, soFromCurrent);
         Status:= True;
       end;
     finally
       FreeMem (Buffer, Filename_Length);
     end;
   end;
 end; // CapturarCentralFileHeader ()

 procedure CapturarEndFileHeader;
 var
   EndHeader: End_Central_Dir_Record;

 begin
   try
     Stream.Read (EndHeader, SizeOf (End_Central_Dir_Record));
     with EndHeader do
       Stream.Seek (Zipfile_Comment_Length, soFromCurrent);
   except
     Status:= False;
   end;
 end; // CapturarEndFileHeader ()

begin
  Status:= False;
  try
    Stream:= TMemoryStream.Create;
    TMemoryStream (Stream).LoadFromFile (FileName);
    Lista.Clear;
    Status:= True;
    while Status and (Stream.Position < Stream.Size) do begin
      try
        Stream.Read (Signature, SizeOf (LongInt));
        case Signature of
          cLocal_File_Header_Signature  : CapturarLocalFileHeader;
          cCentral_File_Header_Signature: CapturarCentralFileHeader;
          cEnd_Central_Dir_Signature    : CapturarEndFileHeader;
        end;
      except
        Status:= False;
      end;
    end;
  finally
    Stream.Free;
  end;
end; // LoadFromFile ()

end.

// Final do Arquivo
