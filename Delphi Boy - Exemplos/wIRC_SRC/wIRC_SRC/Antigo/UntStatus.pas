unit UntStatus;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UntPVT, StdCtrls, UntPrincipal, OleCtrls,
  ComCtrls, Menus;

type
  TFrmStatus = class(TFrmPVT)
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CmbMenssagemKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  FrmStatus: TFrmStatus;

implementation

{$R *.DFM}

procedure TFrmStatus.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  Beep;
  Action:=caNone;
end;

procedure TFrmStatus.CmbMenssagemKeyPress(Sender: TObject; var Key: Char);
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
        AdLinha(Texto);
        CmbMenssagem.Items.Insert(0, CmbMenssagem.Text);
        CmbMenssagem.Text:='';
        FrmPrincipal.ClientePrincipal.Socket.SendText(Texto + NwLine);
      end;
    FrmPrincipal.RolarTexto(Self.MemPVT);
    Abort;
  end;
end;

procedure TFrmStatus.FormCreate(Sender: TObject);
begin
  WindowState:=wsMaximized;
end;

end.
