{**************************************************}
{             c . A . N . A . L                    }
{        # D . E . L . P . H . I . X               }
{    [-----------------------------------]         }
{                                                  }
{       Brasnet - irc.brasnet.org                  }
{       www.delphix.com.br                         }
{ Fonte por:                                       }
{          Glauber A. Dantas(Prodigy) - 21/12/2003 }
{**************************************************}

unit Center;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, FileCtrl, ShellAPI;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    Button1: TButton;
    Memo1: TMemo;
    Label2: TLabel;
    Label3: TLabel;
    Memo2: TMemo;
    Memo3: TMemo;
    Label4: TLabel;
    ListBox1: TListBox;
    Button2: TButton;
    Button3: TButton;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Label14Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

//para Listar Sub-Pastas de uma Pasta em uma TStrings
procedure EnumFolders(Root: String; Folders: TStrings);
   procedure Enum(dir: String);
   var
     SR: TSearchRec;
     ret: Integer;
   begin
     if dir[length(dir)] <> '\' then
       dir := dir + '\';

     ret := FindFirst(dir + '*.*', faDirectory, SR);
     if ret = 0 then
     try
       repeat
         if ((SR.Attr and faDirectory) <> 0) and
            ( SR.Name <> '.') and
            ( SR.Name <> '..') then
         begin
           folders.add( dir+SR.Name );
           Enum( dir + SR.Name );
         end;

         ret := FindNext( SR );
       until ret <> 0;

     finally
       SysUtils.FindClose(SR)
     end;
   end;

begin
  if root <> EmptyStr then
    Enum(root);
end;

//usa EnumFolders para listar as Sub-Pastas e procuras por arquivos
procedure EnumFiles(Pasta, Arquivo: String; Files: TStrings);
var
  SR: TSearchRec;
  SubDirs : TStringList;
  ret, X : integer;
  sPasta: String;
begin
  if Pasta[Length(Pasta)] <> '\' then
   Pasta := Pasta + '\';

 try
   SubDirs := TStringList.Create;
   SubDirs.Add(Pasta);
   EnumFolders(Pasta, SubDirs);
  

    if SubDirs.Count > 0 then
    for X := 0 to SubDirs.Count -1 do
    begin
      sPasta:= SubDirs[X];
      if sPasta[Length(sPasta)] <> '\' then
       sPasta := sPasta + '\';

       ret := FindFirst(sPasta + Arquivo, faAnyFile, SR);
       if ret = 0 then
       try
         repeat
           if not (SR.Attr and faDirectory > 0) then
             Files.Add(sPasta + SR.Name);

           ret := FindNext(SR);
         until ret <> 0;

       finally
         SysUtils.FindClose(SR)
       end;
    end;
  finally
    SubDirs.Free;
  end;
end;

function GetBytesFileSize(const FileName: String): Int64;
var
   FFD: TWIN32FindData;
begin
  If Windows.FindClose( Windows.FindFirstFile( PChar(FileName), FFD) ) then
    Result := (FFD.nFileSizeHigh * MAXDWORD) + FFD.nFileSizeLow
  else
    Result := 0;
end;

function GetAFileSize(SizeInBytes: Integer): String;
const
  Preffixes: array[0..3] of String = //Common file sizes preffixes
   (' Bytes', ' KB', 'MB', ' GB'); //Change if you want to anything that suits
  FormatSpecifier: array[Boolean] of String =
   ('%n', '%.2n'); //the way we format the string;
var
  i: integer; //A counter
  TmpSize: Real; //A temporary variable
begin
  i := -1; //Avoid compiler complain
  tmpSize := SizeInBytes; //Avoid compiler complain
  while (i <= 3) do //Main cycle it is done while i < High(Preffixes) but since
                    // a file will rarely pass a GB up to 3
  begin
    TmpSize := TmpSize / 1024; //1 MB = 1024 KB, 1 KB = 1024 Bytes, 1 Byte = 8 Bits, 1 bit = nothing
    inc( i ); //increment counter and select preffix string
    if Trunc( TmpSize )= 0 then //we reached a maximum nuber of divisions so
    begin
      TmpSize := TmpSize * 1024; //Tmpsize was divided 1 time more than necessary
      Break; //Exit of loop;
    end;
  end;

  //Actual formatting routine
  Result := Format(FormatSpecifier[((Frac(TmpSize)*10) >1)], [TmpSize]) + Preffixes[i];
end;

function GetFileSize(const AFileName: String): String;
begin
   Result := GetAFileSize(GetBytesFileSize(AFileName));
end;

function GetFileDate(FileName: string): string;
var
  FHandle : integer;
begin
  try
    FHandle := FileOpen(FileName, fmShareCompat or fmShareDenyNone or fmOpenRead);
    Result := FormatDateTime('dd/mm/yyyy', FileDateToDateTime(FileGetDate(FHandle)));
    FileClose(FHandle);
  except
    Result := 'Sem data';
    Exit;
  end;
end;

{-------------------------------- Fim funções ---------------------------------}

procedure TForm1.Button1Click(Sender: TObject);
var
  Dir: string;
begin
  if SelectDirectory('Selecione o diretório', 'c:\',Dir) then
  begin
    Edit1.Text := Dir;
    EnumFiles(Edit1.Text, '*.*', ListBox1.Items);
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  X : Integer;
  Html, Arq : String;
  ListaHtml: TStringList;
begin
  EnumFiles(Edit1.Text, '*.*', ListBox1.Items);
  
  if ListBox1.Items.Count > 0 then
  for X := 0 to ListBox1.Items.Count -1 do
  begin
    Label16.Caption := IntToStr(X);
    Application.ProcessMessages;

    Arq := ListBox1.Items[X];
    
    Html := Html + Memo2.Text;
    Html := StringReplace(Html,'$TAMANHO',GetFileSize(Arq), [rfReplaceAll, rfIgnoreCase]);
    Html := StringReplace(Html,'$DATAARQ',GetFileDate(Arq), [rfReplaceAll, rfIgnoreCase]);
    Html := StringReplace(Html,'$NOMEARQ',ExtractFileName(Arq), [rfReplaceAll, rfIgnoreCase]);
    Delete(Arq,1, Length(Edit1.Text)); // Apaga caminho ate a pasta atual
    Arq := StringReplace(Arq,'\','/', [rfReplaceAll]);// de \ para /
    Html := StringReplace(Html,'$PATHARQ',Arq, [rfReplaceAll, rfIgnoreCase]);
  end;

  ListaHtml := TStringList.Create;
  try
    Html := Memo1.Text + Html + Memo3.Text;
    ListaHtml.Text := Html;
    ListaHtml.SaveToFile('index.html');
  finally
    ListaHtml.Free;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Edit1.Text := ExtractFilePath(Application.ExeName);
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.Label14Click(Sender: TObject);
begin
   ShellExecute(Application.Handle, nil, 'http://www.delphix.com.br/',
       nil, nil, SW_SHOWNORMAL);
end;

end.
