
{ #DelphiX - irc.brasnet.org                       }
{ Source by Glauber A. Dantas - www.delphix.com.br }

unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls;

type
  TForm1 = class(TForm)
    StatusBar1: TStatusBar;
    Edit1: TEdit;
    Button1: TButton;
    Label1: TLabel;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
   procedure MinhaProcOnMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}



procedure TForm1.MinhaProcOnMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  Label1.Caption := Edit1.Text;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  Label1.OnMouseMove := MinhaProcOnMouseMove;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  Label1.OnMouseMove := nil;
end;

end.
