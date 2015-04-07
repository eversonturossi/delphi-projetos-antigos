program AppSrv;

uses
  Windows,
  Dialogs,
  Forms,
  uMainSrv in 'uMainSrv.pas' {fMain},
  uCommon in 'uCommon.pas';

{$R *.RES}

begin
  if OpenMutex(MUTEX_ALL_ACCESS, False, 'APPSRVR') <> 0 then begin
    MessageBeep(MB_ICONERROR);
    MessageDlg('Este aplicativo já está sendo executado!', mtError, [mbOK], 0);
  end else begin
    CreateMutex(nil, False, 'APPSRVR');
    Application.Initialize;
    Application.Title := 'Atualizador de Aplicações - Servidor';
    Application.CreateForm(TfMain, fMain);
  Application.ShowMainForm := False;
    Application.Run;
  end;
end.
