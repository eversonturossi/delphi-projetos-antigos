function Percentdisk(unidade: byte): Integer;
{Retorna a porcentagem de espaço livre em uma unidade de disco}
var
A,B, Percentual : longint;
begin
if DiskFree(Unidade)<> -1 then
   begin
   A := DiskFree(Unidade) div 1024;
   B := DiskSize(Unidade) div 1024;
   Percentual:=(A*100) div B;
   result := Percentual;
   end
else
   begin
   result := -1;
   end;
end;
