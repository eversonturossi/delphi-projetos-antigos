{ Wheberson Hudson Migueletti, em Cuiabá, 14 de março de 1994.
  Arquivo: DelphiMat.Pas (10/09/98)
  Últimas alterações: 18/10/97, 10/09/98.
  Rotinateca de Apoio.

      Neste arquivo estão rotinas para serem usadas por outros
  programas, constituindo uma rotinateca.
      As rotinas são todas matemáticas.
}

unit DelphiMat;

interface

function Pot       (X, N: Extended): Extended;
function Raiz      (X: Extended; N: LongInt): Extended;
function Casas     (Num: LongInt): Byte;
function Mdc       (X, Y: Integer): Integer;
function Mmc       (X, Y: Integer): Integer;
function Fat       (N: Word): Extended;
function Rad       (G: Extended): Extended;
function Graus     (Rad: Extended): Extended;
function AntiLog   (X: Extended): Extended;
function AntiLog2  (X: Extended): Extended;
function AntiLogN  (Base, X: Extended): Extended;
function Somatorio (const Vet: array of Double): Extended;
function Media     (const Vet: array of Double): Extended;
function ValorMin  (const Vet: array of Double): Double;
function ValorMax  (const Vet: array of Double): Double;

implementation

uses Math;




{ Calcula X elevado a N }
function Pot (X,          { Número }
              N: Extended { Potência }
             ): Extended;

 function PotInt (N: LongInt): Extended;
 var
   Y  : LongInt;
   Res: Extended;

 begin
   Y  := Abs (N);
   Res:= 1.0;
   while Y > 0 do begin
     while not Odd (Y) do begin
       Y:= Y shr 1;
       X:= X * X
     end;
     Dec (Y);
     Res:= Res* X;
   end;
   if N < 0 then
     Res:= 1.0/Res;
   PotInt:= Res;
 end; { PotInt () }

begin
  if N = 0.0 then
    Pot:= 1.0
  else if (X = 0.0) and (N > 0.0) then
    Result:= 0.0
  else if (Frac (N) = 0.0) and (Abs (N) <= MaxInt) then
    Pot:= PotInt (Trunc (N))
  else if X > 0.0 then
    Pot:= Exp (N * Ln (X));
end; { Pot () }




{ Calcula a raiz n-‚zima de X, ou seja, X elevado a 1/N }
function Raiz (X: Extended; N: LongInt): Extended;

begin
  Raiz:= Pot (X, 1/N);
end; { Raiz () }




{ Calcula quantas casas decimais (dígitos) tem um n£mero inteiro }
function Casas (Num: LongInt): Byte;
var
  Quant: Byte;    { Quantidade de dígitos }
  Divis: LongInt; { Divisíveis por 10 }

begin
  Quant:= 0;
  Divis:= Abs (Num);
  repeat
    Divis:= Divis div 10;
    Inc (Quant);
  until Divis = 0;
  Casas:= Quant;
end; { Casas () }




{ Rotina que calcula o mdc de dois números, 16/03/94 }
function Mdc (X,Y: Integer): Integer;
var
  Aux, Dividendo, Divisor, Resp: Integer;

begin
  if (X > 0) and (Y > 0) then begin
    if X > Y then begin
      Dividendo:= X;
      Divisor  := Y;
    end
    else begin
      Dividendo:= Y;
      Divisor  := X;
    end;
    repeat
      Aux      := Divisor;
      Divisor  := Dividendo mod Divisor;
      Dividendo:= Aux;
    until Divisor = 0;
    Resp:= Aux;
  end
  else if ((X = 0) and (Y = 0)) or (X < 0) or (Y < 0) then
    Resp:= 0
  else if X = 0 then
    Resp:= Y
  else
    Resp:= X;
  Mdc:= Resp;
end; { Mdc () }




{ Rotina que calcula o mmc de dois n£meros, 16/03/94 }
function Mmc (X,Y: Integer): Integer;
var
  Aux: Integer;

begin
  if (X <= 0) or (Y <= 0) then
    Mmc:= 0
  else begin
    Aux:= Mdc (X,Y);
    Mmc:= (X div Aux)*(Y div Aux)*Aux;
  end;
end; { Mmc () }




// Calcula o fatorial de N 
function Fat (N: Word): Extended;
var
  K: Word;

begin
  if N = 0 then
    Result:= 1
  else begin
    Result:= N;
    for K:= N-1 downto 2 do
      Result:= Result*K;
  end;
end; // Fat ()




// Converte graus para radianos 
function Rad (G: Extended // Valor em graus
             ): Extended;

begin
  Rad:= (G*Pi)/180.0;
end; // Rad () 




// Converte radianos para graus
function Graus (Rad: Extended // Valor em radianos 
               ): Extended;

begin
  Graus:= (180.0*Rad)/Pi;
end; // Graus ()





function AntiLog (X: Extended): Extended;

begin
  AntiLog:= Pot (10, X);
end; // AntiLog ()





function AntiLog2 (X: Extended): Extended;

begin
  AntiLog2:= Pot (2, X);
end; // AntiLog2 () 





function AntiLogN (Base, X: Extended): Extended;

begin
  AntiLogN:= Pot (Base, X);
end; // AntiLogN () 





function Somatorio (const Vet: array of Double): Extended;
var
  I: Integer;
  Res: Extended;

begin
  Res:= 0.0;
  for I:= Low (Vet) to High (Vet) do
    Res:= Res + Vet[I];
  Somatorio:= Res;
end; { Somatorio () }





function Media (const Vet: array of Double): Extended;
var
  I: Integer;

begin
  Media:= Somatorio (Vet)/(High (Vet) - Low (Vet) + 1)
end; // Media () 





function ValorMin (const Vet: array of Double): Double;
var
  I: Integer;
  Menor: Double;

begin
  Menor:= Vet[Low (Vet)];
  for I:= Low (Vet) + 1 to High (Vet) do
    if Vet[I] < Menor then
      Menor:= Vet[I];
  ValorMin:= Menor;
end; { ValorMin () }





function ValorMax (const Vet: array of Double): Double;
var
  I: Integer;
  Maior: Double;

begin
  Maior:= Vet[Low (Vet)];
  for I:= Low (Vet) + 1 to High (Vet) do
    if Vet[I] > Maior then
      Maior:= Vet[I];
  ValorMax:= Maior;
end; { ValorMax () }

end.

// Final do Arquivo 