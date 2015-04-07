unit Cli_Center;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ScktComp;

type
  TFrmCenter = class(TForm)
    ClientSocket1: TClientSocket;
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Edit2: TEdit;
    Label3: TLabel;
    Edit3: TEdit;
    Button1: TButton;
    Button2: TButton;
    GroupBox1: TGroupBox;
    Edit4: TEdit;
    GroupBox2: TGroupBox;
    Memo1: TMemo;
    GroupBox3: TGroupBox;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Edit4KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Edit4KeyPress(Sender: TObject; var Key: Char);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure ClientSocket1Connect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ClientSocket1Disconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ClientSocket1Read(Sender: TObject; Socket: TCustomWinSocket);
    procedure Button5Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmCenter: TFrmCenter;

implementation

{$R *.dfm}

procedure TFrmCenter.Button1Click(Sender: TObject);
begin
  ClientSocket1.Host := Edit1.Text;
  ClientSocket1.Port := StrToInt(Edit2.Text);
  ClientSocket1.Open;
end;

procedure TFrmCenter.Button2Click(Sender: TObject);
begin
  ClientSocket1.Close;
end;

procedure TFrmCenter.Edit4KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
  if Edit4.Text <> '' then
  begin
    ClientSocket1.Socket.SendText('MSG:'+ Edit4.Text +#13#10);
    Edit4.Clear;
  end;
end;

procedure TFrmCenter.Edit4KeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
   Key := #0;
end;

procedure TFrmCenter.Button3Click(Sender: TObject);
begin
  ClientSocket1.Socket.SendText('INFO!' +#13#10);
end;

procedure TFrmCenter.Button4Click(Sender: TObject);
begin
  ClientSocket1.Socket.SendText('DATETIME!' +#13#10);
end;

procedure TFrmCenter.ClientSocket1Connect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  Socket.SendText('NICK:'+ Edit3.Text +#13#10);
  Memo1.Lines.Add('Conectado em '+ Socket.RemoteHost+'['+ Socket.RemoteAddress+']')
end;

procedure TFrmCenter.ClientSocket1Disconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  Memo1.Lines.Add('[Deconectado]')
end;

procedure TFrmCenter.ClientSocket1Read(Sender: TObject;
  Socket: TCustomWinSocket);
var
 RecText : String;
begin
  RecText := Socket.ReceiveText;
  Memo1.Lines.Add(RecText);
end;

procedure TFrmCenter.Button5Click(Sender: TObject);
begin
  ClientSocket1.Socket.SendText('GETCLIENT!' +#13#10);
end;

end.
