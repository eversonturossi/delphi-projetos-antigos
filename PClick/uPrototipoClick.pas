unit uPrototipoClick;

interface

uses
 Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
 Dialogs, ExtCtrls, StdCtrls, ShellAPI;

type
 TForm1 = class(TForm)
  Button1: TButton;
  Timer1: TTimer;
  Button2: TButton;
  Timer2: TTimer;
  procedure Button1Click(Sender: TObject);
  procedure Timer1Timer(Sender: TObject);
  procedure Button2Click(Sender: TObject);
  procedure Timer2Timer(Sender: TObject);
 private
  { Private declarations }
 public
  { Public declarations }
 end;
 
var
 Form1: TForm1;
 
implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
 Timer1.Enabled := true;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
 ShellExecute(Handle, 'open', 'PClick.exe', Pchar(Application.Title + '###' + 'OK'), nil, SW_SHOWNORMAL);
 Timer2.Enabled := true;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
 Application.Terminate;
end;

procedure TForm1.Timer2Timer(Sender: TObject);
begin
 ShowMessage('Teste lalalalalalalallala');
 (Sender as TTimer).Enabled := false;
end;

end.

