unit UntwIRCStatus;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UntwIRCSecao, Menus, StdCtrls, IFSPas, IFS_Var, IFS_Utl, IFS_Obj, IFPSLib,
  ifpstrans, ifsdfrm, ifsctrlstd, ImgList;

type
  TwIRCStatus = class(TwIRCSecao)
    procedure FormShow(Sender: TObject);
    procedure CmdTextoKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
  private
    procedure MostrarErro(var Script: TIFPasScript);
  public
    ScriptOk: boolean;
    ArqScript: TStringList;
    Script: TIFPasScript;
  end;

var
  wIRCStatus: TwIRCStatus;

implementation

uses UntPrincipal, UntFuncoes, ifpsdll, ifpsdll2, ifpsdate;

{$R *.DFM}

procedure TwIRCStatus.MostrarErro(var Script: TIFPasScript);
var
  Erro: string;
  Linha: integer;

begin
  Erro:=ErrorToString(Script.ErrorCode, Script.ErrorString);
  Linha:=PosToLinha(ArqScript.Text, Script.ErrorPos);
  AdLinha(Format('-> Erro: %s(%d) %s', [Script.ErrorModule, Linha, Erro]));
end;

function OnUses(id: Pointer; Sender: TIfPasScript; Name: string): TCs2Error;
begin
  Result := ENoError;
  if Name = 'SYSTEM' then
  begin
    RegisterStdLib(Sender, False);
    RegisterTIfStringList(Sender);
    RegisterTransLibrary(Sender);
    RegisterFormsLibrary(Sender);
    RegisterStdControlsLibrary(Sender);

    RegisterDllCallLibrary(Sender);
    RegisterExceptionLib(Sender);
    RegisterDll2library(Sender);
    RegisterDateTimeLib(Sender);

    Result := ENoError;
  end
end;

function RegProc(Sender: TIfPasScript; ScriptID: Pointer; proc: PProcedure; Params: PVariableManager; res: PIfVariant): TIfPasScriptError;
begin
  if proc^.Name = 'ALERTA' then
  begin
    MessageBox(0, PChar(GetString(Vm_Get(Params, 0))), 'wIRC', MB_OK + MB_ICONEXCLAMATION + MB_TASKMODAL);
  end
  else if proc^.Name = 'INFO' then
  begin
    MessageBox(0, PChar(GetString(Vm_Get(Params, 0))), 'wIRC', MB_OK + MB_ICONINFORMATION + MB_TASKMODAL);
  end
  else if proc^.Name = 'ERRO' then
  begin
    MessageBox(0, PChar(GetString(Vm_Get(Params, 0))), 'wIRC', MB_OK + MB_ICONERROR + MB_TASKMODAL);
  end;
  Result := ENoError;
end;

procedure TwIRCStatus.FormShow(Sender: TObject);
begin
  MemTexto.Height:=ClientHeight - 24;
  MemTexto.Width:=ClientWidth;
  CmdTexto.Top:=ClientHeight - 23;
  CmdTexto.Width:=ClientWidth;
  FrmPrincipal.RolarTexto(MemTexto);
end;

procedure TwIRCStatus.CmdTextoKeyPress(Sender: TObject; var Key: Char);
var
  Texto: string;

begin
  if (Key = #13) then
  begin
    if (FrmPrincipal.EstIRC = eiDesconectado) then
    begin
      AdLinha('Não conectado!');
      CmdTexto.Text:='';
    end
    else
      if (Length(CmdTexto.Text) > 0) then
      begin
        Texto:=CmdTexto.Text;
        AdLinha(Texto);
        CmdTexto.Text:='';
        FrmPrincipal.ClientePrincipal.Socket.SendText(Texto + #13 + #10);
      end;
    FrmPrincipal.RolarTexto(Self.MemTexto);
    Abort;
  end;
end;

procedure TwIRCStatus.FormCreate(Sender: TObject);
begin
  {Inicia controle de script}
  Script:=TIFPasScript.Create(nil);

  {Abre o script principal}
  ArqScript:=TStringList.Create;
  try
    ArqScript.LoadFromFile('Script.txt');
    Script.SetText(ArqScript.Text);
    Script.OnUses:=OnUses;
    ScriptOk:=true;
  except
    AdLinha('-> Erro: Impossível abrir o script principal, características padrão executadas');
    ScriptOk:=false;
  end;

  {Exporta funções para o script}
  Script.AddFunction(@RegProc, 'procedure Alerta(Texto: String)', nil);
  Script.AddFunction(@RegProc, 'procedure Info(Texto: String)', nil);
  Script.AddFunction(@RegProc, 'procedure Erro(Texto: String)', nil);

  {Inicia script}
  Script.RunScript;
  if (Script.ErrorCode <> ENoError) then {Ocorreu algum erro}
    MostrarErro(Script);

  inherited;
  {Barra do Status é criada automaticamente(herdada do form TwIRCSecao)}
  Barra.Caption:='Status';
  Barra.Hint:='Status';
  FrmPrincipal.ImlIcones.GetBitmap(0, Self.Barra.Glyph);
end;

procedure TwIRCStatus.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caNone;
  Beep;
end;

procedure TwIRCStatus.FormDestroy(Sender: TObject);
begin
  {Libera o script principal}
  inherited;
  ArqScript.Free;
  Script.Free;
end;

end.
