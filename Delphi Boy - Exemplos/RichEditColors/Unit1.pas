unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls;

type
  TForm1 = class(TForm)
    RichEdit1: TRichEdit;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure HTMLSyntax(RichEdit: TRichEdit; TextCol, TagCol, DopCol: TColor);
var
  i, iDop: Integer;
  s: string;
  Col: TColor;
  isTag, isDop: Boolean;
begin
  iDop := 0;
  isDop := False;
  isTag := False;
  Col := TextCol;
  RichEdit.SetFocus;

  for i := 0 to Length(RichEdit.Text) do
  begin
   RichEdit.SelStart  := i;
   RichEdit.SelLength := 1;
   s := RichEdit.SelText;

   if (s = '<') or (s = '{') then
     isTag := True;

   if isTag then
   if (s = '"') then
   if not isDop then
   begin
    iDop := 1;
    isDop := True;
   end
   else
    isDop := False;

   if isTag then
      if isDop then
      begin
       if iDop <> 1 then
        Col := DopCol;
      end
      else
        Col := TagCol
   else
    Col := TextCol;

   RichEdit.SelAttributes.Color := Col;
   iDop := 0;
   if (s = '>') or (s = '}') then
    isTag := False;
  end;

  RichEdit.SelLength := 0;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  RichEdit1.Lines.BeginUpdate;
  HTMLSyntax(RichEdit1, clBlue, clRed, clGreen);
  RichEdit1.Lines.EndUpdate;
end;

end.
