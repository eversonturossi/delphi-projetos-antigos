function DetectaDrv(const drive : char): boolean;
{Detecta quantas unidade possui no computador}
var
  Letra: string;
begin
  Letra := drive + ':\';
  if GetDriveType(PChar(Letra)) < 2 then
     begin
     result := False;
     end
  else
     begin
     result := True;
     end;
end;
