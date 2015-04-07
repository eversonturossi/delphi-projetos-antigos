{
 UNIT criada por Ernesto R.T - DelphiBoy com o intuito de ajudar os DelphiManíacos BRASILeiros.
 Esta UNIT é totalmente OpenSource e livre para distribuição e alteração.
------------------------------------------------------------------------------------------------
 www.red.not.br/delphiboy - admin@red.not.br - ICQ:337457532 - #DelphiX na BrasNet.
 Ernesto R.T - DelphiBoy
 Rio de Janeiro, RJ - Brasil
}
unit DelphiBoy;
interface
{FUNÇÕES - INÍCIO}
function AlterarResolucaoDoVideo(X, Y: word): Boolean;
function ANSICaixaAlta(const S: string): string;
function ANSICaixaBaixa(const S: string): string;
function BugDoAno2000: Boolean;
function BugDoPentium: integer;
function CalcularDistancia(const X1, Y1, X2, Y2: Extended): Extended;
function CaminhoDeUmArquivo(const NomeDoArquivo: string): string;
function ClonarPrograma(CaminhoDoExecutavel: string): string;
function ContarCaracteres(Edit: string): integer;
function ContarLinhasDeUmArquivo(Arqtexto: string): integer;
function ContarPalavrasNumaString(str: string): integer;
function ConverterANSIparaASCII(str: string): string;
function ConverterBinarioParaInteiro(Value: string): LongInt;
function ConverterBytesEmInteger(Valor: Longint): string;
function ConverterDataBRparaEUA(Data: string): string;
function ConverterHEXparaINTEGER(const HexStr: string): longint;
function ConverterHoraParaMinutos(Hora: string): Integer;
function ConverterStringEmLongInt(InStr: string): LongInt;
function ConverterStringEmReal(InStr: string): Real;
function CriarArquivo(const NomeDoArquivo: string): Integer;
function CriarDiretorio(const Dir: string): Boolean;
function DataDaBIOS: string;
function DataDeUmArquivo(const NomeDoArquivo: string): TDateTime;
function DataPorExtenso(Data: TDateTime): string;
function DescricaoDeUmArquivo(const NomeDoArquivo: string): string;
function DiretorioTEMPorario: string;
function GerarPercentual(valor: real; Percentual: Real): real;
function Inteiro_PARouIMPAR(TestaInteiro: Integer): boolean;
function SerialDoHD(Unidade: string): string;
{FUNÇÕES - FINAL}
{PROCEDIMENTOS - INÍCIO}
procedure AtivarProtecaoDeTela;
procedure AjustarForm(Sender: TObject);
procedure ColarViaAPI;
procedure CopiarArquivosComMascara(Alvo, Destino: string);
procedure CopiarViaAPI;
procedure DeletarDiretorio(CaminhoDoDiretorio: string);
procedure DesativarUmaTecla(Key: integer);
procedure DesfazerViaAPI;
procedure RecortarViaAPI;
{PROCEDIMENTOS - FINAL}
implementation
uses
 Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
 Dialogs, ShellAPI;
// Número serial do HD.

function SerialDoHD(Unidade: string): string;
var
 Serial: DWord;
 DirLen, Flags: DWord;
 DLabel: array[0..11] of Char;
begin try
  GetVolumeInformation(PChar(Unidade + ':\'), dLabel, 12, @Serial, DirLen, Flags, nil, 0);
  Result := IntToHex(Serial, 8);
 except
  Result := '';
 end;
end;
// Ajustar Form de acordo com a tela

procedure AjustarForm(Sender: TObject);
var
 R: TRect;
 DC: HDc;
 Canv: TCanvas;
begin
 R := Rect(0, 0, Screen.Width, Screen.Height);
 DC := GetWindowDC(GetDeskTopWindow);
 Canv := TCanvas.Create;
 Canv.Handle := DC;
 Canv.CopyRect(R, Canv, R);
 ReleaseDC(GetDeskTopWindow, DC);
end;
// Alterar resolução do vídeo

function AlterarResolucaoDoVideo(X, Y: word): Boolean;
var
 lpDevMode: TDeviceMode;
begin
 if EnumDisplaySettings(nil, 0, lpDevMode) then
  lpDevMode.dmFields := DM_PELSWIDTH or DM_PELSHEIGHT;
 lpDevMode.dmPelsWidth := X;
 lpDevMode.dmPelsHeight := Y;
 Result := ChangeDisplaySettings(lpDevMode, 0) = DISP_CHANGE_SUCCESSFUL;
end;
// ANSI em maiúscula

function ANSICaixaAlta(const S: string): string;
var
 Len: Integer;
begin
 Len := Length(S);
 SetString(Result, PChar(S), Len);
 if Len > 0 then CharUpperBuff(Pointer(Result), Len);
end;
// ANSI em minúscula

function ANSICaixaBaixa(const S: string): string;
var
 Len: Integer;
begin
 Len := Length(S);
 SetString(Result, PChar(S), Len);
 if Len > 0 then CharLowerBuff(Pointer(Result), Len);
end;
// Ativar a proteção de tela

procedure AtivarProtecaoDeTela;
begin
 SendMessage(Application.Handle, WM_SYSCOMMAND, SC_SCREENSAVE, 0);
end;
// Testa se o Windows está preparado para o ano 2000

function BugDoAno2000: Boolean;
begin
 Result := (Length(DateToStr(Now)) <> 10);
end;
// Verifica a existência do Bug fatal do Pentium.

function BugDoPentium: integer;
const
 tstBugVal1: single = 4195835.0;
 tstBugVal2: single = 3145727.0;
var
 Answer: double;
begin
{$U-}
 Answer := tstBugVal1 / tstBugVal2;
{$U+}
 if tstBugVal1 - Answer * tstBugVal2 > 1.0 then begin
   BUGDoPentium := 0;
  end
 else
  begin
   BUGDoPentium := 1;
  end;
end;
// Calcular distância

function CalcularDistancia(const X1, Y1, X2, Y2: Extended): Extended;
var
 X, Y: Extended;
begin
 X := Abs(X1 - X2);
 Y := Abs(Y1 - Y2);
 if X > Y then
  Result := X * Sqrt(1 + Sqr(Y / X))
 else if Y <> 0 then
  Result := Y * Sqrt(1 + Sqr(X / Y))
 else
  Result := 0
end;
// Gera o percentual de um valor

function GerarPercentual(valor: real; Percentual: Real): real;
begin
 Percentual := Percentual / 100;
 try
  valor := valor * Percentual;
 finally
  result := valor;
 end; end;
// Retorna a pasta temporária do Windows

function DiretorioTEMPorario: string;
var
 pNetPath: array[0..MAX_PATH - 1] of Char;
 nLength: Cardinal;
begin
 nLength := MAX_PATH;
 FillChar(pNetPath, SizeOF(pNetPath), #0);
 GetTempPath(nLength, pNetPath);
 Result := StrPas(pNetPath);
end;
// Retorna o caminho do arquivo especificado

function CaminhoDeUmArquivo(const NomeDoArquivo: string): string;
var
 I: Integer;
begin
 I := LastDelimiter('\:', NomeDoArquivo);
 Result := Copy(NomeDoArquivo, 1, I);
end;
// Verificar se um campo inteiro é PAR ou ÍMPAR.

function Inteiro_PARouIMPAR(TestaInteiro: Integer): boolean;
begin if (TestaInteiro div 2) = (TestaInteiro / 2) then
  result := True
 else
  result := False;
end;
// Gerar clone de um programa

function ClonarPrograma(CaminhoDoExecutavel: string): string;
var
 pi: TProcessInformation;
 si: TStartupInfo;
begin
 FillMemory(@si, sizeof(si), 0);
 si.cb := sizeof(si);
 CreateProcess(nil, PChar(CaminhoDoExecutavel), nil, nil, False, NORMAL_PRIORITY_CLASS, nil, nil, si, pi);
 CloseHandle(pi.hProcess);
 CloseHandle(pi.hThread);
end;
// Colar via API

procedure ColarViaAPI;
begin
 SendMessage(GetFocus, WM_PASTE, 0, 0);
end;
// Copiar via API

procedure CopiarViaAPI;
begin
 SendMessage(GetFocus, WM_COPY, 0, 0);
end;
// Desfazer via API

procedure DesfazerViaAPI;
begin
 SendMessage(GetFocus, WM_UNDO, 0, 0);
end;
// Recortar via API

procedure RecortarViaAPI;
begin
 SendMessage(GetFocus, WM_CUT, 0, 0);
end;
// Contador de caracteres

function ContarCaracteres(Edit: string): integer;
begin
 Result := Length(Edit);
end;
// Contador de linhas de um arquivo

function ContarLinhasDeUmArquivo(Arqtexto: string): integer;
var
 f: Textfile;
 cont: integer;
begin
 cont := 0;
 AssignFile(f, Arqtexto);
 Reset(f);
 while not eof(f) do
  begin
   ReadLn(f);
   Cont := Cont + 1;
  end;
 Closefile(f);
 result := cont;
end;
// Contador de palavras numa String

function ContarPalavrasNumaString(str: string): integer;
var
 count: integer;
 i: integer;
 len: integer;
begin
 len := length(str);
 count := 0;
 i := 1;
 while i <= len do begin
   while ((i <= len) and ((str[i] = #32) or (str[i] = #9) or (Str[i] = ';'))) do
    inc(i);
   if i <= len then
    inc(count);
   while ((i <= len) and ((str[i] <> #32) and (str[i] <> #9) and (Str[i] <> ';'))) do
    inc(i);
  end;
 ContarPalavrasNumaString := count;
end;
// Converter ANSI para ASCII

function ConverterANSIparaASCII(str: string): string;
var
 i: Integer;
begin
 for i := 1 to Length(str) do
  begin
   case str[i] of
    'á': str[i] := 'a';
    'é': str[i] := 'e';
    'í': str[i] := 'i';
    'ó': str[i] := 'o';
    'ú': str[i] := 'u';
    'à': str[i] := 'a';
    'è': str[i] := 'e';
    'ì': str[i] := 'i';
    'ò': str[i] := 'o';
    'ù': str[i] := 'u';
    'â': str[i] := 'a';
    'ê': str[i] := 'e';
    'î': str[i] := 'i';
    'ô': str[i] := 'o';
    'û': str[i] := 'u';
    'ä': str[i] := 'a';
    'ë': str[i] := 'e';
    'ï': str[i] := 'i';
    'ö': str[i] := 'o';
    'ü': str[i] := 'u';
    'ã': str[i] := 'a';
    'õ': str[i] := 'o';
    'ñ': str[i] := 'n';
    'ç': str[i] := 'c';
    'Á': str[i] := 'A';
    'É': str[i] := 'E';
    'Í': str[i] := 'I';
    'Ó': str[i] := 'O';
    'Ú': str[i] := 'U';
    'À': str[i] := 'A';
    'È': str[i] := 'E';
    'Ì': str[i] := 'I';
    'Ò': str[i] := 'O';
    'Ù': str[i] := 'U';
    'Â': str[i] := 'A';
    'Ê': str[i] := 'E';
    'Î': str[i] := 'I';
    'Ô': str[i] := 'O';
    'Û': str[i] := 'U';
    'Ä': str[i] := 'A';
    'Ë': str[i] := 'E';
    'Ï': str[i] := 'I';
    'Ö': str[i] := 'O';
    'Ü': str[i] := 'U';
    'Ã': str[i] := 'A';
    'Õ': str[i] := 'O';
    'Ñ': str[i] := 'N';
    'Ç': str[i] := 'C';
   end;
  end;
 Result := str;
end;
// Converter binário para inteiro

function ConverterBinarioParaInteiro(Value: string): LongInt;
var
 i, Size: Integer;
begin
 Result := 0;
 Size := Length(Value);
 for i := Size downto 0 do begin if Copy(Value, i, 1) = '1' then begin
     Result := Result + (1 shl i);
    end; end; end;
// Converter Bytes em Integer

function ConverterBytesEmInteger(Valor: Longint): string;
const
 KBYTE = Sizeof(Byte) shl 10;
 MBYTE = KBYTE shl 10;
 GBYTE = MBYTE shl 10;
begin
 if Valor > GBYTE then
  begin
   Result := FloatToStrF(Round(Valor / GBYTE), ffNumber, 6, 0) + ' GB';
  end
 else if Valor > MBYTE then
  begin
   Result := FloatToStrF(Round(Valor / MBYTE), ffNumber, 6, 0) + ' MB';
  end
 else if Valor > KBYTE then
  begin
   Result := FloatToStrF(Round(Valor / KBYTE), ffNumber, 6, 0) + ' KB';
  end
 else
  begin
   Result := FloatToStrF(Round(Valor), ffNumber, 6, 0) + ' Byte';
  end;
end;
// Converte dd/mm/yyyy(BR) para mm/dd/yyyy(EUA).

function ConverterDataBRparaEUA(Data: string): string;
begin
 Result := Copy(Data, 4, 3) + Copy(Data, 1, 3) + Copy(Data, 7, 4);
end;
// Converte Hexadecimal em Integer

function ConverterHEXparaINTEGER(const HexStr: string): longint;
var
 iNdx: integer;
 cTmp: Char;
begin
 Result := 0;
 for iNdx := 1 to Length(HexStr) do begin
   cTmp := HexStr[iNdx];
   case cTmp of
    '0'..'9': Result := 16 * Result + (Ord(cTmp) - $30);
    'A'..'F': Result := 16 * Result + (Ord(cTmp) - $37);
    'a'..'f': Result := 16 * Result + (Ord(cTmp) - $57);
    else raise EConvertError.Create('Illegal character in hex string');
   end;
  end;
end;
// Converte hora (formato HH:MM) para minutos

function ConverterHoraParaMinutos(Hora: string): Integer;
begin
 Result := (StrToInt(Copy(Hora, 1, 2)) * 60) + StrToInt(Copy(Hora, 4, 2));
end;
// Converter String em LongInt

function ConverterStringEmLongInt(InStr: string): LongInt;
var
 Temp, Code: integer;
begin
 result := 0;
 Val(InStr, Temp, Code);
 if Code = 0 then result := Temp;
end;
// Converte String em Real

function ConverterStringEmReal(InStr: string): Real;
var
 Code: Integer;
 Temp: Real;
begin
 Result := 0;
 if Copy(InStr, 1, 1) = '.' then
  InStr := '0' + InStr;
 if (Copy(InStr, 1, 1) = '-') and (Copy(InStr, 2, 1) = '.') then
  Insert('0', InStr, 2);
 if InStr[length(InStr)] = '.' then
  Delete(InStr, length(InStr), 1);
 Val(InStr, Temp, Code);
 if Code = 0 then
  Result := Temp;
end;
// Copiar arquivos
// Utilize asteristico para a seleção dos arquivos. Ex.: c:\*.*  ou *.txt

procedure CopiarArquivosComMascara(Alvo, Destino: string);
var
 FOS: TSHFileOpStruct;
 CopySourceString: string;
 CopyDestString: string;
begin
 ZeroMemory(@FOS, sizeof(TSHFileOpStruct));
 CopySourceString := Alvo + #0#0;
 CopyDestString := Destino;
 with FOS do begin
   Wnd := Application.Handle;
   wFunc := FO_COPY;
   pFrom := Pchar(CopySourceString);
   pTo := Pchar(CopyDestString);
   fFlags := FOF_SIMPLEPROGRESS;
   fAnyOperationsAborted := True;
   lpszProgressTitle := Pchar(Application.Title);
  end;
 SHFileOperation(FOS);
end;
// Criar arquivo

function CriarArquivo(const NomeDoArquivo: string): Integer;
begin
 Result := Integer(CreateFile(PChar(NomeDoArquivo), GENERIC_READ or GENERIC_WRITE,
  0, nil, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0));
end;
// Criar diretório

function CriarDiretorio(const Dir: string): Boolean;
begin
 Result := CreateDirectory(PChar(Dir), nil);
end;
// Retorna a data da BIOS

function DataDaBIOS: string;
begin
 result := string(pchar(ptr($FFFF5)));
end;
// Retorna a data do arquivo indicado

function DataDeUmArquivo(const NomeDoArquivo: string): TDateTime;
begin
 Result := FileDateToDateTime(FileAge(NomeDoArquivo));
end;
// Retorna a data atual por extenso

function DataPorExtenso(Data: TDateTime): string;
var
 NoDia: Integer;
 DiaDaSemana: array[1..7] of string;
 Meses: array[1..12] of string;
 Dia, Mes, Ano: Word;
begin
 DiaDasemana[1] := 'Domingo';
 DiaDasemana[2] := 'Segunda-feira';
 DiaDasemana[3] := 'Terça-feira';
 DiaDasemana[4] := 'Quarta-feira';
 DiaDasemana[5] := 'Quinta-feira';
 DiaDasemana[6] := 'Sexta-feira';
 DiaDasemana[7] := 'Sábado';
 Meses[1] := 'Janeiro';
 Meses[2] := 'Fevereiro';
 Meses[3] := 'Março';
 Meses[4] := 'Abril';
 Meses[5] := 'Maio';
 Meses[6] := 'Junho';
 Meses[7] := 'Julho';
 Meses[8] := 'Agosto';
 Meses[9] := 'Setembro';
 Meses[10] := 'Outubro';
 Meses[11] := 'Novembro';
 Meses[12] := 'Dezembro';
 DecodeDate(Data, Ano, Mes, Dia);
 NoDia := DayOfWeek(Data);
 Result := DiaDaSemana[NoDia] + ', ' + inttostr(Dia) + ' de ' + Meses[Mes] + ' de ' + inttostr(Ano);
end;
// Remove um diretório

procedure DeletarDiretorio(CaminhoDoDiretorio: string);
var
 search: TSearchRec;
 nFiles: integer;
begin
 nFiles := FindFirst(CaminhoDoDiretorio + '\*.*', faAnyFile, search);
 while nFiles = 0 do
  begin
   if Search.Attr = faDirectory then
    begin
     if (Search.Name <> '.') and (Search.Name <> '..') then
      begin
       DeletarDiretorio(CaminhoDoDiretorio + '\' + Search.Name);
       RMDir(CaminhoDoDiretorio + '\' + Search.Name);
      end;
    end
   else
    begin
     SysUtils.DeleteFile(CaminhoDoDiretorio + '\' + Search.Name);
    end;
   nFiles := FindNext(Search);
  end;
 SysUtils.FindClose(Search);
 RMDir(CaminhoDoDiretorio);
end;
// Desativa uma determinada tecla

procedure DesativarUmaTecla(Key: integer);
var
 KeyState: TKeyboardState;
begin
 GetKeyboardState(KeyState);
 if (KeyState[Key] = 1) then begin
   KeyState[Key] := 0;
  end;
 SetKeyboardState(KeyState);
end;
// Retorna a descrição de um determinado arquivo

function DescricaoDeUmArquivo(const NomeDoArquivo: string): string;
var
 aInfo: TSHFileInfo;
begin
 if SHGetFileInfo(PChar(NomeDoArquivo), 0, aInfo, Sizeof(aInfo), SHGFI_TYPENAME) <> 0 then
  Result := StrPas(aInfo.szTypeName)
 else begin
   Result := ExtractFileExt(NomeDoArquivo);
   Delete(Result, 1, 1);
   Result := Result + ' File';
  end;
end;
{
 UNIT criada por Ernesto R.T - DelphiBoy com o intuito de ajudar os DelphiManíacos BRASILeiros.
 Esta UNIT é totalmente OpenSource e livre para distribuição e alteração.
------------------------------------------------------------------------------------------------
 www.red.not.br/delphiboy - admin@red.not.br - ICQ:337457532 - #DelphiX na BrasNet.
 Ernesto R.T - DelphiBoy
 Rio de Janeiro, RJ - Brasil
}
end.
.
