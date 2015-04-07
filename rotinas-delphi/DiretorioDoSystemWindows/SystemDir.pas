function SystemDir : String;
{Retorna o subdiretorio system do windows} 
Var
  Buffer : Array[0..144] of Char;
Begin
GetSystemDirectory(Buffer,144);
Result := StrPas(Buffer);
End;
