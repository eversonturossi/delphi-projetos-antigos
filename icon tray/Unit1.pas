unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ShellAPI, Menus;

const
  wm_IconMessage = wm_User;

type
  TForm1 = class(TForm)
    PopupMenu1: TPopupMenu;
    Lloyd1: TMenuItem;
    close1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure CLOSE1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Lloyd1Click(Sender: TObject);
  private
    procedure IconTray(var Msg: TMessage); message wm_IconMessage;
    { Private declarations }
  public
    { Public declarations }
    nid: TNotifyIconData;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  // carrega o ícone inicial
  Icon.Handle := LoadIcon(HInstance, 'MAINICON');
  // preenche os dados da estrutura NotifyIcon
  nid.cbSize := sizeof(nid);
  nid.wnd := Handle;
  nid.uID := 1; // Identificador do ícone
  nid.uCallBAckMessage := wm_IconMessage;
  nid.hIcon := Icon.Handle;
  nid.szTip := 'LloydSoft';
  nid.uFlags := nif_Message or nif_Icon or nif_Tip;
  Shell_NotifyIcon(NIM_ADD, @nid);
end;

procedure TForm1.IconTray(var Msg: TMessage);
var
  Pt: TPoint;
begin
  if Msg.lParam = wm_rbuttondown then
  begin
    GetCursorPos(Pt);
    // SetForegroundWindow (Handle);
    PopupMenu1.Popup(Pt.x, Pt.y);
  end;
end;

procedure TForm1.CLOSE1Click(Sender: TObject);
begin
  Form1.close;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  nid.uFlags := 0;
  Shell_NotifyIcon(NIM_DELETE, @nid);
end;

procedure TForm1.Lloyd1Click(Sender: TObject);
begin
  Showmessage('Funciona'); { Menu Popup }
end;

end.
