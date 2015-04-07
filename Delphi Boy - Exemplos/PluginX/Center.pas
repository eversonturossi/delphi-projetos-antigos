{*************************************************}
{  Servidor com suporte a Plugins                 }
{  usando biblioteca PluginX 1.1 beta             }
{  Glauber A. Dantas - glauber@delphix.com.br     }
{*************************************************}

unit Center;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ScktComp, PluginX, ExtCtrls;

type
  TBuscaClient = (byNick, byThread, byIndex);

type
  TFrmCenter = class(TForm)
    ServerSocket1: TServerSocket;
    Label1: TLabel;
    Edit1: TEdit;
    Button1: TButton;
    Button2: TButton;
    GroupBox1: TGroupBox;
    Memo1: TMemo;
    Button3: TButton;
    ListBox1: TListBox;
    Label2: TLabel;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ServerSocket1ClientConnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ServerSocket1ClientDisconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ServerSocket1Listen(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ServerSocket1ClientRead(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }

    copydata: TCopyDataStruct;
    Client: TClient;
    RecInfo : TClientInfo;
    
    //Captura mensagem WM_COPYDATA recebida
    procedure WMCopyData(var msg: TWMCopyData); message WM_COPYDATA;
  public
    { Public declarations }

    //Para enviar texto para todos clientes
    procedure SendTextBroadcast(AText: String);
    //Procura cliente pela informação do TClientInfo
    function ClientByInfo(var AClientInfo: TClientInfo; TipoBusca: TBuscaClient): TClient;
    //Procura Plugin pelo Handle
    function PPluginByHandle(PHandle: THandle): PPlugin;
  end;

var
  FrmCenter: TFrmCenter;
  ClientList: TList;//Lista de clientes conectados

implementation

uses Plugins;

{$R *.dfm}

{ TForm1 }

procedure TFrmCenter.WMCopyData(var msg: TWMCopyData);
var
  OK : Boolean;
  Socket: TCustomWinSocket;
begin
  // reply to the message so the clients thread is unblocked
  //ReplyMessage(0);

  Client := nil;
  OK := True;

  { msg.From é o handle de quem esta enviando a mensagem WM_COPYDATA com
    SendMessage }
  //if msg.From = Um_Handle_de_dll_carregada then
  begin
      //verifica identificador da mensagem recebida
      case msg.CopyDataStruct^.dwData of
      
        //manda texto para todos clientes
        APP_BROADCAST_WRITE :
          begin
            // Trata parametro lpData como PChar
            SendTextBroadcast(PChar(msg.CopyDataStruct^.lpData));
          end;

        //manda texto para um cliente
        APP_CLIENT_WRITE :
            try
             //Trata parametro lpData como TClientInfo
             RecInfo := TClientInfo(msg.CopyDataStruct^.lpData^);

             if ClientByInfo(RecInfo, byNick) <> nil then
              Client := ClientByInfo(RecInfo, byNick) //procura cliente pelo Nick
             else
              Client := ClientByInfo(RecInfo, byThread); //procura cliente pelo Thread

              if Client <> nil then
              begin
                Socket := TCustomWinSocket(Pointer(Client.ClientInfo.cThread));
                if Socket <> nil then
                 Socket.SendText(RecInfo.cInfo2);
              end
              else
                Ok := False;
                
             except
               OK := False;
             end;

        //fecha conexão de um cliente
        APP_CLIENT_CLOSE :
            try
             RecInfo := TClientInfo(msg.CopyDataStruct^.lpData^);

             if ClientByInfo(RecInfo, byNick) <> nil then
              Client := ClientByInfo(RecInfo, byNick) //procura cliente pelo Nick
             else
              Client := ClientByInfo(RecInfo, byThread); //procura cliente pelo Thread

              if Client <> nil then
                TCustomWinSocket(Pointer(Client.ClientInfo.cThread)).Close
              else
                Ok := False;

             except
               OK := False;
             end;

        //manda dados do Cliente para o plugin
        APP_CLIENT_GETCLIENT :
          begin
             RecInfo := TClientInfo(msg.CopyDataStruct^.lpData^);

             if ClientByInfo(RecInfo, byNick) <> nil then
              Client := ClientByInfo(RecInfo, byNick) //procura cliente pelo Nick
             else
              Client := ClientByInfo(RecInfo, byThread); //procura cliente pelo Thread

              if Client <> nil then
              if PPluginByHandle(msg.From) <> nil then
               with PPluginByHandle(msg.From)^ do
               if @FSendClientToPlug <> nil then
               begin
                 FSendClientToPlug(Handle, Client, False);
               end
               else
                OK := False;
          end;
      end;

     { Se houve algum erro ou o cliente não foi encontrado,
       executa função de Erro na DLL e/ou responde com MSG_ERROR
       para a aplicação que mandou a mensagem }
     if not OK then
     begin
       //FFuncaoErro;
      { copydata.lpData := @VarStringErr[123];
        copydata.cbData := Length(VarStringErr);
        copydata.dwData := MSG_ERROR;
        SendMessage(msg.From, WM_COPYDATA, Handle, Integer(@copydata)); }
     end;

    //Marca a menssagem como processada
    msg.Result := 1;
  end;
end;

procedure TFrmCenter.SendTextBroadcast(AText: String);
var
 X : Integer;
begin
  for X := 0 to ServerSocket1.Socket.ActiveConnections -1 do
   ServerSocket1.Socket.Connections[X].SendText(AText);
end;

function TFrmCenter.ClientByInfo(var AClientInfo: TClientInfo;
  TipoBusca: TBuscaClient): TClient;
var
 X : Integer;
begin
   Result := nil;

   case TipoBusca of
      byIndex          :
           Result := TClient(ClientList.Items[AClientInfo.cID]);
      byNick, byThread :
          for X := 0 to ClientList.Count - 1 do
          begin
            Application.ProcessMessages;
            
            //compara pelo Thread
            if TipoBusca = byThread then
            begin
              if TClient(ClientList.Items[X]).ClientInfo.cThread =
                    AClientInfo.cThread then
              begin
                Result := TClient(ClientList.Items[X]);
                Break;
              end;
            end  
            else
            //compara pelo nick
              if AClientInfo.cInfo1 <> '' then
              if TClient(ClientList.Items[X]).Nick = AClientInfo.cInfo1 then
              begin
                Result := TClient(ClientList.Items[X]);
                Break;
              end;
          end;
   end;
end;

procedure TFrmCenter.FormCreate(Sender: TObject);
begin
  ClientList := TList.Create;
end;

procedure TFrmCenter.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ClientList.Free;
  { Descarega/Finaliza plugins }
  FrmPlugins.DeInitPlugins;
end;

procedure TFrmCenter.ServerSocket1ClientConnect(Sender: TObject;
  Socket: TCustomWinSocket);
var
  NovoCliente: TClient;
begin
  { Coloca valor na variavel Data do socket, serve como um identificador }
  Socket.Data := Socket;
  { Cria novo cliente }
  NovoCliente := TClient.Create;
  { Define valores }
  NovoCliente.IP := Socket.RemoteAddress;
  NovoCliente.ClientInfo.cThread := Integer(Pointer(Socket));
  NovoCliente.ClientInfo.cID := ClientList.Count;
  { Adiciona na lista de clientes }
  ClientList.Add(NovoCliente);

  Memo1.Lines.Add('Conectado: '+ Socket.RemoteHost +'['+ Socket.RemoteAddress +']');
end;

procedure TFrmCenter.ServerSocket1ClientDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
var
 ClientInf : TClientInfo;
begin
  { Usa valor da variavel Data guardado anteriormente para identificar
    qual cliente desconectou }
  ClientInf.cThread := Integer(Socket.Data);
  { Deleta cliente desconectado da lista de clientes }
  ClientList.Delete(ClientList.IndexOf(ClientByInfo(ClientInf, byThread)));
  Memo1.Lines.Add('Desconectado: '+ Socket.RemoteHost +'['+ Socket.RemoteAddress +']');
end;

procedure TFrmCenter.ServerSocket1Listen(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  Memo1.Lines.Add('Em espera na porta: '+ IntToStr(ServerSocket1.Port));
end;

procedure TFrmCenter.ServerSocket1ClientRead(Sender: TObject;
  Socket: TCustomWinSocket);
var
  RecText, RecNick : String;
  X : Integer;
  ClientInf : TClientInfo;
begin
  RecText := Socket.ReceiveText;

  { Usuario mandou o comando que define o seu nick }
  if Copy(AnsiUpperCase(RecText),1,5) = 'NICK:' then
  begin
    RecNick := Copy(RecText, 6, Length(RecText));
    RecNick := Copy(RecNick, 1, Pos(#13#10, RecNick)-1);
    
    ClientInf.cThread := Integer(Socket.Data);
    if ClientByInfo(ClientInf, byThread) <> nil then
      ClientByInfo(ClientInf, byThread).Nick := RecNick;
  end;

  Memo1.Lines.Add('Texto recebido não processado pelos plugins:');
  Memo1.Lines.Add(RecText);

  { Lista todos os plugins carregados na lista, os que tiverem a função OnExecute
    ele executa a função mandando os dados recebidos(RecText), processa os dados e
    retorna para a propria variavel RecText }
  if PluginList.Count > 0 then
  for X := 0 to PluginList.Count -1 do
  begin
    with PPlugin(PluginList.Items[X])^ do
      if @FOnExecute <> nil then
        FOnExecute(Handle, Pointer(Socket), PChar(RecText), PChar(RecText), False);
  end;

  Memo1.Lines.Add('Texto processado pelos plugins:');
  Memo1.Lines.Add(RecText);
end;

procedure TFrmCenter.Button1Click(Sender: TObject);
begin
  ServerSocket1.Port := StrToIntDef(Edit1.Text, 5075);
  ServerSocket1.Open;
end;

procedure TFrmCenter.Button2Click(Sender: TObject);
var
 X : Integer;
begin
  for X := PluginList.Count -1 downto 0 do
    TClient(PluginList.Items[X]).Free;
  PluginList.Clear;

  ServerSocket1.Close;
  Memo1.Lines.Add('[Servidor fechado]');
end;

procedure TFrmCenter.Button3Click(Sender: TObject);
begin
  FrmPlugins.ShowModal;
end;

procedure TFrmCenter.Timer1Timer(Sender: TObject);
var
 X : Integer;
begin
   ListBox1.Clear;
   for X := 0 to ClientList.Count - 1 do
   with TClient(ClientList.Items[X]) do
     ListBox1.Items.Add('Thread:'+ IntToStr(Integer(ClientInfo.cThread))+
                        ' Nick:' + Nick);
end;

function TFrmCenter.PPluginByHandle(PHandle: THandle): PPlugin;
var
 X : Integer;
begin
  Result := nil;
  if PluginList.Count > 0 then
  for X := 0 to PluginList.Count -1 do
   with PPlugin(PluginList.Items[X])^ do
    if DLLHandle = PHandle then
    begin
      Result := PPLugin(PluginList.Items[X]);
      Break;
    end;
end;

end.
