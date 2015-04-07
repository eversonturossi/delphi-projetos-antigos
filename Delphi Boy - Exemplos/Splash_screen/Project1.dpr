{
Demo: Realisierung eines Splash-Screen

(c) 1998 Rainer Reusch & Toolbox
}

program Project1;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  Unit2 in 'Unit2.pas' {FormSplash};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TFormSplash, FormSplash);
  Application.Run;
end.
