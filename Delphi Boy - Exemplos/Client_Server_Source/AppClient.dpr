program AppClient;

uses
  Windows,
  Dialogs,
  Forms,
  uMainClient in 'uMainClient.pas' {fMain},
  uCommon in 'uCommon.pas';

{$R *.RES}
{$R Resources.RES}

begin
  if OpenMutex(MUTEX_ALL_ACCESS, False, 'APPCLIENT') <> 0 then begin
    MessageBeep(MB_ICONERROR);
    MessageDlg('Este aplicativo já está sendo executado!', mtError, [mbOK], 0);
  end else begin
    CreateMutex(nil, False, 'APPCLIENT');
    Application.Initialize;
    Application.Title := 'Atualizador de Aplicações';
    Application.CreateForm(TfMain, fMain);
  Application.Run;
  end;
end.
