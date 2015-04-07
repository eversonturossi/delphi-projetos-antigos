unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, mmSystem;

{$I CONSTANTS.INC}

type
  TForm1 = class(TForm)
    lblInstalled: TLabel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    procedure HOOK_MSG_PROC(var Msg: TMessage); message HOOK_MSG;
    procedure OnMinimize(var Msg: TMessage); message WM_SYSCOMMAND;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

const InstalledStrings: array[0..2] of string[50]=('Hook installation failed','Hook installed','Hook already installed');
  UnInstalledStrings: array[0..2] of string[50]=('Hook uninstallation failed','Hook uninstalled','No hook was found to uninstall');

{Importing functions from DLL}
function InstallHook: integer; external HOOK_DLL;
function UninstallHook: Integer; external HOOK_DLL;
function IsHookInstalled: Boolean; external HOOK_DLL;
function RegisterServiceProcess(dwProcessID, dwType: integer): Integer; stdcall; external 'KERNEL32.DLL';

procedure TForm1.Button1Click(Sender: TObject);
var rez: Integer;
begin
  rez:=InstallHook;
  lblInstalled.Caption:=InstalledStrings[rez];
end;

procedure TForm1.Button2Click(Sender: TObject);
var rez: Integer;
begin
  rez:=UninstallHook;
  lblInstalled.Caption:=UnInstalledStrings[rez];
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.HOOK_MSG_PROC(var Msg: TMessage);
begin
  case Msg.WParam of
    APP_SHOW:
    begin
      Application.ShowMainForm:=True; Visible:=True;
    end;
    EJECT_CDROM: mciSendString('set CDAudio door open',nil,0,0);
    APP_QUIT: Close;
  end;
end;

procedure TForm1.OnMinimize(var Msg: TMessage);
begin
  if Msg.WParam=SC_MINIMIZE then
  begin
    if not IsHookInstalled then
    begin
      ShowMessage('Install the hook first or you''ll'+#13#10+'not be able to access the program');
      Exit;
    end;
    Application.ShowMainForm:=False;
    Visible:=False;
  end else Inherited;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Caption:=APP_CAPTION;
  RegisterServiceProcess(GetCurrentProcessID, 1);
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;
  if IsHookInstalled then UninstallHook;
end;

end.
