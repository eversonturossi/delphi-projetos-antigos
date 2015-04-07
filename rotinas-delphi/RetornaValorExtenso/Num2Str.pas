function Num2Str(Num: LongInt): String;
//
// Retorna o extenso de um numero
//
Const
hundred = 100;
thousand = 1000;
million = 1000000;
billion = 1000000000;
begin
if Num >= billion then
   begin
   if (Num mod billion) = 0 then
       begin
       Num2Str := Num2Str(Num div billion) + ' Billion';
       end
   else
       begin
         Num2Str := Num2Str(Num div billion) + ' Billion ' +Num2Str(Num mod billion);
       end;
   end
else if Num >= million then
        begin
        if (Num mod million) = 0 then
            begin
            Num2Str := Num2Str(Num div million) + ' Milhão'
            end
        else
            begin
            Num2Str := Num2Str(Num div million) + ' Milhao e ' +Num2Str(Num mod million);
            end;
        end
else if Num >= thousand then
        begin
        if (Num mod thousand) = 0 then
           begin
           Num2Str := Num2Str(Num div thousand) + ' Mil';
           end
        else
           begin
           Num2Str := Num2Str(Num div thousand) + ' Mil e ' +Num2Str(Num mod thousand);
           end;
        end
else if Num >= hundred then
        begin
        if (Num mod hundred) = 0 then
           begin
           Num2Str := Num2Str(Num div hundred) + ' Cento'
           end
        else
           begin
           Num2Str := Num2Str(Num div  hundred) + ' Cento e ' + Num2Str(Num mod hundred)
           end;
        end
else
   begin
   case (Num div 10) of
            9: if Num = 90 then
                  begin
                  Num2Str := 'Noventa'
                  end
               else
                  begin
                  Num2Str := 'Noventa e ' + Num2Str(Num mod 10);
                  end;
            8: if Num = 80 then
                  begin
                  Num2Str := 'Oitenta'
                  end
               else
                  begin
                  Num2Str := 'Oitenta e ' + Num2Str(Num mod 10);
                  end;
            7: if Num = 70 then
                  begin
                  Num2Str := 'Setenta'
                  end
               else
                  begin
                  Num2Str := 'Setenta e ' + Num2Str(Num mod 10);
                  end;
            6: if Num = 60 then
                  begin
                  Num2Str := 'Sessenta'
                  end
               else
                  begin
                  Num2Str := 'Sessenta e ' + Num2Str(Num mod 10);
                  end;
            5: if Num = 50 then
                  begin
                  Num2Str := 'Cinquenta'
                  end
               else
                  begin
                  Num2Str := 'Cinquenta e ' + Num2Str(Num mod 10);
                  end;
            4: if Num = 40 then
                  begin
                  Num2Str := 'Quarenta'
                  end
               else
                  begin
                  Num2Str := 'Quarenta e ' + Num2Str(Num mod 10);
                  end;
            3: if Num = 30 then
                  begin
                  Num2Str := 'Trinta'
                  end
               else
                  begin
                  Num2Str := 'Trinta e ' + Num2Str(Num mod 10);
                  end;
            2: if Num = 20 then
                  begin
                  Num2Str := 'Vinte'
                  end
               else
                  begin
                  Num2Str := 'Vinte e ' + Num2Str(Num mod 10);
                  end;
           0,1: case Num of
                     0: Num2Str := 'Zero';
                     1: Num2Str := 'um';
                     2: Num2Str := 'Dois';
                     3: Num2Str := 'Tres';
                     4: Num2Str := 'Quatro';
                     5: Num2Str := 'Cinco';
                     6: Num2Str := 'Seis';
                     7: Num2Str := 'Sete';
                     8: Num2Str := 'Oito';
                     9: Num2Str := 'Nove';
                    10: Num2Str := 'Dez';
                    11: Num2Str := 'Onze';
                    12: Num2Str := 'Doze';
                    13: Num2Str := 'Treze';
                    14: Num2Str := 'Quatorze';
                    15: Num2Str := 'Quinze';
                    16: Num2Str := 'Dezesseis';
                    17: Num2Str := 'Dezessete';
                    18: Num2Str := 'Dezoito';
                    19: Num2Str := 'Dezenove';
                end;
   end;
  end;
end;
