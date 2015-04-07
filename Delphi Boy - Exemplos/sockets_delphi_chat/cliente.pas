unit cliente;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ScktComp;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Panel1: TPanel;
    Button1: TButton;
    Edit2: TEdit;
    Panel2: TPanel;
    Edit1: TEdit;
    Label2: TLabel;
    Button2: TButton;
    Panel3: TPanel;
    ClientSocket1: TClientSocket;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ClientSocket1Read(Sender: TObject; Socket: TCustomWinSocket);
    procedure ClientSocket1Disconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}



function RecConteudoMsg(comando, mensagem: String): String;
var
   p: Integer;
begin
     p:= Pos(comando, mensagem);
     if p > 0 then
        Result:= Copy(mensagem, p + Length(comando), Length(mensagem));
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
     // Conecta ao servidor CHAT
     ClientSocket1.Open;
     // Espera para o servidor se estabelecer
     while not ClientSocket1.Socket.Connected do
           Application.ProcessMessages;
     // Envia a mensagem de conexão (ver protocolo definido nos parágrafos anteriores)
     ClientSocket1.Socket.SendText('ADDNICK=' + Edit1.Text);
     // Configura interface
     Button2.Enabled:= False;
     Edit1.Enabled:= False;
     Memo1.Enabled:= True;
     Button1.Enabled:= True;
     Edit2.Enabled:= True;
     Edit2.SetFocus;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
     // Envia a mensagem para o servidor (se houver mensagem)
     If Trim(Edit2.Text) <> '' then
     begin
          ClientSocket1.Socket.SendText('MSG=' + '<' + Edit1.Text + '>' + Edit2.Text);
          Edit2.Clear;
          Edit2.SetFocus;
     end
     else
         Beep;
end;

procedure TForm1.ClientSocket1Read(Sender: TObject;
  Socket: TCustomWinSocket);
var buff: String;
begin
     buff:= Socket.ReceiveText;
     // Coloca a nova mensagem na lista de mensagem
     If Pos('MSG=', buff) > 0 then
        Memo1.Lines.Add(RecConteudoMsg('MSG=', buff));
end;

procedure TForm1.ClientSocket1Disconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
     // Configura a interface quando o servidor 'cair'
     Button2.Enabled:= True;
     Edit1.Enabled:= True;
     Memo1.Enabled:= False;
     Button1.Enabled:= False;
     Edit2.Enabled:= False;
     Edit1.SetFocus;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
     ClientSocket1.Socket.SendText('DELNICK=' + Edit1.Text);
end;

end.

