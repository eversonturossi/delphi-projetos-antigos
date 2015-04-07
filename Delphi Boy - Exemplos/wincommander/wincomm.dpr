program wincomm;

uses
  Forms,
  comm in 'comm.pas' {Form1},
  movedlg in 'movedlg.pas' {Form2},
  aboutbox in 'aboutbox.pas' {aboutdlg};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'WinCommander - by QuicKSanD';
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(Taboutdlg, aboutdlg);
  Application.Run;
end.
