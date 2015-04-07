library HookDll;

{%File 'constants.inc'}

uses
  Windows, Messages;

{$I CONSTANTS.INC}

var
  hhk: HHOOK;
  Installed: Boolean;

function KeyboardProc(nCode: Integer; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall;
var Handled: Boolean;
  KeyState: TKeyboardState;
  Han: HWND;

  function WinKeyPressed: boolean;
  begin
    Result := (KeyState[VK_LWIN] and $80 <> 0) or (KeyState[VK_RWIN] and $80 <> 0);
  end;

begin
  Handled:=False;
  Result:=1;
  if nCode=HC_ACTION then
  begin
    GetKeyboardState(KeyState);
    Han:=FindWindow('TForm1',APP_CAPTION);
    if (IsWindow(Han)) and (KeyState[wParam] and $80 <> 0) and WinKeyPressed then
    begin
      Handled:=True;
      case wParam of
        VK_F9: SendMessage(Han,HOOK_MSG, APP_SHOW, 0);
        VK_F10: SendMessage(Han,HOOK_MSG, EJECT_CDROM, 0);
        VK_F12: SendMessage(Han,HOOK_MSG, APP_QUIT, 0);
      else
        Handled:=False;
      end;
    end;
  end;
  if not Handled then
    Result:=CallNextHookEx(hhk, nCode, wParam, lParam);
end;

function InstallHook: integer;
begin
  if Installed then Result:=HOOK_ALREADY_INSTALLED
  else
  begin
    hhk:=SetWindowsHookEx(WH_KEYBOARD, @KeyboardProc, HInstance, 0);
    if hhk<>0 then
    begin
      Result:=HOOK_INSTALLED_OK;
      Installed:=True;
    end else Result:=HOOK_INSTALLED_FAILED;
  end;
end;

function UninstallHook: Integer;
begin
  if Installed then
  begin
    Result:=Ord(UnhookWindowsHookEx(hhk));
    if Result=HOOK_UNINSTALLED_OK then Installed:=False;
  end else Result:=HOOK_NOT_INSTALLED
end;

function IsHookInstalled: Boolean;
begin
  Result:=Installed;
end;

exports InstallHook, UninstallHook, IsHookInstalled;

begin
  Installed:=False;
end.
