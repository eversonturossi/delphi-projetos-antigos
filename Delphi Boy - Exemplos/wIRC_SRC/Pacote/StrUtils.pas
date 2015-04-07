unit StrUtils;
{
-ooooooooooooooooooooooooooooooooooooooooooooooooooooooo-
-o Título: Manipulação de strings                      o-
-o Descrição: Várias rotinas para tratamentos diversos o-
-o em strings                                          o-
-o Autor: Waack3(Davi Ramos)                           o-
-o Última modificação: 01/03/02 16:30                  o-
-o As descrições individuais estão abaixo:             o-
-ooooooooooooooooooooooooooooooooooooooooooooooooooooooo-
}

interface
type
  TSplitArray = array of string;
  TDirEstilete = (deEsquerda, deDireita);

function InverterStr(Texto: string): string;
function Estilete(Texto: string; Ponto: integer; Direcao: TDirEstilete): string;
function PegarStr(Texto: string; Inicio: integer; Fim: integer): string;
function Substituir(Texto: string; String1: char; String2: char): string;
function CodiCgi(Texto: string): string;
function Split(const Source, Delimiter: String): TSplitArray;
function Posicao(Parte: string; Texto: string; Inicio: integer): integer;
procedure Chomp(var Texto: string);

implementation
uses
  SysUtils;

//Inverte leitura dos caracteres de uma string(Waack3)
function InverterStr;
var
  ContLetra: integer;

begin
  for ContLetra:=Length(Texto) downto 1 do
    result:=result + Texto[ContLetra];
end;

//Corta e retorna um lado inteiro de uma string de acordo com o ponto
//especificado(Waack3)
function Estilete;
var
  ContLetra: integer;

begin
  if ((Ponto >= 1) and (Ponto <= length(Texto))) then
  begin
    case Direcao of
      deEsquerda:
      begin
        for ContLetra:=Ponto downto 1 do
          result:=result + Texto[ContLetra];
        result:=InverterStr(result);
      end;
      deDireita:
      begin
        for ContLetra:=Ponto to Length(Texto) do
          result:=result + Texto[ContLetra];
      end;
    end;
  end
  else
    result:='';
end;

//Retorna parte de uma string(especificando suas limitações)(Waack3)
function PegarStr;
var
  Tamanho: integer;

begin
  if ((Length(Texto) < Inicio) or (Inicio > Fim)) then
    result:=''
  else
  begin
    Tamanho:=(Fim - Inicio) + 1;
    result:=Copy(Texto,Inicio,Tamanho);
  end;
end;

//Substitui um caractere por outro em uma string(Waack3)
function Substituir;
var
  ContLetra: integer;

begin
  if Length(Texto) = 0 then
    result:='';
  for ContLetra:=1 to Length(Texto) do
  begin
    if Texto[ContLetra] = String1 then
      Texto[ContLetra] := String2;
  end;
  result:=Texto;
end;

//Codifica o texto para ser recebido por um script CGI(Waack3)
function CodiCgi;
var
  ContLetra: integer;
  NovoChr: string;

begin
  for ContLetra:=1 to Length(Texto) do
    if Texto[ContLetra] in ['0'..'9','A'..'Z','a'..'z'] then
      result:=result + Texto[ContLetra]
    else
    begin
      NovoChr:='%' + IntToHex(Ord(Texto[ContLetra]),2);
      result:=result + NovoChr;
    end;
end;

//Divide uma string em várias partes(autor desconhecido)
function Split(const Source, Delimiter: String): TSplitArray;
var
  iCount: Integer;
  iPos: Integer;
  iLength: Integer;
  sTemp: String;
  aSplit: TSplitArray;

begin
  sTemp:=Source;
  iCount:=0;
  iLength:=Length(Delimiter) - 1;
  repeat
    iPos:=Pos(Delimiter, sTemp);
    if iPos = 0 then
      break
    else
    begin
      Inc(iCount);
      SetLength(aSplit, iCount);
      aSplit[iCount - 1]:=Copy(sTemp, 1, iPos - 1);
      Delete(sTemp, 1, iPos + iLength);
    end;
  until False;
  if Length(sTemp) > 0 then
  begin
    Inc(iCount);
    SetLength(aSplit, iCount);
    aSplit[iCount - 1]:=sTemp;
  end;
  result:=aSplit;
  end;

//Implementação aperfeiçoada da função Pos(Waack3)
function Posicao;
var
  ContLetra: integer;
  TmpString: string;

begin
  result:=0;
  for ContLetra:=Inicio to Length(Texto) do
  begin
    TmpString:=PegarStr(Texto, ContLetra, (ContLetra + (Length(Parte))) - 1);
    if (TmpString = Parte) then
    begin
      result:=ContLetra;
      break;
    end;
  end;
end;

//Retira quebra de linha
procedure Chomp;
var
  TamTotal: integer;
  Carac: string[2];

begin
  TamTotal:=Length(Texto);
  Carac[1]:=Texto[TamTotal - 1]; //Penúltimo caractere
  Carac[2]:=Texto[TamTotal];     //Último caractere

  if ((Carac[1] = #13) and (Carac[2] = #10)) then
    Delete(Texto, TamTotal - 1, 2)
  else if ((Carac[2] = #13) or (Carac[2] = #10)) then
    Delete(Texto, TamTotal, 1);       
end;

end.
