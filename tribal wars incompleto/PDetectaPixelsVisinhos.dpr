program PDetectaPixelsVisinhos;

uses
  Forms,
  uDetectaPixelsVisinhos in 'uDetectaPixelsVisinhos.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
