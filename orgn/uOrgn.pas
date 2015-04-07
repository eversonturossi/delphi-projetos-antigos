unit uOrgn;

interface

uses
 Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
 Dialogs, TFlatTabControlUnit, TFlatGaugeUnit, ToolWin, ComCtrls, ImgList,
 XPMan, ExtCtrls, TFlatPanelUnit, StdCtrls, TFlatEditUnit,
 TFlatSpinEditUnit, TFlatSpeedButtonUnit, TFlatMemoUnit, TFlatListBoxUnit,
 TFlatHintUnit, TFlatButtonUnit, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdFTP, TFlatGroupBoxUnit;

type
 TFTPs = record
  host: string;
  login: string;
  senha: string;
  tipo: char;
 end;
 TfrmPrincipal = class(TForm)
  StatusBar1: TStatusBar;
  pcPrincipal: TPageControl;
  tbPrincipal: TTabSheet;
  tbUpdates: TTabSheet;
  tbFtps: TTabSheet;
  tbStatus: TTabSheet;
  pnlPrincipal: TPanel;
  Panel3: TPanel;
  Panel4: TPanel;
  ListBox1: TListBox;
  Panel2: TPanel;
  FlatGauge1: TFlatGauge;
  pnlAtualizar: TPanel;
  Memo1: TMemo;
  btnAtualizar: TFlatSpeedButton;
  btnParar: TFlatSpeedButton;
  TimerAtualizando: TTimer;
  edtUVersao: TFlatSpinEditInteger;
  FlatHint1: TFlatHint;
  pnlUpdatesBaixo: TPanel;
  Panel6: TPanel;
  ListBox2: TListBox;
  btnUSalvar: TFlatSpeedButton;
  btnUGera: TFlatSpeedButton;
  Label1: TLabel;
  Label2: TLabel;
  edtUNome: TFlatEdit;
  edtLinks: TMemo;
  Label3: TLabel;
  FlatEdit1: TFlatEdit;
  Label4: TLabel;
  FlatSpinEditInteger2: TFlatSpinEditInteger;
  Label5: TLabel;
  pnlFTPBaixo: TPanel;
  btnFSalvar: TFlatSpeedButton;
  btnFGera: TFlatSpeedButton;
  Label6: TLabel;
  FlatEdit2: TFlatEdit;
  Label7: TLabel;
  FlatEdit3: TFlatEdit;
  Label8: TLabel;
  FlatEdit4: TFlatEdit;
  Label9: TLabel;
  edtUarquivo: TFlatEdit;
  Label10: TLabel;
  tbFTPAcontes: TTabSheet;
  tbFTPmanager: TTabSheet;
    pnlFTPCounts: TPanel;
  Panel7: TPanel;
  pnlTeclado: TPanel;
  FlatButton1: TFlatButton;
  FlatButton2: TFlatButton;
  FlatButton3: TFlatButton;
  FlatButton4: TFlatButton;
  FlatButton5: TFlatButton;
  FlatButton6: TFlatButton;
  FlatButton7: TFlatButton;
  FlatButton8: TFlatButton;
  FlatButton9: TFlatButton;
  FlatButton10: TFlatButton;
  tbFTPTest: TTabSheet;
  Panel1: TPanel;
    IdFTP1: TIdFTP;
    FlatGroupBox1: TFlatGroupBox;
    Label11: TLabel;
    FlatEdit8: TFlatEdit;
    FlatEdit5: TFlatEdit;
    FlatEdit6: TFlatEdit;
    FlatEdit7: TFlatEdit;
    ListBox3: TListBox;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
  procedure FormCreate(Sender: TObject);
  procedure FormResize(Sender: TObject);
  procedure btnAtualizarClick(Sender: TObject);
  procedure btnPararClick(Sender: TObject);
  procedure Atualizar;
  procedure Parar;
  procedure TimerAtualizandoTimer(Sender: TObject);
  procedure FormClose(Sender: TObject; var Action: TCloseAction);
  procedure ReadData(sTipo, sData: string);
  procedure WriteData;
 private
  { Private declarations }
 public
  { Public declarations }
 end;
 
var
 frmPrincipal: TfrmPrincipal;
 FTPList: array of TFTPs;
 File_inf: string;
 File_data: TextFile;
 
implementation

uses uFunctions;

{$R *.dfm}

procedure TfrmPrincipal.ReadData(sTipo, sData: string);
begin
 //

end;

procedure TfrmPrincipal.WriteData;
begin
 //
 
end;

procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin
 pcPrincipal.TabIndex := 0;
 tbLoadFormStatus(Self, Self.Name);
 File_inf := ChangeFileExt(ExtractFilePath(ParamStr(0)) + '\' + ExtractFileName(ParamStr(0)), '.txt');
 if not FileExists(File_inf) then
  begin
   AssignFile(File_data, File_inf);
   Rewrite(File_data);
   CloseFile(File_data);
  end
 else
  begin
   AssignFile(File_data, File_inf);
   Reset(File_data);
   while not Eof(File_data) do
    begin

    end;
   CloseFile(File_data);
  end;
end;

procedure TfrmPrincipal.FormResize(Sender: TObject);
begin
 
 pnlTeclado.Top := trunc((pnlPrincipal.Height / 2) - (pnlTeclado.Height / 2));
 pnlTeclado.Left := trunc((pnlPrincipal.Width / 2) - (pnlTeclado.Width / 2));
 
 btnUSalvar.Width := trunc(pnlUpdatesBaixo.Width / 2) - 8;
 btnUGera.Width := btnUSalvar.Width + 1;
 btnUGera.Left := btnUSalvar.Width + btnUSalvar.Left - 1;
 
 btnFSalvar.Width := trunc(pnlFTPBaixo.Width / 2) - 8;
 btnFGera.Width := btnFSalvar.Width + 1;
 btnFGera.Left := btnFSalvar.Width + btnFSalvar.Left - 1;
 
 btnAtualizar.Width := trunc(pnlAtualizar.Width / 2) - 8;
 btnParar.Width := btnAtualizar.Width + 1;
 btnParar.Left := btnAtualizar.Width + btnAtualizar.Left - 1;
 
end;

procedure TfrmPrincipal.btnAtualizarClick(Sender: TObject);
begin
 Atualizar;
end;

procedure TfrmPrincipal.btnPararClick(Sender: TObject);
begin
 Parar;
end;

procedure TfrmPrincipal.Atualizar;
begin
 btnAtualizar.Enabled := false;
 btnParar.Enabled := true;
 // StatusBar1.Panels[0].Text := 'Atualizando...';
 TimerAtualizando.Enabled := true;
 Application.ProcessMessages;
end;

procedure TfrmPrincipal.Parar;
begin
 btnAtualizar.Enabled := true;
 btnParar.Enabled := false;
 TimerAtualizando.Enabled := false;
 StatusBar1.Panels[0].Text := 'Atualizado';
end;

procedure TfrmPrincipal.TimerAtualizandoTimer(Sender: TObject);
begin
 if StatusBar1.Panels[0].Text = 'Atualizando...' then
  StatusBar1.Panels[0].Text := ''
 else
  StatusBar1.Panels[0].Text := 'Atualizando...';
end;

procedure TfrmPrincipal.FormClose(Sender: TObject;
 var Action: TCloseAction);
begin
 tbSaveFormStatus(Self, Self.Name);
end;

end.

