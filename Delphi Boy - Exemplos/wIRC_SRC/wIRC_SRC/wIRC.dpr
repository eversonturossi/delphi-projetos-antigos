{
-ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo-
 Waack3 IRC - wIRC
 Projeto original: Waack3
 Autor: Waack3
 Iniciado em 14/02/2002

 ----------------------------------
 -Todas as funcionalidades do mIRC-
 -Cores                           -
 -Uso da biblioteca IRCUtils      -
 -Suporte a script - VBScript     -
 ----------------------------------
 
-ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo- 
}

program wIRC;
{APPTYPE CONSOLE}

uses
  Forms,
  UntPrincipal in 'UntPrincipal.pas' {FrmPrincipal},
  UntDepurador in 'UntDepurador.pas' {FrmDepurador},
  UntConfiguracao in 'UntConfiguracao.pas' {FrmConfiguracoes},
  SrvAnalisesUtils in 'SrvAnalisesUtils.pas',
  UntProcMsgIRC in 'UntProcMsgIRC.pas',
  UntProcMsgIRCSrv in 'UntProcMsgIRCSrv.pas',
  UntComandos in 'UntComandos.pas',
  UntDiversos in 'UntDiversos.pas',
  ifpslib in '..\..\Libs\Innerfuse Pascal Script 2.78\libraries\ifpslib\ifpslib.pas',
  ifpstrans in '..\..\Libs\Innerfuse Pascal Script 2.78\libraries\translib\ifpstrans.pas',
  ifsdfrm in '..\..\Libs\Innerfuse Pascal Script 2.78\libraries\delphiforms\ifsdfrm.pas',
  ifsctrlstd in '..\..\Libs\Innerfuse Pascal Script 2.78\libraries\delphiforms\ifsctrlstd.pas',
  ifpscall in '..\..\Libs\Innerfuse Pascal Script 2.78\libraries\call\ifpscall.pas',
  ifpsclass in '..\..\Libs\Innerfuse Pascal Script 2.78\libraries\call\ifpsclass.pas',
  ifpsdelphi in '..\..\Libs\Innerfuse Pascal Script 2.78\libraries\call\ifpsdelphi.pas',
  ifpsdll in '..\..\Libs\Innerfuse Pascal Script 2.78\libraries\call\ifpsdll.pas',
  ifpsdll2 in '..\..\Libs\Innerfuse Pascal Script 2.78\libraries\call\ifpsdll2.pas',
  ifpsdate in '..\..\Libs\Innerfuse Pascal Script 2.78\libraries\ifpslib\ifpsdate.pas',
  UntFuncoes in 'UntFuncoes.pas',
  UntwIRCSecao in 'UntwIRCSecao.pas' {wIRCSecao},
  UntwIRCCanal in 'UntwIRCCanal.pas' {wIRCCanal},
  UntwIRCStatus in 'UntwIRCStatus.pas' {wIRCStatus},
  UntwIRCPVT in 'UntwIRCPVT.pas' {wIRCPVT};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'wIRC - Waack3 IRC';
  Application.CreateForm(TFrmPrincipal, FrmPrincipal);
  Application.CreateForm(TFrmDepurador, FrmDepurador);
  Application.CreateForm(TFrmConfiguracoes, FrmConfiguracoes);
  Application.CreateForm(TwIRCStatus, wIRCStatus);
  Application.Run;
end.
