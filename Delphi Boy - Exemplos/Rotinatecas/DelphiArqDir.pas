{ Wheberson Hudson Migueletti, em Brasília, 18 de junho de 1998.
  Arquivo : DelphiArqDir.Pas
  Internet: http://www.geocities.com/SiliconValley/Program/4527
  E-mail  : whebersite@zipmail.com.br
  Tratamento de Arquivos/Diretórios em Delphi.
}

unit DelphiArqDir;

interface

uses
  Windows, SysUtils, Classes, Forms, Graphics, FileCtrl, ShlObj, ShellApi,
  ActiveX;

type
  TRegInfoDrives= record
    Drive : Char;        { Drive }
    Tipo  : TDriveType;  { Tipo do Drive (Disquete, Disco Rígido, etc) }
    Rotulo: PChar;       { Nome do Drive }
  end;
  TInfoDrives= object
    Tam   : Byte;                           { Tamanho do vetor }
    Drives: array[1..26] of TRegInfoDrives; { Drives encontrados, de 'A' a 'Z'}

    function ProcurarDrive     (DriveSelecionado: Char): Byte;
    function BuscarTipoDrive   (DriveSelecionado: Char): TDriveType;
    function BuscarRotuloDrive (DriveSelecionado: Char): String;
  end;

function ConverterKiloByte            (Numero: Integer): Integer;
function ConverterParaPeso            (Numero: LongInt): String;
function CapturarDataCriacaoArquivo   (const FileName: String): Integer;
function CapturarDataAcessoArquivo    (const FileName: String): Integer;
function CapturarNomeDOS              (const FileName: String): String;
function CapturarTamanhoArquivo       (const FileName: String): Integer;
function ExtrairSomenteNomeArquivo    (Nome: String): String;
function ExtrairDriveDiretorio        (Path: String): Char;
function RetornarNivelAcima           (Path: String): String;
function SerPasta                     (Nome: String): Boolean;
function AcertarPasta                 (Path: String): String;
function ExtrairPasta                 (Path: String): String;
function CapturarPropriedadesPasta    (Path: String; var Pastas, Arquivos: Integer): Integer;
function VolumeID                     (DriveChar: Char): String;
function NetworkVolume                (DriveChar: Char): String;
function Apagar                       (Arquivo: String; IrParaLixeira: Boolean): Boolean;
function Copiar                       (Arquivo, Destino: String): Boolean;
function Mover                        (Arquivo, Destino: String): Boolean;
function Renomear                     (Arquivo, NovoNome: String): Boolean;
function BuscarDiretorio              (DiretorioInicial: String; Data: Integer): String;
function CapturarDrives: TInfoDrives;

implementation

var
  gDiretorio: String;





function ConverterKiloByte (Numero: Integer): Integer;

begin
  if Numero > 1024 then
    Result:= Trunc (Numero/1024.0)
  else if Numero > 0 then
    Result:= 1
  else
    Result:= 0;
end;




// Converte um número para Kilo, Mega, Giga, etc
function ConverterParaPeso (Numero: LongInt): String;
var
  Tmp: Extended;

 function ConverterParaString (Valor: Extended): String;

 begin
   Str (Valor:0:2, Result);
 end;

begin
  if Numero > 1024 then begin
    Tmp:= Numero/1024.0;
    if Tmp < 1024.0 then
      Result:= ConverterParaString (Tmp) + 'KB'
    else begin
      Tmp:= Tmp/1024.0;
      if Tmp < 1024.0 then
        Result:= ConverterParaString (Tmp) + 'MB'
      else
        Result:= ConverterParaString (Tmp/1024.0) + 'GB';
    end;
  end
  else if Numero > 0 then
    Result:= ConverterParaString (Numero/1024.0) + 'KB'
  else
    Result:= ConverterParaString (0) + 'KB';
end;





function CopiarNomeFileOp (Nome: String): PChar;
var
  I: Integer;

begin
  Nome  := Nome+#0#0;
  I     := Length (Nome);
  Result:= StrAlloc (I);
  StrMove (Result, PChar (Nome), I);
  // Result:= StrPCopy (Buffer, Result, I); // Buffer: array[0..255] of Char;
  {for I:= 0 to Length (Nome)-1 do
    (Result+I)^:= Nome[I+1];}
end;




// Créditos: Borland
function CapturarDataCriacaoArquivo (const FileName: String): Integer;
var
  Handle       : THandle;
  FindData     : TWin32FindData;
  LocalFileTime: TFileTime;

begin
  Handle:= FindFirstFile (PChar (FileName), FindData);
  if Handle <> INVALID_HANDLE_VALUE then begin
    Windows.FindClose (Handle);
    if (FindData.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY) = 0 then begin
      FileTimeToLocalFileTime (FindData.ftCreationTime, LocalFileTime);
      if FileTimeToDosDateTime (LocalFileTime, LongRec (Result).Hi, LongRec (Result).Lo) then
        Exit;
    end;
  end;
  Result:= -1;
end;




// Créditos: Borland
function CapturarDataAcessoArquivo (const FileName: String): Integer;
var
  Handle       : THandle;
  FindData     : TWin32FindData;
  LocalFileTime: TFileTime;

begin
  Handle:= FindFirstFile (PChar (FileName), FindData);
  if Handle <> INVALID_HANDLE_VALUE then begin
    Windows.FindClose (Handle);
    if (FindData.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY) = 0 then begin
      FileTimeToLocalFileTime (FindData.ftLastAccessTime, LocalFileTime);
      if FileTimeToDosDateTime (LocalFileTime, LongRec (Result).Hi, LongRec (Result).Lo) then
        Exit;
    end;
  end;
  Result:= -1;
end;





function CapturarNomeDOS (const FileName: String): String;
var
  Handle  : THandle;
  FindData: TWin32FindData;

begin
  Handle:= FindFirstFile (PChar (FileName), FindData);
  Result:= '';
  if Handle <> INVALID_HANDLE_VALUE then begin
     Windows.FindClose (Handle);
    if (FindData.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY) = 0 then
      Result:= StrPas (FindData.cAlternateFileName);
  end;
  if (Result = '') and (Length (ExtrairSomenteNomeArquivo (FileName)) <= 8) then
    Result:= ExtractFileName (FileName);
end;  





function CapturarTamanhoArquivo (const FileName: String): Integer;
var
  Handle  : THandle;
  FindData: TWin32FindData;

begin
  Handle:= FindFirstFile (PChar (FileName), FindData);
  if Handle <> INVALID_HANDLE_VALUE then begin
    Result:= FindData.nFileSizeLow;
    Windows.FindClose (Handle);
  end
  else
    Result:= -1;
end; 





function ExtrairSomenteNomeArquivo (Nome: String): String;
var
  K, P: Integer;

begin
  Nome:= ExtractFileName (Nome);
  P   := Length (Nome);
  for K:= P downto 1 do
    if Nome[K] = '.' then begin // Último ponto mais a direita 
      P:= K-1;
      Break;
    end;
  Result:= Copy (Nome, 1, P);
end;





function ExtrairDriveDiretorio (Path: String): Char;
var
  P, T: Byte;

begin
  T:= Length (Path);
  P:= 1;
  while (P <= T) and (Path[P] = ' ') do
    Inc (P);
  Path[P]:= UpCase (Path[P]);
  if (Path[P] >= 'A') and (Path[P] <= 'Z') then
    Result:= Path[P]
  else
    Result:= ' ';
end;





function RetornarNivelAcima (Path: String): String;
var
  K, T: Integer;

begin
  Path:= AcertarPasta (Path);
  T   := Length (Path);
  if T <= 2 then
    Result:= ''
  else begin
    K:= T;
    while (K > 1) and (Path[K] <> '\') do
      Dec (K);
    Delete (Path, K, T-K + 1);
    Result:= Path;
  end;
end;





function SerPasta (Nome: String): Boolean;
var
  Atributos: Integer;

begin
  Atributos:= FileGetAttr (Nome);
  Result   := (Atributos >= 0) and (Atributos and faDirectory > 0);
end;





function AcertarPasta (Path: String): String;
var
  Tam: Integer;

begin
  Tam:= Length (Path);
  if (Tam > 0) and (Path[Tam] = '\') then
    SetLength (Path, Tam-1);
  Result:= Path;
end;





function ExtrairPasta (Path: String): String;
var
  T: Integer;

begin
  Path:= AcertarPasta (Path);
  T   := Length (Path);
  if T <= 2 then begin
    if T = 0 then
      Result:= ''
    else
      Result:= Path[1];
  end
  else begin
    Result:= '';
    while (T > 1) and (Path[T] <> '\') do begin
      Result:= Path[T] + Result;
      Dec (T);
    end;
  end;
end;




// Calcula o tamanho da pasta
function CapturarTamanhoPasta (Path: String): Integer;
var
  Tamanho: Integer;

 procedure EntrarPasta (const Path: String);
 var
   Status: Integer;
   R     : TSearchRec;

 begin
   Status:= FindFirst (Path + '\*.*', faAnyFile, R);
   while Status = 0 do begin
     if R.Name[1] <> '.' then begin
       if R.Attr and faDirectory = 0 then
         Inc (Tamanho, R.Size)
       else
         EntrarPasta (Path + '\' + R.Name);
     end;
     Status:= FindNext (R);
   end;
   FindClose (R);
 end;

begin
  Tamanho:= 0;
  Path   := AcertarPasta (Path);
  EntrarPasta (Path);
  Result:= Tamanho;
end;




// Calcula a quantidade de objetos (arquivos+subpastas) e tamanho da pasta
function CapturarPropriedadesPasta (Path: String; var Pastas, Arquivos: Integer): Integer;
var
  Tamanho: Integer;

 procedure EntrarPasta (const Path: String);
 var
   Status: Integer;
   R     : TSearchRec;

 begin
   Status:= FindFirst (Path + '\*.*', faAnyFile, R);
   while Status = 0 do begin
     if R.Name[1] <> '.' then begin
       if R.Attr and faDirectory = 0 then begin
         Inc (Arquivos);
         Inc (Tamanho, R.Size);
       end
       else begin
         Inc (Pastas);
         EntrarPasta (Path + '\' + R.Name);
       end;
     end;
     Status:= FindNext (R);
   end;
   FindClose (R);
 end;

begin
  Arquivos:= 0;
  Pastas  := 0;
  Tamanho := 0;
  Path    := AcertarPasta (Path);
  EntrarPasta (Path);
  Result:= Tamanho;
end;



// Classe: TInfoDrives
// Retorna a posição do drive selecionado (0 se NÃO foi encontrado)
function TInfoDrives.ProcurarDrive (DriveSelecionado: Char): Byte;
var
  K: Byte;

begin
  DriveSelecionado:= UpCase (DriveSelecionado);
  Result          := 0;
  for K:= 1 to Tam do
    with Drives[K] do
      if Drive = DriveSelecionado then begin
        Result:= K;
        Exit;
      end;
end;




// Retorna o tipo (Disquete, Disco Rígido, etc) do drive selecionado
function TInfoDrives.BuscarTipoDrive (DriveSelecionado: Char): TDriveType;
var
  K: Byte;

begin
  K:= ProcurarDrive (DriveSelecionado);
  if K > 0 then
    Result:= Drives[K].Tipo
  else
    Result:= dtUnKnown
end; 




// Retorna o nome (Rótulo) do drive selecionado
function TInfoDrives.BuscarRotuloDrive (DriveSelecionado: Char): String;
var
  K: Byte;

begin
  K:= ProcurarDrive (DriveSelecionado);
  if K > 0 then
    Result:= StrPas (Drives[K].Rotulo)
  else
    Result:= '';
end;
// Classe: TInfoDrives 



// Créditos: Borland 
function VolumeID (DriveChar: Char): String;
var
  OldErrorMode     : Integer;
  NotUsed, VolFlags: DWORD;
  Buf              : array [0..MAX_PATH] of Char;

begin
  OldErrorMode:= SetErrorMode (SEM_FAILCRITICALERRORS);
  try
    if GetVolumeInformation (PChar (DriveChar + ':\'), Buf, SizeOf (Buf),
                             nil, NotUsed, VolFlags, nil, 0) then
      SetString (Result, Buf, StrLen (Buf))
    else
      Result:= '';
    if DriveChar < 'a' then
      Result:= AnsiUpperCaseFileName (Result)
    else
      Result:= AnsiLowerCaseFileName (Result);
  finally
    SetErrorMode (OldErrorMode);
  end;
end;




// Créditos: Borland
function NetworkVolume (DriveChar: Char): String;
var
  BufferSize: DWORD;
  DriveStr  : array[0..3] of Char;
  Buf       : array[0..MAX_PATH] of Char;

begin
  BufferSize := SizeOf (Buf);
  DriveStr[0]:= UpCase (DriveChar);
  DriveStr[1]:= ':';
  DriveStr[2]:= #0;
  if WNetGetConnection (DriveStr, Buf, BufferSize) = WN_SUCCESS then begin
    SetString (Result, Buf, BufferSize);
    if DriveChar < 'a' then
      Result:= AnsiUpperCaseFileName (Result)
    else
      Result:= AnsiLowerCaseFileName (Result);
  end
  else
    Result:= VolumeID (DriveChar);
end;





function BrowseCallbackProc (Wnd: HWnd; Msg: UINT; _lParam: LPARAM; lData: LPARAM): Integer; stdcall;

begin
  Result:= 0;
  case Msg of
    BFFM_INITIALIZED: if lData <> 0 then
                        SendMessage (Wnd, BFFM_SETSELECTION, 1, LPARAM (gDiretorio));
  end;
end; 




// Exemplo: BuscarDiretorio ('C:\Temp', Integer (Self));
function BuscarDiretorio (DiretorioInicial: String; Data: Integer): String;
var
  Path  : PChar;
  ItemID: PItemIDList;
  lpbi  : TBrowseInfo;
  Shell : IMalloc;

begin
  Result:= '';
  if SHGetMalloc (Shell) = NOERROR then begin
    try
      Path:= PChar (Shell.Alloc (MAX_PATH));
      if Assigned (Path) then begin
        try
          FillChar (lpbi, SizeOf (TBrowseInfo), 0);
          gDiretorio:= DiretorioInicial;
          with lpbi do begin
            hwndOwner:= Application.Handle;
            lpszTitle:= 'Select a directory:';
            ulFlags  := BIF_RETURNONLYFSDIRS;
            lpfn     := BrowseCallbackProc;
            lParam   := Data; // LongInt (Self);
          end;
          ItemID:= SHBrowseForFolder (lpbi);
          if Assigned (ItemID) then begin
            try
              SHGetPathFromIDList (ItemID, Path);
              Result:= Path;
            finally
              Shell.Free (ItemID);
            end;
          end;
        finally
          Shell.Free (Path);
        end;
      end;
    finally
      Shell._Release;
    end;
  end;
end;





function Apagar (Arquivo: String; IrParaLixeira: Boolean): Boolean;
var
  Nome1   : PChar;
  lpFileOp: TSHFileOpStruct;

begin
  Nome1:= CopiarNomeFileOp (Arquivo);
  FillChar (lpFileOp, SizeOf (TSHFileOpStruct), #0);
  with lpFileOp do begin
    Wnd   := Application.Handle;
    wFunc := FO_DELETE;
    pFrom := Nome1;
    fFlags:= FOF_ALLOWUNDO;
    if not IrParaLixeira then
      fFlags:= 0;
  end;
  Result:= SHFileOperation (lpFileOp) = 0;
  StrDispose (Nome1);
end;





function Copiar (Arquivo, Destino: String): Boolean;
var
  Nome1, Nome2: PChar;
  lpFileOp    : TSHFileOpStruct;

begin
  Nome1:= CopiarNomeFileOp (Arquivo);
  Nome2:= CopiarNomeFileOp (Destino);

  FillChar (lpFileOp, SizeOf (TSHFileOpStruct), #0);
  with lpFileOp do begin
    Wnd   := Application.Handle;
    wFunc := FO_COPY;
    pFrom := Nome1;
    pTo   := Nome2;
    fFlags:= FOF_ALLOWUNDO;
    if AcertarPasta (ExtractFilePath (Arquivo)) <> AcertarPasta (ExtractFilePath (Destino)) then
      fFlags:= FOF_ALLOWUNDO;
  end;
  Result:= SHFileOperation (lpFileOp) = 0;

  StrDispose (Nome1);
  StrDispose (Nome2);
end;





function Mover (Arquivo, Destino: String): Boolean;
var
  Nome1, Nome2: PChar;
  lpFileOp    : TSHFileOpStruct;

begin
  Nome1:= CopiarNomeFileOp (Arquivo);
  Nome2:= CopiarNomeFileOp (Destino);
  FillChar (lpFileOp, SizeOf (TSHFileOpStruct), #0);
  with lpFileOp do begin
    Wnd   := Application.Handle;
    wFunc := FO_MOVE;
    pFrom := Nome1;
    pTo   := Nome2;
    fFlags:= FOF_ALLOWUNDO;
  end;
  Result:= SHFileOperation (lpFileOp) = 0;
  StrDispose (Nome1);
  StrDispose (Nome2);
end;





function Renomear (Arquivo, NovoNome: String): Boolean;
var
  Nome1, Nome2: PChar;
  lpFileOp    : TSHFileOpStruct;

begin
  Nome1:= CopiarNomeFileOp (Arquivo);
  Nome2:= CopiarNomeFileOp (NovoNome);

  FillChar (lpFileOp, SizeOf (TSHFileOpStruct), #0);
  with lpFileOp do begin
    Wnd   := Application.Handle;
    wFunc := FO_RENAME;
    pFrom := Nome1;
    pTo   := Nome2;
    fFlags:= FOF_ALLOWUNDO;
  end;
  Result:= SHFileOperation (lpFileOp) = 0;

  StrDispose (Nome1);
  StrDispose (Nome2);
end;




// Créditos: Borland
function CapturarDrives: TInfoDrives;
var
  DriveChar : Char;
  KDrive    : Byte;
  DriveNum  : Integer;
  DriveType : TDriveType;
  DriveBits : set of 0..25;
  SHFileInfo: TSHFileInfo;

  procedure AdicionaDrive (_Drive: Char; _Tipo: TDriveType; _Rotulo: String);

  begin
    Inc (KDrive);
    with Result do begin
      Tam:= KDrive;
      with Drives[KDrive] do begin
        Drive := _Drive;
        Tipo  := _Tipo;
        Rotulo:= StrNew (PChar (_Rotulo));
      end;
    end;
  end;

begin
  // Informa quais os drives instalados (através de bits de um DWORD) 
  Integer(DriveBits):= GetLogicalDrives;
  KDrive            := 0;
  for DriveNum:= 0 to 25 do begin { 'A' até 'Z' }
    if (DriveNum in DriveBits) then begin
      DriveChar:= Char (DriveNum + Ord ('a'));
      DriveType:= TDriveType (GetDriveType (PChar (DriveChar + ':\')));
      DriveChar:= Upcase (DriveChar);
      SHGetFileInfo (PChar (DriveChar + ':\'), 0, SHFileInfo, SizeOf (TSHFileInfo), SHGFI_DISPLAYNAME);
      case DriveType of
        dtFloppy : AdicionaDrive (DriveChar, dtFloppy, SHFileInfo.szDisplayName);
        dtFixed  : AdicionaDrive (DriveChar, dtFixed, SHFileInfo.szDisplayName);
        dtNetwork: AdicionaDrive (DriveChar, dtNetwork, SHFileInfo.szDisplayName);
        dtCDROM  : AdicionaDrive (DriveChar, dtCDROM, SHFileInfo.szDisplayName);
        dtRAM    : AdicionaDrive (DriveChar, dtRAM, SHFileInfo.szDisplayName);
      end;
    end;
  end;
end;

end.
