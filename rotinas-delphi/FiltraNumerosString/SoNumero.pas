Function SoNumero(Texto : String) : String;
//
// Filtra todos os numeros de uma string
//
var
Ind    : Integer;
TmpRet : String;
begin
TmpRet := '';
for Ind := 1 to Length(Texto) do
    begin
    if IsDigit(Copy(Texto,Ind,1)) then
       begin
       TmpRet := TmpRet + Copy(Texto, Ind, 1);
       end;
    end;
Result := TmpRet;
end;
