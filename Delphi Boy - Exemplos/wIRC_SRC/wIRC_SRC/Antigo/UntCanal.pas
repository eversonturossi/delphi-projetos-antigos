{----------------------------------------------------------------
 Nome: UntCanal
 Descrição: Unit do Form do tipo TFrmCanal. Este form contém várias
procedures para manipulação de todos as Janelas-Canais.
 Métodos:

  -procedure AdNick(Nick: string);
  -procedure RmNick(Nick: string);
  -procedure AdLinha(Texto: string);
 ----------------------------------------------------------------}
unit UntCanal;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, IRCUtils;

type
  TFrmCanal = class(TForm)
    CmbMenssagem: TComboBox;
    LsbNicks: TListBox;
    MemCanal: TMemo;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure MemCanalMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure CmbMenssagemKeyPress(Sender: TObject; var Key: Char);
    procedure FormResize(Sender: TObject);
  private

  public
    Canal: string;
    Topico: string;
    procedure AdNick(Nick: string);
    procedure RmNick(Nick: string);
    procedure AdLinha(Texto: string);
  end;

var
  FrmCanal: TFrmCanal;

implementation

uses UntPrincipal, UntComandos, UntStatus;

{$R *.DFM}

{ TFrmCanal }

{Procedures}
procedure TFrmCanal.AdLinha(Texto: string);
begin
  MemCanal.Lines.Add(Texto);
  FrmPrincipal.RolarTexto(MemCanal);
end;

procedure TFrmCanal.AdNick(Nick: string);
var
  IndiceA, IndiceB: integer;

begin
  {Só adiciona o nick se ele nãi estiver adicionado}
  IndiceA:=LsbNicks.Items.IndexOf(Nick);
  IndiceB:=LsbNicks.Items.IndexOf(NickReal(Nick)); {Testa sem os atributos}
  if ((IndiceA < 0) or (IndiceB < 0)) then
    LsbNicks.Items.Add(Nick);
end;

procedure TFrmCanal.RmNick(Nick: string);
var
  Contador: integer;

begin
  for Contador:=0 to LsbNicks.Items.Count - 1 do
    if (NickReal(LsbNicks.Items.Strings[Contador]) = NickReal(Nick)) then
      LsbNicks.Items.Delete(Contador);
end;
{Fim}

procedure TFrmCanal.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;
  PartCha(Canal);
end;

procedure TFrmCanal.MemCanalMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  MemCanal.CopyToClipboard;
  MemCanal.SelLength:=0;
  CmbMenssagem.SetFocus;
end;

procedure TFrmCanal.CmbMenssagemKeyPress(Sender: TObject; var Key: Char);
var
  Texto: string;

begin
  if (Key = #13) then
  begin
    if (FrmPrincipal.EstIRC = eiDesconectado) then
    begin
      AdLinha('Não conectado!');
      CmbMenssagem.Text:='';
    end
    else
      if (Length(CmbMenssagem.Text) > 0) then
      begin
        Texto:=CmbMenssagem.Text;
        AdLinha('[MeuNick] ' + Texto);
        CmbMenssagem.Items.Insert(0, CmbMenssagem.Text);
        PvtMsg(Canal, Texto);
        CmbMenssagem.Text:='';
      end;
    FrmPrincipal.RolarTexto(Self.MemCanal);
    Abort;
  end;
end;

procedure TFrmCanal.FormResize(Sender: TObject);
begin
  LsbNicks.Left:=ClientWidth - LsbNicks.Width;
  CmbMenssagem.Top:=ClientHeight - 23;
  CmbMenssagem.Width:=ClientWidth;
  MemCanal.Width:=ClientWidth - LsbNicks.Width;
  MemCanal.Height:=(ClientHeight - CmbMenssagem.Height) - 1;
  LsbNicks.Height:=(ClientHeight - CmbMenssagem.Height) - 1;
end;

end.
