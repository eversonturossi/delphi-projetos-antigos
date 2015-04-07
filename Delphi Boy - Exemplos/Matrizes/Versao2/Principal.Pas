// Wheberson Hudson Migueletti, em Brasília, 17 de junho de 1999.
// Utilizando uma matriz alocada dinâmicamente

unit Principal;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Grids, Buttons, Menus, ComCtrls, ClipBrd;

type
  TFormPrincipal= class (TForm)
    Grid               : TStringGrid;
    CasasDecimais      : TUpDown;
    Colunas            : TUpDown;
    Linhas             : TUpDown;
    EditCasasDecimais  : TEdit;
    EditColunas        : TEdit;
    EditLinhas         : TEdit;
    DialogSalvar       : TSaveDialog;
    DialogAbrir        : TOpenDialog;
    Panel              : TPanel;
    Label1             : TLabel;
    Label2             : TLabel;
    Label3             : TLabel;
    MainMenu           : TMainMenu;
    MenuArquivo        : TMenuItem;
    MenuAbrir          : TMenuItem;
    MenuMatriz         : TMenuItem;
    MenuRandomico      : TMenuItem;
    MenuLimpar         : TMenuItem;
    MenuSalvar         : TMenuItem;
    MenuRetirarBrancos : TMenuItem;
    MenuOrdenar        : TMenuItem;
    MenuEditar         : TMenuItem;
    MenuCopiar         : TMenuItem;
    MenuColar          : TMenuItem;
    MenuRecortar       : TMenuItem;
    MenuInserir        : TMenuItem;
    MenuInserirCelula  : TMenuItem;
    MenuInserirLinha   : TMenuItem;
    MenuInserirColuna  : TMenuItem;
    MenuApagar         : TMenuItem;
    MenuApagarCelula   : TMenuItem;
    MenuApagarLinha    : TMenuItem;
    MenuApagarColuna   : TMenuItem;
    MenuDeterminante   : TMenuItem;
    MenuTriangular     : TMenuItem;
    MenuTransposta     : TMenuItem;
    MenuInversa        : TMenuItem;
    MenuPermutar       : TMenuItem;
    MenuPermutarLinhas : TMenuItem;
    MenuPermutarColunas: TMenuItem;
    MenuMultiplicar    : TMenuItem;
    N1                 : TMenuItem;
    N2                 : TMenuItem;

    procedure FormCreate               (Sender: TObject);
    procedure GridSetEditText          (Sender: TObject; ACol, ARow: Longint; const Value: string);
    procedure GridSelectCell           (Sender: TObject; Col, Row: Longint; var CanSelect: Boolean);
    procedure MenuAbrirClick           (Sender: TObject);
    procedure MenuSalvarClick          (Sender: TObject);
    procedure MenuRetirarBrancosClick  (Sender: TObject);
    procedure MenuDeterminanteClick    (Sender: TObject);
    procedure MenuTriangularClick      (Sender: TObject);
    procedure MenuTranspostaClick      (Sender: TObject);
    procedure MenuRandomicoClick       (Sender: TObject);
    procedure MenuLimparClick          (Sender: TObject);
    procedure MenuInserirCelulaClick   (Sender: TObject);
    procedure MenuInserirLinhaClick    (Sender: TObject);
    procedure MenuInserirColunaClick   (Sender: TObject);
    procedure MenuApagarCelulaClick    (Sender: TObject);
    procedure MenuApagarLinhaClick     (Sender: TObject);
    procedure MenuApagarColunaClick    (Sender: TObject);
    procedure EditColunasChange        (Sender: TObject);
    procedure EditLinhasChange         (Sender: TObject);
    procedure MenuCopiarClick          (Sender: TObject);
    procedure MenuColarClick           (Sender: TObject);
    procedure MenuRecortarClick        (Sender: TObject);
    procedure MenuOrdenarClick         (Sender: TObject);
    procedure MenuPermutarLinhasClick  (Sender: TObject);
    procedure MenuPermutarColunasClick (Sender: TObject);
    procedure MenuMultiplicarClick     (Sender: TObject);
    procedure MenuInversaClick         (Sender: TObject);
  private
    Atual      : TPoint;
    TamTabela  : Integer;
    NomeArquivo: String;

    function  CalcularTamanho: LongInt;
    function  CalcularLinhas: LongInt;
    procedure Salvar;
    procedure Ativar;
    procedure Preparar;
    procedure Limpar;
    procedure Ordenar;
    procedure GerarRandomicos;
    procedure CopiarGridParaMatriz;
    procedure CopiarMatrizParaGrid;
    procedure CopiarInversaParaGrid;
    procedure ConverterStrParaGrid (const S: String);
    function  RealParaStr          (Valor: Extended): String;
    function  StrParaReal          (Valor: String): Extended;
    function  CalcularPosicao      (Col, Lin: Integer): LongInt;
    function  CalcularCoord        (P: LongInt): TPoint;
    function  Retornar             (P: LongInt): String;
    procedure Armazenar            (P: LongInt; Celula: String);
    function  RetornarElemento     (P: LongInt): Extended;
    procedure ArmazenarElemento    (P: LongInt; Elemento: Extended);
    procedure ApagarCelula         (Col, Lin: Integer; Quant: LongInt);
    procedure ApagarNaLinha        (Col, Lin: Integer; Quant: LongInt);
    procedure ApagarColuna         (Col, Lin: Integer; Quant: LongInt);
    procedure InserirCelula        (Col, Lin: Integer; Quant: LongInt);
    procedure InserirNaLinha       (Col, Lin: Integer; Quant: LongInt);
    procedure InserirColuna        (Col, Lin: Integer; Quant: LongInt);
    function  ProcurarNaoBranco    (Col, Lin: Integer): LongInt;
  end;

var
  FormPrincipal: TFormPrincipal;

implementation

uses Math, Matriz, Permutar;



{$R *.DFM}

procedure TFormPrincipal.FormCreate (Sender: TObject);

begin
  Atual:= Point (0, 0);
  Randomize;
end;





procedure TFormPrincipal.GridSetEditText (Sender: TObject; ACol, ARow: LongInt; const Value: String);
var
  PosErro: Integer;
  Num    : Extended;

begin
  if Value <> '' then begin
    Val (Value, Num, PosErro);
    if PosErro <> 0 then
      MessageDlg ('"'+Value+'" não reconhecido !', mtError, [mbOk], 0);
  end;
end;





procedure TFormPrincipal.GridSelectCell (Sender: TObject; Col, Row: Longint; var CanSelect: Boolean);

begin
  Atual:= Point (Col, Row);
end;





procedure TFormPrincipal.MenuAbrirClick (Sender: TObject);

begin
  if DialogAbrir.Execute then begin
    NomeArquivo:= DialogAbrir.FileName;
    Ativar;
  end;
end;





procedure TFormPrincipal.MenuSalvarClick (Sender: TObject);

begin
  if DialogSalvar.Execute then begin
    NomeArquivo:= DialogSalvar.FileName;
    Salvar;
  end;
end;





procedure TFormPrincipal.MenuCopiarClick (Sender: TObject);
var
  X, Y: Integer;
  S   : String;

begin
  S:= '';
  for Y:= 0 to Grid.RowCount-1 do begin
    for X:= 0 to Grid.ColCount-1 do
      S:= S + ' ' + Grid.Cells[X, Y];
    S:= S + #10;
  end;
  S:= S + #0;
  Clipboard.SetTextBuf (PChar (S));
end;





procedure TFormPrincipal.MenuColarClick (Sender: TObject);

begin
  if Clipboard.HasFormat (CF_TEXT) then
    ConverterStrParaGrid (Clipboard.AsText);
end;





procedure TFormPrincipal.MenuRecortarClick (Sender: TObject);
var
  X, Y: Integer;
  S   : String;

begin
  S:= '';
  for Y:= 0 to Grid.RowCount-1 do begin
    for X:= 0 to Grid.ColCount-1 do begin
      S               := S + ' ' + Grid.Cells[X, Y];
      Grid.Cells[X, Y]:= '';
    end;
    S:= S + #10;
  end;
  S:= S + #0;
  Clipboard.SetTextBuf (PChar (S));
end;





procedure TFormPrincipal.MenuRetirarBrancosClick (Sender: TObject);

begin
  Preparar;
end;





procedure TFormPrincipal.MenuOrdenarClick (Sender: TObject);

begin
  Ordenar;
end;





procedure TFormPrincipal.MenuDeterminanteClick (Sender: TObject);

begin
  if Grid.ColCount = Grid.RowCount then begin
    eMatriz:= TMatriz.Create (Grid.ColCount, Grid.RowCount);
    if eMatriz.Status then begin
      CopiarGridParaMatriz;
      MessageDlg ('Determinante = ' + FloatToStr (CalcularDeterminanteTriangulacao), mtInformation, [mbOk], 0);
    end
    else
      MessageDlg ('Memória insuficiente !', mtError, [mbOk], 0);
    eMatriz.Free;
  end
  else
    MessageDlg ('A matriz deve ser quadrada !', mtError, [mbOk], 0);
end;





procedure TFormPrincipal.MenuTriangularClick (Sender: TObject);
var
  Sinal: SmallInt;

begin
  if Grid.ColCount = Grid.RowCount then begin
    eMatriz:= TMatriz.Create (Grid.ColCount, Grid.RowCount);
    if eMatriz.Status then begin
      CopiarGridParaMatriz;
      Triangular (Sinal);
      CopiarMatrizParaGrid;
    end
    else
      MessageDlg ('Memória insuficiente !', mtError, [mbOk], 0);
    eMatriz.Free;
  end
  else
    MessageDlg ('A matriz deve ser quadrada !', mtError, [mbOk], 0);
end;





procedure TFormPrincipal.MenuTranspostaClick (Sender: TObject);
var
  X, Y: Integer;

begin
  eMatriz:= TMatriz.Create (Grid.ColCount, Grid.RowCount);
  if eMatriz.Status then begin
    CopiarGridParaMatriz;
    with Grid do
      for Y:= 0 to RowCount-1 do
        for X:= 0 to ColCount-1 do
          Cells[X, Y]:= RealParaStr (eMatriz.Retornar (Y, X));
  end
  else
    MessageDlg ('Memória insuficiente !', mtError, [mbOk], 0);
  eMatriz.Free;
end;





procedure TFormPrincipal.MenuInversaClick (Sender: TObject);
var
  Sinal: SmallInt;
  
begin
  if Grid.ColCount = Grid.RowCount then begin
    eMatriz:= TMatriz.Create (Grid.ColCount*2, Grid.RowCount);
    if eMatriz.Status then begin
      CopiarGridParaMatriz;
      if CalcularInversa then
        CopiarInversaParaGrid
      else
        MessageDlg ('Não foi possível encontrar a Inversa !', mtError, [mbOk], 0);
    end
    else
      MessageDlg ('Memória insuficiente !', mtError, [mbOk], 0);
    eMatriz.Free;
  end
  else
    MessageDlg ('A matriz deve ser quadrada !', mtError, [mbOk], 0);
end;





procedure TFormPrincipal.MenuMultiplicarClick (Sender: TObject);
var
  X, Y   : LongInt;
  Escalar: Extended;
  Valor  : String;

begin
  Valor  := InputBox ('Escalar', 'Escalar:', '1');
  Escalar:= StrToFloat (Valor);
  for Y:= 0 to Grid.RowCount-1 do
    for X:= 0 to Grid.ColCount-1 do
      Grid.Cells[X, Y]:= RealParaStr (StrToFloat (Grid.Cells[X, Y])*Escalar);
end;





procedure TFormPrincipal.MenuRandomicoClick (Sender: TObject);

begin
  GerarRandomicos;
end;





procedure TFormPrincipal.MenuLimparClick (Sender: TObject);

begin
  Limpar;
end;





procedure TFormPrincipal.MenuInserirCelulaClick (Sender: TObject);

begin
  InserirCelula (Atual.X, Atual.Y, 1);
end;





procedure TFormPrincipal.MenuInserirLinhaClick (Sender: TObject);

begin
  InserirCelula (0, Atual.Y, Grid.ColCount);
end;





procedure TFormPrincipal.MenuInserirColunaClick (Sender: TObject);

begin
  InserirColuna (Atual.X, 0, Grid.RowCount);
end;





procedure TFormPrincipal.MenuApagarCelulaClick (Sender: TObject);

begin
  ApagarCelula (Atual.X, Atual.Y, 1);
end;





procedure TFormPrincipal.MenuApagarLinhaClick (Sender: TObject);

begin
  ApagarCelula (0, Atual.Y, Grid.ColCount);
end;





procedure TFormPrincipal.MenuApagarColunaClick (Sender: TObject);

begin
  ApagarColuna (Atual.X, 0, Grid.RowCount);
end;





procedure TFormPrincipal.MenuPermutarLinhasClick (Sender: TObject);
var
  X: Integer;
  
begin
  with FormPermutar do begin
    Origem.Max := Grid.RowCount;
    Destino.Max:= Grid.RowCount;
    if ShowModal = mrOk then
      for X:= 0 to Grid.ColCount-1 do
        Grid.Cols[X].Exchange (Origem.Position-1, Destino.Position-1);
  end;
end;





procedure TFormPrincipal.MenuPermutarColunasClick (Sender: TObject);
var
  Y: Integer;

begin
  with FormPermutar do begin
    Origem.Max := Grid.ColCount;
    Destino.Max:= Grid.ColCount;
    if ShowModal = mrOk then
      for Y:= 0 to Grid.RowCount-1 do
        Grid.Rows[Y].Exchange (Origem.Position-1, Destino.Position-1);
  end;
end;





procedure TFormPrincipal.EditColunasChange (Sender: TObject);

begin
  Grid.ColCount:= Colunas.Position;
end;





procedure TFormPrincipal.EditLinhasChange (Sender: TObject);

begin
  Grid.RowCount:= Linhas.Position;
end;





procedure TFormPrincipal.Ativar;
var
  Col, Lin: Word;
  Arq     : System.TextFile;
  Celula  : Extended;

begin
  // Ativa o arquivo
  AssignFile (Arq, NomeArquivo);
  Reset (Arq);

  // Insere os dados na tabela
  Grid.ColCount:= 1;
  Grid.RowCount:= 1;
  Col          := 0;
  Lin          := 0;
  while not EOF (Arq) do begin
    if EOLn (Arq) or SeekEOLn (Arq) then begin // DOS ou Windows
      Col:= 0;
      Inc (Lin);
      Grid.Rows[Grid.RowCount].Clear;
      ReadLn (Arq); // Se for a última linha vai para o fim do arquivo
      if not EOF (Arq) then
        Grid.RowCount:= Grid.RowCount + 1;
    end;
    if not EOF (Arq) then begin
      Read (Arq, Celula);
      Grid.Cells[Col, Lin]:= RealParaStr (Celula);
      Inc (Col);
      if Col > Grid.ColCount then
        Grid.ColCount:= Col;
    end;
  end;

  // Finaliza
  CloseFile (Arq);
  Linhas.Position := Grid.RowCount;
  Colunas.Position:= Grid.ColCount;
end; // Ativar ()




// Salva a tabela corrente em um arquivo
procedure TFormPrincipal.Salvar;
var
  X, Y    : Integer;
  QuantLin: LongInt;
  Arq     : System.TextFile;

begin
  AssignFile (Arq, NomeArquivo);
  Rewrite (Arq);

  for Y:= 0 to Grid.RowCount-1 do begin
    for X:= 0 to Grid.ColCount-1 do
      Write (Arq, Grid.Cells[X, Y] + ' ');
    WriteLn (Arq);
  end;
  
  CloseFile (Arq);
end; // Salvar ()




// Retirar os brancos intermediários 
procedure TFormPrincipal.Preparar;
var
  C, L : Integer;
  Quant: Integer;

begin
  for L:= 0 to Grid.RowCount-1 do begin
    for C:= 0 to Grid.ColCount-1 do
      if Grid.Cells[C, L] = '' then begin
        Quant:= ProcurarNaoBranco (C, L);
        if Quant > 0 then { Não deleta os últimos brancos }
          ApagarCelula (C, L, Quant)
        else begin
          TamTabela:= CalcularTamanho;
          Exit;
        end;
      end
      else
        Grid.Cells[C, L]:= RealParaStr (StrParaReal (Grid.Cells[C, L]));
    end;
  TamTabela:= CalcularTamanho;
end; // Preparar () 





procedure TFormPrincipal.Limpar;
var
  Y: Integer;

begin
  for Y:= 0 to Grid.RowCount-1 do
    Grid.Rows[Y].Clear;
end; // Limpar ()





procedure TFormPrincipal.Ordenar;
 procedure QuickSort (l, r: LongInt);
 var
   i, j: LongInt;
   x, y: Extended;

 begin
   i:= l; j:= r; x:= RetornarElemento ((l+r) div 2);
   repeat
     while RetornarElemento (i) < x do Inc (i);
     while x < RetornarElemento (j) do Dec (j);
     if i <= j then
     begin
       y:= RetornarElemento (i);
       ArmazenarElemento (i, RetornarElemento (j));
       ArmazenarElemento (j, y);
       Inc (i); Dec (j);
     end;
   until i > j;
   if l < j then QuickSort (l, j);
   if i < r then QuickSort (i, r);
 end;

var
  Tamanho: LongInt;

begin
  Tamanho:= CalcularTamanho;
  if Tamanho > 0 then
    QuickSort (0, Tamanho-1);
end; // Ordenar ()





procedure TFormPrincipal.GerarRandomicos;
var
  Col, Lin: Integer;

begin
  for Lin:= 0 to Grid.RowCount-1 do
    for Col:= 0 to Grid.ColCount-1 do
      Grid.Cells[Col, Lin]:= IntToStr (Random (Random (1000)));
end; // GerarRandomicos ()





procedure TFormPrincipal.CopiarGridParaMatriz;
var
  X, Y: Integer;

begin
  for Y:= 0 to Grid.RowCount-1 do
    for X:= 0 to Grid.ColCount-1 do
      if Grid.Cells[X, Y] = '' then
        eMatriz.Armazenar (X, Y, 0.0)
      else
        eMatriz.Armazenar (X, Y, StrToFloat (Grid.Cells[X, Y]));
end; // CopiarGridParaMatriz ()





procedure TFormPrincipal.CopiarMatrizParaGrid;
var
  X, Y: Integer;

begin
  for Y:= 0 to eMatriz.Altura-1 do
    for X:= 0 to eMatriz.Largura-1 do
      Grid.Cells[X, Y]:= RealParaStr (eMatriz.Retornar (X, Y));
end; // CopiarMatrizParaGrid ()





procedure TFormPrincipal.CopiarInversaParaGrid;
var
  I, X, Y: Integer;

begin
  I:= eMatriz.Largura div 2;
  for Y:= 0 to eMatriz.Altura-1 do
    for X:= I to eMatriz.Largura-1 do
      Grid.Cells[X-I, Y]:= RealParaStr (eMatriz.Retornar (X, Y));
end; // CopiarInversaParaGrid ()




// Utilizado para 'Colar'
procedure TFormPrincipal.ConverterStrParaGrid (const S: String);
var
  P, T  : Integer;
  X, Y  : Integer;
  Celula: String;

begin
  P            := 1;
  X            := 0;
  Y            := 0;
  T            := Length (S);
  Grid.ColCount:= 1;
  Grid.RowCount:= 1;

  while P <= T do begin
    Celula:= '';
    while (S[P] = ' ') and (P <= T) do
      Inc (P);
    while not (S[P] in [' ', #10, #13]) and (P <= T) do begin
      Celula:= Celula + S[P];
      Inc (P);
    end;
    Grid.Cells[X, Y]:= Celula;
    Inc (X);
    if X > Grid.ColCount then
      Grid.ColCount:= Grid.ColCount + 1;
    while (S[P] = ' ') and (P <= T)  do
      Inc (P);
    if S[P] in [#10, #13] then begin
      X:= 0;
      Inc (Y);
      Grid.Rows[Y].Clear;
      Grid.RowCount:= Grid.RowCount + 1;
      while (S[P] in [#10, #13]) and (P <= T) do
        Inc (P);
    end;
  end;
  Grid.RowCount   := Grid.RowCount - 1;
  Colunas.Position:= Grid.ColCount;
  Linhas.Position := Grid.RowCount;
end; // ConverterStrParaGrid ()




// Converte um Real para String
function TFormPrincipal.RealParaStr (Valor: Extended): String;

begin
  Str (Valor:0:CasasDecimais.Position, Result);
end; // RealParaStr ()




// Converte uma String para Real
function TFormPrincipal.StrParaReal (Valor: String): Extended;
var
  PosErro: Integer;

begin
  Val (Valor, Result, PosErro);
  if PosErro <> 0 then
    Result:= 0.0;
end; // StrParaReal () 




// Retorna o tamanho da tabela, ou seja, a posição do último não-branco
function TFormPrincipal.CalcularTamanho: LongInt;
var
  C, L    : Integer;
  Col, Lin: Integer;

begin
  Col   := -1;
  Lin   := -1;
  Result:= 0;
  for L:= 0 to Grid.RowCount-1 do
    for C:= 0 to Grid.ColCount-1 do
      if Grid.Cells[C, L] <> '' then begin
        Col:= C;
        Lin:= L;
      end;
  if not ((Col = -1) and (Lin = -1)) then
    Result:= CalcularPosicao (Col, Lin) + 1;
end; // CalcularTamanho () 




// Retorna a quantidade de linhas da tabela
function TFormPrincipal.CalcularLinhas: LongInt;
var
  T: LongInt;
  P: TPoint;

begin
  T:= CalcularTamanho;
  if T = 0 then
    Result:= 0
  else begin
    P     := CalcularCoord (T-1);
    Result:= P.Y + 1;
  end;
end; // CalcularLinhas ()




// Retorna o índice da tabela relativa ao par (Col, Lin)
function TFormPrincipal.CalcularPosicao (Col, Lin: Integer): LongInt;

begin
  // Origem = (0, 0)
  Result:= Lin*Grid.ColCount + Col;
end; // CalcularPosicao ()




// Retona o par (Col, Lin) relativo ao índice P da tabela
function TFormPrincipal.CalcularCoord (P: LongInt): TPoint;

begin
  // Origem = (0, 0) 
  Result:= Point (P mod Grid.ColCount, P div Grid.ColCount);
end; // CalcularCoord ()




// Retorna a string da célula da tabela cujo índice é P
function TFormPrincipal.Retornar (P: LongInt): String;

begin
  with CalcularCoord (P) do
    Retornar:= Grid.Cells[X, Y];
end; // Retornar ()




// Armazenar uma string na célula de posição P da tabela
procedure TFormPrincipal.Armazenar (P: LongInt; Celula: String);

begin
  if P < Grid.RowCount*Grid.ColCount then
    with CalcularCoord (P) do
      Grid.Cells[X, Y]:= Celula;
end; // Armazenar  ()




// Retorna o elemento da tabela cujo índice é P
function TFormPrincipal.RetornarElemento (P: LongInt): Extended;
var
  PosErro: Integer;

begin
  with CalcularCoord (P) do
    Val (Grid.Cells[X, Y], Result, PosErro);
  if PosErro <> 0 then
    Result:= 0.0;
end; // RetornarElemento ()




// Armazenar um elemento na posição P da tabela
procedure TFormPrincipal.ArmazenarElemento (P: LongInt; Elemento: Extended);

begin
  with CalcularCoord (P) do
    Grid.Cells[X, Y]:= RealParaStr (Elemento);
end; // ArmazenarElemento ()




// Deleta Quant células apartir de (Col, Lin)
procedure TFormPrincipal.ApagarCelula (Col, Lin: Integer; Quant: LongInt);

 function Buscar (Pos: LongInt): String;

 begin
   if Pos < TamTabela then
     Result:= Retornar (Pos)
   else
     Result:= '';
 end; // Buscar () 

var
  P: LongInt;

begin
  TamTabela:= CalcularTamanho;
  for P:= CalcularPosicao (Col, Lin) to TamTabela-1 do
    Armazenar (P, Buscar (P+Quant));
end; // ApagarCelula ()




// Apaga sem puxar as células da linha abaixo 
procedure TFormPrincipal.ApagarNaLinha (Col, Lin: Integer; Quant: LongInt);
var
  X: LongInt;

begin
  if Quant > 0 then begin
    for X:= Col to Grid.ColCount-Quant-1 do
      Grid.Cells[X, Lin]:= Grid.Cells[X+Quant, Lin];
    for X:= Grid.ColCount-Quant to Grid.ColCount-1 do
      Grid.Cells[X, Lin]:= '';
  end;
end; // ApagarNaLinha ()





procedure TFormPrincipal.ApagarColuna (Col, Lin: Integer; Quant: LongInt);
var
  Y: LongInt;

begin
  for Y:= Lin to Lin+Quant-1 do
    ApagarNaLinha (Col, Y, 1);
end; // ApagarColuna ()




// Insere Quant células em branco apartir de (Col, Lin)
procedure TFormPrincipal.InserirCelula (Col, Lin: Integer; Quant: LongInt);

 function Retirar (Pos: LongInt): String;

 begin
   Result:= Retornar (Pos);
   Armazenar (Pos, '');
 end; // Retirar ()

var
  P: LongInt;

begin
  TamTabela:= CalcularTamanho;
  for P:= TamTabela-1 downto CalcularPosicao (Col, Lin) do
    Armazenar (P+Quant, Retirar (P));
end; // InserirCelula ()




// Insere (apagando o que ultrapassa o final da linha) Quant células em branco na linha apartir de (Col, Lin)
procedure TFormPrincipal.InserirNaLinha (Col, Lin: Integer; Quant: LongInt);
var
  X: LongInt;

begin
  if Quant > 0 then begin
    for X:= Grid.ColCount-1 downto Col+Quant do
      Grid.Cells[X, Lin]:= Grid.Cells[X-1, Lin];
    for X:= Col to Col+Quant-1 do
      Grid.Cells[X, Lin]:= '';
  end;
end; // InserirNaLinha ()




// Insere uma coluna de Quant células em branco apartir de (Col, Lin)
procedure TFormPrincipal.InserirColuna (Col, Lin: Integer; Quant: LongInt);
var
  Y: LongInt;

begin
  for Y:= Lin to Lin+Quant-1 do
    InserirNaLinha (Col, Y, 1);
end; // InserirColuna ()




// Retorna o número de brancos (menos os últimos) a partir do atual
function TFormPrincipal.ProcurarNaoBranco (Col, Lin: Integer): LongInt;
var
  C, L : Integer;
  Quant: LongInt;

begin
  Quant := 0;
  Result:= 0;
  for L:= Lin to Grid.RowCount-1 do begin
    for C:= Col to Grid.ColCount-1 do
      if Grid.Cells[C, L] = '' then
        Inc (Quant)
      else begin
        Result:= Quant;
        Exit;
      end;
    Col:= 0;
  end;
end; // ProcurarNaoBranco ()

end.

// Final do Arquivo
