unit UntDepurador;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Menus;

type
  TFrmDepurador = class(TForm)
    MnuOpMemDepurador: TPopupMenu;
    Limpar1: TMenuItem;
    Salvaremarquivo1: TMenuItem;
    MemDepurador: TMemo;
    SalvarLog: TSaveDialog;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Limpar1Click(Sender: TObject);
    procedure Salvaremarquivo1Click(Sender: TObject);
  private
    { Private declarations }
  public
    procedure AdLinha(Texto: string);
  end;

var
  FrmDepurador: TFrmDepurador;

implementation

uses UntPrincipal;

{$R *.DFM}

//Procedures
procedure TFrmDepurador.AdLinha;
begin
  MemDepurador.Lines.Add(Texto);
end;
//Fim

procedure TFrmDepurador.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  FrmPrincipal.MniOpcDepurador.Checked:=false;
end;

procedure TFrmDepurador.Limpar1Click(Sender: TObject);
begin
  MemDepurador.Lines.Clear;
end;

procedure TFrmDepurador.Salvaremarquivo1Click(Sender: TObject);
var
  ArqLog: TextFile;
  ContLinha: integer;

begin
  if SalvarLog.Execute then
  begin
    AssignFile(ArqLog, SalvarLog.FileName);
    Rewrite(ArqLog);
    for ContLinha:=0 to MemDepurador.Lines.Count - 1 do
      WriteLn(ArqLog, MemDepurador.Lines[ContLinha]);
    CloseFile(ArqLog);
  end;
end;

end.
