function GetToggleState(Key: integer): boolean;
//
// Testa se uma certa tecla está pressionada ou não
//
begin
Result := Odd(GetKeyState(Key));
end;
end;