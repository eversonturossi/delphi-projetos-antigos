unit Unit1;

interface

uses
 Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
 Dialogs, StdCtrls, Menus;

type
 TForm1 = class(TForm)
  MainMenu1: TMainMenu;
  fazerasporra1: TMenuItem;
  Button1: TButton;
  ListBox1: TListBox;
  ListBox2: TListBox;
  Button3: TButton;
  procedure CloseGenerico(Sender: TObject; var CloseAction: TCloseAction);
  procedure ChamaForm2;
  procedure fazerasporra1Click(Sender: TObject);
  procedure Button1Click(Sender: TObject);
  procedure FormCreate(Sender: TObject);
  procedure Button3Click(Sender: TObject);
 private
  { Private declarations }
 public
  { Public declarations }
 end;
 
var
 Form1: TForm1;
 
implementation

uses Unit10, Unit11, Unit12, Unit13, Unit14, Unit15, Unit16, Unit17,
 Unit18, Unit19, Unit2, Unit20, Unit3, Unit4, Unit5, Unit6, Unit7, Unit8,
 Unit9;

{$R *.dfm}

function CriaFormModal(Formulario: TFormClass): Boolean;
begin
  with Formulario.Create(Application) do
   begin
    try
     Result := ShowModal = mrYes;
    finally
     //  Free
    end;
   end;
end;

procedure TForm1.CloseGenerico(Sender: TObject; var CloseAction: TCloseAction);
begin
 // ShowMessage('');
 CloseAction := caFree;
end;

procedure TForm1.ChamaForm2;
begin
 {Form2 := TForm2.Create(self);
 Form2.OnClose := CloseGenerico;  }
end;

procedure TForm1.fazerasporra1Click(Sender: TObject);
var
 i: integer;
begin
 for i := 1 to Screen.FormCount - 1 do
  begin
   Screen.Forms[i].Caption := 'Formulário número: ' + IntToStr(i);
   Screen.Forms[i].Height := 300;
   Screen.Forms[i].Width := 300;
   Screen.Forms[i].Show;
  end;
 
end;

procedure TForm1.Button1Click(Sender: TObject);
var
 i: integer;
begin
 ListBox2.Clear;
 for i := 1 to Screen.FormCount - 1 do
  begin
   ListBox2.Items.Add(Screen.Forms[i].Name);
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
 i: integer;
begin
 for i := 2 to 20 do
  ListBox1.Items.Add('TForm' + IntToStr(i))
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
 if CriaFormModal(TForm2) then
  ShowMessage('aaaaa');
end;

end.

