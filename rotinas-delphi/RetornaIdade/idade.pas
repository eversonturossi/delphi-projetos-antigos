function idade(Nascimento,DataAtual:string):Integer;
//
// Retorna a idade de uma pessoa
//
var
idade,dian,mesn,anon,diaa,mesa,anoa:word;
begin
decodedate(StrToDate(DataAtual),anoa,mesa,diaa);
decodedate(StrToDate(Nascimento),anon,mesn,dian);
idade := anoa - anon;
if mesn > mesa then
   begin
   idade := idade;
   end;
 if(mesn > mesa) and (dian > diaa)then
   begin
   idade := idade;
   end;
result := idade;
end;
