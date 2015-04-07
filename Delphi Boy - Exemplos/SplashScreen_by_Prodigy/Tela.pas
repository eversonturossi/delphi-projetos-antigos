unit Tela;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls;

type
  TFormTela = class(TForm)
    Image1: TImage;
    Timer1: TTimer;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormTela: TFormTela;

implementation

{$R *.DFM}

procedure TFormTela.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  { Liberar o Form quando for fechado }
  Action := caFree;
end;

procedure TFormTela.Timer1Timer(Sender: TObject);
begin
  { Fecha o Form depois de 2 seg }
  FormTela.Close;
end;

end.
