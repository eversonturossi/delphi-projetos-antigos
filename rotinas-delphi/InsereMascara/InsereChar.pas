function InsereChar(l: longint;Charin:String): string;
//
// Insere uma mascara especificada em um valor numérico
//
var
len, count: integer;
s: string;
begin
str(l, s);
len := length(s);
for count := ((len - 1) div 3) downto 1 do
    begin
    insert(Charin, s, len - (count * 3) + 1);
    len := len + 1;
    end;
Result := s;
end;
