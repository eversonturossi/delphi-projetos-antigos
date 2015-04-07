procedure QuickChangeRes(iWidth: integer; iHeight: integer);
Const
DM_PELSWIDTH = $80000;
DM_PELSHEIGHT = $100000;
var
DevMode : TDevMode;
A : boolean;
i : longint;
begin
i := 0;
repeat
A := EnumDisplaySettings(nil,i,DevMode);
i := i + 1;
until (A = False);
DevMode.dmFields := DM_PELSWIDTH or DM_PELSHEIGHT;
DevMode.dmPelsWidth := iWidth;
DevMode.dmPelsHeight := iHeight;
ChangeDisplaySettings(DevMode,0);
Application.ProcessMessages;
end;
