{**************************************************}
{             c . A . N . A . L                    }
{        # D . E . L . P . H . I . X               }
{    [-----------------------------------]         }
{                                                  }
{       Brasnet - irc.brasnet.org                  }
{       www.delphix.com.br                         }
{ Fontes por:                                      }
{         Glauber A. Dantas (Prodigy) - 01/09/2003 }
{**************************************************}

{ Compile (Ctrl+F9), Coloque na pasta do mIRC      }
{ e já pode usar as funções da DLL, no começo de   }
{ cada função tem explicando como usar-la          }


library MircDLL;

uses
  SysUtils, Windows, Messages,
  Classes;

type
 TmIRCDLL = packed record
  mVersion : DWORD;
  mHwnd    : HWND;
  mKeep    : Boolean;
 end;
 PmIRCDLL = ^TmIRCDLL;  

{$R *.RES}

procedure LoadDll(mIRCDLL: PmIRCDLL); stdcall; export;
begin
  mIRCDLL.mKeep := False;
 // Quando é true a dll fica aberta, se for false a dll executa os comandos e fecha
end;

procedure UnloadDll(mTimeOut: integer); stdcall; export;
begin
 //se mTimeOut = 0 então a dll fechou pelo comando /dll -u
 //se mTimeOut = 1 então a dll fechou porque se passaram 10 minutos da dll inativa
end;

function MudaTextAtiva(mWnd: hWnd; aWnd: hWnd; Data: PChar; Parms: PChar;
 Show: Boolean; NoPause: Boolean ): Integer; export; stdcall;
begin
 { /dll MircDLL.dll MudaTextAtiva Titulo da janela }
 SetWindowText(aWnd, Data);

 Result := 0;
end;

function MudaTextMain(mWnd: hWnd; aWnd: hWnd; Data: PChar; Parms: PChar;
 Show: Boolean; NoPause: Boolean ): Integer; export; stdcall;
begin
 { /dll MircDLL.dll MudaTextMain Titulo da janela }
 SetWindowText(mWnd, Data);

 Result := 0;
end;

function ControlaAtiva(mWnd: hWnd; aWnd: hWnd; Data: PChar; Parms: PChar;
 Show: Boolean; NoPause: Boolean ): Integer; export; stdcall;
begin
  { /dll MircDLL.dll ControlaAtiva MA }
  if UpperCase(Data) = 'MA' then
    ShowWindow(aWnd, SW_MAXIMIZE);
  if UpperCase(Data) = 'MI' then
    ShowWindow(aWnd, SW_MINIMIZE);
  if UpperCase(Data) = 'RE' then
    ShowWindow(aWnd, SW_RESTORE);
  if UpperCase(Data) = 'CL' then
    SendMessage(aWnd,WM_CLOSE,0,0);

  Result := 0;
end;

function AnimateAtiva(mWnd: hWnd; aWnd: hWnd; Data: PChar; Parms: PChar;
 Show: Boolean; NoPause: Boolean ): Integer; export; stdcall;
begin
  { /dll MircDLL.dll AnimateAtiva }
  AnimateWindow(aWnd, 1000, AW_HOR_POSITIVE or AW_HOR_NEGATIVE or AW_Hide);
  AnimateWindow(aWnd, 1000, AW_HOR_POSITIVE or AW_HOR_NEGATIVE or AW_CENTER);
  AnimateWindow(aWnd, 1000, AW_HOR_NEGATIVE or AW_HOR_POSITIVE or AW_Hide);
  AnimateWindow(aWnd, 1000, AW_HOR_POSITIVE or AW_HOR_NEGATIVE or AW_SLIDE);
  AnimateWindow(aWnd, 1000, AW_VER_POSITIVE or AW_HIde);
  AnimateWindow(aWnd, 1000, AW_VER_NEGATIVE or AW_SLIDE);

  Result := 0;
end;

function SayComHora(mWnd: hWnd; aWnd: hWnd; Data: PChar; Parms: PChar;
 Show: Boolean; NoPause: Boolean ): Integer; export; stdcall;
var
 sData : String;
begin
  { /dll MircDLL.dll SayComHora teste }

  //Coloca o parametro recebido de PChar para String
  sData := StrPas(Data);
  //Adiciona a Hora no final
  sData := sData +' ['+ TimeToStr(Time) +']';
  //Retorna comando
  strcopy(data, Pchar('/say '+ sData));

  Result := 2;
end;


//exporta função para poder ser usada por outras aplicações
exports LoadDll, UnloadDll, MudaTextAtiva, MudaTextMain,
       ControlaAtiva, AnimateAtiva, SayComHora;


begin
end.
