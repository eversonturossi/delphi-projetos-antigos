program Project1;

uses
 windows, messages;

var
 Handle: hWnd;
 PositionX: integer = 300;
 PositionY: integer = 200;
 DevMode: _deviceModeA;
 
{$R dialog.res}
 
procedure TimerProc(hw: hWnd; mess, id: longint; stime: dword); stdcall;
const
 text = '4k Delphi intro is POSSiBLE!';
var
 DC: hDC;
begin
 DC := GetDC(Handle);
 if Round(Random) = 1 then
  inc(PositionX)
 else
  dec(PositionX);
 if Round(Random) = 1 then
  inc(PositionY)
 else
  dec(PositionY);
 
 SetTextColor(DC, PositionX * 65536 + PositionX * 256 + PositionX);
 TextOutA(DC, PositionX, PositionY, @text[1], Length(text));
 
 ReleaseDC(Handle, DC);
end;

function DlgProc(Dialog: HWnd; Msg, WParam: Word; LParam: Longint): DWORD; stdcall;
// Message processing
begin
 case Msg of
  WM_CLOSE:
   begin
    EndDialog(Dialog, 0);
   end;

  WM_INITDIALOG:
   begin
    // go fullscreen
    DevMode.dmFields := DM_PELSWIDTH + DM_PELSHEIGHT;
    DevMode.dmPelsWidth := 640;
    DevMode.dmPelsHeight := 480;
    DevMode.dmSize := SizeOf(DevMode);
    ChangeDisplaySettingsA(DevMode, 0);

    Handle := Dialog; // we'll need it later
    SetCursorPos(640, 480);
    SetTimer(Handle, 1, 30, @TimerProc);
   end;

  WM_KEYUP: EndDialog(Dialog, 0);
 end;
 DlgProc := DWORD(false);
 
end;

begin
 Randomize;
 // $400000 is HINST, you should obtain it with GetModuleHandle(nil)
 // but HINST is actually application's imageBase
 DialogBoxParam($400000, 'MAIN', 0, @DlgProc, 0);
 
 KillTimer(Handle, 1);
 
 // i can't pass nil to lpDevMode for ChangeDisplaySettings - why?
 // ...have to do it w/ assembler
 asm
    push 0
    push 0
    call ChangeDisplaySettingsA
 end;
end.

