
{ Fontes por Glauber A. Dantas - www.delphix.com.br }

unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


var
  Form1: TForm1;
  I : Integer; { Variavel global }

implementation

{$R *.dfm}

function Soma(N :Integer): Integer;
var
  PI: ^Integer ; { Variavel Local }
begin
  PI := @I; { Endereço de I para PI}
  PI^ := N + PI^; { Soma }
  Result := PI^; { Result }
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  I := 0;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  Edit1.Text := IntToStr(Soma(10));
end;

end.
