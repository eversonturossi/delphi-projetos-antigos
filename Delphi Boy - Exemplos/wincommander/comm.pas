unit comm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
   StdCtrls, Buttons, Menus;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    ListBox1: TListBox;
    BitBtn1: TBitBtn;
    Edit1: TEdit;
    Edit2: TEdit;
    Button7: TButton;
    GroupBox1: TGroupBox;
    Button8: TButton;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Help1: TMenuItem;
    Close1: TMenuItem;
    Alittlehelp1: TMenuItem;
    N2: TMenuItem;
    About1: TMenuItem;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button6MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure BitBtn1Click(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Close1Click(Sender: TObject);
    procedure Alittlehelp1Click(Sender: TObject);
    procedure About1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses movedlg, aboutbox;
var
global : string;
function EnumWindowsProc(Wnd : HWnd;Form : TForm1) : Boolean; Export; {$ifdef Win32} StdCall; {$endif}
var
Buffer : Array[0..99] of char;
begin
GetWindowText(Wnd,Buffer,100);
if StrLen(Buffer) > 0 then
Form.ListBox1.Items.Add(StrPas(Buffer));
Result := True;
end;
{$R *.DFM}
procedure TForm1.Button1Click(Sender: TObject);
var
h : hwnd;
begin
try
H := findwindow(nil, Pchar(global));
if H <> 0 then Showwindow(h, SW_HIDE);
except
showmessage('O erro ocorrido eh desconhecido!');
end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
h : hwnd;
begin
try
H := findwindow(nil, Pchar(global));
if H <> 0 then Showwindow(h, SW_SHOW);
except
showmessage('O erro ocorrido eh desconhecido!');
end;
Form1.setfocus;
end;

procedure TForm1.Button3Click(Sender: TObject);
var
h : hwnd;
begin
try
H := findwindow(nil, Pchar(Global));
if H <> 0 then Showwindow(h, SW_MINIMIZE);
except
showmessage('O erro ocorrido eh desconhecido!');
end;
form1.setfocus;
end;
procedure TForm1.Button4Click(Sender: TObject);
var
h : hwnd;
begin
try
H := findwindow(nil, Pchar(Global));
if H <> 0 then Showwindow(h, SW_RESTORE);
except
showmessage('O erro ocorrido eh desconhecido!');
end;
form1.SetFocus;
end;


procedure TForm1.Button5Click(Sender: TObject);
var
h : hwnd;
begin
try
H := findwindow(nil, Pchar(global));
if H <> 0 then Showwindow(h, SW_MAXIMIZE);
except
showmessage('O erro ocorrido eh desconhecido!');
end;
form1.setfocus;
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
Form2.Show;
end;

procedure TForm1.Button6MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
if (ssAlt in shift) then
ShowMessage('Bingow!! You''re smart!');
end;

procedure TForm1.BitBtn1Click(Sender: TObject);
begin
listbox1.Clear;
EnumWindows(@EnumWindowsProc,LongInt(Self));
end;

procedure TForm1.ListBox1Click(Sender: TObject);
var
I : integer;
begin
for i := 0 to (ListBox1.Items.Count - 1) do begin
  try
    if ListBox1.Selected[i] then
    begin
global := listbox1.items.Strings[i];
edit1.text := global;
end;
finally

end;

end;
end;

procedure TForm1.Button7Click(Sender: TObject);
var
H : hwnd;
begin
H := findwindow(nil, pchar(global));
SetWindowText (h, pchar(edit2.text));

end;

procedure TForm1.Button8Click(Sender: TObject);
var
h : hwnd;
begin
H := findwindow(nil, Pchar(global));
SendMessage(h,WM_CLOSE,0,0);
SendMessage(h,wM_CLOSE,0,0);
SendMessage(h,WM_CLOSE,0,0);
listbox1.Clear;
EnumWindows(@EnumWindowsProc,LongInt(Self))
end;

procedure TForm1.Close1Click(Sender: TObject);
begin
close;
end;

procedure TForm1.Alittlehelp1Click(Sender: TObject);
begin
messagedlg('Way of work: Click in the "List" button to show all actives processes (window).'+
' Then, select one process of the list and choose one of the buttons (Hide, Show, Move,'+
' Restore, Minimize, Maximize, or Kill). You can also rename the process just selecting one of active processe of the list, filling'+
' the "New windows name" field and pressing the "Change" button. That''s all.'+#13+#13+#13+'brought for you by [quicksand].', mtinformation, [mbOk], 0);
end;

procedure TForm1.About1Click(Sender: TObject);
begin
aboutdlg.showmodal;
end;

end.
