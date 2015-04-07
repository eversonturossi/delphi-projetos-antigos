program Find_And_Replace_Word_in_a_File;

uses
  Forms,
  FormMain in 'FormMain.pas' {MainForm},
  FormAbout in 'FormAbout.pas' {AboutForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
