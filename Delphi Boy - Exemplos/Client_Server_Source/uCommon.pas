unit uCommon;

interface

uses
  Windows, Classes, SysUtils, ScktComp, Dialogs, Forms;

const
  SRV_PORTA              = 3051;
  SRV_HOST               = 'localhost';
  NO_DATA                = '_ERRO_';

  SKT_ERR_RESET_BY_PEER  = 10054;

  MSG_REQUEST_APP_INFO   = $0011;
  MSG_APP_INFO_FOLLOWS   = $0012;

  MSG_REQUEST_FILE       = $0021;
  MSG_FILE_FOLLOWS       = $0022;

  MSG_ERR_ILLEGAL_CODE   = $0091;
  MSG_ERR_APP_NOT_FOUND  = $0092;
  MSG_ERR_FILE_NOT_FOUND = $0093;
  MSG_ERR_CANNOT_SEND    = $0094;
  MSG_ERR_DISCONECTING   = $0099;

type
  TMsgHeader = packed record
    MsgKind: integer;
    MsgSize: integer;
  end;

  TAppInfo = packed record
    Nome: string[8];
    Arquivo: string[12];
    Versao: TDateTime;
    Status: string[1];
    Comment: string[255];
  end;

  procedure SendData(Socket: TCustomWinSocket; Kind: integer; Msg: string);
  procedure SendError(Socket: TCustomWinSocket; Kind: integer);
  procedure SendFile(Socket: TCustomWinSocket; FName: string);
  procedure SendInfo(Socket: TCustomWinSocket; AppInfo: TAppInfo);
  procedure Erro(Texto: string);
  procedure Informacao(Texto: string);
  function DataArquivo(FName: string): TDateTime;
  procedure Delay(mSecs: Cardinal);

implementation

procedure SendData(Socket: TCustomWinSocket; Kind: integer; Msg: string);
var
  S: TMemoryStream;
  Header: TMsgHeader;
begin
  // prepara o cabecalho
  with Header do begin
    MsgKind := Kind;
    MsgSize := Length(Msg);
  end;
  // cria o "pacote"
  S := TMemoryStream.Create;
  // escreve o cabecalho
  S.Write(Header, SizeOf(Header));
  // anexa os dados, caso haja dados
  if Header.MsgSize > 0 then
   S.Write(Msg[1], Header.MsgSize);
  // envia
  S.Position := 0;
  Socket.SendStream(S);
  // **Nao precisa destruir o MemoryStream, sera destruido automaticamente**
end;

procedure SendError(Socket: TCustomWinSocket; Kind: integer);
begin
  SendData(Socket, Kind, '');
end;

procedure SendFile(Socket: TCustomWinSocket; FName: string );
var
  Header: TMsgHeader;
  Fs: TFileStream;
  S: TMemoryStream;
begin
  // se o arquivo NAO existe
  if not FileExists(FName) then
    SendError(Socket, MSG_ERR_FILE_NOT_FOUND)
  else
    try
      // abre o arquivo
      Fs := TFileStream.Create(FName, (fmOpenRead or fmShareDenyWrite));
      Fs.Position := 0;
      // prepara o cabecalho
      with Header do begin
        MsgKind := MSG_FILE_FOLLOWS;
        MsgSize := Fs.Size;
      end;
      // cria o "pacote"
      S := TMemoryStream.Create;
      // escreve o cabecalho
      S.Write(Header, SizeOf(Header));
      // anexa o conteudo do arquivo
      S.CopyFrom(Fs, Fs.Size);
      // send to socket
      S.Position := 0;
      Socket.SendStreamThenDrop(S);
      // **Nao precisa destruir o TMemoryStream, sera destruido automaticamente**
      // mas precisa destruir o TFileStream...
      Fs.Free;
    except
      // em caso de erro...
      SendError(Socket, MSG_ERR_CANNOT_SEND);
    end;
end;

procedure SendInfo(Socket: TCustomWinSocket; AppInfo: TAppInfo);
var
  S: TMemoryStream;
  Header: TMsgHeader;
begin
  // prepara o cabecalho
  with Header do begin
    MsgKind := MSG_APP_INFO_FOLLOWS;
    MsgSize := SizeOf(AppInfo);
  end;
  // cria o "pacote"
  S := TMemoryStream.Create;
  // escreve o cabecalho
  S.Write(Header, SizeOf(Header));
  // anexa os dados (info) da aplicacao (AppInfo)
  S.Write(AppInfo, SizeOf(AppInfo));
  // envia
  S.Position := 0;
  Socket.SendStream(S);
  // **Nao precisa destruir o MemoryStream, sera destruido automaticamente**
end;

procedure Erro(Texto: string);
begin
  MessageBeep(MB_ICONERROR);
  MessageDlg(Texto, mtError, [mbOK], 0);
end;

procedure Informacao(Texto: string);
begin
  MessageBeep(MB_ICONINFORMATION);
  MessageDlg(Texto, mtInformation, [mbOK], 0);
end;

function DataArquivo(FName: string): TDateTime;
begin
  if FileExists(FName) then
    Result := FileDateToDateTime(FileAge(FName))
  else
    Result := 0;
end;

procedure Delay(mSecs: Cardinal);
var
  Comeco: Cardinal;
begin
  Comeco := GetTickCount;
  repeat
    Application.ProcessMessages;
  until (GetTickCount - Comeco) <= mSecs;
end;

end.
