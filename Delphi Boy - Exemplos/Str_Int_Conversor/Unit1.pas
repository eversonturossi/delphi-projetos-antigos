{==========================================================================}
{       Coded by
       	          Mr_Geek : )

        www.dbmsoft.kit.net

        dbmsoft@linuxmail.org

        #Geeks #SourceX #DelphiX

              ________                              _     _____
              ___  __ \_____    __          _   ___(_)_  / /¯¯¯
              __  / / /_  _ \  / /         / /  __  /\ \/ /
              _  /_/ / /  __/ / /_  /¯¯¯¯// -¯\ _  /  \ \/
              /_____/  \___/ /____//  ¯ //_//_/ /_/   / /\_____
                                  / /¯¯¯       ¯  ___/ /\      \
                                 /_/              ¯¯¯¯¯  ¯¯¯¯¯¯¯

Agradecimentos especiais:
- kiyo ( efnet ) que me ajudou com:
* valor := ord(Texto[cont]) - $30;
* resultado := resultado + (char($30 + num));

- LordCrc ( #Delphi - efnet) que me ajudou com a função:
function digits(num: integer; base: integer = 10): integer;
var
t: extended; digits: integer;
begin
t:= ln(abs(num)) / ln(base);
result:= trunc(t)+1;
end;
que serve pra fazer um "length" em números;

- #DelphiX da Brasnet claro hehehe


O QUE ESSE PROGRAMA FAZ:
-Converte String para Integer;
-Converte Integer para String;
A DIFERENÇA É QUE NÃO USEI AS FUNÇÕES IntToStr e StrToInt e nem usei val
(apesar de ser uma função nativa)
                                                                           }
{==========================================================================}


unit Unit1;

interface

uses
  Forms, Buttons, Spin, StdCtrls, Controls, Classes;

type
  TForm1 = class(TForm)
    GroupBox1: TGroupBox;
    Edit1: TEdit;
    SpinEdit1: TSpinEdit;
    GroupBox2: TGroupBox;
    Edit2: TEdit;
    SpinEdit2: TSpinEdit;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

{
Eu fiz essa função apenas para achar as potencias de base 10 de acordo com a posição de cada 
número.
Exemplo: se o expoente for 5... o resultado será 100000, se for 2 o resultado sera 10² = 100 ...
abaixo eu explico pra que preciso dela...
}
function potencia(expoente: integer): integer;
var
num, cont: integer;
begin
num := 1;
if expoente = 1 then num := 10 else
for cont := 0 to expoente-1 do
num := num * 10;
result := num;
end;
//essa é a função que converte em si a string pra integer. Ela utiliza a função acima
function converterStr2Int(Texto: string):integer;
var
cont, valor, resultado: integer;
S: string;
begin
For cont := Length(Texto) DownTo 0 do S:=S+Texto[cont]; texto := S;  {inverte a string. Abaixo
explico porque inverti ...}
resultado:= 0;
for cont := 1 to length(Texto)-1 do //le cada um dos caracteres da string à ser convertida...
begin
valor := ord(Texto[cont]) - $30; {ve se o caracter é '0' .. '9' e faz a var VALOR ser igual
à seu enquivalente em inteiro}
if cont = 1 then  //se a string só tiver 1 caracter... o resultado já é o equivalente
resultado := valor else // se só tiver 1 caracter já tá pronto o resultado hehe, do contrário ...
resultado := resultado + (potencia(cont-1) * (valor));
{essa potência serve para separar os algarismos em dezena, centena, milhar... e depois somá-los
ou seja ... 423 é o mesmo que 400 + 20 + 3 .. então primeiro somamos o 3, depois multiplicamos o 2
por 10 porque ele é dezena e somamos no 3 aí dá 23, então multiplicamos o 4 por 100 porque ele é 
centena somamos no 23.. dando 423.
Eu só inverti os caracteres para poder começar trabalhando com o de unidade... depois passar para 
o de dezena, centena... em ordem crescente porque assim eu poderia aproveitar a posição deles com
o for que fiz acima e usar ela na função potencia().}
end;
result := resultado;
end;
//essa função pega o número de caracteres de um inteiro. é o mesmo que length() pra uma string
function digits(num: integer; base: integer = 10): integer;
var
t: extended; digits: integer;
begin
 t:= ln(abs(num)) / ln(base);
result:= trunc(t)+1;
end;

Function ConverterInt2Str(Valor: Integer): string;
var
cont, num: integer;
resultado: string;
begin
resultado := '';
for cont := digits(valor) downto 1 do //faz um loop com o número de caracteres do numero total
begin
num := valor div (potencia(cont-1));
{aqui eu fiz com que ele dividisse o número para que ficasse +- assim: x,xxxx e peguei só o
inteiro.. por exemplo .. se o numero fosse 652 dividiria por 100, daria 6,52.. pegaria só o 6
(parte inteira) aí nó próximo loop, excluiria o 6 (veja isso na próxima 2ª linha de código ) e
faria isso com o 5... depois excluiria o 5 e pegaria o 2.}
resultado := resultado + (char($30 + num)); {pega o caracter inteiro e faz a var resultado
valer o que ela vale + o equivalente EM STRING do algarismo atual (aquele que foi pego na
linha acima}
valor := (valor - (num * potencia(cont-1)));
{Aqui usei a potência novamente para multiplicar pelo inteiro que eu tinha pego e excluir ele
do número... exemplo ... em 652, pegaria o 6 como inteiro, acrecentaria '6' à string depois
ele seria multiplicado por 100 e daria 600... aí seria feito 652 - 600 = 52 ...}
end;
result := resultado;
end;

//exemplo de como usar a função de conversão de String para Integer
procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
SpinEdit1.Value := converterStr2Int(edit1.text);
end;

//exemplo de como usar a função de conversão de Integer para String
procedure TForm1.SpeedButton2Click(Sender: TObject);
begin
edit2.Text := converterint2str(spinedit2.value);
end;

end.
