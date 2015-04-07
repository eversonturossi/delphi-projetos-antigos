unit Unit1;

interface

uses
 Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
 Dialogs, StdCtrls;

type
 TForm1 = class(TForm)
  Button1: TButton;
  Label1: TLabel;
  procedure Button1Click(Sender: TObject);
 private
  { Private declarations }
 public
  { Public declarations }
 end;
 
var
 Form1: TForm1;
 
implementation

{$R *.dfm}

function FilesOnDir(FDpasta: string): integer;
var
 SR: TSearchRec;
 FDcont: Integer;
 i: integer;
begin
 i := 0;
 FDcont := FindFirst(FDpasta + '*.*', faArchive, SR);
 while FDcont = 0 do
  begin
   if (SR.Attr and faDirectory) <> faDirectory then
    begin
     FDcont := FindNext(SR);
     i := 1 + i;
    end;
  end;
 Result := i;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
 Label1.Caption := IntToStr(FilesOnDir('c:\windows\'))
end;

end.

