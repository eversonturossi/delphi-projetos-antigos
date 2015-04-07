unit aboutbox;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, shellapi;

type
  Taboutdlg = class(TForm)
    Label1: TLabel;
    StaticText1: TStaticText;
    Bevel1: TBevel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    procedure Label5Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  aboutdlg: Taboutdlg;

implementation

{$R *.DFM}

procedure Taboutdlg.Label5Click(Sender: TObject);
begin
shellexecute(application.handle, 'open', 'www.megahertz.he.com.br', nil,nil , SW_SHOWNORMAL);
end;

end.
