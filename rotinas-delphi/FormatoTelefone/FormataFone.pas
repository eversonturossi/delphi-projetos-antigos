Function FormataFone(Fone: String; Area: String): string;
//
// Formata uma cadeia de strings numericos em formato de
// numero de telefone
//
var
DDD      : String;
Prefixo  : String;
Numero   : String;
Telefone : String;
Caracter : String;
Ind      : Integer;
Estado   : Integer;    // 0-DDD, 1-Prefixo, 2-Numero
begin
Ind      := 1;
DDD      := '';
Prefixo  := '';
Numero   := '';
Estado   := -1;
Telefone := '';
while ind <= length(Fone) do
      begin
      caracter := Copy(Fone,ind,1);
      if caracter = '(' then
         begin
         Estado := 0;
         end
      else
         begin
         if caracter = ')' then
            begin
            if Estado = 0 then
               begin
               Estado := 1;
               end;
            end
         else
            begin
            if caracter = '-' then
               begin
               if Estado = 1 then
                  begin
                  Estado := 2;
                  end;
               end;
            end;
         end;
      case Estado of
           0 : DDD     := DDD     + Caracter;
           1 : Prefixo := Prefixo + Caracter;
           2 : Numero  := Numero  + Caracter;
      end;
      Ind := Ind + 1;
      end;
if Estado = -1 then
   begin
   Telefone := Fone;
   if Length(Telefone) = 10 then
      begin
      Result := '('+Copy(Telefone,1,3)+') '+Copy(Telefone,4,3)+'-'+Copy(Telefone,7,4);
      end
   else
      begin
      if Length(Telefone) = 7 then
         begin
         Result := '('+Area+') '+Copy(Telefone,1,3)+'-'+Copy(Telefone,4,4)
         end
      else
         begin
         Result := Fone;
         end;
      end;
   end
else
   begin
   if Length(DDD) = 0 then
      begin
      DDD := Area;
      end;
   if Length(Numero) = 0 then
      begin
      Result := '('+DDD+') '+Prefixo
      end
   else
      begin
      Result := '('+DDD+') '+Prefixo+'-'+Numero;
      end;
   end;
end;
