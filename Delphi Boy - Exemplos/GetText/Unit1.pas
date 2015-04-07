{**************************************************}
{             c . A . N . A . L                    }
{        # D . E . L . P . H . I . X               }
{    [-----------------------------------]         }
{                                                  }
{       Brasnet - irc.brasnet.org                  }
{ Fontes por:                                      }
{         Glauber A. Dantas (Prodigy)              }
{         www.delphix.com.br                       }
{**************************************************}

unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    Memo1: TMemo;
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

function EnumChildProc(Child : HWND; Form: TForm1): Boolean; Export; {$ifdef Win32} StdCall; {$endif}
var
  Cla, WTest : Array[0..99] of char;
  ID : Integer;
  Classe: String;
 WinStr: Array[0..2047] of Char; //Ate 2048 caracteres
begin
   //GetWindow(Child, GW_CHILD);
   GetClassName(Child, Cla, SizeOf(Cla)+1);
   GetWindowText(Child, WTest , SizeOf(WTest)+1);

   Classe := StrPas(Cla);
   //Verifica a classe
   if UpperCase(Classe) = UpperCase('EDIT') then
   begin
    //Retorna o text
    SendMessage(Child, WM_GETTEXT, 2048, Longint(@WinStr));
    Form.Memo1.Lines.Text := StrPas(WinStr);
   end;
   Result := True;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  Wnd : Hwnd;
begin
  //Retorna o handle
  Wnd := Findwindow(nil, Pchar(Edit1.TExt));
  //Lista janelas Childs
  if Wnd <> 0 then
    EnumChildWindows(Wnd, @EnumChildProc, LongInt(Self));
end;

end.
