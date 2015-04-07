program Cliente;

uses
  Forms,
  Cli_Center in 'Cli_Center.pas' {FrmCenter};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFrmCenter, FrmCenter);
  Application.Run;
end.
