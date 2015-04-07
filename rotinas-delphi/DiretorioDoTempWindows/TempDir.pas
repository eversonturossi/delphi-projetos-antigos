function TempDir : String;
{Retorna o Diretorio Temp do Windows}
Var
  Buffer : Array[0..144] of Char;
Begin
GetTempPath(144,Buffer);
Result := StrPas(Buffer);
end;
