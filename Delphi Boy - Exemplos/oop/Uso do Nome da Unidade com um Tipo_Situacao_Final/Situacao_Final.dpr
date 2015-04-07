program Situacao_Final;

uses
  Forms,
  Unidade_A in 'Uso do Nome da Unidade com um Tipo_Situacao_Final\Unidade_A.pas',
  Unidade_C in 'Uso do Nome da Unidade com um Tipo_Situacao_Final\Unidade_C.pas',
  Unidade_B in 'Unidade_B.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
