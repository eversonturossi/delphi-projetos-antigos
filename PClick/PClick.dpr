program PClick;

uses
 Forms,
 uClick in 'uClick.pas' {Form1};

{$R *.res}

begin
 Application.Initialize;
 Application.CreateForm(TForm1, Form1);
 Application.ShowMainForm := false;
 Application.Run;
end.

