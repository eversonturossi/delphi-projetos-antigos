procedure TurnOffKey(Key: integer);
//
// Desliga uma Tecla
//
Var
KeyState  :  TKeyboardState;
begin
GetKeyboardState(KeyState);
if (KeyState[Key] = 1) then
   begin
   KeyState[Key] := 0;
   end;
SetKeyboardState(KeyState);
end;
