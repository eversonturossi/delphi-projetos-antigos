unit Exemplo;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation
  uses Unidade_Forward_de_Classes;

{$R *.DFM}

procedure TForm1.Button1Click(Sender: TObject);
var
  MyCalculateClass : TCalculateClass;
begin
  //instanciando o Objeto....
  MyCalculateClass := TCalculateClass.Create;

  //pegamos os Valores necessários para o calculo...
  MyCalculateClass.Base     := StrToFloat(Edit1.Text);
  MyCalculateClass.Expoente := StrToInt(Edit2.Text);

  //mostrando o valor de retorno da propriedade...
  ShowMessage(FloatToStr(MyCalculateClass.ResutlValue));
end;

procedure TForm1.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  //se inserimos um ponto entao....
  if Key = ThousandSeparator then
    //trocamos por uma virgula....
    Key := DecimalSeparator;
  if not(Key in ['0'..'9','.', #08]) then
    Key := #0;
end;

end.
