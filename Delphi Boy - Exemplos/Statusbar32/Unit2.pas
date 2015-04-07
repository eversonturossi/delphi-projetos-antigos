unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm2 = class(TForm)
    ListBox1: TListBox;
    Button1: TButton;
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Edit2: TEdit;
    Button2: TButton;
    Label3: TLabel;
    Label4: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure ListBox1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Edit1Change(Sender: TObject);
  private
    { Private declarations }
    procedure UpdateItems;
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

uses Unit1;

{$R *.dfm}

procedure TForm2.Button1Click(Sender: TObject);
var
  Cont : Integer;
begin
  Cont := ListBox1.Items.Count;
  Panels[Cont] := TPanelX.Create;
  Panels[Cont].Texto := Edit1.TExt;
  Panels[Cont].Index := Cont;
  Panels[Cont].Largura := StrToInt(Edit2.Text);
  ListBox1.AddItem(Panels[Cont].Texto, Panels[Cont]);

  Inc(PanelsCont);
end;

procedure TForm2.Button2Click(Sender: TObject);
begin
  Form2.Close;
end;

procedure TForm2.ListBox1Click(Sender: TObject);
begin
   Edit1.Text := Panels[ListBox1.ItemIndex].Texto;
   Edit2.Text := IntToStr(Panels[ListBox1.ItemIndex].Largura);
   Label4.Caption := IntToStr(Panels[ListBox1.ItemIndex].Index);
end;

procedure TForm2.ListBox1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_DELETE then
  begin
   Panels[ListBox1.ItemIndex] := nil;
   //ListBox1.Items.Delete(ListBox1.ItemIndex);
   Dec(PanelsCont);
  end;

  UpdateItems;
end;

procedure TForm2.UpdateItems;
var
 I, Id : Integer;
begin
  ListBox1.Items.Clear;
  Id := 0 ;
  { Verifica quais o Paneis validos e coloca na listbox}
  for I := 0 to PanelsCont do
  begin
    if Panels[I] <> nil then
    begin
     Panels[I].Index := Id;
     Inc(Id);
     ListBox1.AddItem(Panels[I].Texto, Panels[I]);
    end;
  end;
  { Limpa os Panels}
  for I := 0 to 127 do
   Panels[I] := nil;
  { Coloca os Panels da listbox na variavel }
  for I := 0 to PanelsCont -1 do
  begin
   //Panels[I] := TPanelX.Create;
   Panels[I] := TPanelX(ListBox1.Items.Objects[I]);
  end;
end;

procedure TForm2.Edit1Change(Sender: TObject);
begin
  ListBox1.Items[ListBox1.ItemIndex] := Edit1.Text;
  Panels[ListBox1.ItemIndex].Texto := Edit1.Text;
  Panels[ListBox1.ItemIndex].Largura := StrToInt(Edit2.TExt);
end;

end.
