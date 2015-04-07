function ArredontaFloat(x : Real): Real;
{Arredonda um número float para convertê-lo em String}
Begin
  if x > 0 Then
     begin
     if Frac(x) > 0.5 Then
        begin
        x := x + 1 - Frac(x);
        end
     else
        begin
        x := x - Frac(x);
        end;
     end
  else
     begin
     x := x - Frac(x);
     end;
     result := x
end;
