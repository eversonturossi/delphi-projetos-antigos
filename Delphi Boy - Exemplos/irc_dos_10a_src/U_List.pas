unit U_List;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TFrmList = class(TForm)
    LBNicks: TListBox;
    procedure LBNicksClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmList: TFrmList;

implementation

uses Center, U_Info;

{$R *.dfm}

procedure TFrmList.LBNicksClick(Sender: TObject);
begin
  Destino := LBNicks.Items[LBNicks.ItemIndex];
  if Destino[1] in ['@','+','!'] then
   Delete(Destino,1,1);
  FrmInfo.EdtDestino.Text := Destino;
end;

end.
