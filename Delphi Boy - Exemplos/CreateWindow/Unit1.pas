{                                                  }
{             c . A . N . A . L                    }
{        # D . E . L . P . H . I . X               }
{    [-----------------------------------]         }
{                                                  }
{       Brasnet - irc.brasnet.org                  }
{ Fontes por Glauber A. Dantas(Prodigy)            }

unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, CheckLst, Menus;

type
  TForm1 = class(TForm)
    Button_Criar: TButton;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Edit2: TEdit;
    Label3: TLabel;
    RadioGroup1: TRadioGroup;
    Edit3: TEdit;
    Edit4: TEdit;
    Label4: TLabel;
    GroupBox2: TGroupBox;
    Label5: TLabel;
    Edit5: TEdit;
    Edit6: TEdit;
    Label6: TLabel;
    PageControl1: TPageControl;
    TB_BUTTON: TTabSheet;
    TB_COMBOBOX: TTabSheet;
    TB_EDIT: TTabSheet;
    TB_LISTBOX: TTabSheet;
    TB_MDICLIENT: TTabSheet;
    TB_SCROLLBAR: TTabSheet;
    TB_STATIC: TTabSheet;
    Check_Button: TCheckListBox;
    Check_ComboBox: TCheckListBox;
    Check_Edit: TCheckListBox;
    Check_ListBox: TCheckListBox;
    Check_MDIClient: TCheckListBox;
    Check_ScrollBar: TCheckListBox;
    Check_Static: TCheckListBox;
    TB_WindowStyles: TTabSheet;
    Check_WindowStyle: TCheckListBox;
    Button1: TButton;
    TB_ExtendedStyle: TTabSheet;
    Check_ExtendedStyle: TCheckListBox;
    PopupMenu1: TPopupMenu;
    Padro1: TMenuItem;
    DesmarcarTudo1: TMenuItem;
    Fechar1: TMenuItem;
    TB_DialogBox: TTabSheet;
    Check_DialogBoxStyle: TCheckListBox;
    procedure Button_CriarClick(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Padro1Click(Sender: TObject);
  private
    { Private declarations }
    C_dwStyle, C_dwExStyle : Cardinal;
    Classe : PChar;
    procedure SetStyle;
  public
    { Public declarations }
    HW : HWND;
  end;

var
  Form1: TForm1;

implementation

uses U_Window;

{$R *.DFM}

procedure TForm1.Button_CriarClick(Sender: TObject);
var
  ClientCreateStruct: TClientCreateStruct;
  C_Width, C_Heigh, C_Left, C_Top: Integer;
begin
   try
    //SendMessage(HW, WM_CLOSE, 0, 0);
    DestroyWindow(HW);
   except
   end;

   C_Heigh := StrToInt(Edit1.Text);
   C_Width := StrToInt(Edit2.Text);
   C_Left  := StrToInt(Edit3.Text);
   C_Top   := StrToInt(Edit4.Text);

   with ClientCreateStruct do
   begin
     idFirstChild := $FF00;
     hWindowMenu := 0;
     //if FWindowMenu <> nil then hWindowMenu := FWindowMenu.Handle;
   end;

   SetStyle;

   HW := CreateWindowEx( C_dwExStyle, Classe, PChar(Edit5.Text),
         C_dwStyle ,C_Left ,C_Top ,C_Width ,C_Heigh ,FrmWindow.Handle ,
         0 , HInstance, nil {@ClientCreateStruct} );

   //SetWindowText(Hw, Pchar(Edit6.Text));
   //SendMessage(Hw, WM_SETTEXT, 0, Longint(Edit6.Text));
   FrmWindow.Show;
end;

procedure TForm1.RadioGroup1Click(Sender: TObject);
begin
  Case RadioGroup1.ItemIndex of
   0 :  begin
         Classe := 'BUTTON';
         PageControl1.ActivePage := TB_BUTTON;
        end;
   1 :  begin
         Classe := 'COMBOBOX';
         PageControl1.ActivePage := TB_COMBOBOX;
        end;
   2 :  begin
         Classe := 'EDIT';
         PageControl1.ActivePage := TB_EDIT;
        end;
   3 :  begin
         Classe := 'LISTBOX';
         PageControl1.ActivePage := TB_LISTBOX;
        end;
   4 :  begin
         Classe := 'MDICLIENT';
         PageControl1.ActivePage := TB_MDICLIENT;
        end;
   5 :  begin
         Classe := 'SCROLLBAR';
         PageControl1.ActivePage := TB_SCROLLBAR;
        end; 
   6 :  begin
         Classe := 'STATIC';
         PageControl1.ActivePage := TB_STATIC;
        end;
   7 :   Classe := 'TPUtilWindow';
   8 :   Classe := '';
   
  end;
end;

procedure TForm1.SetStyle;
const
  {**********************}
  WindowStyle: array[0..26] of Cardinal =
   (WS_BORDER, WS_CAPTION, WS_CHILD, WS_CHILDWINDOW, WS_CLIPCHILDREN, WS_CLIPSIBLINGS
   ,WS_DISABLED, WS_DLGFRAME, WS_GROUP, WS_HSCROLL, WS_ICONIC, WS_MAXIMIZE, WS_MAXIMIZEBOX
   ,WS_MINIMIZE, WS_MINIMIZEBOX, WS_OVERLAPPED, WS_OVERLAPPEDWINDOW, WS_POPUP, WS_POPUPWINDOW
   ,WS_SIZEBOX, WS_SYSMENU, WS_TABSTOP, WS_THICKFRAME, WS_TILED, WS_TILEDWINDOW
   ,WS_VISIBLE, WS_VSCROLL);

  ExtendedStyle: array[0..20] of Cardinal =
   (WS_EX_ACCEPTFILES, WS_EX_APPWINDOW, WS_EX_CLIENTEDGE, WS_EX_CONTEXTHELP
   ,WS_EX_CONTROLPARENT, WS_EX_DLGMODALFRAME, WS_EX_LEFT, WS_EX_LEFTSCROLLBAR
   ,WS_EX_LTRREADING, WS_EX_MDICHILD, WS_EX_NOPARENTNOTIFY, WS_EX_OVERLAPPEDWINDOW
   ,WS_EX_PALETTEWINDOW, WS_EX_RIGHT, WS_EX_RIGHTSCROLLBAR, WS_EX_RTLREADING
   ,WS_EX_STATICEDGE, WS_EX_TOOLWINDOW, WS_EX_TOPMOST, WS_EX_TRANSPARENT
   ,WS_EX_WINDOWEDGE);

  DialogBoxStyle: array[0..13] of Cardinal =
   (DS_3DLOOK, DS_ABSALIGN, DS_CENTER, DS_CENTERMOUSE, DS_CONTEXTHELP, DS_CONTROL
   ,DS_FIXEDSYS, DS_LOCALEDIT, DS_MODALFRAME, DS_NOFAILCREATE, DS_NOIDLEMSG
   {,DS_RECURSE}, DS_SETFONT, DS_SETFOREGROUND, DS_SYSMODAL);
  {**********************}
  ButtonStyle: array[0..23] of Cardinal =
   (BS_3STATE, BS_AUTO3STATE, BS_AUTOCHECKBOX, BS_AUTORADIOBUTTON, BS_CHECKBOX
   ,BS_DEFPUSHBUTTON, BS_GROUPBOX, BS_LEFTTEXT, BS_OWNERDRAW, BS_PUSHBUTTON
   ,BS_RADIOBUTTON, BS_USERBUTTON, BS_BITMAP, BS_BOTTOM, BS_CENTER, BS_ICON
   ,BS_LEFT, BS_MULTILINE, BS_NOTIFY, BS_PUSHLIKE, BS_RIGHT, BS_TEXT, BS_TOP
   ,BS_VCENTER);

  ComboBoxStyle: array[0..12] of Cardinal =
   (CBS_AUTOHSCROLL, CBS_DISABLENOSCROLL, CBS_DROPDOWN, CBS_DROPDOWNLIST
   ,CBS_HASSTRINGS, CBS_LOWERCASE, CBS_NOINTEGRALHEIGHT, CBS_OEMCONVERT
   ,CBS_OWNERDRAWFIXED, CBS_OWNERDRAWVARIABLE, CBS_SIMPLE, CBS_SORT, CBS_UPPERCASE);

  EditStyle: array[0..13] of Cardinal =
   (ES_AUTOHSCROLL, ES_AUTOVSCROLL, ES_CENTER, ES_LEFT, ES_LOWERCASE, ES_MULTILINE
   ,ES_NOHIDESEL, ES_NUMBER, ES_OEMCONVERT, ES_PASSWORD, ES_READONLY, ES_RIGHT
   ,ES_UPPERCASE, ES_WANTRETURN);

  ListBoxStyle: array[0..15] of Cardinal =
   (LBS_DISABLENOSCROLL, LBS_EXTENDEDSEL, LBS_HASSTRINGS, LBS_MULTICOLUMN
   ,LBS_MULTIPLESEL, LBS_NODATA, LBS_NOINTEGRALHEIGHT, LBS_NOREDRAW, LBS_NOSEL
   ,LBS_NOTIFY, LBS_OWNERDRAWFIXED, LBS_OWNERDRAWVARIABLE , LBS_SORT, LBS_STANDARD
   ,LBS_USETABSTOPS, LBS_WANTKEYBOARDINPUT);

  MDIClientStyle: array[0..0] of Cardinal = (MDIS_ALLCHILDSTYLES);

  ScrollBarStyle: array[0..9] of Cardinal =
   (SBS_BOTTOMALIGN, SBS_HORZ, SBS_LEFTALIGN, SBS_RIGHTALIGN, SBS_SIZEBOX
   ,SBS_SIZEBOXBOTTOMRIGHTALIGN, SBS_SIZEBOXTOPLEFTALIGN, SBS_SIZEGRIP
   ,SBS_TOPALIGN, SBS_VERT);

{ StaticStyle: array[0..17] of Cardinal =
   (SS_BITMAP, SS_BLACKFRAME, SS_BLACKRECT, SS_CENTER, SS_CENTERIMAGE, SS_GRAYFRAME
   ,SS_GRAYRECT, SS_ICON, SS_LEFT, SS_LEFTNOWORDWRAP, SS_METAPICT, SS_NOPREFIX
   ,SS_NOTIFY, SS_RIGHT, SS_RIGHTIMAGE, SS_SIMPLE, SS_WHITEFRAME, SS_WHITERECT); }
  StaticStyle: array[0..29] of Cardinal =
   (SS_LEFT, SS_CENTER, SS_RIGHT, SS_ICON, SS_BLACKRECT, SS_GRAYRECT, SS_WHITERECT
   ,SS_BLACKFRAME, SS_GRAYFRAME, SS_WHITEFRAME, SS_USERITEM, SS_SIMPLE, SS_LEFTNOWORDWRAP
   ,SS_BITMAP, SS_OWNERDRAW, SS_ENHMETAFILE, SS_ETCHEDHORZ, SS_ETCHEDVERT, SS_ETCHEDFRAME
   ,SS_TYPEMASK, SS_NOPREFIX, SS_NOTIFY, SS_CENTERIMAGE, SS_RIGHTJUST, SS_REALSIZEIMAGE
   ,SS_SUNKEN, SS_ENDELLIPSIS, SS_PATHELLIPSIS, SS_WORDELLIPSIS, SS_ELLIPSISMASK);

var
  X : Integer;
begin
  //Reinicia o valor dos parametros dwStyle e dwExStyle
  C_dwStyle   := 0;
  C_dwExStyle := 0;
  
  //Window Style
  for X := 0 to Check_WindowStyle.Items.Count -1 do
  if Check_WindowStyle.Checked[X] = True then
    C_dwStyle := C_dwStyle or WindowStyle[X];
  //Dialog Box Style
  for X := 0 to Check_DialogBoxStyle.Items.Count -1 do
  if Check_DialogBoxStyle.Checked[X] = True then
    C_dwStyle := C_dwStyle or DialogBoxStyle[X];
  //Extended Style
  for X := 0 to Check_ExtendedStyle.Items.Count -1 do
  if Check_ExtendedStyle.Checked[X] = True then
    C_dwExStyle := C_dwExStyle or ExtendedStyle[X];

  Case RadioGroup1.ItemIndex of
    0 : begin //Button
         for X := 0 to Check_Button.Items.Count -1 do
         if Check_Button.Checked[X] = True then
          C_dwStyle := C_dwStyle or ButtonStyle[X];
        end;
    1 : begin //ComboBox
         for X := 0 to Check_ComboBox.Items.Count -1 do
         if Check_ComboBox.Checked[X] = True then
          C_dwStyle := C_dwStyle or ComboBoxStyle[X];
        end;
    2 : begin //Edit
         for X := 0 to Check_Edit.Items.Count -1 do
         if Check_Edit.Checked[X] = True then
          C_dwStyle := C_dwStyle or EditStyle[X];
        end;
    3 : begin //ListBox
         for X := 0 to Check_ListBox.Items.Count -1 do
         if Check_ListBox.Checked[X] = True then
          C_dwStyle := C_dwStyle or ListBoxStyle[X];
        end;
    4 : begin //MDIClient
         for X := 0 to Check_MDIClient.Items.Count -1 do
         if Check_MDIClient.Checked[X] = True then
          C_dwStyle := C_dwStyle or MDIS_ALLCHILDSTYLES;//MDIClientStyle[X];
        end;
    5 : begin //ScrollBar
         for X := 0 to Check_ScrollBar.Items.Count -1 do
         if Check_ScrollBar.Checked[X] = True then
          C_dwStyle := C_dwStyle or ScrollBarStyle[X];
        end;
    6 : begin //Static
         for X := 0 to Check_Static.Items.Count -1 do
         if Check_Static.Checked[X] = True then
          C_dwStyle := C_dwStyle or StaticStyle[X];
        end;
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  SendMessage(HW, WM_CLOSE, 0, 0);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Classe := 'BUTTON';
end;

procedure TForm1.Padro1Click(Sender: TObject);
begin
   Check_WindowStyle.Checked[2] := True;
   Check_WindowStyle.Checked[25] := True;
   //Check_ExtendedStyle.Checked[5] := True;
end;

end.
