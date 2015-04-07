program Servidor;

uses
  Forms,
  Center in 'Center.pas' {FrmCenter},
  Plugins in 'Plugins.pas' {FrmPlugins};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFrmCenter, FrmCenter);
  Application.CreateForm(TFrmPlugins, FrmPlugins);
  Application.Run;
end.
