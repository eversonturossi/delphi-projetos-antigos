program CreateWindow;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  U_Window in 'U_Window.pas' {FrmWindow};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TFrmWindow, FrmWindow);
  Application.Run;
end.
