procedure PrintMemo;
// Imprime um campo memo
// Requer a unit Printers declarada na clausula uses da unit
var
i,col,lin:integer;
begin
col:=0;   // posição da coluna
lin:=0;    // posição da linha
printer.begindoc;
for i := 0 to memo1.Lines.Count-1 do
    begin
    printer.Canvas.TextOut(col,lin, memo1.Lines[i]);
    lin := lin + 30;
    end;
printer.Enddoc;
end;
