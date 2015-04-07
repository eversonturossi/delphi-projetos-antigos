Function FormataCGC(CGC : string): string;
//
// Formata uma cadeia de strings referente ao CGC
//
begin
Result := Copy(CGC,1,2)+'.'+Copy(CGC,3,3)+'.'+Copy(CGC,6,3)+'/'+Copy(CGC,9,4)+'-'+Copy(CGC,13,2);
end;
