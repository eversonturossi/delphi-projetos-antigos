unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls;

type
  TFormSplash = class(TForm)
    Timer1: TTimer;
    Panel1: TPanel;
    Label1: TLabel;
    procedure Timer1Timer(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  FormSplash: TFormSplash;

implementation

{$R *.DFM}

procedure TFormSplash.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled:=false;
  Close;
end;

procedure TFormSplash.FormShow(Sender: TObject);
begin
  SetWindowPos(Handle,HWND_TOPMOST,0,0,0,0,SWP_NOMOVE or SWP_NOSIZE);
end;

end.
