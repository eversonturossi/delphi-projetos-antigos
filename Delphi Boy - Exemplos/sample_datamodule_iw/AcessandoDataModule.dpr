program AcessandoDataModule;

uses
  Forms,
  IWMain,
  ServerController in 'ServerController.pas' {IWServerController: TIWServerController},
  MainFrm in 'MainFrm.pas' {IWForm2: TIWFormModuleBase},
  UserSession in 'UserSession.pas' {IWUserSession: TIWUserSessionBase},
  MainDM in 'MainDM.pas' {DMMain: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TformIWMain, formIWMain);
  Application.Run;
end.
