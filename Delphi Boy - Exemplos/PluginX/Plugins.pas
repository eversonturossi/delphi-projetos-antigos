unit Plugins;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, PluginX;

type
  TFrmPlugins = class(TForm)
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    ListView1: TListView;
    Label1: TLabel;
    MemDesc: TMemo;
    Label2: TLabel;
    LabAuthor: TLabel;
    Label4: TLabel;
    LabCopy: TLabel;
    Label6: TLabel;
    LabHome: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure ListView1Change(Sender: TObject; Item: TListItem;
      Change: TItemChange);
  private
    { Private declarations }
  public
    { Public declarations }
    AppInfo : TAppInfo;
    procedure InitPlugins;
    procedure DeInitPlugins;
    procedure NewPPlugin(var APlugin: PPlugin);
  end;


var
  FrmPlugins: TFrmPlugins;
  PluginList: TList;//Lista de Plugins carregados
  Plugin : PPlugin;


implementation

uses Center;

{$R *.dfm}

//Retorna lista arquivos numa pasta
procedure EnumFiles(Pasta, Arquivo: String; Files: TStringList);
var
  SR: TSearchRec;
  ret : integer;
begin
  if Pasta[Length(Pasta)] <> '\' then
   Pasta := Pasta + '\';

   ret := FindFirst(Pasta + Arquivo, faAnyFile, SR);
   if ret = 0 then
   try
     repeat
       if not (SR.Attr and faDirectory > 0) then
         Files.Add(Pasta + SR.Name);

       ret := FindNext(SR);
     until ret <> 0;

   finally
     SysUtils.FindClose(SR)
   end;
end;

//Carrega DLLs/Plugins/Funções das DLLs na memória
procedure TFrmPlugins.InitPlugins;
var
  DllList : TStringList;
  X : Integer;
  LibHandle: THandle;
  Item: TListItem;
begin
  PluginList := TList.Create;
  DllList := TStringList.Create;

  //Procura DLLs na subpasta plugins da aplicação
  EnumFiles(ExtractFilePath(Application.ExeName)+'plugins\', '*.dll', DllList);

  try
    if DllList.Count > 0 then
    for X := 0 to DllList.Count -1 do
    begin
       NewPPlugin(Plugin);
       //New(PLugin);
       with Plugin^ do
       begin
        StrPCopy(DLLName, DllList[X]);

        //Carrega DLL
        LibHandle := LoadLibrary(PChar(DllList[X]));
        if LibHandle <> 0 then
        begin
          DLLHandle := LibHandle;
          //Carrega funções
          @FLoadPlugin   := GetProcAddress(LibHandle, 'LoadPlugin');
          @FUnloadPlugin := GetProcAddress(LibHandle, 'UnLoadPlugin');
          @FOnExecute    := GetProcAddress(LibHandle, 'OnExecute');
          @FSendClientToPlug := GetProcAddress(LibHandle, 'SendClientToPlug');
          end;
         if @FLoadPlugin <> nil then
         begin
           //ShowMEssage(StrPas(DLLName));

           //Executa função LoadPlugin
           FLoadPlugin(AppInfo, PluginInfo);

           //ShowMEssage(StrPas(DLLName));

           //Coloca informações no ListView 
           with PluginInfo do
           begin
             Item := ListView1.Items.Add;
             Item.Caption      := StrPas(pFunction);
             LabAuthor.Caption := StrPas(pAuthor);
             LabCopy.Caption   := StrPas(pCopyright);
             LabHome.Caption   := StrPas(pHome);
             MemDesc.Lines.Text := StrPas(pDescription);
             Item.SubItems.Add(StrPas(pVersion));
             Item.SubItems.Add(ExtractFileName(StrPas(DLLName)));
             //Item.SubItems.Add(FileSize(StrPas(DLLName)));
             Item.Data := Plugin;
           end;
         end;
      end;
     PluginList.Add(Plugin);
    end;
  finally
    DllList.Free;
  end;
end;

//Libera DLLs/plugins da memória
procedure TFrmPlugins.DeInitPlugins;
var
  X : Integer;
begin
  if PluginList.Count > 0 then
  for X := PluginList.Count -1 downto 0 do
  begin
    Plugin := PPlugin(PluginList.Items[X]);
    with Plugin^ do
    begin
      { Executa função UnloadPlugin da DLL }
      if @FUnloadPlugin <> nil then
        FUnloadPlugin;
      { Libera DLL }
      FreeLibrary(DLLHandle);
      @FLoadPlugin   := nil;
      @FUnloadPlugin := nil;
      @FOnExecute    := nil;
    end;
    { Liebra plugin }
    Dispose(Plugin);
    //PluginList.Delete(X);
  end;
  PluginList.Clear;
  PluginList.Free;
end;

procedure TFrmPlugins.FormCreate(Sender: TObject);
begin
   { Define valores a serem enviados para o plugin quando
     executar a função LoadPlugin }
   AppInfo.Version := '1.0.0.1';
   AppInfo.Hwnd    := FrmCenter.Handle;
   //AppInfo.Keep := True;

   { Carrega/Inicializa plugins }
   InitPlugins;   
end;

//Aloca espaço na memória para novo Plugin carregado
procedure TFrmPlugins.NewPPlugin(var APlugin: PPlugin);
begin
  New(APlugin);
  with APlugin^ do
  begin
    DLLName := AllocMem(SizeOf(TPlugin));
    with PluginInfo do
    begin
      pVersion   := AllocMem(SizeOf(TPlugin));
      pAuthor    := AllocMem(SizeOf(TPlugin));
      pCopyright := AllocMem(SizeOf(TPlugin));
      pHome      := AllocMem(SizeOf(TPlugin));
      pFunction  := AllocMem(SizeOf(TPlugin));
      pDescription := AllocMem(SizeOf(TPlugin));
    end;
  end;
end;

procedure TFrmPlugins.ListView1Change(Sender: TObject; Item: TListItem;
  Change: TItemChange);
var
  X : Integer;
begin
  X := PluginList.IndexOf(Item.Data);
   if X <> -1 then
    with PPlugin(PluginList[X])^.PluginInfo do
    begin
       Item.Caption      := StrPas(pFunction);
       LabAuthor.Caption := StrPas(pAuthor);
       LabCopy.Caption   := StrPas(pCopyright);
       LabHome.Caption   := StrPas(pHome);
       MemDesc.Lines.Text := StrPas(pDescription);
       Item.SubItems[0] := StrPas(pVersion);
       Item.SubItems[1] := ExtractFileName(StrPas(PPlugin(PluginList[X])^.DLLName));
       //Item.SubItems[2] := FileSize(StrPas(DLLName));
    end;
end;

end.
