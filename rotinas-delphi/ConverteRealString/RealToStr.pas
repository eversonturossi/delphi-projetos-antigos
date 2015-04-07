Function RealToStr(InVal:Real; Decimals:Byte): String;
//
// Converte um numero real em String
//
Var
 Width   : Byte;
 IntPart : Real;
 TempStr : String;
Begin
IntPart := Int(InVal);
STR(Int(InVal):0:0,TempStr);
Width := Length((TempStr));
STR(InVal:Width:Decimals,TempStr);
Result := TempStr;
End;
