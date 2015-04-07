{*******************************************************}
{                                                       }
{  Plugin X versão 1.1 beta - 21/01/2004                }
{                                                       }
{  Biblioteca para comunicação entre uma DLL/Aplicação  }
{  e uma aplicação Servidor de Internet                 }
{  Glauber Almeida Dantas - glauber@delphix.com.br      }
{                                                       }
{*******************************************************}

unit PluginX;

interface

uses Windows, Classes;

type
   { AppInfo Info }
   TAppInfo = packed record
    Version : String[30];
    Hwnd    : HWND;
    Keep    : Boolean;
   end;
   PAppInfo = ^TAppInfo;

  { Plugin Info }
  TPluginInfo = packed record
    pVersion, pAuthor,
    pCopyright, pHome,
    pFunction, pDescription : PChar;
  end;
  PPluginInfo = ^TPluginInfo;

{ Pacote com informações de um cliente }
  TClientInfo = packed record
    cID: Integer;
    cThread: Integer;
    cInfo1, cInfo2, cInfo3  : String[255];
  end;

{** Objeto TClient usado nesse exemplo
    para guardar info de uma conexão **}
  PClient = ^TClient;
  TClient = class(TObject)
    Nick, IP: String[50];
    ClientInfo: TClientInfo;
  end;

 { Função executada quando o plugin é carregado }
 TLoadPlugin   = procedure (AppInfo: TAppInfo; PluginInfo: TPluginInfo); stdcall;
 { Função executada quando o plugin é liberado }
 TUnloadPlugin = procedure; stdcall;
 { Função executada quando o servidor receber dados }
 TOnExecute    = function(mWnd: hWnd; eClientThread: Pointer; eCmd, eReturn: PChar;
                           NoPause: Boolean): Integer; stdcall;

 { Para enviar ao plugin dados de um TClient }
 TSendClientToPlug = procedure (mWnd: hWnd; sClient: TClient;
                           NoPause: Boolean); stdcall;

 { Tipo TPlugin para armazenar informações
   dos plugins carregados }
  PPLugin = ^TPlugin;
  TPlugin = packed record
    DLLName       : PChar;
    DLLHandle     : THandle;
    FLoadPlugin   : TLoadPlugin;
    FUnLoadPlugin : TUnLoadPlugin;
    FOnExecute    : TOnExecute;
    PluginInfo    : TPluginInfo;
    FSendClientToPlug : TSendClientToPlug;
  end;

{ Identificadores das mensagens do plugin para a aplicação }
const
  MSG_BASE                     = $9000;
  MSG_ERROR                    = MSG_BASE + 1;

  APP_BROADCAST_WRITE          = MSG_BASE + 11;
  APP_CLIENT_WRITE             = MSG_BASE + 12;
  APP_CLIENT_CLOSE             = MSG_BASE + 13;
  APP_CLIENT_GETCLIENT         = MSG_BASE + 14;


implementation

end.
