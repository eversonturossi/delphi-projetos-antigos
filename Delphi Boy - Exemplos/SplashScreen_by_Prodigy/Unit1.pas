{**************************************************}
{             c . A . N . A . L                    }
{        # D . E . L . P . H . I . X               }
{    [-----------------------------------]         }
{                                                  }
{       Brasnet - irc.brasnet.org                  }
{       www.delphix.com.br                         }
{ Source by:                                       }
{          Glauber A. Dantas(Prodigy) - 15/08/2003 }
{**************************************************}

unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses Tela;

{$R *.DFM}

procedure TForm1.FormShow(Sender: TObject);
begin
  { Cria e Mostra FormTela }
  Application.CreateForm(TFormTela, FormTela);
  FormTela.ShowModal;
end;

end.
