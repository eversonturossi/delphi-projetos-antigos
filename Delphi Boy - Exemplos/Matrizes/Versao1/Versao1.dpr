program Versao1;

uses
  Forms,
  Principal in 'Principal.Pas' {FormPrincipal},
  Matriz in 'Matriz.Pas',
  Permutar in 'Permutar.Pas' {FormPermutar};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TFormPrincipal, FormPrincipal);
  Application.CreateForm(TFormPermutar, FormPermutar);
  Application.Run;
end.
