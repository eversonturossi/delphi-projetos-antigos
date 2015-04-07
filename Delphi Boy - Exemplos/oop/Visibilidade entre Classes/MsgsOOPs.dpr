program MsgsOOPs;

uses
  Forms,
  Unidade_Programa in 'Unidade_Programa.pas' {Form1},
  OOPClasses in 'OOPClasses.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
