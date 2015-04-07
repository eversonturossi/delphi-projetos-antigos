unit Matriz;

interface

uses Windows, Classes, SysUtils;

type
  pVetor = ^tVetor;
  tVetor = array[0..0] of Extended;
  TMatriz= class
    private
      Tamanho: LongInt;
      Matriz : pVetor;
    public
      Status : Boolean;
      Altura : LongInt;
      Largura: LongInt;

      constructor Create             (_Largura, _Altura: LongInt);
      destructor  Destroy; override;
      function    Retornar           (X, Y: LongInt): Extended;
      procedure   Armazenar          (X, Y: LongInt; Valor: Extended);
  end;

var
  eMatriz: TMatriz;

procedure MultiplicarPorEscalar (Escalar: Extended);
procedure Triangular            (var Sinal: SmallInt);
function  CalcularDeterminanteTriangulacao: Extended;
function  CalcularInversa: Boolean;

implementation

uses Principal;




// Classe: TMatriz
constructor TMatriz.Create (_Largura, _Altura: LongInt);

begin
  inherited Create;
  
  Largura:= _Largura;
  Altura := _Altura;
  Tamanho:= Largura*Altura*SizeOf (Extended);
  try
    GetMem (Matriz, Tamanho);
    Status:= True;
  except
    Status:= False;
  end;
end; // Create ()





destructor TMatriz.Destroy;

begin
  FreeMem (Matriz, Tamanho);

  inherited Destroy;
end; // Destroy ()




// Retorna o índice da matriz relativa ao par (X, Y)
function TMatriz.Retornar (X, Y: LongInt): Extended;

begin
  Result:= Matriz^[X + Y*Largura];
end; // Retornar ()




// Armazenar um elemento na matriz
procedure TMatriz.Armazenar (X, Y: LongInt; Valor: Extended);

begin
  Matriz^[X + Y*Largura]:= Valor;
end; // Armazenar ()
// Classe: TMatriz




procedure MultiplicarPorEscalar (Escalar: Extended);
var
  X, Y: Integer;

begin
  for Y:= 0 to eMatriz.Largura-1 do
    for X:= 0 to eMatriz.Altura-1 do
      eMatriz.Armazenar (X, Y, eMatriz.Retornar (X, Y)*Escalar);
end; // MultiplicarPorEscalar ()





procedure PermutarLinhas (A, B: LongInt);
var
  X   : LongInt;
  Temp: Extended;

begin
  for X:= 0 to eMatriz.Largura-1 do begin
    Temp:= eMatriz.Retornar (X, B);
    eMatriz.Armazenar (X, B, eMatriz.Retornar (X, A));
    eMatriz.Armazenar (X, A, Temp);
  end;
end; // PermutarLinhas ()





function ProcurarNaoZero (X, Y: LongInt): LongInt;
var
  P: LongInt;

begin
  Result:= -1;
  for P:= Y to eMatriz.Altura-1 do
    if eMatriz.Retornar (X, P) <> 0 then begin
      Result:= P;
      Exit;
    end;
end; // ProcurarNaoZero ()





procedure TriangularLinhas (PosicaoPivo: LongInt; SerParaBaixo: Boolean);
var
  X, Y   : LongInt;
  Escalar: Extended;

begin
  if SerParaBaixo then
    for Y:= PosicaoPivo+1 to eMatriz.Altura-1 do begin
      Escalar:= eMatriz.Retornar (PosicaoPivo, Y)/eMatriz.Retornar (PosicaoPivo, PosicaoPivo);
      eMatriz.Armazenar (PosicaoPivo, Y, 0.0);
      for X:= PosicaoPivo+1 to eMatriz.Largura-1 do
        eMatriz.Armazenar (X, Y, eMatriz.Retornar (X, Y) - eMatriz.Retornar (X, PosicaoPivo)*Escalar);
    end
  else
    for Y:= PosicaoPivo-1 downto 0 do begin
      Escalar:= eMatriz.Retornar (PosicaoPivo, Y)/eMatriz.Retornar (PosicaoPivo, PosicaoPivo);
      for X:= eMatriz.Largura-1 downto 0 do
        eMatriz.Armazenar (X, Y, eMatriz.Retornar (X, Y) - eMatriz.Retornar (X, PosicaoPivo)*Escalar);
      eMatriz.Armazenar (PosicaoPivo, Y, 0.0);
    end;
end; // TriangularLinhas ()




// O sinal do DETERMINANTE muda quando se permuta 2 linhas
procedure Triangular (var Sinal: SmallInt);
var
  P, PosicaoPivo: LongInt;

begin
  Sinal:= 1;
  for P:= 0 to eMatriz.Altura-1 do
    if eMatriz.Retornar (P, P) <> 0 then
      TriangularLinhas (P, True)
    else if P < eMatriz.Altura then begin // Para evitar de permutar a última linha
      PosicaoPivo:= ProcurarNaoZero (P, P);
      if PosicaoPivo > 0 then begin
        Sinal:= -Sinal;
        PermutarLinhas (P, PosicaoPivo);
        TriangularLinhas (P, True);
      end;
    end;
end; // Triangular ()





function CalcularInversa: Boolean;
var
  P, PosicaoPivo: LongInt;
  Escalar       : Extended;

 procedure FazerPivoUm;
 var
   X    : LongInt;
   Valor: Extended;

 begin
   for X:= 0 to eMatriz.Largura-1 do begin
     Valor:= eMatriz.Retornar (X, P);
     if Valor <> 0 then
       eMatriz.Armazenar (X, P, Valor*Escalar);
   end;
 end; // FazerPivoUm ()

 procedure AnexarIdentidade;
 var
   I, X, Y: LongInt;

 begin
   I:= eMatriz.Largura div 2;
   for Y:= 0 to eMatriz.Altura-1 do
     for X:= I to eMatriz.Largura-1 do
       if X = Y+I then
         eMatriz.Armazenar (X, Y, 1.0)
       else
         eMatriz.Armazenar (X, Y, 0.0);
 end; // AnexarIdentidade ()

begin
  Result:= True;
  AnexarIdentidade;
  for P:= 0 to eMatriz.Altura-1 do
    if eMatriz.Retornar (P, P) <> 0 then begin
      TriangularLinhas (P, True);
      TriangularLinhas (P, False);
      Escalar:= 1/eMatriz.Retornar (P, P);
      FazerPivoUm;
    end
    else if P < eMatriz.Altura then begin // Para evitar de permutar a última linha
      PosicaoPivo:= ProcurarNaoZero (P, P);
      if PosicaoPivo > 0 then begin
        PermutarLinhas (P, PosicaoPivo);
        TriangularLinhas (P, True);
        TriangularLinhas (P, False);
        Escalar:= 1/eMatriz.Retornar (P, P);
        FazerPivoUm;
      end
      else begin
        Result:= False; // Determinante = 0
        Exit;
      end;
    end
    else begin
      Result:= False; // Determinante = 0
      Exit;
    end;
end; // CalcularInversa ()





function CalcularDeterminanteTriangulacao: Extended;
var
  Sinal: SmallInt;
  P    : LongInt;

begin
  Result:= 1.0;
  Triangular (Sinal);
  for P:= 0 to eMatriz.Altura-1 do
    Result:= Result*eMatriz.Retornar (P, P); // Multiplicar os elementos da Diagonal Principal
  Result:= Result*Sinal;
end; // CalcularDeterminanteTriangulacao ()

end.

// Final do Arquivo
