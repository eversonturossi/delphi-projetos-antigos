unit UntConfiguracao;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, IniFiles, IAeverButton, ComCtrls;

type
  TFrmConfiguracoes = class(TForm)
    BtnGravar: TIAeverButton;
    BtnCancelar: TIAeverButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    EdtServidor: TEdit;
    EdtPorta: TEdit;
    EdtNick: TEdit;
    EdtNome: TEdit;
    EdtEmail: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure BtnGravarClick(Sender: TObject);
    procedure BtnCancelarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmConfiguracoes: TFrmConfiguracoes;
  IniConfig: TIniFile;

implementation

uses UntPrincipal;

{$R *.DFM}

procedure TFrmConfiguracoes.FormCreate(Sender: TObject);
begin
  IniConfig:=TIniFile.Create(FrmPrincipal.DirwIRC + '\Config.ini');
  EdtServidor.Text:=IniConfig.ReadString('Geral', 'Servidor', '');
  EdtPorta.Text:=IniConfig.ReadString('Geral', 'Porta', '');
  EdtNome.Text:=IniConfig.ReadString('Geral', 'Nome', '');
  EdtEmail.Text:=IniConfig.ReadString('Geral', 'Email', '');
  EdtNick.Text:=IniConfig.ReadString('Geral', 'Nick', '');
end;

procedure TFrmConfiguracoes.BtnGravarClick(Sender: TObject);
begin
  IniConfig.WriteString('Geral', 'Servidor', EdtServidor.Text);
  IniConfig.WriteInteger('Geral', 'Porta', StrToInt(EdtPorta.Text));
  IniConfig.WriteString('Geral', 'Nome', EdtNome.Text);
  IniConfig.WriteString('Geral', 'Email', EdtEmail.Text);
  IniConfig.WriteString('Geral', 'Nick', EdtNick.Text);
  Close;
end;

procedure TFrmConfiguracoes.BtnCancelarClick(Sender: TObject);
begin
  Close;
end;

end.
