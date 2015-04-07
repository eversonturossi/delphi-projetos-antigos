unit U_Info;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, StdCtrls;

type
  TFrmInfo = class(TForm)
    Label1: TLabel;
    EdtUser: TEdit;
    Label2: TLabel;
    EdtDestino: TEdit;
    SpeedButton1: TSpeedButton;
    Label3: TLabel;
    EdtPass: TEdit;
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmInfo: TFrmInfo;

implementation

uses U_List, Center;

{$R *.DFM}

procedure TFrmInfo.SpeedButton1Click(Sender: TObject);
begin
  FrmList.ShowModal;
end;

procedure TFrmInfo.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  FrmCenter.Vortex.Nick(EdtUser.Text);
  NickPass := EdtPass.Text;
  Destino := EdtDestino.Text;
end;

end.
