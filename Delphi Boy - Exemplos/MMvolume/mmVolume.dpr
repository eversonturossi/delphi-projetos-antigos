program mmVolume;

uses
  Forms,
  uVolMain in 'uVolMain.pas' {FrmMMVolMain};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TFrmMMVolMain, FrmMMVolMain);
  Application.Run;
end.
