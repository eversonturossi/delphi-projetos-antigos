program Str_Int_Conversor;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Str & Int Conversor by Mr_Geek';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
