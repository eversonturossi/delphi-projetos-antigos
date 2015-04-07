{----------------------------------------------------------------
 Nome: UntPVT
 Descrição: Unit do Form do tipo TFrmPVT. Este form contém várias
procedures para manipulação de todos os PVTs. 
 ----------------------------------------------------------------}

unit UntPVT;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, Menus;

type
  TFrmPVT = class(TForm)
    CmbMenssagem: TComboBox;
    PopupMenu1: TPopupMenu;
    Limpar1: TMenuItem;
    MemPVT: TMemo;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CmbMenssagemKeyPress(Sender: TObject; var Key: Char);
    procedure MemPVTMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Limpar1Click(Sender: TObject);
  private

  public
    Nick: string;
    Ip: string;
    procedure AdLinha(Texto: string);
  end;

const
  NwLine = #13 + #10;

var
  FrmPVT: TFrmPVT;

implementation

uses UntPrincipal, UntComandos, UntDiversos;

{$R *.DFM}

procedure TFrmPVT.AdLinha;
begin
  MemPVT.Lines.Add(Texto);
  FrmPrincipal.RolarTexto(Self.MemPVT);
end;

procedure TFrmPVT.FormShow(Sender: TObject);
begin
  MemPVT.Height:=ClientHeight - 24;
  MemPVT.Width:=ClientWidth;
  CmbMenssagem.Top:=ClientHeight - 23;
  CmbMenssagem.Width:=ClientWidth;
  FrmPrincipal.RolarTexto(Self.MemPVT);
end;

procedure TFrmPVT.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;
end;

procedure TFrmPVT.CmbMenssagemKeyPress(Sender: TObject; var Key: Char);
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
        PvtMsg(Nick, Texto);
        CmbMenssagem.Text:='';
      end;
    FrmPrincipal.RolarTexto(Self.MemPVT);
    Abort;
  end;
end;

procedure TFrmPVT.MemPVTMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  MemPVT.CopyToClipboard;
  MemPVT.SelLength:=0;
  CmbMenssagem.SetFocus;
end;

procedure TFrmPVT.Limpar1Click(Sender: TObject);
begin
  MemPVT.Lines.Clear;
end;

end.
