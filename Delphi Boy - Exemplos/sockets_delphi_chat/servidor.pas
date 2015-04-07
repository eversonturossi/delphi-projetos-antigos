unit servidor;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ScktComp, StdCtrls, ExtCtrls;

type
  TfrmServidor = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Memo2: TMemo;
    ListBox1: TListBox;
    Splitter1: TSplitter;
    Panel3: TPanel;
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Panel4: TPanel;
    ServerSocket1: TServerSocket;
    procedure ServerSocket1ClientRead(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ServerSocket1ClientConnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    procedure EnviarMsgBroadcast(msg: String);
  public
    { Public declarations }
  end;

var
  frmServidor: TfrmServidor;

implementation

{$R *.DFM}


// Esta rotina é responsável por traduzir uma mensagem enviada ou recebida. Para isso elimina o
// identificador da mensagem, comando, (ADDNICK, DELNICK ou MSG) e retorna o restante
// do string em mensagem
function RecConteudoMsg(comando, mensagem: String): String;
var
   p: Integer;
begin
     p:= Pos(comando, mensagem);
     if p > 0 then
        Result:= Copy(mensagem, p + Length(comando), Length(mensagem));
end;

// Esta rotina é responsável por enviar uma determinada mensagem para
// todos os clientes conectados
procedure TfrmServidor.EnviarMsgBroadcast(msg: String);
var i: Integer;
begin
     try
        for i:= 0 to ServerSocket1.Socket.ActiveConnections - 1 do
            ServerSocket1.Socket.Connections[i].SendText(msg);
     except
           Beep;
     end;
end;

procedure TfrmServidor.ServerSocket1ClientRead(Sender: TObject;
  Socket: TCustomWinSocket);
var
   buff: String;
begin
     // Recupera a mensagem do buffer do socket
     buff:= Socket.ReceiveText;
     // Coloca o usuário recém-conectado da lista
     If Pos('ADDNICK=', buff) > 0 then
     begin
          Listbox1.Items.Add(RecConteudoMsg('ADDNICK=', buff));
          Memo2.Lines.Add('<' + RecConteudoMsg('ADDNICK=', buff) + '>entrou na sala.');
          // Avisa a todos os clientes conectados
          EnviarMsgBroadcast('MSG=<' + RecConteudoMsg('ADDNICK=', buff) + '>entrou na sala.');
     end;
     // Retira o usuário conectado da lista
     If Pos('DELNICK=', buff) > 0 then
     begin
          // Exclui o elemento da lista de usuários conectados
          Listbox1.Items.Delete(Listbox1.Items.IndexOf(RecConteudoMsg('DELNICK=', buff)));
          // Apresenta mensagem de abandono da sala
          Memo2.Lines.Add('<' + RecConteudoMsg('DELNICK=', buff) + '>deixou a sala.');
          // Espera enquanto o socket ainda estiver ativo (essa espera
          // evita que se trabalhe com objetos desatualizados)
          while Socket.Connected do
                Application.ProcessMessages;
          // Apresenta o número de clientes conectados (opcionalmente
          // poderia ficar no evento OnClientDisconnect)
          Label2.Caption:= IntToStr(ServerSocket1.Socket.ActiveConnections);
          // Avisa a todos os clientes conectados
          EnviarMsgBroadcast('MSG=<' + RecConteudoMsg('DELNICK=', buff) + '>deixou a sala.');
     end;
     // Coloca a nova mensagem na lista de mensagem e posta para todos os clientes uma cópia para que
     // atualizem suas listas locais
     If Pos('MSG=', buff) > 0 then
     begin
          Memo2.Lines.Add(RecConteudoMsg('MSG=', buff));
          // Avisa a todos os clientes conectados
          EnviarMsgBroadcast(buff);
     end;
end;

// Apresenta o número de clientes conectados
procedure TfrmServidor.ServerSocket1ClientConnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
     Label2.Caption:= IntToStr(ServerSocket1.Socket.ActiveConnections);
end;

procedure TfrmServidor.Button1Click(Sender: TObject);
begin
     // Elimina o usuário conectado da sala
     If Listbox1.ItemIndex > -1 then
        Listbox1.Items.Delete(Listbox1.ItemIndex);
end;

procedure TfrmServidor.Button2Click(Sender: TObject);
begin
     // Checa se o estado do botão é desligar ou religar
     if Button2.Caption = 'Desligar' then
     begin
          // Avisa a todos os clientes conectados
          EnviarMsgBroadcast('Servidor desligado !');
          Listbox1.Items.Clear;
          Memo2.Lines.Clear;
          ServerSocket1.Close;
          Label2.Caption:= '0';
          Button2.Caption:= 'Religar';
     end
     else
     begin
          // Coloca o servidor no estado de espera de
          // conexões
          ServerSocket1.Open;
          Button2.Caption:= 'Desligar';
     end;
end;

procedure TfrmServidor.FormShow(Sender: TObject);
begin
     // Coloca o servidor no estado de espera de conexões
     ServerSocket1.Open;
end;

end.

