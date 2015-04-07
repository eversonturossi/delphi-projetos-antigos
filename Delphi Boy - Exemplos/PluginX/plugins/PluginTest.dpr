{*************************************************}
{  Plugin exemplo para a aplicação                }
{  usando biblioteca PluginX 1.1 beta             }
{  Glauber A. Dantas - glauber@delphix.com.br     }
{*************************************************}

library PluginTest;

uses
  Windows, SysUtils, Messages,
  Classes,
    Dialogs,
  PluginX in '..\PluginX.pas';

type
 TComando = (cMsg, cInfo, cDateTime, cMostraInfo, cNone);

var
 RecList: TStringList;
 copydata: TCopyDataStruct;
 ClientInfo: TClientInfo;
 AppInfo: TAppInfo;

{$R *.res}

{ Quando A DLL é carregada, a aplicação executa essa procedure,
  a aplicação manda suas informações no parametro lAppInfo
  o plugin preenche suas informações no parametro lPluginInfo }
procedure LoadPlugin(lAppInfo: TAppInfo; lPluginInfo: TPluginInfo); stdcall;
begin
   with lPluginInfo do
   begin
     StrCopy(pVersion, '1.0A');
     StrCopy(pAuthor, 'Glauber Almeida Dantas');
     StrCopy(pCopyright, 'Glauber Almeida Dantas, 2004');
     StrCopy(pHome, 'www.delphix.com.br');
     StrCopy(pFunction, 'Protocolo de comunicação by Plugin X');
     StrCopy(pDescription, 'Meu Plugin Teste');
   end;

   RecList := TStringList.Create;
   AppInfo := lAppInfo;

  // ShowMessage(AppInfo.Version);
end;

{ Quando a DLL é descarregada a aplicação executa essa procedure }
procedure UnLoadPlugin; stdcall;
begin
  //ShowMessage('UnLoadPlugin');
  RecList.Free;
end;

{ Quando o servidor recebe dados executa essa função, mandando o texto recebido
  pelo parametro eCmd, a função retorna o valor para o parametro eReturn }
function OnExecute(mWnd: hWnd; eClientThread: Pointer; eCmd, eReturn: PChar;
                           NoPause: Boolean): Integer; stdcall;
var
  RecLinha, UpRecLinha : String;
  RecStr: String[255];
  X : Integer;
  Comando : TComando;
begin
  RecList.Text := StrPas(eCmd);

  //Verifica linha por linha na RecList
  if RecList.Count > 0 then
  for X := RecList.Count -1 downto 0 do
  begin
    { Verifica se a linha esta vazia }
    if RecList[X] <> '' then
      RecLinha := RecList[X]
    else
      Continue;

       UpRecLinha := AnsiUpperCase(RecLinha);
       
       if Copy(UpRecLinha,1,4) = 'MSG:' then
        Comando := cMsg
       else if UpRecLinha = 'INFO!' then
        Comando := cInfo
       else if UpRecLinha = 'DATETIME!' then
        Comando := cDateTime
       else if UpRecLinha = 'GETCLIENT!' then
        Comando := cMostraInfo
       else
        Comando := cNone;

       //Manda a aplicação enviar a Msg para todos os clientes
       if Comando = cMsg then
       begin
         RecStr := Copy(RecLinha, 5, Length(RecLinha)) +#13#10;
         copydata.lpData := @RecStr;
         copydata.cbData := Length(RecStr);
         copydata.dwData := APP_BROADCAST_WRITE;
         SendMessage(mWnd, WM_COPYDATA, HInstance, Integer(@copydata));
       end;

       //Cliente pediu Informações
       if Comando = cInfo then
       begin
         ClientInfo.cInfo2 := 'Informações desse protocolo: ' +#13#10+
                              'Versão: 1.0' +#13#10+
                              'Criado: 21/01/20004' +#13#10;
       end;
       //Cliente pediu DateTime atual
       if Comando = cDateTime then
         ClientInfo.cInfo2 := DateTimeToStr(Now);

       //Manda a aplicação enviar as informações para o cliente
       if (Comando = cInfo) or (Comando = cDateTime) then
       begin
         ClientInfo.cThread := Integer(eClientThread);
         copydata.cbData := SizeOf(ClientInfo);
         copydata.lpData := @ClientInfo;
         copydata.dwData := APP_CLIENT_WRITE;
         SendMessage(mWnd, WM_COPYDATA, HInstance, Integer(@copydata));
       end;

       //Manda a aplicação mostra informações do cliente
       if Comando = cMostraInfo then
       begin
         ClientInfo.cThread := Integer(eClientThread);
         copydata.cbData := SizeOf(ClientInfo);
         copydata.lpData := @ClientInfo;
         copydata.dwData := APP_CLIENT_GETCLIENT;
         SendMessage(mWnd, WM_COPYDATA, HInstance, Integer(@copydata));
       end;

       //Deleta linha processada, se foi um comando reconhecido
       if Comando <> cNone then
        RecList.Delete(X);
  end;//fim for

  //Devolve para a variavel eReturn o valor que restou
  StrPCopy(eReturn, RecList.Text);
  
  Result := 0;
end;

{ Quando a DLL faz pedido que a aplicação envie dados de um cliente,
  a aplicação executa essa função mandando os dados no parametro sClient }
procedure SendClientToPlug(mWnd: hWnd; sClient: TClient;
                           NoPause: Boolean); stdcall;
begin
  ShowMessage('Nick:'+ sClient.Nick +#13+
              'IP:'+ sClient.IP +#13+
              'Thread:'+ IntToStr(sClient.ClientInfo.cThread));
end;

{ Exporta rotinas para serem usadas por aplicações }
exports LoadPlugin, UnLoadPlugin, OnExecute,
        SendClientToPlug;

begin
end.
