
{ Source by Prodigy - [#DELPHIX] - irc.brasnet.org }

unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,
  ImageHlp, StdCtrls, FileCtrl;

type
  TForm1 = class(TForm)
    DriveComboBox1: TDriveComboBox;
    DirectoryListBox1: TDirectoryListBox;
    FileListBox1: TFileListBox;
    FilterComboBox1: TFilterComboBox;
    Memo1: TMemo;
    procedure FileListBox1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    List: TStrings;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure ListDLLFunctions(DLLName: String; List: TStrings);
type
  chararr = array [0..$FFFFFF] of Char;
  var
  H: THandle;
  I,
  fc: integer;
  st: string;
  arr: Pointer;
  ImageDebugInformation: PImageDebugInformation;
begin
  List.Clear;
  DLLName := ExpandFileName(DLLName);
  if FileExists(DLLName) then
  begin
    H := CreateFile(PChar(DLLName), GENERIC_READ, FILE_SHARE_READ or
      FILE_SHARE_WRITE, nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
    if H<>INVALID_HANDLE_VALUE then
      try
        ImageDebugInformation := MapDebugInformation(H, PChar(DLLName), nil, 0);
        if ImageDebugInformation<>nil then
          try
            arr := ImageDebugInformation^.ExportedNames;
            fc := 0;
            for I := 0 to ImageDebugInformation^.ExportedNamesSize - 1 do
              if chararr(arr^)[I]=#0 then
              begin
                st := PChar(@chararr(arr^)[fc]);
                if Length(st)>0 then
                  List.Add(st);
                if (I>0) and (chararr(arr^)[I-1]=#0) then
                  Break;
                fc := I + 1
              end
          finally
            UnmapDebugInformation(ImageDebugInformation)
          end
      finally
        CloseHandle(H)
      end
  end
end;

procedure TForm1.FileListBox1Change(Sender: TObject);
var
  Arquivo: String;
  I: integer;
  S: String;
begin
  if  FileListBox1.ItemIndex <> -1 then
  begin
   Arquivo := FileListBox1.FileName;
   Memo1.Lines.Clear;
   
   ListDLLFunctions(Arquivo, List);
   S := 'Lista de funções encontrada:';
    for I := 0 to List.Count - 1 do
     S := S + #13#10 + List[I];
   Memo1.Lines.Add(S);
   Memo1.Lines.Add('-------------------------------');
   Memo1.Lines.Add('Número de funções: '+ IntToStr(List.Count));
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  List := TStringList.Create;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  List.Free;
end;

end.
