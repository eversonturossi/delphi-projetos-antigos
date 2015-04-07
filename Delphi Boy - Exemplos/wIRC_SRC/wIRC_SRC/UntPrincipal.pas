{----------------------------------------------------------------
 Nome: UntPrincipal
 Descrição: Unit do FrmPrincipal, nesta unit se encontram os
principais métodos do wIRC:

  -procedure ProcMsg(Janela: string; Menssagem: string);
  -procedure AtlNick(Nick: string; NvNick: string);
  -procedure RolarTexto(Texto: TwwDBRichEdit);
  -procedure ProcChaMsg(Janela: string; Menssagem: string);
  -procedure AdNick(Nick, Canal: string);
  -procedure RmNick(Nick, Canal: string);

 As descrições individuais estão na implementação de cada uma.
 ----------------------------------------------------------------}
unit UntPrincipal;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, StdCtrls, ComCtrls, ScktComp, IniFiles, ExtCtrls, IRCUtils,
  StrUtils, OleCtrls, ImgList, Buttons, ToolWin, IAeverButton, FatThings;

type {Objeto de configuração do wIRC}
  TwIRCConfig = record
    {Geral}
    IniServidor: string;
    IniPorta: integer;
    IniNome: string;
    IniEmail: string;
    IniNick: string;
  end;
  
  TEstIRC = (eiConectado, eiDesconectado, eiAway);
  TFrmPrincipal = class(TForm)
    ClientePrincipal: TClientSocket;
    TmrPingPong: TTimer;
    ImlIcones: TImageList;
    MnuPrincipal: TMainMenu;
    MnuArquivo: TMenuItem;
    MniArqConectar: TMenuItem;
    MniArqDesconectar: TMenuItem;
    Separador1: TMenuItem;
    MniArqSair: TMenuItem;
    MnuOpcoes: TMenuItem;
    MniOpcDepurador: TMenuItem;
    MniOpcConfig: TMenuItem;
    BarraJanelas: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure ClientePrincipalConnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ClientePrincipalDisconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure TmrPingPongTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ClientePrincipalRead(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure MniArqConectarClick(Sender: TObject);
    procedure MniArqDesconectarClick(Sender: TObject);
    procedure MniOpcConfigClick(Sender: TObject);
    procedure MniOpcDepuradorClick(Sender: TObject);
    procedure MniArqSairClick(Sender: TObject);
  private

  public
    IniConfig: TIniFile;
    Configuracao: TwIRCConfig;
    EstIRC: TEstIRC;
    DirwIRC: string;
    procedure ProcMsg(Janela: string; Menssagem: string);
    procedure AtlNick(Nick: string; NvNick: string);
    procedure RolarTexto(var Texto: TFatMemo);
    procedure ProcChaMsg(Janela: string; Menssagem: string);
    procedure AdNick(Nick, Canal: string; CriarJanela: boolean);
    procedure RmNick(Nick, Canal: string);
    procedure AbrirPvt(Nick: string);
  end;

var
  FrmPrincipal: TFrmPrincipal;
  Buffer: string;

  ArqScript: TStringList;

implementation

uses UntDepurador, UntConfiguracao, SrvAnalisesUtils, UntProcMsgIRC,
     UntFuncoes, UntwIRCCanal, UntwIRCStatus, UntwIRCPVT;

{$R *.DFM}

procedure TFrmPrincipal.ProcMsg(Janela: string; Menssagem: string);
{
  Procedure para processar uma menssagem privada.
Funcionamento:
  Procura uma janela que tenha o Caption = Janela
e chama o método AdLinha(Menssagem).
  Caso esta janela não exista ela será criada e o
mesmo método será chamado.
}
var
  Contador: integer;
  NovoPVT, PVT: TwIRCPVT;
  Encontrado: boolean;
  TipoForm: string;

begin {WARNING - Mudar para IS}
  Encontrado:=false;
  TipoForm:='TwIRCPVT';
  for Contador:=0 to FrmPrincipal.MDIChildCount - 1 do
  begin {Procura a janela}
    if (FrmPrincipal.MDIChildren[Contador].ClassName = TipoForm) then
    begin
      PVT:=(FrmPrincipal.MDIChildren[Contador] as TwIRCPVT);
      if (AnsiCompareText(PVT.Nick, Janela) = 0) then
      begin
        PVT.AdLinha(Menssagem);
        Encontrado:=true;
     end;
    end;
  end;

  if not Encontrado then
  begin
    {Não encontrada, cria nova}
    NovoPVT:=TwIRCPVT.Create(Self);
    NovoPVT.Nick:=Janela;
    NovoPVT.Barra.Caption:=Janela;
    NovoPVT.Barra.Hint:=Janela;
    {Adiciona menssagem a janela}
    NovoPVT.AdLinha(Menssagem);
  end;
end;

procedure TFrmPrincipal.AtlNick(Nick: string; NvNick: string);
{
  Esta procedure atualiza o Caption da janela de um usuário que
mudou de nick e a listagem deste em um canal.

Funcionamento:
  Procura uma janela em que Caption = Nick e coloca
Caption := NvNick
}
var
  Contador: integer;
  PVT: TwIRCPVT;
  TipoForm: string;

begin {WARNING - Mudar para IS}
  TipoForm:='TwIRCPVT';
  for Contador:=0 to FrmPrincipal.MDIChildCount - 1 do
  begin
    if (FrmPrincipal.MDIChildren[Contador].ClassName = TipoForm) then
    begin
      PVT:=(FrmPrincipal.MDIChildren[Contador] as TwIRCPVT);
      if (AnsiCompareText(PVT.Nick, Nick) = 0) then
        PVT.Nick:=NvNick;
    end;
  end;
end;

procedure TFrmPrincipal.FormCreate(Sender: TObject);
begin
  {Pega diretório do wIRC}
  GetDir(0, DirwIRC);

  {o wIRC vai iniciar desconectado(óbvio)}
  EstIRC:=eiDesconectado;

  {Inicia objeto INI}
  IniConfig:=TIniFile.Create(DirwIRC + '\Config.ini');
end;

procedure TFrmPrincipal.ClientePrincipalConnect(Sender: TObject; Socket: TCustomWinSocket);
{
  Estabelece conexão, enviando as informações sobre o cliente
como nick, servidor, nome real, email...
}
begin
  Socket.SendText(Format('USER %s %s %s :%s',[Configuracao.IniEmail, Socket.LocalHost, Configuracao.IniServidor, Configuracao.IniNome]) + #13+#10);
  Socket.SendText(Format('NICK %s', [Configuracao.IniNick]) + #13+#10);
  EstIRC:=eiConectado;
  TmrPingPong.Enabled:=true;
end;

procedure TFrmPrincipal.ClientePrincipalDisconnect(Sender: TObject; Socket: TCustomWinSocket);
begin
  TmrPingPong.Enabled:=false;
  EstIRC:=eiDesconectado;
end;

{TEMP}
procedure TFrmPrincipal.TmrPingPongTimer(Sender: TObject);
begin
  with ClientePrincipal do
  begin
    Socket.SendText('PONG :' + Configuracao.IniServidor + #13 + #10);
    wIRCStatus.AdLinha('PING -> PING OK');
  end;
end;
{TEMP}

procedure TFrmPrincipal.FormClose(Sender: TObject; var Action: TCloseAction);
var
  Contador: integer;
{
  Quando o wIRC finalizar ocorre a chamada do evento AoFinalizar
do Script.
}
begin
  {Libera todos os forms da memória, antes de fechar}
  for Contador:=0 to Self.MDIChildCount - 1 do
    Self.MDIChildren[Contador].Release;  
end;

procedure TFrmPrincipal.RolarTexto(var Texto: TFatMemo);
{
  Procedure que trabalha com a API do windows, que
tem por função rolar um campos de texto do tipo
TMemo.
}
begin
  SendMessage(Texto.Handle, EM_SCROLL, SB_BOTTOM, 0);
end;

procedure TFrmPrincipal.ProcChaMsg(Janela, Menssagem: string);
{
  Esta procedure tem por função adicionar menssagens
a uma janela de canal.

Funcionamento:
  Procura um canal e depois adiciona menssagem a esta
janela invocando o procedimento AdLinha(Menssagem).
}
var
  Contador: integer;
  CanalAtual: TwIRCCanal;
  TipoForm: string;

begin {WARNING - Mudar para IS}
  TipoForm:='TwIRCCanal';
  for Contador:=0 to FrmPrincipal.MDIChildCount - 1 do
  begin {Procura a janela}
    if (FrmPrincipal.MDIChildren[Contador].ClassName = TipoForm) then
    begin
      CanalAtual:=(FrmPrincipal.MDIChildren[Contador] as TwIRCCanal);
      if (AnsiCompareText(CanalAtual.Canal, Janela) = 0) then
      begin
        CanalAtual.AdLinha(Menssagem);
      end;
    end;
  end;
end;

procedure TFrmPrincipal.ClientePrincipalRead(Sender: TObject; Socket: TCustomWinSocket);
{
  Procedure automática do evento OnRead do cliente.
  Esta rotina verifica se o comando recebido está completo(
termina com quebra de linha). Caso o comando não esteja
completo ele será armazenado em Buffer e irá agurdar o
recebimento de uma string que termine com quebra de linha,
esta string será somada com o Buffer então será processada
normalmente
}
var
  QbrLinha, TamTotal: integer;
  TextoReceb: string;

begin
  TextoReceb:=Socket.ReceiveText;
  TextoReceb:=Buffer + TextoReceb;
  TamTotal:=Length(TextoReceb);
  QbrLinha:=UltQuebra(TextoReceb);

  if (QbrLinha = TamTotal) then
  begin
    Chomp(TextoReceb);
    ProcMsgIRC(TextoReceb);
    FrmDepurador.AdLinha(TextoReceb);
    Buffer:='';
  end
  else
  begin
    Buffer:=TextoReceb;
  end;

end;

procedure TFrmPrincipal.AdNick(Nick, Canal: string; CriarJanela: boolean);
{
  Esta procedure tem duas funções diferentes:
-Criar janelas de canais
-Adicionar nicks a uma janela de canais

Funcionamento:
  Verifica-se a existência de um canal aberto com o nome dado
e adiciona o nick. Caso o canal não exista ele será criado e
o nick será adicionado
}
var
  Contador: integer;
  NovoCanal, CanalAtual: TwIRCCanal;
  Encontrado: boolean;
  TipoForm: string;

begin {WARNING - Mudar para IS}
  Encontrado:=false;
  TipoForm:='TwIRCCanal';
  for Contador:=0 to FrmPrincipal.MDIChildCount - 1 do
  begin {Procura a janela}
    if (FrmPrincipal.MDIChildren[Contador].ClassName = TipoForm) then
    begin
      CanalAtual:=(FrmPrincipal.MDIChildren[Contador] as TwIRCCanal);
      if (CanalAtual.Canal = Canal) then
      begin
        CanalAtual.AdNick(Nick);
        Encontrado:=true;
      end;
    end;
  end;

  if not (Encontrado) and (CriarJanela) then
  begin
    {Não encontrada, cria nova}
    NovoCanal:=TwIRCCanal.Create(Self);
    NovoCanal.Canal:=Canal;
    NovoCanal.Barra.Caption:=Canal;
    NovoCanal.Barra.Hint:=Canal;
    {Adiciona o nick a lista}
    NovoCanal.AdNick(Nick);
  end;
end;

procedure TFrmPrincipal.RmNick(Nick, Canal: string);
{
  Procedure para remover um nick de uma determinada janela
de um canal
Funcionamento:
  Procura a janela e chama o procedimento correspondente
para remover o nick
}
var
  Contador: integer;
  CanalAtual: TwIRCCanal;
  TipoForm: string;

begin {WARNING - Mudar para IS}
  TipoForm:='TwIRCCanal';
  for Contador:=0 to FrmPrincipal.MDIChildCount - 1 do
  begin {Procura a janela}
    if (FrmPrincipal.MDIChildren[Contador].ClassName = TipoForm) then
    begin
      CanalAtual:=(FrmPrincipal.MDIChildren[Contador] as TwIRCCanal);
      if (AnsiCompareText(CanalAtual.Canal, Canal) = 0) then
      begin {Chama procedimento para remover o nick}
        CanalAtual.RmNick(Nick);
      end;
    end;
  end;
end;

procedure TFrmPrincipal.MniArqConectarClick(Sender: TObject);
begin
  {Carrega informações de configurações}
  Configuracao.IniServidor:=IniConfig.ReadString('Geral', 'Servidor', '');
  Configuracao.IniPorta:=IniConfig.ReadInteger('Geral', 'Porta', 6667);
  Configuracao.IniNome:=IniConfig.ReadString('Geral', 'Nome', '');
  Configuracao.IniEmail:=IniConfig.ReadString('Geral', 'Email', '');
  Configuracao.IniNick:=IniConfig.ReadString('Geral', 'Nick', '');

  {Coloca informações no cliente IRC(Socket)}
  ClientePrincipal.Host:=Configuracao.IniServidor;
  ClientePrincipal.Port:=Configuracao.IniPorta;
  {Ativa conexão}
  ClientePrincipal.Active:=true;
end;

procedure TFrmPrincipal.MniArqDesconectarClick(Sender: TObject);
begin
  ClientePrincipal.Socket.SendText(Format('QUIT :%s', ['Saindo...']) + #13+#10);
  ClientePrincipal.Socket.Close;
end;

procedure TFrmPrincipal.MniOpcConfigClick(Sender: TObject);
begin
  FrmConfiguracoes.ShowModal;
end;

procedure TFrmPrincipal.MniOpcDepuradorClick(Sender: TObject);
{
  Controle da janela do depurador
}
begin
  if not (MniOpcDepurador.Checked) then
  begin
    MniOpcDepurador.Checked:=true;
    FrmDepurador.Show;
  end
  else
  begin
    MniOpcDepurador.Checked:=false;
    FrmDepurador.Close;
  end;
end;

procedure TFrmPrincipal.MniArqSairClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmPrincipal.AbrirPvt(Nick: string);
{
  Procedure para processar uma menssagem privada.
Funcionamento:
  Procura uma janela que tenha o Caption = Janela
e chama o método AdLinha(Menssagem).
  Caso esta janela não exista ela será criada e o
mesmo método será chamado.
}
var
  Contador: integer;
  NovoPVT, PVT: TwIRCPVT;
  Encontrado: boolean;
  TipoForm: string;

begin {WARNING - Mudar para IS}
  Encontrado:=false;
  TipoForm:='TwIRCPVT';
  for Contador:=0 to FrmPrincipal.MDIChildCount - 1 do
  begin {Procura a janela}
    if (FrmPrincipal.MDIChildren[Contador].ClassName = TipoForm) then
    begin
      PVT:=(FrmPrincipal.MDIChildren[Contador] as TwIRCPVT);
      if (AnsiCompareText(PVT.Nick, Nick) = 0) then
      begin
        PVT.BringToFront; 
        Encontrado:=true;
     end;
    end;
  end;

  if not Encontrado then
  begin
    {Não encontrada, cria nova}
    NovoPVT:=TwIRCPVT.Create(Self);
    NovoPVT.Nick:=Nick;
    NovoPVT.Barra.Caption:=Nick;
    NovoPVT.Barra.Hint:=Nick;
    NovoPVT.BringToFront;
  end;
end;

end.
