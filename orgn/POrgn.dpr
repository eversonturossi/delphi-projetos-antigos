program POrgn;

uses
  Forms,
  uOrgn in 'uOrgn.pas' {frmPrincipal},
  uFunctions in 'uFunctions.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.Run;
end.
