function RomanNum(num:integer):string;
//
// Converte um valor integer em Romano
//
var
i,j,n: integer;
digit,pivot:string;
begin
if (num<1) or (num>9999) then
   begin
   result:='Error!';
   exit;
   end;
result := '';
digit := 'IXCM';
pivot := 'VLD';
for i:=1 to 3 do
    begin
    n := num MOD 10;
    num := num Div 10;
    case n of
         1..3: begin
               for j := 1 to n do
                   begin
                   result := digit[i]+result;
                   end;
               end;
         4: result := digit[i]+pivot[i]+result;
         5..8: begin
               for j := 6 to n do
                   begin
                   result:=digit[i]+result;
                   end;
               result:=pivot[i]+result;
               end;
         9: result:=Copy(digit,i,2)+result;
    end;
    end;
for i:=1 to num do
    begin
    result:='M'+result;
    end;
end;
