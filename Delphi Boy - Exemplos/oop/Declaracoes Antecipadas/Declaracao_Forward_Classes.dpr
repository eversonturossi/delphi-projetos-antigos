program Declaracao_Forward_Classes;

uses
  Forms,
  Exemplo in 'Exemplo.pas' {Form1},
  Unidade_Forward_de_Classes in 'Unidade_Forward_de_Classes.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
