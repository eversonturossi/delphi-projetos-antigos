Function FormataCPF(CPF : string): string;
//
// Formata uma cadeia de strings referente ao CPF
//
begin
Result := Copy(CPF,1,3)+'.'+Copy(CPF,4,3)+'.'+Copy(CPF,7,3)+'-'+Copy(CPF,10,2);
end;
