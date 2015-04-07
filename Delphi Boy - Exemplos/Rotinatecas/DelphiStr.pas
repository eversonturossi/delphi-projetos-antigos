{ Wheberson Hudson Migueletti, em Brasília, 8 de agosto de 1998.
  Arquivo: DelphiStr.Pas
  Tratamento de Strings em Delphi.
}

unit DelphiStr;

interface

function SerNumero  (S: String): Integer;
function SerInteiro (S: String): Integer;

implementation





function SerNumero (S: String): Integer;
var
  Num   : Real;
  Status: Integer;

begin
  Val (S, Num, Status);
  SerNumero:= Status;
end; { SerNumero () }





function SerInteiro (S: String): Integer;
var
  Num   : Integer;
  Status: Integer;

begin
  Val (S, Num, Status);
  SerInteiro:= Status;
end; { SerInteiro () }

end.
