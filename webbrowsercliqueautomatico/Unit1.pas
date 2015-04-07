unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, OleCtrls, SHDocVw, ExtCtrls, Menus;

type
  TForm1 = class(TForm)
    WebBrowser1: TWebBrowser;
    Panel1: TPanel;
    Button1: TButton;
    Edit1: TEdit;
    MainMenu1: TMainMenu;
    Arquivo1: TMenuItem;
    Jose1: TMenuItem;
    procedure Button1Click(Sender: TObject);
    procedure WebBrowser1DocumentComplete(Sender: TObject;
      const pDisp: IDispatch; var URL: OleVariant);
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
  WebBrowser1.Navigate(Edit1.Text);
end;

procedure TForm1.WebBrowser1DocumentComplete(Sender: TObject;
  const pDisp: IDispatch; var URL: OleVariant);
var
  Pt : TPoint;
begin
  Pt.X := 414;
  Pt.Y := 388;
  {Obtém o point no centro do Button1}
  //Pt.x := Button2.Left + (Button2.Width div 2);
  //Pt.y := Button2.Top + (Button2.Height div 2);
  {Converte Pt para as coordenadas da tela }
  Pt := ClientToScreen(Pt);
  Pt.x := Round(Pt.x * (65535 / Screen.Width));
  Pt.y := Round(Pt.y * (65535 / Screen.Height));
  {Move o mouse}
  Mouse_Event(MOUSEEVENTF_ABSOLUTE or MOUSEEVENTF_MOVE, Pt.x, Pt.y, 0, 0);
  {Simula o pressionamento do botão esquerdo do mouse}
  Mouse_Event(MOUSEEVENTF_ABSOLUTE or MOUSEEVENTF_LEFTDOWN, Pt.x, Pt.y, 0, 0);
  {Simula soltando o botão esquerdo do mouse}
  Mouse_Event(MOUSEEVENTF_ABSOLUTE or MOUSEEVENTF_LEFTUP, Pt.x, Pt.y, 0, 0);
end;

end.
