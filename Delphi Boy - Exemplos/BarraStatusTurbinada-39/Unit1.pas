unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, ComCtrls,  Menus, ToolWin, StdCtrls;

type
  TForm1 = class(TForm)
    StatusBar1: TStatusBar;
    Timer1: TTimer;
    ImageList1: TImageList;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    MainMenu1: TMainMenu;
    Arquivo1: TMenuItem;
    Editar1: TMenuItem;
    Ajuda1: TMenuItem;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    Panel1: TPanel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Memo1: TMemo;
    Sair1: TMenuItem;
    procedure Timer1Timer(Sender: TObject);
    procedure StatusBar1DrawPanel(StatusBar: TStatusBar;
      Panel: TStatusPanel; const Rect: TRect);
    procedure Sair1Click(Sender: TObject);
  private
    procedure DoDrawClock(ACanvas:TCanvas; Rect:TRect);
    procedure DoDrawMessagePanel(ACanvas: TCanvas; Atext: String; Rect: TRect);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.DoDrawClock(ACanvas: TCanvas; Rect: TRect);
var
  sText: String;
begin

  with ACanvas do
  begin
    Brush.Color := clBlack;
    Brush.Style := bsSolid;
    FillRect(Rect);

    Font.Color := clLime;
    SetBKMode(Handle, TRANSPARENT);

    sText := TimeToStr(Time);
    DrawText(Handle, PChar(sText), Length(sText),
               Rect, DT_CENTER or DT_SINGLELINE or DT_VCENTER);
  end;

end;

procedure TForm1.DoDrawMessagePanel(ACanvas: TCanvas; Atext: String; Rect: TRect);
var
  sText: String;
Begin

 with ACanvas do
 begin

   FillRect(Rect);

   ImageList1.Draw(ACanvas,Rect.Left+2,Rect.Top,0);

   Rect.Left := 22;

   DrawText(Handle, PChar(AText), Length(AText),
                Rect, DT_SINGLELINE or DT_VCENTER);
 end;

end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  StatusBar1.Refresh;
end;



procedure TForm1.StatusBar1DrawPanel(StatusBar: TStatusBar;
  Panel: TStatusPanel; const Rect: TRect);
begin

  Case Panel.Index of
    0: DoDrawMessagePanel(StatusBar.Canvas, Panel.Text, Rect);
    2: DoDrawClock(StatusBar.Canvas, Rect);
  end;

end;

procedure TForm1.Sair1Click(Sender: TObject);
begin
   Close;
end;

end.
