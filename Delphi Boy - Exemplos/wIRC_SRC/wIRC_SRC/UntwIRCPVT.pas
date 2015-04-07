unit UntwIRCPVT;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UntwIRCSecao, Menus, StdCtrls;

type
  TwIRCPVT = class(TwIRCSecao)
    procedure FormShow(Sender: TObject);
    procedure CmdTextoKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    Nick: string;
    Ip: string;
  end;

var
  wIRCPVT: TwIRCPVT;

implementation

uses UntPrincipal, UntComandos;

{$R *.DFM}

procedure TwIRCPVT.FormShow(Sender: TObject);
begin
  MemTexto.Height:=ClientHeight - 24;
  MemTexto.Width:=ClientWidth;
  CmdTexto.Top:=ClientHeight - 23;
  CmdTexto.Width:=ClientWidth;
  FrmPrincipal.RolarTexto(MemTexto);
end;

procedure TwIRCPVT.CmdTextoKeyPress(Sender: TObject; var Key: Char);
var
  Texto: string;

begin
  if (Key = #13) then
  begin
    if (FrmPrincipal.EstIRC = eiDesconectado) then
    begin
      AdLinha('Não conectado!');
      CmdTexto.Text:='';
    end
    else
      if (Length(CmdTexto.Text) > 0) then
      begin
        Texto:=CmdTexto.Text;
        AdLinha('[MeuNick] ' + Texto);
        PvtMsg(Nick, Texto);
        CmdTexto.Text:='';
      end;
    FrmPrincipal.RolarTexto(Self.MemTexto);
    Abort;
  end;
end;

procedure TwIRCPVT.FormCreate(Sender: TObject);
begin
  inherited;
  FrmPrincipal.ImlIcones.GetBitmap(2, Self.Barra.Glyph);
end;

end.
