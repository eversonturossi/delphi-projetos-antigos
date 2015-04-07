program PBiologo;

uses
  Forms,
  ufrmPrincipal in 'ufrmPrincipal.pas' {frmPrincipal};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Biomas Software v1.0 beta';
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.Run;
end.
