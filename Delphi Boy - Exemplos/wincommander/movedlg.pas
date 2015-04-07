unit movedlg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, comm;

type
  TForm2 = class(TForm)
    GroupBox1: TGroupBox;
    Edit1: TEdit;
    Label1: TLabel;
    Edit2: TEdit;
    Label2: TLabel;
    Edit3: TEdit;
    Edit4: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation



{$R *.DFM}

procedure TForm2.Button1Click(Sender: TObject);
var
H : Hwnd;
begin
H := FindWindow(nil, Pchar(form1.edit1.text));
MoveWindow(H, Strtoint(edit1.text), Strtoint(edit2.text), Strtoint(edit3.text),
Strtoint(edit4.text), True);

end;

end.
