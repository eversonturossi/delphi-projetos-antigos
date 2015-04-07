program RTMChat;

uses
  Forms,
  RTMCh in 'RTMCh.pas' {Chat},
  Config1 in 'Config1.pas' {Config2},
  Sobre1 in 'Sobre1.pas' {Sobre2};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'RTMChat 1.0';
  Application.CreateForm(TChat, Chat);
  Application.CreateForm(TConfig2, Config2);
  Application.CreateForm(TSobre2, Sobre2);
  Application.Run;
end.
