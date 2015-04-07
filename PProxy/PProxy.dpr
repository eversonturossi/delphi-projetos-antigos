program PProxy;

uses
  Forms,
  uProxy in 'uProxy.pas' {Form1},
  uNavegador in 'uNavegador.pas' {NavegadorProxy: TFrame},
  uConfiguracoes in 'uConfiguracoes.pas',
  GruposDownload in 'GruposDownload.pas';

{$R *.res}



begin
 Application.Initialize;
 Application.CreateForm(TForm1, Form1);
  Application.Run;

end.

