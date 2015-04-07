{                                                  }
{             c . A . N . A . L                    }
{        # D . E . L . P . H . I . X               }
{    [-----------------------------------]         }
{                                                  }
{       Brasnet - irc.brasnet.org                  }
{ Fontes por Glauber A. Dantas(Prodigy) 13/09/2002 }
{ www.delphix.com.br                               }

unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, CheckLst,
  ComCtrls, CommCtrl;{common controls interface unit}

type

  TForm1 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Label1: TLabel;
    Button2: TButton;
    Button3: TButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet3: TTabSheet;
    Check_WindowStyle: TCheckListBox;
    Check_Status: TCheckListBox;
    GroupBox1: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Button4: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    { Private declarations }
    StatusXWND : HWND;
    StatusX_WStyles : Cardinal;
    procedure SetStatusStyle;
    procedure UpdatePanelsX;
  public
    { Public declarations }
  end;

const
  MaxPanelCount = 128;
//PanelX !
type
  TPanelX = class(TObject)
  Largura: Integer;
  Texto: String;
  Index: Integer;
end;

var
  Form1: TForm1;
  Panels: Array[0..127] of TPanelX;
  PanelsCont: Integer;
  PanelWids: array[0..MaxPanelCount - 1] of Integer;

implementation

uses Unit2;

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  C_Width, C_Heigh, C_Left, C_Top: Integer;
begin
   try
    DestroyWindow(StatusXWND);
   except
   end;
   C_Heigh := StrToInt(Edit3.Text);
   C_Width := StrToInt(Edit4.Text);
   C_Left  := StrToInt(Edit5.Text);
   C_Top   := StrToInt(Edit6.Text);

  { Atrinui os estilos }
  SetStatusStyle;
  { Cria a msctls_statusbar32 }
  //StatusXWND := CreateStatusWindow(StatusX_WStyles, Pchar('teste'), Form1.Handle, 123);
  StatusXWND := CreateWindow('msctls_statusbar32', PChar(Edit1.TExt),
   StatusX_WStyles , C_Left , C_Top, C_Width ,C_Heigh , Form1.Handle, 0, HInstance, Nil);

  { Coloca a divisao dos Panels (Se tiver)}
  UpdatePanelsX;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
   Form2.ShowModal;
end;

procedure TForm1.SetStatusStyle;
const
  WindowStyle: array[0..26] of Cardinal =
   (WS_BORDER, WS_CAPTION, WS_CHILD, WS_CHILDWINDOW, WS_CLIPCHILDREN, WS_CLIPSIBLINGS
   ,WS_DISABLED, WS_DLGFRAME, WS_GROUP, WS_HSCROLL, WS_ICONIC, WS_MAXIMIZE, WS_MAXIMIZEBOX
   ,WS_MINIMIZE, WS_MINIMIZEBOX, WS_OVERLAPPED, WS_OVERLAPPEDWINDOW, WS_POPUP, WS_POPUPWINDOW
   ,WS_SIZEBOX, WS_SYSMENU, WS_TABSTOP, WS_THICKFRAME, WS_TILED, WS_TILEDWINDOW
   ,WS_VISIBLE, WS_VSCROLL);
   //CSS = COMMON CONTROL STYLES
  StatusStyle: Array[0..12] of Cardinal =
   (SBARS_SIZEGRIP, SBT_TOOLTIPS, CCS_TOP, CCS_NOMOVEY, CCS_BOTTOM, CCS_NORESIZE
   ,CCS_NOPARENTALIGN, CCS_ADJUSTABLE, CCS_NODIVIDER, CCS_VERT, CCS_LEFT
   ,CCS_RIGHT, CCS_NOMOVEX);
var
  X : Integer;
begin
  //Reinicia valores
  StatusX_WStyles := 0;

  //Window Style
  for X := 0 to Check_WindowStyle.Items.Count -1 do
  if Check_WindowStyle.Checked[X] then
    StatusX_WStyles := StatusX_WStyles or WindowStyle[X];
    
  //StatusBar Style
  for X := 0 to Check_Status.Items.Count -1 do
  if Check_Status.Checked[X] then
    StatusX_WStyles := StatusX_WStyles or StatusStyle[X];
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  PanelsCont := 0;
  Check_WindowStyle.Checked[2] := True;
  Check_WindowStyle.Checked[25] := True;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  DestroyWindow(StatusXWND);
end;

procedure TForm1.Button4Click(Sender: TObject);
var
 Color: TColor;
begin
  Color := clBlue;
  SendMessage(StatusXWND, SB_SETBKCOLOR, 0, ColorToRGB(Color));
  UpdatePanelsX;
end;

procedure TForm1.UpdatePanelsX;
var
  Wid, X, I: Integer;
  Text: Array[1..255] of Char;
begin
  { Coloca a divisao dos Panels (Se tiver)}
  if (PanelsCont <> 0) then
  begin
    Wid := 0;
    for X := 0 to PanelsCont -2 do
    begin
      Inc(Wid, Panels[X].Largura);
      PanelWids[X] := Wid;
    end;

    PanelWids[PanelsCont - 1] := -1;
    { Divide os Panels }
    SendMessage(StatusXWND, SB_SETPARTS, PanelsCont, Integer(@PanelWids));
    { Coloca o texto de cada panel}
    for X := 0 to PanelsCont-1 do
    begin
      //Limpa o text
      FillChar(Text, SizeOf(Text), 0);
      //Coloca a string
      for I := 1 to Length(Panels[X].Texto) do
       Text[I] := Panels[X].Texto[I];
      //Inclui no Panel
      SendMessage(StatusXWND, SB_SETTEXT, Panels[X].Index, LongInt(@Text) );
    end;
  end;
end;

end.
