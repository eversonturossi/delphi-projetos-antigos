{**************************************************}
{            IRC-DOS 1.0 Alfa                      }
{ Fontes por:                                      }
{         Glauber A. Dantas (Prodigy) - 01/10/2003 }
{  [ #DelphiX ] Brasnet - irc.brasnet.org          }
{  [ www.delphix.com.br ] glauber@delphix.com.br   }
{                                                  }
{**************************************************}

unit Center;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, ScktComp, Menus, vortex, ClusterChat;

type
  TFrmCenter = class(TForm)
    PanelTool: TPanel;
    ComboFonte: TComboBox;
    Speed_Marcar: TSpeedButton;
    Speed_Copiar: TSpeedButton;
    Speed_Colar: TSpeedButton;
    Speed_Tela: TSpeedButton;
    Speed_Propriedades: TSpeedButton;
    Speed_SegPlano: TSpeedButton;
    Speed_Fonte: TSpeedButton;
    PopupMenu1: TPopupMenu;
    Conectar1: TMenuItem;
    Desconectar1: TMenuItem;
    Informcoes: TMenuItem;
    Opes1: TMenuItem;
    N1: TMenuItem;
    Sair1: TMenuItem;
    Join1: TMenuItem;
    Part1: TMenuItem;
    Notice1: TMenuItem;
    Quit1: TMenuItem;
    DefinirDestino1: TMenuItem;
    Memo1: TMemo;
    Servidor1: TMenuItem;
    SalvarLog1: TMenuItem;
    Vortex: TVortex;
    ClusterChat1: TClusterChat;
    SaveDialog: TSaveDialog;
    MemoDos: TMemo;
    Menu1: TMenuItem;
    Sobre1: TMenuItem;
    PaneEdit: TPanel;
    EdtMsg: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure Conectar1Click(Sender: TObject);
    procedure Desconectar1Click(Sender: TObject);
    procedure InformcoesClick(Sender: TObject);
    procedure DefinirDestino1Click(Sender: TObject);
    procedure Join1Click(Sender: TObject);
    procedure Part1Click(Sender: TObject);
    procedure Quit1Click(Sender: TObject);
    procedure Speed_MarcarClick(Sender: TObject);
    procedure Servidor1Click(Sender: TObject);
    procedure Sair1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure VortexAfterJoined(Sender: TObject; Channelname: String);
    procedure VortexAfterKicked(Sender: TObject; Nickname, ChannelName,
      Reason: String);
    procedure VortexAfterNickChanged(Sender: TObject; Oldnick,
      Newnick: String);
    procedure VortexAfterParted(Sender: TObject; Channelname: String);
    procedure VortexAfterPrivateMessage(Sender: TObject; Nickname, Ident,
      Mask, Content: String);
    function VortexBeforeConnect(Sender: TObject; Ircserver,
      Ircport: String): Boolean;
    procedure VortexIRCList(Sender: TObject; ChannelName, Topic: String;
      Users: Integer; EndOfList: Boolean);
    procedure VortexIRCNames(Sender: TObject; Commanicks,
      ChannelName: String; endofnames: Boolean);
    procedure VortexIRCNickInUse(Sender: TObject; Nickname: String);
    procedure VortexIRCNoSuchNickChannel(Sender: TObject; Value: String);
    procedure VortexIRCNotify(Sender: TObject; NotifyUsers: String);
    procedure VortexIRCWho(Sender: TObject; ChannelName, Nickname,
      Username, Hostname, Name, Servername, status, other: String;
      EndOfWho: Boolean);
    procedure VortexIRCWhois(Sender: TObject; Info: String;
      EndOfWhois: Boolean);
    procedure VortexServerError(ErrorString: String);
    procedure VortexServerQuote(Command: String);
    procedure VortexUserCtcp(Sender: TObject; Nickname, Command,
      Destination: String);
    procedure VortexUserInvite(Sender: TObject; NickName,
      ChannelName: String);
    procedure VortexUserJoin(Sender: TObject; Nickname, Hostname,
      ChannelName: String);
    procedure VortexUserKick(Sender: TObject; KickedUser, Kicker,
      ChannelName, Reason: String);
    procedure VortexUserNickChange(Sender: TObject; Oldnick,
      Newnick: String);
    procedure VortexUserPart(Sender: TObject; Nickname, Hostname,
      Channelname, Reason: String);
    procedure VortexUserQuit(Sender: TObject; Nickname, Reason: String);
    procedure VortexUserTopic(Sender: TObject; ChannelName, Nickname,
      Topic: String);
    procedure VortexSocketAuth;
    procedure VortexSocketBgException(Sender: TObject; E: Exception;
      var CanClose: Boolean);
    procedure VortexSocketConnect(Sender: TObject);
    procedure VortexSocketDisconnect(Sender: TObject);
    procedure VortexSocketError(Sender: TObject; Error: Word);
    procedure VortexMessagePrivate(Sender: TObject; Nickname, Ident, Mask,
      Content: String);
    procedure VortexMessageNotice(Sender: TObject; NickName,
      Content: String);
    procedure VortexMessageChannel(Sender: TObject; Channelname, Content,
      Nickname, Ident, Mask: String);
    procedure VortexMessageAction(Sender: TObject; NickName, Content,
      Destination: String);
    procedure VortexIRCMotd(Sender: TObject; Line: String;
      EndOfMotd: Boolean);
    procedure VortexIRCMode(Sender: TObject; Nickname, Destination, Mode,
      Parameter: String);
    procedure VortexAfterServerPing(Sender: TObject);
    procedure SalvarLog1Click(Sender: TObject);
    procedure MemoDosKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure MemoDosClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Sobre1Click(Sender: TObject);
    procedure EdtMsgKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EdtMsgKeyPress(Sender: TObject; var Key: Char);
    procedure Memo1Click(Sender: TObject);
  private
    { Private declarations }
    CopiandoNicks, CancelListing : Boolean;
    procedure Conectar;
    procedure AddLine(ATexto: String);
    procedure Echo(ATexto: String);
    procedure EchoChan(ACanal, ATexto: String; ShowEcho: Boolean = False);
    procedure MandaLista(Destino: String; Lista: TStrings; CharsStep, SleepTime: Integer);
  public
    { Public declarations }
  end;

var
  FrmCenter: TFrmCenter;
  TempList, MsgList : TStringList;
  ListaId: Integer;
  Nick, Nick2, NickPass, Nome, Ident, Serv, Porta, Destino : String;

const
  CRLF = #13#10;
  STR_VERSAO = '1.0a';

implementation

uses Rotinas, U_Info, U_List;

{$R *.DFM}

procedure TFrmCenter.FormCreate(Sender: TObject);
begin
{  Memo1.Font.Handle := GetStockObject(OEM_FIXED_FONT);
  Memo2.Font.Handle := GetStockObject(OEM_FIXED_FONT);}
  MemoDos.Font.Handle := GetStockObject(OEM_FIXED_FONT);

  FrmCenter.Icon := Application.Icon;
  Application.Title := FrmCenter.Caption;
  SaveDialog.InitialDir := ExtractFilePath(ParamStr(0));
  MemoDos.Text := GetWindowsDir +'>';

  TempList := TStringList.Create;
  MsgList  := TStringList.Create;
  CopiandoNicks := False;
  CancelListing := False;
  ListaId := 0;
  
  LoadOptions;
end;

procedure TFrmCenter.Conectar;
begin
   if Vortex.IsConnected then
   Vortex.Disconnect(True);

   Vortex.Server(Serv, Porta);
   Vortex.connect;
end;

procedure TFrmCenter.AddLine(ATexto: String);
begin
  Memo1.Lines.Add(ATexto);
end;

procedure TFrmCenter.MandaLista(Destino: String; Lista: TStrings; CharsStep,
  SleepTime: Integer);
var
  Len, X, I, LIndex, Msgs : Integer;//verificar nº de Msgs
begin
   Len := 0;
   LIndex := 0;
   Msgs := 0;
   
   TempList.Text := Lista.Text;
   Lista.Clear;

   if TempList.Count > 0 then
   for X := 0 to TempList.Count -1 do
   begin
     Inc(Len, Length(TempList[X]));
     if Len > CharsStep then
     begin
       for I := LIndex to X-1 do
       begin
         if Lista[I] <> '' then
          Vortex.Say(Destino,TempList[I]);
         Sleep(1000);//a cada Msg

         Application.ProcessMessages;////
         if CancelListing then
         begin
          CancelListing := False;
          Exit;
         end;

         Inc(Msgs);
         if Msgs = 10 then
         begin
          Sleep(SleepTime);//a cada 10 msgs
          Msgs := 0;
         end;
       end;

       Application.ProcessMessages;
       if not Vortex.IsConnected then
         Exit;
       if CancelListing then
       begin
         CancelListing := False;
         Exit;
       end;

       LIndex := X;
       Len := 0;
       Msgs := 0;
       Sleep(SleepTime);//a cada X nº de caracteres
     end
     else
     if X = TempList.Count -1 then
     begin
         for I := LIndex to X do
         begin
           if TempList[I] <> '' then
            Vortex.Say(Destino,TempList[I]);
           Sleep(1000);//a cada Msg

           Application.ProcessMessages;
           if CancelListing then
           begin
             CancelListing := False;
             Exit;
           end;

           Inc(Msgs);
           if Msgs = 10 then
           begin
            Sleep(SleepTime);//a cada 10 msgs
            Msgs := 0;
           end;
         end;
         Exit;
       end;
   end;
end;

{------------------ Fim funções -----------------------------------------------}

procedure TFrmCenter.Conectar1Click(Sender: TObject);
begin
  Conectar;
end;

procedure TFrmCenter.Desconectar1Click(Sender: TObject);
begin
  Vortex.Disconnect(True);
end;

procedure TFrmCenter.InformcoesClick(Sender: TObject);
var
 S  : String;
begin
  if InputQuery('Definir Nick', 'Digite seu Nick:', S) then
   Nick  := S;
  if InputQuery('Definir Senha do Nick', 'Digite sua Senha:', S) then
   NickPass  := S;
  if InputQuery('Definir Nick2', 'Digite seu Nick Alternativo:', S) then
   Nick2 := S;
  if InputQuery('Definir Nome', 'Digite seu Nome:', S) then
   Nome  := S;
end;

procedure TFrmCenter.DefinirDestino1Click(Sender: TObject);
var
 S : String;
begin
  if InputQuery('Definir Destino', 'Digite o Destino das Msgs:', S) then
  begin
   Destino := S;
   FrmInfo.EdtDestino.Text := Destino;
  end;
end;

procedure TFrmCenter.Join1Click(Sender: TObject);
var
 S : String;
begin
  if InputQuery('Entrar em um canal', 'Canal:', S) then
  if S[1] <> '#' then
   S := '#'+ S;

  Vortex.Join(S);
end;

procedure TFrmCenter.Part1Click(Sender: TObject);
var
 S : String;
begin
  if InputQuery('Sair do canal', 'Canal:', S) then
  if S[1] <> '#' then
   S := '#'+ S;
  Vortex.Part(S);
end;

procedure TFrmCenter.Quit1Click(Sender: TObject);
var
 S : String;
begin
  if InputQuery('Sair do servidor', 'Mensagem de saida:', S) then
    Vortex.Quit(S);
end;

procedure TFrmCenter.Speed_MarcarClick(Sender: TObject);
begin
  AddLine('Teste');
end;

procedure TFrmCenter.Servidor1Click(Sender: TObject);
var
 S, TempStr: String;
begin
  if InputQuery('Definir Servidor', 'Digite ex.: servidor:porta', S) then
  begin
    S := AnsiLowerCase(S);
    //Se definiu a Porta
    if Pos(':', S) > 0 then
    begin
     TempStr := Copy(S, Pos(':',S)+1, Length(S));
     if IsInteger(TempStr) then
      Porta := TempStr;
     S := Copy(S,1, Pos(':',S)-1); //Deleta porta
    end
    else
     Porta := '6667';
     
    //Servidor
    Serv := S;
  end;
end;

procedure TFrmCenter.Sair1Click(Sender: TObject);
begin
  Close;
end;

procedure TFrmCenter.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  SaveOptions;
  TempList.Free;
  MsgList.Free;
end;

procedure TFrmCenter.VortexAfterJoined(Sender: TObject;
  Channelname: String);
begin
  AddLine(STR_ECHO +' Agora falando em: '+ ChannelName);
  Destino := ChannelName;
  FrmInfo.EdtDestino.Text := Destino;
  Echo('Destino = '+ Destino);
end;

procedure TFrmCenter.VortexAfterKicked(Sender: TObject; Nickname,
  ChannelName, Reason: String);
begin
  EchoChan(ChannelName, ' vc foi expulso por '+ Nickname +' [' +Reason+ ']', True);
end;

procedure TFrmCenter.Echo(ATexto: String);
begin
  AddLine(STR_ECHO +' '+ ATexto);
end;

procedure TFrmCenter.EchoChan(ACanal, ATexto: String; ShowEcho: Boolean = False);
begin
  if ShowEcho then
    Echo('['+ ACanal +'] '+ ATexto)
  else
    AddLine('['+ ACanal +'] '+ ATexto); 
end;

procedure TFrmCenter.VortexAfterNickChanged(Sender: TObject; Oldnick,
  Newnick: String);
begin
  Echo('Seu nick [( '+ Oldnick +' ) -> ( '+ Newnick +' )]');
  Nick := Newnick;
  FrmInfo.EdtUser.Text := Nick;
end;

procedure TFrmCenter.VortexAfterParted(Sender: TObject;
  Channelname: String);
begin
  Echo('Você saiu do '+ Channelname);
end;

procedure TFrmCenter.VortexAfterPrivateMessage(Sender: TObject; Nickname,
  Ident, Mask, Content: String);
begin
  Echo('AfterPrivateMessage'+ Nickname+ Ident+Mask+Content);
end;

function TFrmCenter.VortexBeforeConnect(Sender: TObject; Ircserver,
  Ircport: String): Boolean;
begin
  Echo('Conectando em '+ Ircserver +':'+ Ircport +'...');
end;

procedure TFrmCenter.VortexIRCList(Sender: TObject; ChannelName,
  Topic: String; Users: Integer; EndOfList: Boolean);
begin
  Echo('IRCList '+ ChannelName+' '+Topic+' '+IntToStr(Users)+' '+IntToStr(Integer(EndOfList)));
end;

procedure TFrmCenter.VortexIRCNames(Sender: TObject; Commanicks,
  ChannelName: String; EndOfNames: Boolean);
begin
  if not CopiandoNicks then
  begin
   FrmList.LBNicks.Clear;
   FrmList.LBNicks.Items.Add(ChannelName);
  end;

  if not EndOfNames then
  begin
    CopiandoNicks := True;
    FrmList.LBNicks.Items.CommaText := FrmList.LBNicks.Items.CommaText +','+ Commanicks;
    AddLine(ChannelName+' ,'+Commanicks)
  end
  else
  begin
    AddLine(ChannelName +' End of Names list');
    CopiandoNicks := False;
  end;
end;

procedure TFrmCenter.VortexIRCNickInUse(Sender: TObject; Nickname: String);
begin
  Echo('Nick já está em uso ['+ Nickname +']');
end;

procedure TFrmCenter.VortexIRCNoSuchNickChannel(Sender: TObject;
  Value: String);
begin
  Echo('Nick ou canal não identificado ['+ Value +']');
end;

procedure TFrmCenter.VortexIRCNotify(Sender: TObject; NotifyUsers: String);
begin
  Echo('IRCNotify '+ NotifyUsers);
end;

procedure TFrmCenter.VortexIRCWho(Sender: TObject; ChannelName, Nickname,
  Username, Hostname, Name, Servername, status, other: String;
  EndOfWho: Boolean);
begin
  if not EndOfWho then
  begin
    FrmList.LBNicks.Items.Add(Nickname);
    AddLine(ChannelName +' '+Nickname +' '+Username+' '+Hostname+' '+' '+
      Servername+' '+ status +' '+ Name +' '+ other)
  end
  else
  begin
    AddLine(ChannelName +' End of /WHO list');
    FrmList.LBNicks.Items.Insert(0, ChannelName);
  end;

end;

procedure TFrmCenter.VortexIRCWhois(Sender: TObject; Info: String;
  EndOfWhois: Boolean);
begin
  with Memo1.Lines do
  begin
    Add(Info);
    if EndOfWhois then
     Add('Fim do /Whois');
  end;
end;

procedure TFrmCenter.VortexServerError(ErrorString: String);
begin
  Echo('ServerError '+ ErrorString);
end;

procedure TFrmCenter.VortexServerQuote(Command: String);
begin
  //Echo('ServerQuote '+ Command);
end;

procedure TFrmCenter.VortexUserCtcp(Sender: TObject; Nickname, Command,
  Destination: String);
begin
  Echo('UserCtcp '+ Nickname +' '+ Command +' '+Destination);
end;

procedure TFrmCenter.VortexUserInvite(Sender: TObject; NickName,
  ChannelName: String);
begin
  Echo('Você foi convidado para o canal '+ ChannelName +' por '+ NickName);
end;

procedure TFrmCenter.VortexUserJoin(Sender: TObject; Nickname, Hostname,
  ChannelName: String);
begin
  EchoChan(ChannelName, 'Entrou: '+ Nickname +' ['+ Hostname +']', True);
  with FrmList.LBNicks do
  begin
    Items.Add(Nickname);
    Sorted := True;
  end;
end;

procedure TFrmCenter.VortexUserKick(Sender: TObject; KickedUser, Kicker,
  ChannelName, Reason: String);
begin
  EchoChan(ChannelName, KickedUser +' foi expulso por '+ Kicker +'['+ Reason +']', True);
  with FrmList.LBNicks do
  begin
    Items.Delete(Items.IndexOf(KickedUser));
    Sorted := True;
  end;  
end;

procedure TFrmCenter.VortexUserNickChange(Sender: TObject; Oldnick,
  Newnick: String);
begin
  Echo('Mudança de apelido [( '+ Oldnick +' ) -> ( '+ Newnick+ ' )]');
  with FrmList.LBNicks do
  begin
    Items.Delete(Items.IndexOf(Oldnick));
    Items.Add(Newnick);
    Sorted := True;
  end;
  if Oldnick = Destino then
  begin
    Destino := Newnick;
    FrmInfo.EdtDestino.Text := Destino;
  end;
end;

procedure TFrmCenter.VortexUserPart(Sender: TObject; Nickname, Hostname,
  Channelname, Reason: String);
begin
  EchoChan(Channelname, 'Saiu: '+ Nickname +' ['+ Hostname+ '] '+ Reason, True);
  with FrmList.LBNicks do
  begin
    Items.Delete(Items.IndexOf(Nickname));
    Sorted := True;
  end;
end;

procedure TFrmCenter.VortexUserQuit(Sender: TObject; Nickname,
  Reason: String);
begin
  Echo(Nickname +' se foi: ['+ Reason +']');
  with FrmList.LBNicks do
  begin
    Items.Delete(Items.IndexOf(Nickname));
    Sorted := True;
  end;  
end;

procedure TFrmCenter.VortexUserTopic(Sender: TObject; ChannelName,
  Nickname, Topic: String);
var
 S : String;
begin
  if Nickname = '' then
   S := ' Tópico: '
  else
   S := Nickname + ' mudou o Tópico para: ';
  EchoChan(ChannelName, S + Topic);
end;

procedure TFrmCenter.VortexSocketAuth;
begin
  Echo('SocketAuth');
end;

procedure TFrmCenter.VortexSocketBgException(Sender: TObject; E: Exception;
  var CanClose: Boolean);
begin
  Echo('SocketBgException');
end;

procedure TFrmCenter.VortexSocketConnect(Sender: TObject);
begin
  Echo('Conectado');
end;

procedure TFrmCenter.VortexSocketDisconnect(Sender: TObject);
begin
  Echo('Desconectado.');
end;

procedure TFrmCenter.VortexSocketError(Sender: TObject; Error: Word);
begin
  Echo('Erro '+ IntToStr(Error));
end;

procedure TFrmCenter.VortexMessagePrivate(Sender: TObject; Nickname, Ident,
  Mask, Content: String);
begin
  AddLine('[PVT] <'+ Nickname +'> '+ Content);
  if Destino = '' then
  begin
   Destino := Nickname;
   FrmInfo.EdtDestino.Text := Destino;
  end;
end;

procedure TFrmCenter.VortexMessageNotice(Sender: TObject; NickName,
  Content: String);
begin
  AddLine('-'+ NickName +'- '+ Content);
   if (Pos('registrado e protegido', AnsiLowerCase(Content)) > 0) or
      (Pos('nick foi registrado', AnsiLowerCase(Content)) > 0) then
   if AnsiLowerCase(NickName) = AnsiLowerCase('NickServ') then
   if NickPass <> '' then
     Vortex.Quote('NickServ Identify '+ NickPass);
end;

procedure TFrmCenter.VortexMessageChannel(Sender: TObject; Channelname,
  Content, Nickname, Ident, Mask: String);
begin
  EchoChan(Channelname, '<'+ Nickname +'> '+ Content);
end;

procedure TFrmCenter.VortexMessageAction(Sender: TObject; NickName,
  Content, Destination: String);
begin
  AddLine('* '+Destination +' '+ NickName +' '+ Content);
end;

procedure TFrmCenter.VortexIRCMotd(Sender: TObject; Line: String;
  EndOfMotd: Boolean);
begin
  AddLine(Line);
  if (EndOfMotd) and (Line = '') then
   AddLine('Fim do /Motd.');
end;

procedure TFrmCenter.VortexIRCMode(Sender: TObject; Nickname, Destination,
  Mode, Parameter: String);
begin
  Echo(Nickname +' define modo: '+ Mode +' '+Parameter+' '+Destination)
end;

procedure TFrmCenter.VortexAfterServerPing(Sender: TObject);
begin
  AddLine('Ping? Pong!');
end;

procedure TFrmCenter.SalvarLog1Click(Sender: TObject);
begin
  if SaveDialog.Execute then
   Memo1.Lines.SaveToFile(SaveDialog.FileName);
end;

procedure TFrmCenter.MemoDosKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  S, SPrompt, SCmd : String;
  P : Integer;
  label AddPrompt;
begin
  if Key = VK_RETURN then
  begin
    S := MemoDos.Lines[MemoDos.CaretPos.y];//Linha atual
    if Pos(GetWindowsDir +'>', S) >0  then
    begin
     P := Pos('>', S);
     SPrompt := Copy(S, 1, P-1);
     SCmd := Copy(S, P+1, Length(S));
     if SCmd <> '' then
      CaptureConsoleOutput(SCmd, SPrompt, MemoDos)
     else
      goto AddPrompt;
    end
    else
    begin
      AddPrompt:
      MemoDos.Lines.Add(GetWindowsDir +'>');
      if MemoDos.Lines[MemoDos.Lines.Count] ='' then
        MemoDos.Lines.Delete(MemoDos.Lines.Count);
      keybd_event(VK_BACK,1,0,0);
      MemoDos.SelStart := Length(MemoDos.Text);
    end;
  end;
  
  if (ssAlt in Shift) and (Key = Ord('D')) then
  begin
    MemoDos.Visible := False;
    PaneEdit.Visible := True;
  end;
end;

procedure TFrmCenter.MemoDosClick(Sender: TObject);
begin
  MemoDos.Cursor   := crDefault;
  MemoDos.SelStart := Length(MemoDos.Text);
end;

procedure TFrmCenter.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (ssAlt in Shift) and (Key = Ord('I')) then
  with FrmInfo do
  begin
    EdtDestino.Text := Destino;
    EdtUser.Text    := Nick;
    EdtPass.Text    := NickPass;
    ShowModal;
  end;
  if (ssAlt in Shift) and (Key = Ord('L')) then
    FrmList.ShowModal;
  if (ssAlt in Shift) and (Key = Ord('D')) then
  begin
    MemoDos.Text := GetWindowsDir +'>';
    MemoDos.Visible := True;
    MemoDos.SelStart := Length(MemoDos.Text);
    MemoDos.SetFocus;
    PaneEdit.Visible := False;
  end;
end;

procedure TFrmCenter.Sobre1Click(Sender: TObject);
begin
  ShowMessage('IRC-DOS 1.0a por Glauber Almeida Dantas'+#13+
   'www.delphix.com.br');
end;

procedure TFrmCenter.EdtMsgKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  Texto, STexto, LowTexto, Comando, LowComando, S : String;
begin
  FrmCenter.OnKeyDown(Sender, Key, Shift);
  Texto  := EdtMsg.Text;
  STexto := Texto;

  if Texto <> '' then
  if Key = VK_RETURN then
  begin
    EdtMsg.Clear;
    if Texto[1] <> '/' then
    begin
      Vortex.Say(Destino, Texto);
      AddLine('[MSG] ['+ Destino +']<'+ Nick +'> '+ Texto);
    end
    else
    begin
      Texto      := Copy(Texto, 2, Length(Texto)-1);
      LowTexto   := AnsiLowerCase(Texto);
      Comando    := CopyPalav(Texto,1);
      LowComando := AnsiLowerCase(Comando);

      if LowComando = 'server' then
      begin
        //Se definiu a Porta
        if Pos(':', Texto) > 0 then
        begin
          S := Trim(Copy(LowTexto, Pos(':',LowTexto)+1, Length(LowTexto)));
          if IsInteger(S) then
           Porta := S;
          LowTexto := Copy(LowTexto,1, Pos(':',LowTexto)-1); //Deleta porta
        end
        else
          Porta := '6667';

        //Servidor
        Serv := Trim(CopyPalav(LowTexto,2));
        Application.ProcessMessages;
        if Serv <> '' then
          Conectar;
      end
      else
      if (LowComando = 'join') or (LowComando = 'j') then
      begin
        S := CopyPalav(Texto,2);
        if S[1] <> '#' then
          S := '#'+ S;
        Vortex.Join(S, CopyPalav(Texto,3));
      end
      else
      if LowComando = 'part' then
      begin
        S := CopyPalav(Texto,2);
        if S[1] <> '#' then
          S := '#'+ S;
        Vortex.Part(CopyPalav(Texto,2), CopyPalav(Texto,3));
      end
      else
      if LowComando = 'motd' then
       Vortex.Quote('MOTD')
      else
      if LowComando = 'motd' then
       Vortex.Quote('MOTD')
      else
      if LowComando = 'nick' then
       Vortex.Nick(CopyPalav(Texto,2))
      else
      if Trim(LowComando) = 'disconnect' then
       Vortex.Disconnect(True, 'Fui')
      else
      if LowComando = 'quit' then
      begin
        Delete(Texto,1, Pos(' ', Texto));
        Vortex.Quit(Copy(Texto,Pos(' ', Texto)+1, Length(Texto)));
      end
      else
      if LowComando = 'msg' then
      begin
        Delete(Texto,1, Pos(' ', Texto));
        Vortex.Say(CopyPalav(Texto,1), Copy(Texto,Pos(' ', Texto)+1, Length(Texto)));
      end
      else
      if LowComando = 'me' then
      begin
        {Delete(Texto,1, Pos(' ', Texto));
        Vortex.Action(CopyPalav(Texto,1), Copy(Texto,Pos(' ', Texto)+1, Length(Texto)));
        }
      end
      else
      if LowComando = 'destino' then
      begin
        Destino := CopyPalav(Texto,2);
        FrmInfo.EdtDestino.Text := Trim(Destino);
        Echo('Destino = '+ Destino);
      end
      else
      if LowComando = 'senha' then
      begin
        NickPass := CopyPalav(Texto,2);
        FrmInfo.EdtPass.Text := NickPass;
      end
      else
       Vortex.Quote(Texto);
    end;

    UpdateMsgList(STexto);
  end;

  if MsgList.Count > 0 then
  begin
    if Key = VK_UP then
    begin
      if ListaId > 0 then
       Dec(ListaId);
      EdtMsg.Text := MsgList[ListaId];
    end;

    if Key = VK_DOWN then
    begin
      if (ListaId < 20) and (ListaId+1 <> MsgList.Count) then
       Inc(ListaId);
      EdtMsg.Text := MsgList[ListaId];
    end;
  end;
end;

procedure TFrmCenter.EdtMsgKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
   Key := #0;
end;

procedure TFrmCenter.Memo1Click(Sender: TObject);
begin
  EdtMsg.SetFocus;
end;

end.
