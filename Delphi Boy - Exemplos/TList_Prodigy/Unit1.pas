
{ Source by Prodigy - [#DelphiX] - irc.brasnet.org } 

unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm1 = class(TForm)
    Button2: TButton;
    Memo1: TMemo;
    Button1: TButton;
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    List : TList; { Lista de Pointers }
  public
    { Public declarations }
  end;

type
  PMyBuf = ^MyBuf; { Pointer para o tipo MyBuf }
  MyBuf = array[1..1000] of byte; { tipo MyBuf }


var
  Form1: TForm1;
  Buf, BufCopia : PMyBuf; { variavel Buf e a sua respectiva Copia..
                            criei so pra nao usar a variavel Buf pq ela pode ser
                            modificada por outro evento }

implementation

{$R *.DFM}

procedure TForm1.Button2Click(Sender: TObject);
var
  I : Byte;
begin
  Buf[1] := 100;
  
  //Lista as variaveis contidas na lista
  for I := 0 to (List.Count - 1) do
  begin
   //atribui a BufCopia cada uma
   BufCopia := List.Items[I];

   //adiciona o 1º valor no Memo
   Memo1.Lines.Add(IntToStr(BufCopia[1]));
  end;

end;

procedure TForm1.FormCreate(Sender: TObject);
begin
   New(Buf); { Cria uma nova variavel dinamica Buf }
   Buf[1] := 123; { seta um valor qualquer }
   Buf[2] := 255;
   List := TList.Create; { Cria a lista de Pointers }
   
   BufCopia := Buf;
   List.Add(BufCopia); { adiciona a variavel Buf na Lista }
   New(BufCopia); { Cria uma nova BufCopia, e deixa salva a q esta na lista }
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
   Buf[1] := 111;
   Buf[2] := 222;

   BufCopia := Buf;
   List.Add(BufCopia);
   Memo1.Lines.Add(IntToStr(BufCopia[1]));
   New(BufCopia);
end;

end.
