unit RTMCh;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ImgList, ComCtrls, ToolWin, Menus, ScktComp, ExtCtrls;

type
  TChat = class(TForm)
    MainMenu1: TMainMenu;
    Arquivo1: TMenuItem;
    Condes: TMenuItem;
    N1: TMenuItem;
    Config: TMenuItem;
    Ajuda1: TMenuItem;
    Help: TMenuItem;
    N2: TMenuItem;
    About: TMenuItem;
    ToolBar1: TToolBar;
    Condes1: TToolButton;
    ToolButton1: TToolButton;
    Config1: TToolButton;
    ToolButton2: TToolButton;
    Help1: TToolButton;
    About1: TToolButton;
    ImageList1: TImageList;
    Txt: TMemo;
    Msg: TEdit;
    Cliente: TClientSocket;
    Servidor: TServerSocket;
    Aguardarconexo1: TMenuItem;
    procedure FormShow(Sender: TObject);
    procedure Config1Click(Sender: TObject);
    procedure ConfigClick(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure AboutClick(Sender: TObject);
    procedure CondesClick(Sender: TObject);
    procedure Condes1Click(Sender: TObject);
    procedure MsgKeyPress(Sender: TObject; var Key: Char);
    procedure ClienteConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure ClienteDisconnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure ClienteError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure ClienteConnecting(Sender: TObject; Socket: TCustomWinSocket);
    procedure ServidorClientConnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ServidorClientDisconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ServidorClientError(Sender: TObject;
      Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
      var ErrorCode: Integer);
    procedure ServidorListen(Sender: TObject; Socket: TCustomWinSocket);
    procedure ServidorClientRead(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure Aguardarconexo1Click(Sender: TObject);
    procedure ClienteRead(Sender: TObject; Socket: TCustomWinSocket);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Chat: TChat;
  Test: BOOLEAN;
implementation

uses Config1, Sobre1;

{$R *.dfm}

procedure TChat.FormShow(Sender: TObject);
begin
Msg.SetFocus;
end;

procedure TChat.Config1Click(Sender: TObject);
begin
ConfigClick(Sender);
end;

procedure TChat.ConfigClick(Sender: TObject);
begin
Config2.ShowModal;
end;

procedure TChat.About1Click(Sender: TObject);
begin
AboutClick(Sender);
end;

procedure TChat.AboutClick(Sender: TObject);
begin
Sobre2.ShowModal;
end;

procedure TChat.CondesClick(Sender: TObject);
begin
if Condes.Caption = '&Conectar' then
ConfigClick(Sender)
else
begin
Servidor.Close;
Cliente.Close;
Condes.Caption := '&Conectar';
Condes1.Hint := 'Conectar';
Condes.ImageIndex := 0;
Condes1.ImageIndex := 0;
Chat.Caption := 'RTMChat 1.0 - Desconectado';
Aguardarconexo1.Enabled := True;
end
end;

procedure TChat.Condes1Click(Sender: TObject);
begin
CondesClick(Sender);
end;

procedure TChat.MsgKeyPress(Sender: TObject; var Key: Char);
begin
if key = #13 then
begin
if Chat.Caption = 'RTMChat 1.0 - Conectado' then
begin
if (Msg.Text = '/clear') or (Msg.Text = '/Clear') then
begin
Txt.Text := '';
Msg.Text := '';
end
else
if Test = False then
begin
Cliente.Socket.SendText('<' + Config2.nick.Text + '> ' + Msg.Text);
Txt.Lines.Add('<' + Config2.nick.Text + '> ' + Msg.Text);
Msg.Text := '';
end
else
begin
Servidor.Socket.Connections[0].SendText('<' + Config2.nick.Text + '> ' + Msg.Text);
Txt.Lines.Add('<' + Config2.nick.Text + '> ' + Msg.Text);
Msg.Text := '';
end;
end
else
begin
Application.MessageBox('Você não está conectado !','RTMChat', + mb_OK + mb_IconError);
Msg.Text := ''
end;
end;
end;

procedure TChat.ClienteConnect(Sender: TObject; Socket: TCustomWinSocket);
begin
Chat.Caption := 'RTMChat 1.0 - Conectado';
Chat.Condes.ImageIndex := 1;
Chat.Condes1.ImageIndex := 1;
Chat.Condes.Caption := '&Desconectar';
Chat.Condes1.Hint := 'Desconectar';
Aguardarconexo1.Enabled := False;
end;

procedure TChat.ClienteDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
Chat.Caption := 'RTMChat 1.0 - Desconectado';
Chat.Condes.ImageIndex := 0;
Chat.Condes1.ImageIndex := 0;
Chat.Condes.Caption := '&Conectar';
Chat.Condes1.Hint := 'Conectar';
Aguardarconexo1.Enabled := True;
end;

procedure TChat.ClienteError(Sender: TObject; Socket: TCustomWinSocket;
  ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
Application.MessageBox('Não foi possível conectar !','RTMChat', + mb_OK + mb_IconError);
Chat.Caption := 'RTMChat 1.0 - Desconectado';
Chat.Condes.ImageIndex := 0;
Chat.Condes1.ImageIndex := 0;
Chat.Condes.Caption := '&Conectar';
Chat.Condes1.Hint := 'Conectar';
Aguardarconexo1.Enabled := True;
end;

procedure TChat.ClienteConnecting(Sender: TObject;
  Socket: TCustomWinSocket);
begin
Chat.Caption := 'RTMChat 1.0 - Conectando à ' + Config2.ende.Text;
Chat.Condes.ImageIndex := 1;
Chat.Condes1.ImageIndex := 1;
Chat.Condes.Caption := '&Desconectar';
Chat.Condes1.Hint := 'Desconectar';
Aguardarconexo1.Enabled := False;
end;

procedure TChat.ServidorClientConnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
Chat.Caption := 'RTMChat 1.0 - Conectado';
Chat.Condes.ImageIndex := 1;
Chat.Condes1.ImageIndex := 1;
Chat.Condes.Caption := '&Desconectar';
Chat.Condes1.Hint := 'Desconectar';
Aguardarconexo1.Enabled := False;
end;

procedure TChat.ServidorClientDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
Chat.Caption := 'RTMChat 1.0 - Desconectado';
Chat.Condes.ImageIndex := 0;
Chat.Condes1.ImageIndex := 0;
Chat.Condes.Caption := '&Conectar';
Chat.Condes1.Hint := 'Conectar';
Aguardarconexo1.Enabled := True;
end;

procedure TChat.ServidorClientError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
Application.MessageBox('Não foi possível conectar !','RTMChat', + mb_OK + mb_IconError);
Chat.Caption := 'RTMChat 1.0 - Desconectado';
Chat.Condes.ImageIndex := 0;
Chat.Condes1.ImageIndex := 0;
Chat.Condes.Caption := '&Conectar';
Chat.Condes1.Hint := 'Conectar';
Aguardarconexo1.Enabled := True;
end;

procedure TChat.ServidorListen(Sender: TObject; Socket: TCustomWinSocket);
begin
Chat.Caption := 'RTMChat 1.0 - Aguardando conexão...';
Aguardarconexo1.Enabled := False;
end;

procedure TChat.ServidorClientRead(Sender: TObject;
  Socket: TCustomWinSocket);
begin
Txt.Lines.Add(Socket.ReceiveText);
end;

procedure TChat.Aguardarconexo1Click(Sender: TObject);
begin
Servidor.Port := StrToInt(Config2.porta.Text);
Servidor.Open;
Test := True;
end;

procedure TChat.ClienteRead(Sender: TObject; Socket: TCustomWinSocket);
begin
Txt.Lines.Add(Socket.ReceiveText);
end;

end.
