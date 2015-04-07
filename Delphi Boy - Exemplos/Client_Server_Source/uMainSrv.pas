unit uMainSrv;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ScktComp, StdCtrls, RXShell, Menus, IniFiles, uCommon, ImgList;

type
  TfMain = class(TForm)
    sktServidor: TServerSocket;
    TrayIcon: TRxTrayIcon;
    PopupMenu: TPopupMenu;
    N1: TMenuItem;
    Sair1: TMenuItem;
    Pausar1: TMenuItem;
    Continuar1: TMenuItem;
    ImageList: TImageList;
    procedure Sair1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TrayIconDblClick(Sender: TObject);
    procedure Continuar1Click(Sender: TObject);
    procedure Pausar1Click(Sender: TObject);
    procedure sktServidorClientRead(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure TrayIconMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure sktServidorClientConnect(Sender: TObject;
      Socket: TCustomWinSocket);
  private
    { Private declarations }
    TodasApp: TStringList;
    NomeArquivoINI: string;
    procedure AtivarServidor;
    procedure SuspenderServidor;
    function GetAppInfo(FName: string; SectionName: string): TAppInfo;
    procedure UpdateHint;
    procedure TrataErro(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
  public
    { Public declarations }
  end;

var
  fMain: TfMain;

implementation

{$R *.DFM}

procedure TfMain.FormCreate(Sender: TObject);
var
  ArquivoINI: TIniFile;
  Porta: integer;
begin
  // Recupera (ou grava) as configuracoes num arquivo .INI
  NomeArquivoINI := ChangeFileExt(ParamStr(0), '.INI');
  ArquivoINI := TIniFile.Create(NomeArquivoINI);
  // Le as configuracoes do servidor
  Porta := ArquivoINI.ReadInteger('Geral', 'Porta', -1);
  if Porta = -1 then begin
    Porta := SRV_PORTA;
    ArquivoINI.WriteInteger('Geral', 'Porta', Porta);
  end;
  // carrega a lista com as aplicacoes atendidas (todas as secoes menos GERAL)
  TodasApp := TStringList.Create;
  ArquivoINI.ReadSections(TodasApp);
  TodasApp.Delete(TodasApp.IndexOf('Geral'));
  // fecha o arquivo .INI
  ArquivoINI.Free;

  // configura o servidor
  sktServidor.Close;
  sktServidor.Port := Porta;
  sktServidor.Open;

  // exibe o icone correto
  ImageList.GetIcon(0, TrayIcon.Icon);
end;

procedure TfMain.TrataErro(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
  // para evitar mensagens de erro no servidor
  // desenvolver depois uma rotina de "log de erros"
  case ErrorCode of
    SKT_ERR_RESET_BY_PEER: Socket.Close;
  end;
  ErrorCode := 0;
  Application.ProcessMessages;
end;

procedure TfMain.sktServidorClientConnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  Socket.OnErrorEvent := TrataErro;
end;

procedure TfMain.AtivarServidor;
begin
  // reinicia a execucao do servidor
  sktServidor.Open;
  // atualiza as opcoes de menu
  Pausar1.Enabled := True;
  Pausar1.Default := True;
  Continuar1.Enabled := False;
  // exibe o icone correto
  ImageList.GetIcon(0, TrayIcon.Icon);
end;

procedure TfMain.SuspenderServidor;
begin
  // suspende execucao do servidor
  sktServidor.Close;
  // atualiza as opcoes de menu
  Pausar1.Enabled := False;
  Continuar1.Enabled := True;
  Continuar1.Default := True;
  // exibe o icone correto
  ImageList.GetIcon(1, TrayIcon.Icon);
end;

procedure TfMain.Continuar1Click(Sender: TObject);
begin
  AtivarServidor;
end;

procedure TfMain.Pausar1Click(Sender: TObject);
begin
  SuspenderServidor;
end;

procedure TfMain.TrayIconDblClick(Sender: TObject);
begin
  if sktServidor.Active then
    SuspenderServidor
  else
    AtivarServidor;
end;

procedure TfMain.Sair1Click(Sender: TObject);
begin
  // desativa o servidor
  sktServidor.Close;
  Close;
end;

procedure TfMain.sktServidorClientRead(Sender: TObject;
  Socket: TCustomWinSocket);
var
 Buffer: string;
 MsgLen, LenReceived: integer;
 Header: TMsgHeader;
 AppInfo: TAppInfo;
begin
  // tamanho aproximado da mensagem
  MsgLen := Socket.ReceiveLength;
  // prepara o tamanho do buffer e recebe a mensagem em si
  SetLength(Buffer, MsgLen);
  LenReceived := Socket.ReceiveBuf(Buffer[1], MsgLen);
  // ajusta para o numero correto de bytes
  Buffer := Copy(Buffer, 1, LenReceived);

  // verifica validade da mensagem (no minimo eh um cabecalho vazio, sem dados)
  if Length(Buffer) < SizeOf(Header) then
    // fecha conexao, provavelmente nao eh o cliente correto!
    Socket.Close
  else begin
    // extrai o cabecalho da mensagem
    Move(Buffer[1], Header, SizeOf(Header));
    Delete(Buffer, 1, SizeOf(Header));

    // procura a aplicacao solicitada entre as atendidas
    if TodasApp.IndexOf(Buffer) < 0 then
      SendError(Socket, MSG_ERR_APP_NOT_FOUND)
    else begin
      // carrega os dados da aplicacao
      AppInfo := GetAppInfo(NomeArquivoINI, Buffer);

      // age de acordo com o TIPO de mensagem recebida
      case Header.MsgKind of
        MSG_REQUEST_APP_INFO: SendInfo(Socket, AppInfo);
        MSG_REQUEST_FILE    : SendFile(Socket, AppInfo.Arquivo);
      else
        SendError(Socket, MSG_ERR_ILLEGAL_CODE);
      end;
    end;
  end;
end;

function TfMain.GetAppInfo(FName: string; SectionName: string): TAppInfo;
var
  ArquivoINI: TIniFile;
begin
  // abre o arquivo .INI
  ArquivoINI := TIniFile.Create(FName);
  // carrega os dados da aplicacao mandada como parametro (nome da secao)
  with ArquivoINI do begin
    Result.Nome := ReadString(SectionName, 'Aplicacao', NO_DATA);
    Result.Arquivo := ReadString(SectionName, 'Arquivo', NO_DATA);
    Result.Versao := DataArquivo(Result.Arquivo);
    Result.Status := ReadString(SectionName, 'Status', '0');
    Result.Comment := ReadString(SectionName, 'Comment', '');
  end;
end;

procedure TfMain.UpdateHint;
var
  s: string;
begin
  if not sktServidor.Active then
    s := 'Suspenso'
  else begin
    case sktServidor.Socket.ActiveConnections of
      0: s := 'Ocioso';
      1: s := '1 usuário';
    else
      s := Format('%d usuários', [sktServidor.Socket.ActiveConnections]);
    end;
  end;
  TrayIcon.Hint := Application.Title + ' (' + s + ')';
end;

procedure TfMain.TrayIconMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  // atualiza os Hints
  UpdateHint;
end;

end.
