function RetornaAZ: String;
//
// Gera letras aleatórias
//
var
  n: integer;
  i: integer;
begin
  Randomize;
  n := Random(26) * 1000;
  i := (n mod 26); // 26 = Número de letras do alfabeto
  Result := Chr(i + 64);
end;

