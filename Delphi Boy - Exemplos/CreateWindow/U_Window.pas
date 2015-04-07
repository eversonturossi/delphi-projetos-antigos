unit U_Window;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus;

type
  TFrmWindow = class(TForm)
    PopupMenu1: TPopupMenu;
    Mostrar1: TMenuItem;
    Esconder1: TMenuItem;
    Fechar1: TMenuItem;
    Mover1: TMenuItem;
    NoTopo1: TMenuItem;
    procedure Mostrar1Click(Sender: TObject);
    procedure Esconder1Click(Sender: TObject);
    procedure Fechar1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure NoTopo1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmWindow: TFrmWindow;

implementation

uses Unit1;

{$R *.DFM}

procedure TFrmWindow.Mostrar1Click(Sender: TObject);
begin
   ShowWindow(Form1.HW , SW_SHOW);
end;

procedure TFrmWindow.Esconder1Click(Sender: TObject);
begin
   ShowWindow(Form1.HW , SW_HIDE);
end;

procedure TFrmWindow.Fechar1Click(Sender: TObject);
begin
   SendMessage(Form1.HW, WM_CLOSE, 0, 0);
end;

procedure TFrmWindow.FormShow(Sender: TObject);
begin
  FrmWindow.Left := 0;
  FrmWindow.Top  := 0;
end;

procedure TFrmWindow.NoTopo1Click(Sender: TObject);
begin
   SetWindowPos(Form1.HW, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE or
        SWP_NOSIZE or SWP_NOACTIVATE);
end;

end.
