unit uProxy;

interface

uses
 Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
 Dialogs, StdCtrls, uNavegador, ExtCtrls, ComCtrls, OleCtrls, SHDocVw_EWB,
 EwbCore, EmbeddedWB, WinInet, Inifiles, GruposDownload;

type
 
 TProxyPorGrupo = record
  Nome: string;
  Proxys: TstringList;
 end;
 TForm1 = class(TForm)
  PageControl1: TPageControl;
  TabSheet1: TTabSheet;
  PanelNavegadores: TPanel;
  Panel1: TPanel;
  Button1: TButton;
  Button2: TButton;
  Button3: TButton;
  Panel2: TPanel;
  TabSheet2: TTabSheet;
  Proxys: TListBox;
  addProxy: TMemo;
  Panel3: TPanel;
  btnAddProxy: TButton;
  btnRemoverProxy: TButton;
  btmRemoverTodos: TButton;
  TabSheet4: TTabSheet;
  GroupBox1: TGroupBox;
  GroupBox2: TGroupBox;
  GroupBox3: TGroupBox;
  Panel8: TPanel;
  Panel7: TPanel;
  Panel4: TPanel;
  Panel5: TPanel;
  GruposDownloadListBox: TListBox;
  LinksDownloadMemo: TMemo;
  btnAdicionarGrupo: TButton;
  btnRemoverGrupoSelecionado: TButton;
  edtGrupo: TEdit;
  Panel6: TPanel;
  btnSalvarLinksDownloadMemo: TButton;
  Splitter1: TSplitter;
  Button4: TButton; //ApplicationEvents1Exception

  procedure MostraErro(Sender: TObject; E: Exception);

  procedure Button1Click(Sender: TObject);
  procedure Button3Click(Sender: TObject);
  procedure Button2Click(Sender: TObject);
  procedure FormClose(Sender: TObject; var Action: TCloseAction);
  procedure FormCreate(Sender: TObject);
  procedure btnAdicionarGrupoClick(Sender: TObject);
  procedure btnRemoverGrupoSelecionadoClick(Sender: TObject);
  procedure btnAddProxyClick(Sender: TObject);
  procedure btnRemoverProxyClick(Sender: TObject);
  procedure btmRemoverTodosClick(Sender: TObject);
  procedure GruposDownloadListBoxClick(Sender: TObject);
  procedure btnSalvarLinksDownloadMemoClick(Sender: TObject);
  procedure Button4Click(Sender: TObject);
 private
  { Private declarations }
 public
  GruposDeDownloads: TGruposDeDownload;
  procedure CriarComponente(Nome: string; Componente: TWinControl; Site: string; Proxy: string);
  function ExisteComponente(Nome: string): boolean;
  function ContaNumeroComponentes(Tipo: TComponent): Integer;
  procedure ComponentesSaveLoad(Acao: string);
 { procedure SalvarLinksDownload;
  procedure AbrirLinksDownload;
  procedure AdicionarGrupo(Nome: string);
  procedure RemoverGrupo(Nome: string);
  function LinkRandomico: string;}
  { Public declarations }
 end;
 
var
 Form1: TForm1;
 
implementation

uses uConfiguracoes, Math;

{$R *.dfm}

procedure DeleteIECache;
var
 lpEntryInfo: PInternetCacheEntryInfo;
 hCacheDir: LongWord;
 dwEntrySize: LongWord;
begin
 dwEntrySize := 0;
 FindFirstUrlCacheEntry(nil, TInternetCacheEntryInfo(nil^), dwEntrySize);
 GetMem(lpEntryInfo, dwEntrySize);
 if dwEntrySize > 0 then lpEntryInfo^.dwStructSize := dwEntrySize;
 hCacheDir := FindFirstUrlCacheEntry(nil, lpEntryInfo^, dwEntrySize);
 if hCacheDir <> 0 then
  begin
   repeat
    DeleteUrlCacheEntry(lpEntryInfo^.lpszSourceUrlName);
    FreeMem(lpEntryInfo, dwEntrySize);
    dwEntrySize := 0;
    FindNextUrlCacheEntry(hCacheDir, TInternetCacheEntryInfo(nil^), dwEntrySize);
    GetMem(lpEntryInfo, dwEntrySize);
    if dwEntrySize > 0 then lpEntryInfo^.dwStructSize := dwEntrySize;
   until not FindNextUrlCacheEntry(hCacheDir, lpEntryInfo^, dwEntrySize);
  end;
 FreeMem(lpEntryInfo, dwEntrySize);
 FindCloseUrlCache(hCacheDir);
end;

function TForm1.ExisteComponente(Nome: string): boolean;
var
 I: integer;
begin
 Result := false;
 for I := ComponentCount - 1 downto 0 do
  if Components[I].Name = Nome then
   result := true;
end;

function TForm1.ContaNumeroComponentes(Tipo: TComponent): Integer;
var
 Cont: Integer;
begin
 Cont := 0;
 
end;

procedure TForm1.CriarComponente(Nome: string; Componente: TWinControl; Site: string; Proxy: string);
var
 NavegadorProxy1: TNavegadorProxy;
begin
 if ExisteComponente(Nome) = false then
  begin
   NavegadorProxy1 := TNavegadorProxy.Create(Form1);
   with NavegadorProxy1 do begin
     Randomize;
     Name := Nome + IntToStr(RandomRange(0, 10000000));
     Parent := Componente;
     Visible := true;
     Left := 0;
     Top := 0;
     Width := 500;
     Height := 500;
     DragMode := dmAutomatic;
     Align := alClient;
     //SetProxy(Proxy); ativar novamente pra funcionar proxy
     Navega(Site);
    end;
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
 CriarComponente('MyBrowser', PanelNavegadores, LinkRandomico, Proxys.Items.Strings[Proxys.ItemIndex]);
 CriarComponente('MyBrowser', PanelNavegadores, LinkRandomico, Proxys.Items.Strings[Proxys.ItemIndex]);
 CriarComponente('MyBrowser', PanelNavegadores, LinkRandomico, Proxys.Items.Strings[Proxys.ItemIndex]);
 CriarComponente('MyBrowser', PanelNavegadores, LinkRandomico, Proxys.Items.Strings[Proxys.ItemIndex]);
 CriarComponente('MyBrowser', PanelNavegadores, LinkRandomico, Proxys.Items.Strings[Proxys.ItemIndex]);
 CriarComponente('MyBrowser', PanelNavegadores, LinkRandomico, Proxys.Items.Strings[Proxys.ItemIndex]);
 CriarComponente('MyBrowser', PanelNavegadores, LinkRandomico, Proxys.Items.Strings[Proxys.ItemIndex]);
 CriarComponente('MyBrowser', PanelNavegadores, LinkRandomico, Proxys.Items.Strings[Proxys.ItemIndex]);
 CriarComponente('MyBrowser', PanelNavegadores, LinkRandomico, Proxys.Items.Strings[Proxys.ItemIndex]);
 CriarComponente('MyBrowser', PanelNavegadores, LinkRandomico, Proxys.Items.Strings[Proxys.ItemIndex]);
 
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
 DeleteIECache;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
 I: Integer;
 NavegadorProxy1: TNavegadorProxy;
begin
 for I := ComponentCount - 1 downto 0 do
  begin
   if Components[I] is TNavegadorProxy then
    begin
     NavegadorProxy1 := Components[I] as TNavegadorProxy;
     NavegadorProxy1.Free;
     NavegadorProxy1 := nil;
    end;
  end;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 tbSaveFormStatus(Self, Self.Name);
 //ComponentesSaveLoad('save');
end;

procedure TForm1.MostraErro(Sender: TObject; E: Exception);
begin
 //ShowMessage('Ocorreu algum erro!');
end;

procedure TForm1.FormCreate(Sender: TObject);
var
 CONT: integer;
begin
 
 Application.OnException := MostraErro;
 
 tbLoadFormStatus(Self, Self.Name);
 //ComponentesSaveLoad('load');
 PageControl1.ActivePageIndex := 0;
 
 Proxys.Items.LoadFromFile('proxys.conf');
 AbrirLinksDownload;
end;

procedure TForm1.ComponentesSaveLoad(Acao: string);
 function FindComponentEx(const Name: string): TComponent;
 var
  FormName: string;
  CompName: string;
  P: Integer;
  Found: Boolean;
  Form: TForm;
  I: Integer;
 begin
  // Split up in a valid form and a valid component name
  P := Pos('.', Name);
  if P = 0 then
   begin
    raise Exception.Create('No valid form name given');
   end;
  FormName := Copy(Name, 1, P - 1);
  CompName := Copy(Name, P + 1, High(Integer));
  Found := False;
  // find the form
  for I := 0 to Screen.FormCount - 1 do
   begin
    Form := Screen.Forms[I];
    // case insensitive comparing
    if AnsiSameText(Form.Name, FormName) then
     begin
      Found := True;
      Break;
     end;
   end;
  if Found then
   begin
    for I := 0 to Form.ComponentCount - 1 do
     begin
      Result := Form.Components[I];
      if AnsiSameText(Result.Name, CompName) then
       Exit;
     end;
   end;
  Result := nil;
 end;
var
 Componente: TComponent;
 ComponenteDado: string;
 ComponenteNome: string;
 Ini: TIniFile;
 Componentes: TStringList;
 Cont: Integer;
begin
 Componentes := TStringList.Create;
 Ini := TIniFile.Create(ChangeFileExt(ExtractFilePath(ParamStr(0)) + '\' + ExtractFileName(ParamStr(0)), '.ini'));
 { Componentes.Add('wProcura_Filtro');
  Componentes.Add('wProcura_MAX');
  Componentes.Add('wProcura_MIN');
  Componentes.Add('wComunidades_Sorted');
  Componentes.Add('wComunidades_CapturarRelacionadas');
  Componentes.Add('wComunidades_Filtro');
  Componentes.Add('wComunidades_DelayPagina');
  Componentes.Add('wComunidades_DelayComunidade'); }
 for Cont := 0 to Componentes.Count - 1 do
  begin
   ComponenteNome := Componentes.Strings[Cont];
   Componente := FindComponentEx(Self.GetNamePath + '.' + ComponenteNome);
   if LowerCase(Acao) = LowerCase('save') then
    begin
     try
      ComponenteDado := '';
      if LowerCase(Componente.ClassName) = LowerCase('TEdit') then
       ComponenteDado := Tedit(Componente).Text;
      //if LowerCase(Componente.ClassName) = LowerCase('TFlatEdit') then
       //ComponenteDado := TFlatEdit(Componente).Text;
      if LowerCase(Componente.ClassName) = LowerCase('TCheckBox') then
       ComponenteDado := BoolToStr(TCheckBox(Componente).Checked);
      //if LowerCase(Componente.ClassName) = LowerCase('TFlatCheckBox') then
      // ComponenteDado := BoolToStr(TFlatCheckBox(Componente).Checked);
      //if LowerCase(Componente.ClassName) = LowerCase('TFlatSpinEditFloat') then
      // ComponenteDado := FloatToStr(TFlatSpinEditFloat(Componente).Value);
      Ini.WriteString('APPConf', ComponenteNome, ComponenteDado);
     except
     end;
    end;
   if LowerCase(Acao) = LowerCase('load') then
    begin
     try
      ComponenteDado := '';
      if Ini.ReadString('APPconf', ComponenteNome, '') <> '' then
       ComponenteDado := Ini.ReadString('APPconf', ComponenteNome, '');
      if ComponenteDado <> '' then
       begin
        if LowerCase(Componente.ClassName) = LowerCase('TEdit') then
         Tedit(Componente).Text := ComponenteDado;
        // if LowerCase(Componente.ClassName) = LowerCase('TFlatEdit') then
         //  TFlatEdit(Componente).Text := ComponenteDado;
        if LowerCase(Componente.ClassName) = LowerCase('TCheckBox') then
         TCheckBox(Componente).Checked := StrToBool(ComponenteDado);
        //   if LowerCase(Componente.ClassName) = LowerCase('TFlatCheckBox') then
        //    TFlatCheckBox(Componente).Checked := StrToBool(ComponenteDado);
           //if LowerCase(Componente.ClassName) = LowerCase('TFlatSpinEditFloat') then
          //  TFlatSpinEditFloat(Componente).Value := StrToFloat(ComponenteDado);
       end;
     except
     end;
    end;
  end;
 Ini.Free;
 Componentes.Free;
end;

procedure TForm1.btnAdicionarGrupoClick(Sender: TObject);
begin
 if trim(edtGrupo.Text) <> '' then
  begin
   AdicionarGrupo(edtGrupo.Text);
   SalvarLinksDownload;
   edtGrupo.Clear;
  end;
end;

procedure TForm1.btnRemoverGrupoSelecionadoClick(Sender: TObject);
begin
 if GruposDownloadListBox.ItemIndex <> -1 then
  begin
   RemoverGrupo(GruposDownloadListBox.Items.Strings[GruposDownloadListBox.ItemIndex]);

   LinksDownloadMemo.Enabled := false;
   btnSalvarLinksDownloadMemo.Enabled := false;
   LinksDownloadMemo.Lines.Clear;

   GruposDownloadListBox.Items.Delete(GruposDownloadListBox.ItemIndex);
  end;
end;

procedure TForm1.btnAddProxyClick(Sender: TObject);
var
 i: integer;
begin
 for i := 0 to addProxy.Lines.Count - 1 do
  begin
   Proxys.Items.Add(Trim(addProxy.Lines.Strings[0]));
   addProxy.Lines.Delete(0);
   Application.ProcessMessages;
  end;
 Proxys.Items.SaveToFile('proxys.conf');
end;

procedure TForm1.btnRemoverProxyClick(Sender: TObject);
begin
 if Proxys.ItemIndex <> -1 then
  begin
   Proxys.Items.Delete(Proxys.ItemIndex);
   Proxys.Items.SaveToFile('proxys.conf');
  end;
end;

procedure TForm1.btmRemoverTodosClick(Sender: TObject);
begin
 Proxys.Clear;
 Proxys.Items.SaveToFile('proxys.conf');
end;

procedure TForm1.GruposDownloadListBoxClick(Sender: TObject);
var
 CONT: integer;
begin
 if GruposDownloadListBox.ItemIndex <> -1 then
  begin
   LinksDownloadMemo.Enabled := true;
   LinksDownloadMemo.Lines.Clear;
   btnSalvarLinksDownloadMemo.Enabled := true;
   LinksDownloadMemo.Lines.Assign(GruposDeDownloads.getLinks(GruposDownloadListBox.Items.Strings[GruposDownloadListBox.ItemIndex]));
  end;
end;

procedure TForm1.btnSalvarLinksDownloadMemoClick(Sender: TObject);
var
 CONT, I: integer;
begin
 if GruposDownloadListBox.ItemIndex <> -1 then
  begin
   for I := LinksDownloadMemo.Lines.Count - 1 downto 0 do
    begin
     LinksDownloadMemo.Lines.Strings[I] := Trim(LinksDownloadMemo.Lines.Strings[I]);
     if Trim(LinksDownloadMemo.Lines.Strings[I]) = '' then
      LinksDownloadMemo.Lines.Delete(I);
    end;
   GruposDeDownloads.AdicionarAlterarLinks(GruposDownloadListBox.Items.Strings[GruposDownloadListBox.ItemIndex], LinksDownloadMemo.Lines);
   SalvarLinksDownload;
  end;
end;

{procedure TForm1.SalvarLinksDownload;
begin
end;

procedure TForm1.AbrirLinksDownload;
begin
end;

procedure TForm1.AdicionarGrupo(Nome: string);

begin
 
end;

procedure TForm1.RemoverGrupo(Nome: string);

begin
 
end;

function TForm1.LinkRandomico: string;

begin
 
end; }

procedure TForm1.Button4Click(Sender: TObject);
var
 I, Cont: Integer;
begin
 cont := 0;
 for I := ComponentCount - 1 downto 0 do
  begin
   if Components[I] is TNavegadorProxy then
    begin
     Cont := cont + 1;
    end;
  end;
 caption := IntToStr(Cont) + ' Instancias';
end;

end.

