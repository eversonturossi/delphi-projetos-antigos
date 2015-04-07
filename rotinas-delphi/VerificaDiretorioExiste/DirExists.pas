function DirExists(const S : String): Boolean;
//
// Verifica se um diretorio existe
//
var
  OldMode : Word;
  OldDir : String;
begin
  Result := True;
  GetDir(0, OldDir); {save old dir for return}
  OldMode := SetErrorMode(SEM_FAILCRITICALERRORS); {if drive empty, except}
  try
    try
      ChDir(S);
    except
      on EInOutError DO Result := False;
    end;
  finally
    ChDir(OldDir); {return to old dir}
    SetErrorMode(OldMode); {restore old error mode}
  end;
end;
