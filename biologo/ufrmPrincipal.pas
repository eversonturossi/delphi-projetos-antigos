unit ufrmPrincipal;

interface

uses
 Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
 Dialogs, ComCtrls, StdCtrls, ExtCtrls, TFlatRadioButtonUnit,
 TFlatCheckBoxUnit, TFlatHintUnit, TFlatGaugeUnit, TFlatButtonUnit;

type
 QuestoesObjetivas = record
  pergunta: string;
  AlternativaA: string;
  AlternativaB: string;
  AlternativaC: string;
  AlternativaD: string;
  AlternativaE: string;
  Objetiva: Boolean;
  Resposta: string;
 end;
 
 TfrmPrincipal = class(TForm)
  StatusBar1: TStatusBar;
  Panel1: TPanel;
  edtNome: TEdit;
  btnEntar: TButton;
  Label1: TLabel;
  Panel2: TPanel;
  FlatHint1: TFlatHint;
  progresso: TFlatGauge;
  edtResposta: TEdit;
  wPergunta: TMemo;
  wRespostaE: TFlatRadioButton;
  wRespostaD: TFlatRadioButton;
  wRespostaC: TFlatRadioButton;
  wRespostaB: TFlatRadioButton;
  wRespostaA: TFlatRadioButton;
  btnProxima: TFlatButton;
  btnFinalizar: TFlatButton;
  lblTxt: TLabel;
  procedure btnEntarClick(Sender: TObject);
  procedure FormCreate(Sender: TObject);
  procedure Perguntas;
  procedure btnProximaClick(Sender: TObject);
  procedure btnFinalizarClick(Sender: TObject);
 private
  { Private declarations }
 public
  { Public declarations }
 end;
 
var
 frmPrincipal: TfrmPrincipal;
 nome: string;
 arquivo: TextFile;
 Bioma: array of QuestoesObjetivas;
 NrPergunta: integer;
implementation

{$R *.dfm}

procedure TfrmPrincipal.btnEntarClick(Sender: TObject);
begin
 if edtNome.Text <> '' then
  begin
   Panel1.Visible := false;
   Panel2.Visible := true;
   btnEntar.Default := false;
   nome := edtNome.Text;
   NrPergunta := 0;
   Perguntas;
   frmPrincipal.Caption := 'Biomas Software v1.0 beta - Seja Bem Vindo(a), ' + nome + ', tenha um bom trabalho.';
  end
 else
  ShowMessage('Por favor digitar seu nome.');
end;

procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin
 StatusBar1.Panels[0].Text := ' A l u n o s :   J o n a s ,   S a m u e l ,  S  é r g i o ,   S i l v i a ';
 SetLength(Bioma, 10);
 Bioma[0].pergunta := 'A região do nosso planeta ocupada pelos seres vivos constitui a(o):';
 Bioma[0].AlternativaA := 'Biosfera';
 Bioma[0].AlternativaB := 'Biocora';
 Bioma[0].AlternativaC := 'Biologia';
 Bioma[0].AlternativaD := 'Bioma';
 Bioma[0].AlternativaE := 'Nicho Ecológico';
 Bioma[0].Objetiva := true;
 
 Bioma[1].pergunta := 'Um grande ecossistema, onde estão presentes clima, vegetação e animais da região, é conhecido por:';
 Bioma[1].AlternativaA := 'Bioma';
 Bioma[1].AlternativaB := 'Biocenose';
 Bioma[1].AlternativaC := 'Biosfera';
 Bioma[1].AlternativaD := 'Biótipo';
 Bioma[1].AlternativaE := 'Biomassa';
 Bioma[1].Objetiva := true;
 
 Bioma[2].pergunta := 'Bioma constituído principalmente por liquens e musgos que vegetam num período muito curto do ano localiza-se no _______ e é conhecido por ________.';
 Bioma[2].AlternativaA := 'Pólo Ártico - Taiga';
 Bioma[2].AlternativaB := 'Pólo Austral - Tundra';
 Bioma[2].AlternativaC := 'Pólo Antártico - Floresta de Coníferas';
 Bioma[2].AlternativaD := 'Pólo Ártico - Tundra';
 Bioma[2].AlternativaE := 'Equador - Floresta Latifoliada';
 Bioma[2].Objetiva := true;
 
 Bioma[3].pergunta := 'Pertencem ao nécton:';
 Bioma[3].AlternativaA := 'todos os habitantes dos mares que nadam ativamente;';
 Bioma[3].AlternativaB := 'todos os habitantes dos mares, fixos ou rastejantes do substrato abissal;';
 Bioma[3].AlternativaC := 'todos os habitantes dos mares, fixos ou rastejantes do substrato litorâneo;';
 Bioma[3].AlternativaD := 'todos os habitantes dos mares que vivem flutuando no oceano;';
 Bioma[3].AlternativaE := 'todos os animais microscópicos do substrato abissal ou litorâneo.';
 Bioma[3].Objetiva := true;
 
 Bioma[4].pergunta := 'Dos biociclos que integram a Biosfera, qual o que diz respeito à flora e à fauna marinhas?';
 Bioma[4].AlternativaA := 'talassociclo';
 Bioma[4].AlternativaB := 'limnociclo';
 Bioma[4].AlternativaC := 'epinociclo';
 Bioma[4].AlternativaD := 'limnobiose';
 Bioma[4].AlternativaE := 'biociclo';
 Bioma[4].Objetiva := true;
 
 Bioma[5].pergunta := 'O que são biociclos?';
 Bioma[5].Objetiva := false;
 
 Bioma[6].pergunta := 'O biociclo terrestre pode ser dividido em seis Biomas. Quais são eles?';
 Bioma[6].Objetiva := false;
 
 Bioma[7].pergunta := 'Quais são as zonas em que se pode dividir o ambiente marinho quanto à luz?';
 Bioma[7].Objetiva := false;
 
 Bioma[8].pergunta := 'Como é dividido o Limnociclo?';
 Bioma[8].Objetiva := false;
end;

procedure TfrmPrincipal.Perguntas;

begin
 wPergunta.Clear;
 wPergunta.Lines.Add(Bioma[NrPergunta].pergunta);
 if Bioma[NrPergunta].Objetiva = true then
  begin
   wRespostaA.Checked := false;
   wRespostaB.Checked := false;
   wRespostaC.Checked := false;
   wRespostaD.Checked := false;
   wRespostaE.Checked := false;
   wRespostaA.Caption := Bioma[NrPergunta].AlternativaA;
   wRespostaB.Caption := Bioma[NrPergunta].AlternativaB;
   wRespostaC.Caption := Bioma[NrPergunta].AlternativaC;
   wRespostaD.Caption := Bioma[NrPergunta].AlternativaD;
   wRespostaE.Caption := Bioma[NrPergunta].AlternativaE;

  end
 else
  begin
   wRespostaA.Visible := false;
   wRespostaB.Visible := false;
   wRespostaC.Visible := false;
   wRespostaD.Visible := false;
   wRespostaE.Visible := false;
   edtResposta.Visible := true;
   edtResposta.Clear;
   edtResposta.SetFocus;
  end;
 if NrPergunta = 9 then
  begin
   edtResposta.Visible := false;
   btnProxima.Enabled := false;
   btnFinalizar.Enabled := true;
   lblTxt.Visible := true;
  end;
end;

procedure TfrmPrincipal.btnProximaClick(Sender: TObject);
begin
 // if NrPergunta <= 8 then
 //  begin
 if Bioma[NrPergunta].Objetiva = true then
  if (wRespostaA.Checked = true) or (wRespostaB.Checked = true) or (wRespostaC.Checked = true) or (wRespostaD.Checked = true)
   or (wRespostaE.Checked = true) then
   begin
    if wRespostaA.Checked then
     Bioma[NrPergunta].Resposta := wRespostaA.Caption;
    if wRespostaB.Checked then
     Bioma[NrPergunta].Resposta := wRespostaB.Caption;
    if wRespostaC.Checked then
     Bioma[NrPergunta].Resposta := wRespostaC.Caption;
    if wRespostaD.Checked then
     Bioma[NrPergunta].Resposta := wRespostaD.Caption;
    if wRespostaE.Checked then
     Bioma[NrPergunta].Resposta := wRespostaE.Caption;
    NrPergunta := NrPergunta + 1;
    Perguntas
   end
  else
   begin
    ShowMessage('Por favor ' + nome + ' selecione uma das alternativas.')
   end
 else
  if edtResposta.Text = '' then
   begin
    ShowMessage('Por favor ' + nome + ' mesmo que não saiba escreve alguma coisa aqui.');
    edtResposta.SetFocus;
   end
  else
   begin
    Bioma[NrPergunta].Resposta := edtResposta.Text;
    NrPergunta := NrPergunta + 1;
    Perguntas;
   end;
 progresso.Progress := trunc((NrPergunta / 9) * 100);
end;

procedure TfrmPrincipal.btnFinalizarClick(Sender: TObject);
var
 contador: integer;
 p, r: string;
begin
 AssignFile(arquivo, nome + '.txt');
 Rewrite(arquivo);
 for contador := 0 to 8 do
  begin
   p := Bioma[contador].pergunta;
   r := Bioma[contador].Resposta;
   Writeln(arquivo, 'P: ' + p);
   Writeln(arquivo, 'R: ' + r);
   Writeln(arquivo, '------------------------------------------------------');
  end;
 CloseFile(arquivo);
 close;
end;

end.

