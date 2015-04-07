unit Config1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, Buttons, ExtCtrls, ColorGrd;

type
  TConfig2 = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Label1: TLabel;
    nick: TEdit;
    BitBtn2: TBitBtn;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    BitBtn1: TBitBtn;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    porta: TEdit;
    Label8: TLabel;
    Label9: TLabel;
    ende: TEdit;
    Conex: TBitBtn;
    ColorGrid1: TColorGrid;
    ColorGrid2: TColorGrid;
    ColorGrid3: TColorGrid;
    ColorGrid4: TColorGrid;
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure ConexClick(Sender: TObject);
    procedure ColorGrid1Change(Sender: TObject);
    procedure ColorGrid2Change(Sender: TObject);
    procedure ColorGrid3Change(Sender: TObject);
    procedure ColorGrid4Change(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Config2: TConfig2;

implementation

uses RTMCh;

{$R *.dfm}

procedure TConfig2.BitBtn2Click(Sender: TObject);
begin
Close;
end;

procedure TConfig2.BitBtn1Click(Sender: TObject);
begin
Chat.Msg.Color := Panel1.Color;
Chat.Txt.Color := Panel2.Color;
Chat.Msg.Font.Color := Panel3.Color;
Chat.Txt.Font.Color := Panel4.Color;
Close;
end;

procedure TConfig2.ConexClick(Sender: TObject);
begin
Chat.Cliente.Port := StrToInt(porta.Text);
Chat.Cliente.Address := ende.Text;
Chat.Cliente.Open;
Test := False;
Close;
end;

procedure TConfig2.ColorGrid1Change(Sender: TObject);
begin
Panel1.Color := ColorGrid1.ForegroundColor; 
end;

procedure TConfig2.ColorGrid2Change(Sender: TObject);
begin
Panel2.Color := ColorGrid2.ForegroundColor;
end;

procedure TConfig2.ColorGrid3Change(Sender: TObject);
begin
Panel3.Color := ColorGrid3.ForegroundColor;
end;

procedure TConfig2.ColorGrid4Change(Sender: TObject);
begin
Panel4.Color := ColorGrid4.ForegroundColor;
end;

procedure TConfig2.FormShow(Sender: TObject);
begin
PageControl1.ActivePageIndex := 1;
ende.SetFocus;
end;

end.
