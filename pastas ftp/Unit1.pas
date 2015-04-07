unit Unit1;

interface

uses
 Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
 Dialogs, StdCtrls, IdBaseComponent, IdComponent, IdTCPConnection,
 IdTCPClient, IdFTP, ComCtrls, ShellCtrls;

type
 TForm1 = class(TForm)
  Button1: TButton;
  IdFTP1: TIdFTP;
  ShellTreeView1: TShellTreeView;
 private
  { Private declarations }
 public
  { Public declarations }
 end;
 
var
 Form1: TForm1;
 
implementation

{$R *.dfm}

procedure FTPDirToTreeView(AFTP: TidFTP; ATree: TTreeView; ADirectory: string; AItem: TTreeNode; AIncludeFiles: Boolean);
var
 ItemTemp: TTreeNode;
 LS: TStringList;
 i: integer;
begin
 ATree.Items.BeginUpdate;
 LS := TStringList.Create;
 try
  if ADirectory <> '' then
   AFTP.ChangeDir(ADirectory);
  AFTP.TransferType := ftASCII;
  AFTP.List(LS);
  if AnsiPos('total', LS[0]) > 0 then
   LS.Delete(0);
  LS.Sorted := True;
  if LS.Count <> 0 then
   begin
    for i := 0 to LS.Count - 1 do
     begin
      try
       if Pos('.', LS.Strings[i]) = 0 then
        begin
         AItem := ATree.Items.AddChild(AItem, Trim(Copy(LS.Strings[i],
          Pos(':', LS.Strings[i]) + 3,
          Length(LS.Strings[i])) + '/'));
         ItemTemp := AItem.Parent;
         FTPDirToTreeView(AFTP, ATree, ADirectory + Trim(Copy(LS.Strings[i],
          Pos(':', LS.Strings[i]) + 3,
          Length(LS.Strings[i]))) + '/', AItem, AIncludeFiles);
         AItem := ItemTemp;
        end
       else if (AIncludeFiles) and (Pos('.', LS.Strings[i]) <> 0) then
        ATree.Items.AddChild(AItem, LS.Strings[i]);
      except
      end;
     end;
   end;
 finally
  ATree.Items.EndUpdate;
  LS.Free;
 end;
end;

procedure FTPDirToTreeView(AFTP: TIdFTP; ATree: TTreeView;
 const ADirectory: string; AItem: TTreeNode;
 AIncludeFiles: Boolean);
var
 TempItem: TTreeNode;
 I: Integer;
 DirList: TIdFTPListItems;
 DirItem: TIdFTPListItem;
 LS: TStringList;
begin
 LS := TStringList.Create;
 try
  LS.Sorted := True;
  ATree.Items.BeginUpdate;
  try
   if (ADirectory <> '') then
    AFTP.ChangeDir(ADirectory);
   AFTP.TransferType := ftASCII;
   AFTP.List(nil);

   DirList := AFTP.DirectoryListing;
   for i := 0 to DirList.Count - 1 do
    begin
     try
      DirItem := DirList.Items[i];
      if (DirItem.ItemType = ditDirectory) then
       begin
        TempItem := ATree.Items.AddChild(AItem, Trim(DirItem.FileName)
         + '/');
        LS.AddObject(Trim(DirItem.FileName), TempItem);
       end
      else
       begin
        if (AIncludeFiles) then
         ATree.Items.AddChild(AItem, DirItem.FileName);
       end;
     except
     end;
    end;

   for i := 0 to LS.Count - 1 do
    begin
     FTPDirToTreeView(AFTP, ATree, ADirectory +
      LS.Strings[i] + '/', TTreeNode(LS.Objects[i]), AIncludeFiles);
    end;
  finally
   ATree.Items.EndUpdate;
  end;
 finally
  LS.Free;
 end;
end;

Usage:

procedure TForm1.IdFTP1AfterClientLogin(Sender: TObject);
begin
 tvFileList.Items.BeginUpdate;
 Screen.Cursor := crHourGlass;
 try
  tvFileList.Items.Clear;
  FTPDirToTreeView(idFTP1, tvFileList, '/', nil, True);
 finally
  Screen.Cursor := crDefault;
  tvFileList.Items.EndUpdate;
 end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
 idFTP1.Connect;
end;

end.

 