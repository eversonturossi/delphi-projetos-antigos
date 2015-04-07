program FSockServ;

uses
  Forms,
  ServUnit in 'ServUnit.pas' {Form1},
  common in 'common.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
