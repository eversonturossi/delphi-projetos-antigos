program appservidor;

uses
  Forms,
  servidor in 'servidor.pas' {frmServidor};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfrmServidor, frmServidor);
  Application.Run;
end.
