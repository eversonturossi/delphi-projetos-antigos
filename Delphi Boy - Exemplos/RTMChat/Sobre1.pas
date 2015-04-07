unit Sobre1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, antLabel, ShellApi;

type
  TSobre2 = class(TForm)
    Image1: TImage;
    antLabel1: TantLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    procedure Label6Click(Sender: TObject);
    procedure Label8Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Sobre2: TSobre2;

implementation

{$R *.dfm}

procedure TSobre2.Label6Click(Sender: TObject);
begin
ShellExecute(Handle, 'open', 'http://www.rtmsoft.hpg.com.br', '', '', 0);
end;

procedure TSobre2.Label8Click(Sender: TObject);
begin
ShellExecute(Handle, 'open', 'mailto:rtlvm@bol.com.br', '', '', SW_Show);
end;

end.
