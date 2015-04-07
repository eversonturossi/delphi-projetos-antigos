unit Unit1;

{The transparent form effect is done with Regions.
 First create a region that encompasses the entire form.
 Then, find the client area of the form (Client vs. non-Client) and
 combine with the full region with RGN_DIFF to make the borders
 and title bar visible.  Then create a region for each of the
 controls and combine them with the original (FullRgn) region.}

{From various posts in the newsgroups - based on some famous
 author I'm sure, but I first saw the post by Kerstin Thaler...}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Panel1: TPanel;
    Button2: TButton;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }
    procedure DoVisible;
    procedure DoInvisible;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  FullRgn, ClientRgn, CtlRgn : THandle;

implementation

{$R *.DFM}

procedure TForm1.DoInvisible;
var
  AControl : TControl;
  A, Margin, X, Y, CtlX, CtlY : Integer;
begin
  Margin := ( Width - ClientWidth ) div 2;
  //First, get form region
  FullRgn := CreateRectRgn(0, 0, Width, Height);
  //Find client area region
  X := Margin;
  Y := Height - ClientHeight - Margin;
  ClientRgn := CreateRectRgn( X, Y, X + ClientWidth, Y + ClientHeight );
  //'Mask' out all but non-client areas
  CombineRgn( FullRgn, FullRgn, ClientRgn, RGN_DIFF );

  //Now, walk through all the controls on the form and 'OR' them
  // into the existing Full region.
  for A := 0 to ControlCount - 1 do begin
    AControl := Controls[A];
    if ( AControl is TWinControl ) or ( AControl is TGraphicControl )
        then with AControl do begin
      if Visible then begin
        CtlX := X + Left;
        CtlY := Y + Top;
        CtlRgn := CreateRectRgn( CtlX, CtlY, CtlX + Width, CtlY + Height );
        CombineRgn( FullRgn, FullRgn, CtlRgn, RGN_OR );
      end;
    end;
  end;
  //When the region is all ready, put it into effect:
  SetWindowRgn(Handle, FullRgn, TRUE);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  //Clean up the regions we created
  DeleteObject(ClientRgn);
  DeleteObject(FullRgn);
  DeleteObject(CtlRgn);
end;

procedure TForm1.DoVisible;
begin
  //To restore complete visibility:
  FullRgn := CreateRectRgn(0, 0, Width, Height);
  CombineRgn(FullRgn, FullRgn, FullRgn, RGN_COPY);
  SetWindowRgn(Handle, FullRgn, TRUE);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  //We start out as a transparent form....
  DoInvisible;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  //This button just toggles between transparent and not trans..
  if Button1.Caption = 'Show Form' then begin
    DoVisible;
    Button1.Caption := 'Hide Form';
  end
  else begin
    DoInvisible;
    Button1.Caption := 'Show Form';
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TForm1.FormResize(Sender: TObject);
begin
  //Need to address the transparency if the form gets re-sized.
  //Also, note that Form1 scroll bars are set to VISIBLE/FALSE.
  //I did that to save a little coding here....
  if Button1.Caption = 'Show Form' then
    DoInvisible
  else
    DoVisible;
end;

end.
 