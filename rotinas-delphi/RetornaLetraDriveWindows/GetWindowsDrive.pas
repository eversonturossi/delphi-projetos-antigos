function GetWindowsDrive: Char;
//
// retorna a letra do drive onde está
// instalado oWindows:
//
var
  S: string;
begin
  SetLength(S, MAX_PATH);
  if GetWindowsDirectory(PChar(S), MAX_PATH) > 0 then
    Result := string(S)[1]
  else
    Result := #0;
end;
