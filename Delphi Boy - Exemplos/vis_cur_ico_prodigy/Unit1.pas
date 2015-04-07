{********************************************************************}
{  ** Visualizador de cursores e icones by Prodigy **                }
{ - Autor: Glauber A. Dantas(Prodigy_-)                              }
{ - Info: masterx@cpunet.com.br,                                     }
{         #DelphiX - [Brasnet] irc.brasnet.org - www.delphix.com.br  }
{ - Descrição:                                                       }
{   Visualização de cursores(*.cur) e cursores animados(*.ani) no    }
{   proprio cursor e de icones(*.ico) em um TImage.                  }
{ - Este exemplo pode ser modificado livremente.                     }
{********************************************************************}

unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, FileCtrl, StdCtrls, ShellAPI;

type
  TForm1 = class(TForm)
    FileListBox1: TFileListBox;
    DriveComboBox1: TDriveComboBox;
    DirectoryListBox1: TDirectoryListBox;
    FilterComboBox1: TFilterComboBox;
    Label1: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    Image1: TImage;
    procedure FileListBox1Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.FileListBox1Change(Sender: TObject);
var
  NomeArq, Ext : String;
  Pic : TPicture;
  TI : TIcon;
const
  MC = 1;
begin
  if FileListBox1.ItemIndex <> -1 then
  begin
    NomeArq := FileListBox1.FileName;
    Ext := AnsiUpperCase(ExtractFileExt(NomeArq));
    
    if (Ext = '.ICO') then
    begin
      TI := TIcon.Create;
      TI.Handle := ExtractIcon(HInstance, Pchar(NomeArq), 0);
      Pic := TPicture.Create;
      Pic.Icon := TI;
      Image1.Picture := Pic;
      TI.Free;
      Pic.Free;
    end
    else
    begin
      Image1.Picture := nil;
      Screen.Cursors[MC] := LoadCursorFromFile(Pchar(NomeArq));
      Cursor := MC;
      Panel1.Cursor := MC;
      Panel2.Cursor := MC;
      FileListBox1.Cursor := MC;
    end;
    
    Label1.Caption := NomeArq;
  end;

end;

end.
