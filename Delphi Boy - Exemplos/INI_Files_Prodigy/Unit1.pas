{********************************************************************}
{  ** Arquivos INI Exemplo by Prodigy **                             }
{ - Autor: Glauber A. Dantas(Prodigy_-)                              }
{ - Info: masterx@cpunet.com.br,                                     }
{         #DelphiX - [Brasnet] irc.brasnet.org - www.delphix.com.br  }
{ - Descrição:                                                       }
{   Utilização de arquivos ini(IniFiles).                            }
{ - Este exemplo pode ser modificado livremente.                     }
{********************************************************************}
unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, INIFiles;

type
  TForm1 = class(TForm)
    GroupBox1: TGroupBox;
    ComboBox1: TComboBox;
    GroupBox2: TGroupBox;
    CheckBox1: TCheckBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    ComboBox2: TComboBox;
    Button1: TButton;
    Label3: TLabel;
    Edit4: TEdit;
    Button2: TButton;
    Button3: TButton;
    GroupBox3: TGroupBox;
    Label5: TLabel;
    Button4: TButton;
    Label4: TLabel;
    ComboBox4: TComboBox;
    Label6: TLabel;
    Button5: TButton;
    LBL_Fonte: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    FontDialog1: TFontDialog;
    ComboBox3: TComboBox;
    Label7: TLabel;
    Button6: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure ComboBox3Change(Sender: TObject);
    procedure Button6Click(Sender: TObject);
  private
    { Private declarations }
    ini : TIniFile;{** variavel do tipo arquivo ini **}
    Pasta : String;{** variavel com valor da pasta local **}
    procedure SalvarFonte;
    procedure CarregarFonte;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
begin
  {retorna a pasta local}
  Pasta := ExtractFilePath(Application.ExeName);//Pasta := ParamStr(0);
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 {cria o arquivo ini na pasta local}
 ini := TiniFile.Create(Pasta + 'Teste.ini');

  {grava estado da CheckBox}
  if Checkbox1.Checked then
   ini.WriteBool('Valores', 'CheckBox1', True)
  else
   ini.WriteBool('Valores', 'CheckBox1', False);

   {grava texto do Edit1}
   ini.WriteString('Valores','Edit1', Edit1.Text);
   {grava valor do Edit2}
   ini.WriteFloat('Valores','Edit2', StrToFloat(Edit2.TExt));
   {grava dimensoes do Form}
   ini.WriteInteger('Config', 'Left', Left);
   ini.WriteInteger('Config', 'Top',  Top);
   ini.WriteInteger('Config', 'Width',  Width);
   ini.WriteInteger('Config', 'Height', Height);

 {libera o arquivo ini}
 ini.Free;
 
   {grava fonte do LBL_Fonte}
   SalvarFonte;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
 ini := TiniFile.Create(Pasta + 'Teste.ini');
  {Retorna todas as seções existentes}
  ini.ReadSections(ComboBox1.Items);
  ComboBox1.ItemIndex := 0;
  ComboBox3.Items := ComboBox1.Items;
  ComboBox3.ItemIndex := 0;
  {carrega estado da CheckBox}
  if ini.ReadBool('Valores', 'CheckBox1', False) = True then
   Checkbox1.Checked := True
  else
   Checkbox1.Checked := False;
  {carrega texto dos Edits}
  Edit1.Text := ini.ReadString('Valores', 'Edit1', '');
  Edit2.Text := FloatToStr(ini.ReadFloat('Valores', 'Edit2', 0));
  {carrega dimensoes do Form}
  Left :=   ini.ReadInteger('Config', 'Left', Left);
  Top :=    ini.ReadInteger('Config', 'Top',  Top);
  Width :=  ini.ReadInteger('Config', 'Width', Width);
  Height := ini.ReadInteger('Config', 'Height', Height);

 ini.Free;
 
  {carrega fonte do LBL_Fonte}
  CarregarFonte;

  ComboBox1.OnChange(Self);
  ComboBox3.OnChange(Self);
end;

procedure TForm1.ComboBox1Change(Sender: TObject);
begin
  ini := TiniFile.Create(Pasta + 'Teste.ini');
   ini.ReadSection(ComboBox1.Items[ComboBox1.ItemIndex], ComboBox2.Items);
   ComboBox2.ItemIndex := 0;
   Edit4.Clear;
  ini.Free;
end;

procedure TForm1.ComboBox2Change(Sender: TObject);
begin
  ini := TiniFile.Create(Pasta + 'Teste.ini');
  Edit4.TExt := ini.ReadString(ComboBox1.Items[ComboBox1.ItemIndex],
                 ComboBox2.Items[ComboBox2.ItemIndex], '');
  ini.Free;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  ini := TiniFile.Create(Pasta + 'Teste.ini');
  ini.WriteString(ComboBox1.Items[ComboBox1.ItemIndex],
                  ComboBox2.Items[ComboBox2.ItemIndex],
                  Edit4.TExt);
  ini.Free;
end;


procedure TForm1.Button2Click(Sender: TObject);
begin
  ini := TiniFile.Create(Pasta + 'Teste.ini');
   ini.EraseSection(ComboBox1.Items[ComboBox1.ItemIndex]);
  ini.Free;
  Form1.OnShow(self);
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  ini := TiniFile.Create(Pasta + 'Teste.ini');
  ini.DeleteKey(ComboBox1.Items[ComboBox1.ItemIndex],
                ComboBox2.Items[ComboBox2.ItemIndex]);
  ini.Free;
  ComboBox2.Text := '';
  Form1.OnShow(self);
end;

procedure TForm1.SalvarFonte;
var
  FontSize, FontColor : Integer;
  FontName : String;
begin
 ini := TiniFile.Create(Pasta + 'Teste.ini');
  with FontDialog1 do
  begin
    FontName := Font.Name;
    FontSize := Font.Size;
    FontColor:= Font.Color;
    ini.WriteString('FONTE', 'Name', FontName);
    ini.WriteInteger('FONTE', 'Size', FontSize);
    ini.WriteInteger('FONTE', 'Color', FontColor);

   if fsBold in Font.Style then
    ini.WriteInteger('FONTE','Bold',1)
   Else
    ini.WriteInteger('FONTE','Bold',0);

   if fsItalic in Font.Style then
    ini.WriteInteger('FONTE','Italic',1)
   Else
    ini.WriteInteger('FONTE','Italic',0);

   if fsUnderline in Font.Style then
    ini.WriteInteger('FONTE','Underline',1)
   Else
    ini.WriteInteger('FONTE','Underline',0);

   if fsStrikeOut in Font.Style then
    ini.WriteInteger('FONTE','Strikeout',1)
   Else
    ini.WriteInteger('FONTE','Strikeout',0);

 end;

 ini.Free;
end;

procedure TForm1.CarregarFonte;
var
  FonteX : TFont;
begin
 ini := TiniFile.Create(Pasta + 'Teste.ini');
  FonteX := TFont.Create;
  FonteX.Name := ini.ReadString('FONTE', 'Name', 'MS Sans Serif');
  FonteX.Size := ini.ReadInteger('FONTE', 'Size', 8);
  FonteX.Color:= ini.ReadInteger('FONTE', 'Color', 0);

 if ini.ReadInteger('FONTE', 'Bold', 0) = 1 then
   FonteX.Style := FonteX.Style + [fsBold];
 if ini.ReadInteger('FONTE', 'Italic', 0) = 1 then
   FonteX.Style := FonteX.Style + [fsItalic];
 if ini.ReadInteger('FONTE', 'Underline', 0) = 1 then
   FonteX.Style := FonteX.Style + [fsUnderline];
 if ini.ReadInteger('FONTE', 'Strikeout', 0) = 1 then
   FonteX.Style := FonteX.Style + [fsStrikeOut];

  LBL_Fonte.Font := FonteX;

 ini.Free;
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
  FontDialog1.Font := LBL_Fonte.Font;
  if FontDialog1.Execute then
   LBL_Fonte.Font := FontDialog1.Font;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  ini := TiniFile.Create(Pasta + 'Teste.ini');
   ini.ReadSections(ComboBox3.Items);
   ComboBox3.ItemIndex := 0;
  ini.Free;

  ComboBox3.OnChange(Self);
end;

procedure TForm1.ComboBox3Change(Sender: TObject);
begin
  ini := TiniFile.Create(Pasta + 'Teste.ini');
   ComboBox4.Items.Clear;
   ini.ReadSectionValues(ComboBox3.Items[ComboBox3.ItemIndex], ComboBox4.Items);
   ComboBox4.ItemIndex := 0;
  ini.Free;
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
  Form1.OnShow(Self);
end;

end.
