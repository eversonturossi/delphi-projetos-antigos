procedure SetCapsLock(State: boolean);
//
// Liga e desliga o Caps Lock
//
//tbSetCapsLock(true); { Liga Caps Lock }
//
//tbSetCapsLock(false); { Desliga Caps Lock }
//
begin
  if (State and ((GetKeyState(VK_CAPITAL) and 1) = 0)) or
     ((not State) and ((GetKeyState(VK_CAPITAL) and 1) = 1)) then
  begin
    keybd_event(VK_CAPITAL, $45, KEYEVENTF_EXTENDEDKEY or 0, 0);
    keybd_event(VK_CAPITAL, $45, KEYEVENTF_EXTENDEDKEY or KEYEVENTF_KEYUP, 0);
  end;
end;
