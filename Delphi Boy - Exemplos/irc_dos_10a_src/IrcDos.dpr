program IrcDos;

uses
  Forms,
  Center in 'Center.pas' {FrmCenter},
  Rotinas in 'Rotinas.pas',
  U_Info in 'U_Info.pas' {FrmInfo},
  U_List in 'U_List.pas' {FrmList};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TFrmCenter, FrmCenter);
  Application.CreateForm(TFrmInfo, FrmInfo);
  Application.CreateForm(TFrmList, FrmList);
  Application.Run;
end.
