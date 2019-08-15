{**************************************************}
{             c . A . N . A . L                    }
{        # D . E . L . P . H . I . X               }
{    [-----------------------------------]         }
{                                                  }
{       Brasnet - irc.brasnet.org                  }
{ Source by:                                       }
{            Glauber A. Dantas(Prodigy) 02/02/2003 }
{**************************************************}
unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ScktComp, StdCtrls;

type
  TForm1 = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Button1: TButton;
    Button2: TButton;
    Label3: TLabel;
    Label4: TLabel;
    Edit3: TEdit;
    Edit4: TEdit;
    ClientS: TClientSocket;
    Edit5: TEdit;
    Label5: TLabel;
    GroupBox2: TGroupBox;
    ListBox1: TListBox;
    Button3: TButton;
    Button4: TButton;
    Label6: TLabel;
    procedure ClientSConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure ClientSDisconnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure ClientSRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure ClientSConnecting(Sender: TObject; Socket: TCustomWinSocket);
  private
    { Private declarations }
    procedure EnviaTexto(Texto: String);
    procedure EnviaPrivMsg(Destino, Texto: String);
    procedure EnviaNotice(Destino, Texto: String);
    procedure SetNick(sNick: String);
    procedure SetUsuario(Ident, Nome: String);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  RecList : TStringList;

implementation

{$R *.DFM}

{------------ Funções ---------------}

//Função padrão para enviar Texto com #13#10 no final
procedure TForm1.EnviaTexto(Texto: String);
begin
   ClientS.Socket.SendText(Texto + #13#10)
end;

procedure TForm1.EnviaNotice(Destino, Texto: String);
begin
  EnviaTexto( Format('NOTICE %s :%s' , [Destino, Texto]) );
end;

procedure TForm1.EnviaPrivMsg(Destino, Texto: String);
begin
  EnviaTexto( Format('PRIVMSG %s :%s', [Destino, Texto]));
end;

procedure TForm1.SetNick(sNick: String);
begin
  EnviaTexto( Format('NICK %s', [sNick]) );
end;

procedure TForm1.SetUsuario(Ident, Nome: String);
begin
  EnviaTexto( Format('USER %s "%s" "%s" :%s',
   [Ident, ClientS.Socket.LocalAddress, ClientS.Socket.RemoteAddress, Nome]) );
end;

// Função para copiar uma palavra determinando o Indice
function CopyPalav(Msg: String; Index: Integer; const Separador: String = ' '): String;
var
  S : string;
  I : Integer;
begin
  if Index > 0 then
  begin
    I := 1;
    S := Msg + Separador;     
    while I < Index do
    begin
      S := Copy(S, Pos(Separador,S) + Length(Separador), Length(S));
      Inc(I);
    end;
    S := S + Separador;
    Result := Copy(S, 1, Pos(Separador,S)-1);
  end;
end;

{------------------- Fim Funções ----------------------------------------------}

procedure TForm1.ClientSConnect(Sender: TObject; Socket: TCustomWinSocket);
begin
  { Seta o Nick }
  SetNick(Edit3.Text);
  { Identifcia com o Servidor }
  SetUsuario(Edit4.Text, Edit5.Text);
  { Label fica conectado }
  Label5.Caption := '[Conectado]';
  { Muda a cor do Label }
  Label5.Font.Color := clGreen;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  //Define Host ou IP
  ClientS.Host := Edit1.Text;
  //Define Porta
  ClientS.Port := StrToInt(Edit2.Text);
  //Conecta
  ClientS.Open;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  //Fecha
  ClientS.Close;
end;

procedure TForm1.ClientSDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  { Label fica DESconectado }
  Label5.Caption := '[Deconectado]';
  { Muda a cor do Label }
  Label5.Font.Color := clRed;
end;

procedure TForm1.ClientSRead(Sender: TObject; Socket: TCustomWinSocket);
var
  RecText, RPing, RecNick, RecMsg, RecDestino, Comando : String;
  P, X : Integer;
begin
  RecText := Socket.ReceiveText;//Texto recebido

  //Coloca na StringList, isso evita erros se receber linhas juntas
  //Mensagem1#13#10Mensagem2#13#10, fica sendo 1 linha Mensagem1 e outra Mensagem2 =)
  RecList.Text := RecText;

  //Verifica linha por linha na RecList
  if RecList.Count > 0 then
  for X := 0 to RecList.Count -1 do
  begin
    { Verifica se a linha esta vazia }
    if RecList[X] <> '' then
      RecText := RecList[X]
    else
      Continue;

     //Responde pings
     if Pos('PING :', RecText) > 0 then
     begin
      P := Pos(':',RecText);
      RPing := Copy(RecText, P+1, Length(RecText)-P);
      EnviaTexto('PONG ' + RPing);
     end;

    //Verifica Mensagens 
    //:Prodigy_-!~prodigy@01zsyQa9sgk.200.157.170.O PRIVMSG #SourceX :!teste
    if CopyPalav(RecText, 2) = 'PRIVMSG' then
    begin
       //Nick que enviou
      RecNick := Copy(RecText,2, Pos('!',RecText)-2);
       //Destino - CANAL ou NICK
      RecDestino := CopyPalav(RecText,3);
       //Mensagem recebida
      RecMsg  := Copy(RecText, Pos(RecDestino,RecText) + Length(RecDestino)+2,Length(RecText));

      if RecDestino[1] = '#' then//Se foi mensagem no CANAL
      begin
        // ***** Comandos *****
        Comando := AnsiUpperCase( CopyPalav(RecMsg,1) );//1ª palavra paar maiuscula
        if Comando = '!FALA' then
          EnviaPrivMsg(RecDestino, 'O que é q vc quer '+ RecNick +' ?');

        if Comando = '!HORA' then
          EnviaPrivMsg(RecDestino, RecNick +': '+ TimeToStr(Now));

        if Comando = '!BLEH' then
          EnviaPrivMsg(RecDestino, RecNick +': bleh tb! :P');

        if Comando = '!ASCII' then
          EnviaPrivMsg(RecDestino, RecNick +': '+ IntToStr( Ord(CopyPalav(RecMsg,2)[1] ) ));

        if Comando = '!CHAR' then
        try
          EnviaPrivMsg(RecDestino, RecNick +': '+ Char(StrToInt(CopyPalav(RecMsg,2))) );
        except
          EnviaPrivMsg(RecDestino, RecNick +': Valor inválido');
        end;
      end;
      
    end;


  end;//Fim for X := 0 to RecList.Count -1 do
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
   //Cria SringList
   RecList := TStringList.Create;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //Libera SringList
  RecList.Free;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  //Se tem algum selecionado
  if ListBox1.ItemIndex <> -1 then
  //Envia comando para ENTRAR no Canal
   EnviaTexto('JOIN '+ ListBox1.Items[ListBox1.ItemIndex]);
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  //Se tem algum selecionado
  if ListBox1.ItemIndex <> -1 then
  //Envia comando para SAIR no Canal
   EnviaTexto('PART '+ ListBox1.Items[ListBox1.ItemIndex]);
end;

procedure TForm1.ClientSConnecting(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  { Label fica Conectando }
  Label5.Caption := '[Conectando...]';
  { Muda a cor do Label }
  Label5.Font.Color := clYellow;
end;

end.
