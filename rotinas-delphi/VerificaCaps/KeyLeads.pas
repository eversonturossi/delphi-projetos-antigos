function KeyLeads:String;
{verificação das teclas Caps, Scroll e NUM que usa
 um evento do Delphi e naum o Timer}
Var
State : String;
KeyState  :  TKeyboardState;
begin
State := '';
GetKeyboardState(KeyState);
if (KeyState[VK_NUMLOCK] = 1) then
    begin
    State := State + 'Num Lock';
    end;
if (KeyState[VK_CAPITAL] = 1) then
   begin
   State := State + 'Caps Lock';
   end;
if (KeyState[VK_SCROLL] = 1) then
    begin
    State := State + 'Scroll Lock';
    end;
    Result := State;
end;
