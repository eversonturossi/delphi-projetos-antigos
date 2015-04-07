function IsPrinter : Boolean;
{Testa se a impressora está ativa ou não, retornando .t.
 em caso positivo} 
Const
    PrnStInt  : Byte = $17;
    StRq      : Byte = $02;
    PrnNum    : Word = 0;  { 0 para LPT1, 1 para LPT2, etc. }
Var
  nResult : byte;
Begin  (* IsPrinter*)
Asm
   mov ah,StRq;
   mov dx,PrnNum;
   Int $17;
   mov nResult,ah;
end;
IsPrinter := (nResult and $80) = $80;
End;
