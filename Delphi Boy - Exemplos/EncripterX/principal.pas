unit principal;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, Mask, ExtCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Label1: TLabel;
    Button3: TButton;
    OpenDialog1: TOpenDialog;
    Label2: TLabel;
    Label3: TLabel;
    procedure Button3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  NomedoArquivo: String;

implementation


{$R *.DFM}


procedure TForm1.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if Key in ['0'..'9',#8] then
    begin
      exit;
    end
  else
    begin
      Abort;
    end;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
    begin
      NomedoArquivo:=OpenDialog1.FileName;
      Label1.Caption:='Arquivo: '+NomedoArquivo;
    end;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  InMS, OutMS : TMemoryStream;
  I : Integer;
  C : byte;
begin
  if Edit1.Text<>'' then
    begin
      InMS := TMemoryStream.Create;
      OutMS := TMemoryStream.Create;
      try
        InMS.LoadFromFile(NomedoArquivo);
        InMS.Position := 0;
      for I := 0 to InMS.Size - 1 do
        begin
          InMS.Read(C, 1);
          C := (C xor not(ord(StrToInt(Edit1.Text) shr I)));
          OutMS.Write(C,1);
        end;
      OutMS.SaveToFile(NomedoArquivo);
      finally
        InMS.Free;
        OutMS.Free;
      end;
    end
  else
    begin
      InMS := TMemoryStream.Create;
      OutMS := TMemoryStream.Create;
      try
        InMS.LoadFromFile(NomedoArquivo);
        InMS.Position := 0;
      for I := 0 to InMS.Size - 1 do
        begin
          InMS.Read(C, 1);
          C := (C xor not(ord(0 shr I)));
          OutMS.Write(C,1);
        end;
      OutMS.SaveToFile(NomedoArquivo);
      finally
        InMS.Free;
        OutMS.Free;
      end;
    end;
end;

end.
