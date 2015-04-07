unit Unidade_Programa;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, OOPClasses;

type
  TForm1 = class(TForm)
    RadioGroupTipoIcone: TRadioGroup;
    Button1: TButton;
    Label1: TLabel;
    MemoCorpoMsg: TMemo;
    CheckBoxMesagem: TCheckBox;
    Label2: TLabel;
    EditTituloMsg: TEdit;
    CheckBoxOperacao: TCheckBox;
    RadioGroupTipoOperacao: TRadioGroup;
    Calcular: TButton;
    EditPrimeiroValor: TEdit;
    EditSegundoValor: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    procedure CheckBoxMesagemClick(Sender: TObject);
    procedure CheckBoxOperacaoClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure EditPrimeiroValorKeyPress(Sender: TObject; var Key: Char);
    procedure CalcularClick(Sender: TObject);
  private
    OOPClass : TOOPClass;
    OOPClassDescendente : TOOPClassDescendente;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.CheckBoxMesagemClick(Sender: TObject);
begin
  //habilita os controles de acordo com o estado contrario de checagem do outro checkbox.
  CheckBoxOperacao.Enabled        := Not(CheckBoxMesagem.Checked);
  RadioGroupTipoOperacao.Enabled  := Not(CheckBoxMesagem.Checked);
  EditPrimeiroValor.Enabled       := Not(CheckBoxMesagem.Checked);
  EditSegundoValor.Enabled        := Not(CheckBoxMesagem.Checked);
  Calcular.Enabled                := Not(CheckBoxMesagem.Checked);
end;

procedure TForm1.CheckBoxOperacaoClick(Sender: TObject);
begin
  //habilita os controles de acordo com o estado contrario de checagem do outro checkbox.
  CheckBoxMesagem.Enabled     := Not(CheckBoxOperacao.Checked);
  RadioGroupTipoIcone.Enabled := Not(CheckBoxOperacao.Checked);
  MemoCorpoMsg.Enabled        := Not(CheckBoxOperacao.Checked);
  EditTituloMsg.Enabled       := Not(CheckBoxOperacao.Checked);
  Button1.Enabled             := Not(CheckBoxOperacao.Checked);
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  //se nao estiver checado entao.
  if not(CheckBoxMesagem.Checked) then
  begin
    //mostra mensagem.
    MessageBox(Handle,
               'Selecione um dos Dois Tipo de Objetos para Continuar...',
               PChar(Form1.Caption),
               MB_ICONWARNING);
    //poe o foco no Check do Objeto de mensagem.
    CheckBoxMesagem.SetFocus;
    //sai.
    Exit;
  end;//if-then.

  //escolha o indice selecionado...
  case RadioGroupTipoIcone.ItemIndex of
       //se ja fomos instanciados entao...
    0: begin
          if OOPClass <> nil then
            //se nao temos os edits em branco entao...
            if (EditTituloMsg.Text <> '') and
               (MemoCorpoMsg.Text <> '')  then
               //chama o metodo do objeto...
               OOPClass.ShowMessageEx(MemoCorpoMsg.Text,
                                      EditTituloMsg.Text,
                                      itInformation)
            else
              MessageBox(handle,
                         'Existe Campos Obrigatorios em Branco...',
                         PChar(Form1.Caption),
                         MB_ICONSTOP);
       end;
       //se ja fomos instanciados entao...
    1: begin
         if OOPClass <> nil then
            //se nao temos os edits em branco entao...
            if (EditTituloMsg.Text <> '') and
               (MemoCorpoMsg.Text <> '')  then
               //chama o metodo do objeto...
               OOPClass.ShowMessageEx(MemoCorpoMsg.Text,
                                      EditTituloMsg.Text,
                                      itQuestion)
            else
              MessageBox(handle,
                         'Existe Campos Obrigatorios em Branco...',
                         PChar(Form1.Caption),
                         MB_ICONSTOP);
       end;
       //se ja fomos instanciados entao...
    2: begin
         if OOPClass <> nil then
            //se nao temos os edits em branco entao...
            if (EditTituloMsg.Text <> '') and
               (MemoCorpoMsg.Text <> '')  then
               //chama o metodo do objeto...
               OOPClass.ShowMessageEx(MemoCorpoMsg.Text,
                                      EditTituloMsg.Text,
                                      itStop)
            else
              MessageBox(handle,
                         'Existe Campos Obrigatorios em Branco...',
                         PChar(Form1.Caption),
                         MB_ICONSTOP);
       end;
       //se ja fomos instanciados entao...
    3: begin
          if OOPClass <> nil then
            //se nao temos os edits em branco entao...
            if (EditTituloMsg.Text <> '') and
               (MemoCorpoMsg.Text <> '')  then
               //chama o metodo do objeto...
               OOPClass.ShowMessageEx(MemoCorpoMsg.Text,
                                      EditTituloMsg.Text,
                                      itWarning)
            else
              MessageBox(handle,
                         'Existe Campos Obrigatorios em Branco...',
                         PChar(Form1.Caption),
                         MB_ICONSTOP);
      end;
  end;//case.
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  //iniciando o Objetos.
  OOPClass := nil;
  OOPClassDescendente := nil;

  //instanciando os Objetos.
  OOPClass := TOOPClass.Create;
  OOPClassDescendente := TOOPClassDescendente.Create;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
OOPClass.Free;
OOPClassDescendente.Free;
end;

procedure TForm1.EditPrimeiroValorKeyPress(Sender: TObject; var Key: Char);
begin
  //se teclamos um '.' entao...
  if Key = ThousandSeparator then
  begin
   //recebe uma virgula.
   Key := DecimalSeparator;
   //sai.
   Exit;
  end;

  //se nao temos numero entao...
  if not(Key in ['0'..'9', #08]) then
    //anula a tecla.
    Key := #0;
end;

procedure TForm1.CalcularClick(Sender: TObject);
begin
 if not(CheckBoxOperacao.Checked) then
 begin
    //mostra mensagem.
    MessageBox(Handle,
               'Selecione um dos Dois Tipo de Objetos para Continuar...',
               PChar(Form1.Caption),
               MB_ICONWARNING);
    //poe o foco no Check do Objeto de mensagem.
    CheckBoxOperacao.SetFocus;
    //sai.
    Exit;
 end;//if-then.

  //escolha o indice selecionado...
  case RadioGroupTipoOperacao.ItemIndex of
       //se ja fomos instanciados entao...
    0: begin
         if OOPClassDescendente <> nil then
            //se nao temos os edits em branco entao...
            if (EditPrimeiroValor.Text <> '') and
               (EditSegundoValor.Text <> '')  then
               //chama o metodo do objeto...
               OOPClassDescendente.ChooseOperation(StrToFloat(EditPrimeiroValor.Text),
                                                   StrToFloat(EditSegundoValor.Text),
                                                   otSoma)
            else
              MessageBox(handle,
                         'Existe Campos Obrigatorios em Branco...',
                         PChar(Form1.Caption),
                         MB_ICONSTOP);
       end;
       //se ja fomos instanciados entao...
    1: begin
          if OOPClassDescendente <> nil then
              //se nao temos os edits em branco entao...
              if (EditPrimeiroValor.Text <> '') and
                 (EditSegundoValor.Text <> '')  then
                 //chama o metodo do objeto...
                 OOPClassDescendente.ChooseOperation(StrToFloat(EditPrimeiroValor.Text),
                                                     StrToFloat(EditSegundoValor.Text),
                                                     otSubtracao)
            else
              MessageBox(handle,
                         'Existe Campos Obrigatorios em Branco...',
                         PChar(Form1.Caption),
                         MB_ICONSTOP)
       end;
       //se ja fomos instanciados entao...
    2: begin
         if OOPClassDescendente <> nil then
            //se nao temos os edits em branco entao...
            if (EditPrimeiroValor.Text <> '') and
               (EditSegundoValor.Text <> '')  then
               //chama o metodo do objeto...
               OOPClassDescendente.ChooseOperation(StrToFloat(EditPrimeiroValor.Text),
                                                   StrToFloat(EditSegundoValor.Text),
                                                   otMultplicacao)
          else
            MessageBox(handle,
                       'Existe Campos Obrigatorios em Branco...',
                       PChar(Form1.Caption),
                       MB_ICONSTOP);
       end;
       //se ja fomos instanciados entao...
    3: begin
          if OOPClassDescendente <> nil then
              //se nao temos os edits em branco entao...
              if (EditPrimeiroValor.Text <> '') and
                 (EditSegundoValor.Text <> '')  then
                 //chama o metodo do objeto...
                 OOPClassDescendente.ChooseOperation(StrToFloat(EditPrimeiroValor.Text),
                                                     StrToFloat(EditSegundoValor.Text),
                                                     otDivisao)
            else
              MessageBox(handle,
                         'Existe Campos Obrigatorios em Branco...',
                         PChar(Form1.Caption),
                         MB_ICONSTOP);
      end;
  end;//case.

end;//

end.
