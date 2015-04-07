program Thread;

uses
  Forms,
  Principal in 'Principal.Pas' {FormPrincipal};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TFormPrincipal, FormPrincipal);
  Application.Run;
end.
