unit uNavegador;

interface

uses
 Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
 Dialogs, OleCtrls, SHDocVw_EWB, EwbCore, EmbeddedWB, ComCtrls, ExtCtrls, Math;

type
 TNavegadorProxy = class(TFrame)
  EmbeddedWB1: TEmbeddedWB;
  Panel1: TPanel;
  ProgressBar1: TProgressBar;
  Panel2: TPanel;
  TimerDownload: TTimer;
  TimerFechaLimite: TTimer;
  TimerFechar: TTimer;
  procedure EmbeddedWB1BeforeNavigate2(ASender: TObject; const pDisp: IDispatch; var URL, Flags, TargetFrameName, PostData, Headers: OleVariant; var Cancel: WordBool);
  procedure EmbeddedWB1DownloadBegin(Sender: TObject);
  procedure EmbeddedWB1ProgressChange(ASender: TObject; Progress, ProgressMax: Integer);
  procedure EmbeddedWB1ScriptError(Sender: TObject; ErrorLine, ErrorCharacter, ErrorCode, ErrorMessage, ErrorUrl: string; var ContinueScript, Showdialog: Boolean);
  function EmbeddedWB1ShowMessage(HWND: Cardinal; lpstrText, lpstrCaption: PWideChar; dwType: Integer; lpstrHelpFile: PWideChar; dwHelpContext: Integer; var plResult: Integer): HRESULT;
  procedure EmbeddedWB1StatusTextChange(ASender: TObject; const Text: WideString);
  procedure EmbeddedWB1DocumentComplete(ASender: TObject; const pDisp: IDispatch; var URL: OleVariant);
  procedure TimerDownloadTimer(Sender: TObject);
  procedure TimerFecharTimer(Sender: TObject);
  procedure TimerFechaLimiteTimer(Sender: TObject);
 private
  { Private declarations }
 public
  procedure NavegaProxy(Url: string; Proxy: string);
  procedure Navega(Url: string);
  procedure SetProxy(Proxy: string);
  procedure ExecutaTimerDownload;
  { Public declarations }
 end;
 
implementation

{$R *.dfm}

function SendForm(WebBrowser: TEmbeddedWB; FieldName: string): boolean;
var
 i, j: Integer;
 FormItem: Variant;
begin
 Result := False;
 try
  if WebBrowser.OleObject.Document.all.tags('FORM').Length = 0 then
   begin
    Exit;
   end;
  for I := 0 to WebBrowser.OleObject.Document.forms.Length - 1 do
   begin
    FormItem := WebBrowser.OleObject.Document.forms.Item(I);
    for j := 0 to FormItem.Length - 1 do
     begin
      try
       if FormItem.Item(j).Name = FieldName then
        begin
         FormItem.Item(j).Click;
         Result := True;
        end;
      except
       Exit;
      end;
     end;
   end;
 except
 end;
end;

procedure TNavegadorProxy.Navega(Url: string);
begin
 
 EmbeddedWB1.Navigate(Url);
end;

procedure TNavegadorProxy.NavegaProxy(Url: string; Proxy: string);
begin
 EmbeddedWB1.ProxySettings.SetProxy(EmbeddedWB1.UserAgent, Proxy);
 EmbeddedWB1.Navigate(Url);
end;

procedure TNavegadorProxy.SetProxy(Proxy: string);
begin
 EmbeddedWB1.ProxySettings.SetProxy(EmbeddedWB1.UserAgent, Proxy);
end;

procedure TNavegadorProxy.EmbeddedWB1BeforeNavigate2(ASender: TObject;
 const pDisp: IDispatch; var URL, Flags, TargetFrameName, PostData,
 Headers: OleVariant; var Cancel: WordBool);
begin
 Panel2.Caption := URL;
end;

procedure TNavegadorProxy.EmbeddedWB1DownloadBegin(Sender: TObject);
begin
 ProgressBar1.Position := 0;
end;

procedure TNavegadorProxy.EmbeddedWB1ProgressChange(ASender: TObject;
 Progress, ProgressMax: Integer);
begin
 try
  if Progress > 0 then
   begin
    ProgressBar1.Max := ProgressMax;
    ProgressBar1.Position := Progress;
   end
  else
   begin
    ProgressBar1.Position := 0;
   end;
 except
 end;
end;

procedure TNavegadorProxy.EmbeddedWB1ScriptError(Sender: TObject;
 ErrorLine, ErrorCharacter, ErrorCode, ErrorMessage, ErrorUrl: string;
 var ContinueScript, Showdialog: Boolean);
begin
 try
  Showdialog := false; //Do not show the script error dialog
  ContinueScript := true; //Go on loading the page
 except
 end;
end;

function TNavegadorProxy.EmbeddedWB1ShowMessage(HWND: Cardinal; lpstrText,
 lpstrCaption: PWideChar; dwType: Integer; lpstrHelpFile: PWideChar;
 dwHelpContext: Integer; var plResult: Integer): HRESULT;
begin
 Result := S_OK; //Don't show the messagebox
end;

procedure TNavegadorProxy.EmbeddedWB1StatusTextChange(ASender: TObject;
 const Text: WideString);
begin
 // if (LowerCase(Copy(Text, 1, 7)) = 'http://') or (LowerCase(Copy(Text, 1, 10)) = 'javascript') or (Trim(Text) = '') then
 //  wStatusBar.Panels[2].Text := Text;
end;

procedure TNavegadorProxy.EmbeddedWB1DocumentComplete(ASender: TObject; const pDisp: IDispatch; var URL: OleVariant);
begin
 ExecutaTimerDownload;
end;

procedure TNavegadorProxy.ExecutaTimerDownload;
var
 Tempo: integer;
begin
 Randomize;
 Tempo := RandomRange(1500, 4000);
 TimerDownload.Interval := Tempo;
 TimerDownload.Enabled := true;
end;

procedure TNavegadorProxy.TimerDownloadTimer(Sender: TObject);
var
 Tempo: integer;
begin
 SendForm(EmbeddedWB1, 'download');
 (Sender as TTimer).Enabled := false;
 
 Randomize;
 Tempo := RandomRange(5000, 15000);
 TimerFechar.Interval := Tempo;
 TimerFechar.Enabled := true;
end;

procedure TNavegadorProxy.TimerFecharTimer(Sender: TObject);
begin
 //fechar aplicaçao apos clicar no botao download
end;

procedure TNavegadorProxy.TimerFechaLimiteTimer(Sender: TObject);
begin
 if (Sender as TTimer).Interval = 100 then
  begin
   (Sender as TTimer).Enabled := false;
   (Sender as TTimer).Interval := 30000;
   (Sender as TTimer).Enabled := true;
  end
 else
  begin
   (Sender as TTimer).Enabled := false;
   //fechar aplicaçao apos nao dar nada certo
  end;
end;

end.

