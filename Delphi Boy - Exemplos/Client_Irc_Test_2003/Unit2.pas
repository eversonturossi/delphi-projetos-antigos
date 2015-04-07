unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Spin;

type
  TFrmConect = class(TForm)
    Label2: TLabel;
    SpinEdit1: TSpinEdit;
    Button1: TButton;
    Button2: TButton;
    GroupBox1: TGroupBox;
    CheckBox1: TCheckBox;
    Label7: TLabel;
    Label8: TLabel;
    EProxy_Host: TEdit;
    EProxy_Porta: TEdit;
    Label9: TLabel;
    Label10: TLabel;
    EProxy_User: TEdit;
    EProxy_Pass: TEdit;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    E_Server: TEdit;
    E_Nick: TEdit;
    E_Nome: TEdit;
    E_Mail: TEdit;
    Edit1: TEdit;
    E_AltNick: TEdit;
    Label11: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmConect: TFrmConect;

implementation

uses Unit1;

{$R *.DFM}

procedure TFrmConect.Button1Click(Sender: TObject);
begin
  Nick := E_Nick.Text;
  AltNick := E_AltNick.Text;
  Nome := E_Nome.Text;
  Mail := E_Mail.Text;
  Servidor := E_Server.Text;
  ServPorta := SpinEdit1.Value;

  UseProxy := CheckBox1.Checked;

  if UseProxy then
  begin
    ProxyServer := EProxy_Host.Text;
    ProxyPorta := StrToInt(EProxy_Porta.Text);
    Form1.ClientSocket.Host := ProxyServer;
    Form1.ClientSocket.Port := ProxyPorta;
  end
  else
  begin
    Form1.ClientSocket.Host := Servidor;
    Form1.ClientSocket.Port := ServPorta;
  end;

  Form1.ClientSocket.Open;
  FrmConect.Close;
end;

procedure TFrmConect.Button2Click(Sender: TObject);
begin
  FrmConect.Close;
end;

end.
 