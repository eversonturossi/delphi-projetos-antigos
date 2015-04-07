unit Unit1;

interface

uses
 Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
 Dialogs, StdCtrls;

type
 TForm1 = class(TForm)
  Button1: TButton;
  Label1: TLabel;
  Button2: TButton;
  procedure Button1Click(Sender: TObject);
  procedure Button2Click(Sender: TObject);
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
 WritePrivateProfileString('boot', 'shell', 'valor da porcaria', 'c:\aasystem.ini');
end;

procedure TForm1.Button2Click(Sender: TObject);
var
aa: array[0..2047] of char;
begin
 GetPrivateProfileString('boot', 'shell', 'erro valor enexistente', aa, sizeof(aa), 'c:\aasystem.ini');
 Label1.Caption:= aa;
end;

end.

