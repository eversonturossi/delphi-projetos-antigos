unit Matriz;

interface

const
  cOrdemMax= 100;

type
  tMatriz= array[1..cOrdemMax, 1..cOrdemMax] of Extended;

var
  eMatriz: tMatriz;

procedure MultiplicarPorEscalar            (Largura, Altura: Integer; Escalar: Extended);
procedure Triangular                       (Ordem: Integer; var Sinal: SmallInt);
function  CalcularDeterminanteTriangulacao (Ordem: Integer): Extended;

implementation

uses Principal;





procedure MultiplicarPorEscalar (Largura, Altura: Integer; Escalar: Extended);
var
  X, Y: Integer;
  
begin
  for Y:= 1 to Largura do
    for X:= 1 to Altura do
      eMatriz[X, Y]:= eMatriz[X, Y]*Escalar;
end; // MultiplicarPorEscalar ()





procedure PermutarLinhas (Ordem: Integer; A, B: LongInt);
var
  X   : LongInt;
  Temp: Extended;

begin
  for X:= 1 to Ordem do begin
    Temp         := eMatriz[X, B];
    eMatriz[X, B]:= eMatriz[X, A];
    eMatriz[X, A]:= Temp;
  end;
end; // PermutarLinhas ()





procedure TriangularLinhas (Ordem: Integer; PosicaoPivo: LongInt);
var
  X, Y   : LongInt;
  Escalar: Extended;

begin
  for Y:= PosicaoPivo+1 to Ordem do begin
    Escalar                := eMatriz[PosicaoPivo, Y]/eMatriz[PosicaoPivo, PosicaoPivo];
    eMatriz[PosicaoPivo, Y]:= 0.0;
    for X:= PosicaoPivo+1 to Ordem do
      eMatriz[X, Y]:= eMatriz[X, Y] - eMatriz[X, PosicaoPivo]*Escalar;
  end;
end; // TriangularLinhas ()





function ProcurarNaoZero (Ordem: Integer; X, Y: LongInt): LongInt;
var
  P: LongInt;

begin
  Result:= -1;
  for P:= Y to Ordem do
    if eMatriz[X, P] <> 0 then begin
      Result:= P;
      Exit;
    end
end; // ProcurarNaoZero ()




// O sinal do DETERMINANTE muda quando se permuta 2 linhas
procedure Triangular (Ordem: Integer; var Sinal: SmallInt);
var
  P, PosicaoPivo: LongInt;

begin
  Sinal:= 1;
  for P:= 1 to Ordem do
    if eMatriz[P, P] <> 0.0 then
      TriangularLinhas (Ordem, P)
    else if P < Ordem then begin // Para evitar de permutar a última linha
      PosicaoPivo:= ProcurarNaoZero (Ordem, P, P);
      if PosicaoPivo > 0 then begin
        Sinal:= -Sinal;
        PermutarLinhas (Ordem, P, PosicaoPivo);
        TriangularLinhas (Ordem, P);
      end;
    end;
end; // Triangular ()





function CalcularDeterminanteTriangulacao (Ordem: Integer): Extended;
var
  Sinal: SmallInt;
  P    : LongInt;

begin
  Result:= 1;
  Triangular (Ordem, Sinal);
  for P:= 1 to Ordem do
    Result:= Result*eMatriz[P, P]; // Multiplicar os elementos da Diagonal Principal
  Result:= Result*Sinal;
end; // CalcularDeterminanteTriangulacao ()

end.
