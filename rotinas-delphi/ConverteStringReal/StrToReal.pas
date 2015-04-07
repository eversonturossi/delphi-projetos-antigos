Function StrToReal(InStr: String): Real;
//
// Converte uma String em Real
//
var
Code : Integer;
Temp : Real;
begin
Result := 0;
If Copy(InStr,1,1)='.' then
   InStr:= '0' + InStr;
If (Copy(InStr,1,1)='-') and (Copy(InStr,2,1)='.') then
   Insert('0',InStr,2);
If InStr[length(InStr)] = '.' then
   Delete(InStr,length(InStr),1);
Val(InStr,Temp,Code);
if Code = 0 then
   Result := Temp;
end;
