{********************************************************************}
{  ** Client Irc by Prodigy **                                       }
{ - Autor: Glauber A. Dantas(Prodigy_-)                              }
{ - Info: glauber@delphix.com.br,                                    }
{         #DelphiX - [Brasnet] irc.brasnet.org                       }
{ - Atualização 01/03/2003                                           }
{********************************************************************}
unit Unit1;

interface

uses
 Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
 StdCtrls, ExtCtrls, ScktComp, Menus, ComCtrls;

type
 TForm1 = class(TForm)
  RichEdit1: TRichEdit;
  MainMenu1: TMainMenu;
  Conexo1: TMenuItem;
  Conectar1: TMenuItem;
  Desconectar1: TMenuItem;
  Info: TMenuItem;
  N1: TMenuItem;
  Sair1: TMenuItem;
  Opes1: TMenuItem;
  Join1: TMenuItem;
  Part1: TMenuItem;
  Notice1: TMenuItem;
  N2: TMenuItem;
  Quit1: TMenuItem;
  Sobre1: TMenuItem;
  ClientSocket: TClientSocket;
  Splitter1: TSplitter;
  ListBox1: TListBox;
  Panel1: TPanel;
  Edit1: TEdit;
  ComboBox1: TComboBox;
  procedure Sair1Click(Sender: TObject);
  procedure FormResize(Sender: TObject);
  procedure Conectar1Click(Sender: TObject);
  procedure Desconectar1Click(Sender: TObject);
  procedure Join1Click(Sender: TObject);
  procedure Quit1Click(Sender: TObject);
  procedure ClientSocketConnect(Sender: TObject;
   Socket: TCustomWinSocket);
  procedure ClientSocketDisconnect(Sender: TObject;
   Socket: TCustomWinSocket);
  procedure ClientSocketRead(Sender: TObject; Socket: TCustomWinSocket);
  procedure Edit1KeyDown(Sender: TObject; var Key: Word;
   Shift: TShiftState);
  procedure Edit1KeyPress(Sender: TObject; var Key: Char);
  procedure Part1Click(Sender: TObject);
  procedure ClientSocketConnecting(Sender: TObject;
   Socket: TCustomWinSocket);
  procedure FormCreate(Sender: TObject);
  procedure FormClose(Sender: TObject; var Action: TCloseAction);
 private
  { Private declarations }
 public
  RecText: string;
  { Public declarations }
 end;
 
var
 Form1: TForm1;
 Nick, AltNick, Nome, Mail, Servidor, ProxyServer: string;
 UseProxy: Boolean;
 ServPorta, ProxyPorta: Integer;
 RecList: TStringList;
 
implementation

uses Unit2, Rotinas;

{$R *.DFM}

procedure TForm1.Sair1Click(Sender: TObject);
begin
 Close;
end;

procedure TForm1.FormResize(Sender: TObject);
begin
 Edit1.Width := RichEdit1.Width + ListBox1.Width - 130;
end;

procedure TForm1.Conectar1Click(Sender: TObject);
begin
 FrmConect.ShowModal;
end;

procedure TForm1.Desconectar1Click(Sender: TObject);
begin
 ClientSocket.Close;
end;

procedure TForm1.Join1Click(Sender: TObject);
begin
 MandaTexto('JOIN ' + '#' + ComboBox1.Text);
end;

procedure TForm1.Quit1Click(Sender: TObject);
begin
 //QUIT : 1Fui +#15#10
 ClientSocket.Socket.SendText('QUIT :' + 'Fui' + #15#10);
end;

procedure TForm1.ClientSocketConnect(Sender: TObject;
 Socket: TCustomWinSocket);
begin
 //'CONNECT flanders.be.eu.undernet.org:6664 HTTP/1.0' + #13#10#13#10
 //Se estiver usando Proxy manda comando de conexão com o servidor IRC
 if UseProxy then
  ClientSocket.Socket.SendText(
   'CONNECT ' + Servidor + ':' + IntToStr(ServPorta) + ' HTTP/1.0' + #13#10#13#10);
 
 Caption := 'Cliente IRC' + ' - [Conectado]';
end;

procedure TForm1.ClientSocketDisconnect(Sender: TObject;
 Socket: TCustomWinSocket);
begin
 Caption := 'Cliente IRC' + ' - [Desconectado]';
end;

procedure TForm1.ClientSocketRead(Sender: TObject;
 Socket: TCustomWinSocket);
var
 RecText, RPing, RecNick, RecMsg, RecDestino, Comando, TempStr: string;
 P, X, ID: Integer;
 Breaked, ProxyOK: Boolean;
begin
 RecText := Socket.ReceiveText;
 RichEdit1.Lines.Add(RecText);
 
 //Coloca na StringList, isso evita erros se receber linhas juntas
 RecList.Text := RecText;
 
 //Verifica linha por linha na RecList
 if RecList.Count > 0 then
  for X := 0 to RecList.Count - 1 do
   begin
    { Verifica se a linha esta vazia }
    if RecList[X] <> '' then
     RecText := RecList[X]
    else
     Continue;

    ProxyOK := False;
    if UseProxy then
     //Servidor Proxy aceitou a conexao
     if Pos('HTTP', AnsiUpperCase(RecText)) = 1 then
      begin
       ProxyOK := True;
       RichEdit1.Lines.Add('-->Conectado ao Proxy');
      end;

    if (Pos('NOTICE AUTH', RecText) > 0) then
     begin
      //Pedido de identificação
      if (Pos('checking ident', AnsiLowerCase(RecText)) > 0) then
       begin
        SetNick(Nick);
        SetUsuario(Mail, Socket.RemoteAddress, Nome);
       end;

      if (Pos('looking up your hostname', AnsiLowerCase(RecText)) > 0) then
       Caption := 'Cliente IRC' + ' - [Conectado]-' + Nick;
     end;

    //Se contem mais de 1 palavra
    Breaked := False;
    if Pos(' ', RecText) > 0 then
     Breaked := True;

    {** Pega ID(Numero identificador das mensagen) **}
    ID := 0;
    if Breaked then
     begin
      TempStr := CopyPalav(RecText, 2);
      if (Length(TempStr) = 3) then
       if (isInteger(TempStr)) then
        begin
         ID := StrToInt(TempStr);
        end;
     end;

    {** Se o nick ja estiver em uso **}
    //:Unisys.RJ.BRASnet.org 433 * Prodigy_- :Nickname is already in use.
    if ID = 433 then
     begin
      Nick := AltNick;
      //Se jah estiver com Nick Alternativo
      if CopyPalav(RecText, 4) = AltNick then
       Nick := Nick + IntToStr(Random(1000));

      SetNick(Nick);
     end;

    //Atualiza nick, se for mudado
    //:Nick!~me@ztMJaCfIApI.cable.cpunet.com.br NICK :Guest4408
    if (Pos('NICK :', RecText) > 0) then
     begin
      TempStr := Copy(RecText, Pos(':' + Nick + '!', RecText), Length(RecText));
      RecNick := Copy(TempStr, Pos('NICK :', TempStr) + 6, Length(TempStr));
      Nick := RecNick;
      RichEdit1.Lines.Add('-->Nick mudado: ' + Nick);
     end;

    //Responde pings
    if Pos('PING :', RecText) > 0 then
     begin
      P := Pos(':', RecText);
      RPing := Copy(RecText, P + 1, Length(RecText) - P);
      MandaTexto('PONG ' + RPing);
      RichEdit1.Lines.Add('-->Ping? Pong! ' + RPing);
     end;

   end; //Fim for X := 0 to RecList.Count -1 do
end;

procedure TForm1.Edit1KeyDown(Sender: TObject; var Key: Word;
 Shift: TShiftState);
var
 Canal: string;
begin
 if (Edit1.Text) <> '' then
  if Key = VK_Return then
   if Edit1.Text[1] <> '/' then
    begin
     Canal := ComboBox1.Text;
     MandaPrivMsg('#' + Canal, Edit1.Text);
     Edit1.Clear;
    end
   else
    begin
     MandaTexto(Copy(Edit1.Text, 2, Length(Edit1.Text) - 1));
     Edit1.Clear;
    end;
 
end;

procedure TForm1.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
 if Key = #13 then //Tira o som da tecla Enter
  Key := #0;
end;

procedure TForm1.Part1Click(Sender: TObject);
begin
 MandaTexto('PART ' + '#' + ComboBox1.Text);
end;

procedure TForm1.ClientSocketConnecting(Sender: TObject;
 Socket: TCustomWinSocket);
begin
 RichEdit1.Lines.Add('Conectando a ' + ClientSocket.Host + ' ...');
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

end.

