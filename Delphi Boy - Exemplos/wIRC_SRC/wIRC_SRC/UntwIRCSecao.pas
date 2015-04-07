{----------------------------------------------------------------
 Nome: UntwIRCSecao
 Descrição: Unit que contém a definição do form TwIRCSecao, que
contém o comportamento padrão usado de base para construção dos
outros forms(wIRCPVT, wIRCCanal, wIRCStatus).
 O comportamento padrão está descrito abaixo:

 -Procedure AdLinha (Adicina texto a área de texto TMemo(MemTexto))
 -Iteração com a BarraJanelas do form principal, que funciona como
uma barra de tarefas. O form ao ser criado adiciona uma barra ao
objeto BarraJanelas e obedece aos comandos tal como minimizar,
restaurar.

 As descrições individuais estão na implementação de cada uma.
 ----------------------------------------------------------------}
unit UntwIRCSecao;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, Menus, Buttons, FatThings;

type
  TwIRCSecao = class(TForm)
    CmdTexto: TEdit;
    MenuContexto: TPopupMenu;
    Limpar1: TMenuItem;
    MemTexto: TFatMemo;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure MemTextoaMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MemTextoaMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
    Estado: TWindowState;
    Ativo: boolean;
    procedure BarraClick(Sender: TObject);
    procedure Tamanho(var Menssagem: TWMSize); message WM_SIZE;
  public
    { Public declarations }
    Barra: TSpeedButton;
    procedure AdLinha(Texto: string);
  end;

var
  wIRCSecao: TwIRCSecao;

implementation

uses UntPrincipal;

{$R *.DFM}

procedure TwIRCSecao.BarraClick(Sender: TObject);
{Ativamento da barra de tarefas}
begin {Verifica se ela não está desativada(minimizada)}
  if (Ativo) then
  begin {Caso ela esteja focada, então ela é desativada}
    if FrmPrincipal.ActiveMDIChild = Self then
    begin {Esconde janela}
      Ativo:=false;
      ShowWindow(Self.Handle, SW_HIDE);
      FrmPrincipal.Previous;
    end
    else {Dá foco}
      Self.BringToFront;
  end
  else
  begin {Mostra janela, restaurando suas características}
   if (Estado = wsMinimized) then
      ShowWindow(Self.Handle, SW_RESTORE)
    else
      ShowWindow(Self.Handle, SW_SHOW);

    Ativo:=true;
    Self.Perform(WM_MDIRESTORE, Self.Handle, 0);
    Self.BringToFront;
  end;
end;

procedure TwIRCSecao.FormCreate(Sender: TObject);
begin {Criação da barra na BarraJanelas}
  MemTexto.Lines.Clear;
  Ativo:=true;
  Barra:=TSpeedButton.Create(Self);
  with Barra do
  begin {São definidas suas características básicas}
    Parent:=FrmPrincipal.BarraJanelas;
    OnClick:=BarraClick; {Procedimento local para controle da barra}
    {Características básicas}
    ShowHint:=true;
    GroupIndex:=1;
    Width:=100;
    Align:=alLeft;
    Flat:=true;
    Down:=true;
    AllowAllUp:=true;
    Margin:=0;
  end;
end;

procedure TwIRCSecao.Tamanho(var Menssagem: TWMSize);
begin {Intercepta redimencionamento da janela}
  if (Menssagem.SizeType = SIZE_MINIMIZED) then
  begin {Verifica se ela foi minimizada}
    Ativo:=false; {variável de controle}
    ShowWindow(Self.Handle, SW_HIDE);
    Self.Perform(WM_MDIRESTORE, Self.Handle, 0);
    FrmPrincipal.Previous;
    Barra.Down:=false;
    Estado:=wsMinimized;
  end
  else if (Menssagem.SizeType = SIZE_MAXIMIZED) then
    Estado:=wsMaximized;
  inherited;
end;

procedure TwIRCSecao.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;
end;

procedure TwIRCSecao.MemTextoaMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  Posicao: TPoint;

begin {Não permite que o menu de contexto padrão do Windows intereja}
  GetCursorPos(Posicao); {Um menu Popup é acinado na posição do mouse}
  if (Button = mbRight) then
    MenuContexto.Popup(Posicao.x, Posicao.y);
end;

procedure TwIRCSecao.MemTextoaMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin {Característica padrão do mIRC}
{ MemTexto.CopyToClipboard; {Para copiar um texto basta seleciona-lo
  MemTexto.SelLength:=0;
  CmdTexto.SetFocus;}
end;

procedure TwIRCSecao.AdLinha(Texto: string);
begin
  MemTexto.Lines.AddLineWithIrcTags(Texto);
  FrmPrincipal.RolarTexto(MemTexto);
end;

procedure TwIRCSecao.FormActivate(Sender: TObject);
begin
  Barra.Down:=true;
end;

end.
