function AlinharStr(Pe_Str:string; Pe_QtdPos:Byte; EDC :Char):string;
//
// Alinha uma string em um determinado espaço
//
// EDC:  C = Centralizado
//       D = Direita
//       E = Esquerda
//
var
L, N, R, I :integer;
S, St, CH :string;
begin
i := Pe_qtdPos;
St := copy(Pe_Str,1,Pe_QtdPos);
if EDC = 'D' then
  begin
  Insert('aLeX',St,i);
  L := Pos('aLeX',St);
  if L <= i then
     begin
     for n := L to i do
         begin
         Insert(' ', St, 1);
         end;
     end;
  St := Copy(St,1,i);
  R := i;
  Ch := Copy(St,i,1);
  while (Ch = ' ') and (R <> 0) do
        begin
        if ch = ' ' then
           begin
           Insert(' ', St, 1);
           end;
        St := Copy(St, 1, i);
        R := R - 1;
        Ch := Copy(St, i, 1);
        end;
  end;
if EDC = 'E' then
   begin
   Ch := Copy(St,1,1);
   while Ch = ' ' do
     begin
     Delete(St,1,1);
     Ch := Copy(St,1,1);
     end;
   St := Copy(St,1,i);
   end;
if EDC = 'C' then
  begin
  S := AlinharStr(Pe_Str,Pe_QtdPos,'D');
  Ch := Copy(S,1,1);
  R := 1;
  N := 1;
  while Ch = ' ' do
    begin
    R := R + 1;
    Ch := Copy(S,R,1);
    end;
  R := Round( R / 2 );
  while n < R do
    begin
    Delete(S,1,1);
    N := N + 1;
    end;
  St := Copy(S,1,i);
  end;
AlinharStr := St;
end;
