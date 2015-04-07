{*****************************************}
{  Exemplo usando tabela dinâmica em XML  }
{  Fontes por Tadeu Torquato da Silva     }
{  E-mail: tadeutorquato@yahoo.com.br     }
{  Site: www.delphix.com.br               }
{  01/11/2003                             }
{*****************************************}

unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Provider, DBTables, ExtCtrls, DBCtrls, DB, DBClient, DBLocal,
  DBLocalB, Grids, DBGrids, StdCtrls, SqlExpr, DBLocalS, ShellApi,
  OleCtrls, SHDocVw;

type
  TForm1 = class(TForm)
    Button1: TButton;
    DataSource1: TDataSource;
    DBNavigator1: TDBNavigator;
    Button2: TButton;
    SQLClientDataSet1: TSQLClientDataSet;
    ListBox1: TListBox;
    EdtDescricao: TEdit;
    EdtSize: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    EdtTipo: TComboBox;
    Label4: TLabel;
    Button3: TButton;
    Button4: TButton;
    WebBrowser1: TWebBrowser;
    Button5: TButton;
    DBGrid1: TDBGrid;
    Label5: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure SQLClientDataSet1AfterPost(DataSet: TDataSet);
    procedure SQLClientDataSet1AfterUpdateRecord(Sender: TObject;
      SourceDS: TDataSet; DeltaDS: TCustomClientDataSet;
      UpdateKind: TUpdateKind);
    procedure Button5Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function CAMPO(Index: Integer): string;
    function TIPO(Index: Integer): string;
    function TAMANHO(Index: Integer): string;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  CAMPOS: TField;
  I: Integer;
begin
  with SQLClientDataSet1 do
  begin
    Close;
    Fields.Clear;
    FieldDefs.Clear;

    if(ListBox1.Items.Count >  0)then
    begin
      for I := 0 to ListBox1.Items.Count - 1 do
      begin
        if(TIPO(I) = 'ftString')then
        begin
          CAMPOS := TStringField.Create(self);
          CAMPOS.FieldName := AnsiUpperCase(CAMPO(I));
          CAMPOS.DisplayLabel := CAMPO(I);
          CAMPOS.Size := StrToInt(TAMANHO(I));
          CAMPOS.Name := SQLClientDataSet1.Name + CAMPOS.FieldName;
          CAMPOS.Index := SQLClientDataSet1.FieldCount;
          CAMPOS.DataSet := SQLClientDataSet1;
          CAMPOS.DisplayLabel := CAMPO(I);
        end
        else
        if(TIPO(I) = 'ftInteger')then
        begin
          CAMPOS := TIntegerField.Create(self);
          CAMPOS.FieldName := AnsiUpperCase(CAMPO(I));
          CAMPOS.DisplayLabel := CAMPO(I);
          CAMPOS.Name := SQLClientDataSet1.Name + CAMPOS.FieldName;
          CAMPOS.Index := SQLClientDataSet1.FieldCount;
          CAMPOS.DataSet := SQLClientDataSet1;
          CAMPOS.DisplayLabel := CAMPO(I);
        end
        else
        if(TIPO(I) = 'ftFloat')then
        begin
          CAMPOS := TFloatField.Create(self);
          CAMPOS.FieldName := AnsiUpperCase(CAMPO(I));
          CAMPOS.DisplayLabel := CAMPO(I);
          CAMPOS.Name := SQLClientDataSet1.Name + CAMPOS.FieldName;
          CAMPOS.Index := SQLClientDataSet1.FieldCount;
          CAMPOS.DataSet := SQLClientDataSet1;
          CAMPOS.DisplayLabel := CAMPO(I);
        end
        else
        if(TIPO(I) = 'ftDate')then
        begin
          CAMPOS := TDateField.Create(self);
          CAMPOS.FieldName := AnsiUpperCase(CAMPO(I));
          CAMPOS.DisplayLabel := CAMPO(I);
          CAMPOS.Name := SQLClientDataSet1.Name + CAMPOS.FieldName;
          CAMPOS.Index := SQLClientDataSet1.FieldCount;
          CAMPOS.DataSet := SQLClientDataSet1;
          CAMPOS.DisplayLabel := CAMPO(I);
        end
        else
        if(TIPO(I) = 'ftTime')then
        begin
          CAMPOS := TTimeField.Create(self);
          CAMPOS.FieldName := AnsiUpperCase(CAMPO(I));
          CAMPOS.DisplayLabel := CAMPO(I);
          CAMPOS.Name := SQLClientDataSet1.Name + CAMPOS.FieldName;
          CAMPOS.Index := SQLClientDataSet1.FieldCount;
          CAMPOS.DataSet := SQLClientDataSet1;
          CAMPOS.DisplayLabel := CAMPO(I);
        end
        else
        if(TIPO(I) = 'ftDateTime')then
        begin
          CAMPOS := TDateTimeField.Create(self);
          CAMPOS.FieldName := AnsiUpperCase(CAMPO(I));
          CAMPOS.DisplayLabel := CAMPO(I);
          CAMPOS.Name := SQLClientDataSet1.Name + CAMPOS.FieldName;
          CAMPOS.Index := SQLClientDataSet1.FieldCount;
          CAMPOS.DataSet := SQLClientDataSet1;
          CAMPOS.DisplayLabel := CAMPO(I);
        end
        else
        if(TIPO(I) = 'ftMemo')then
        begin
          CAMPOS := TMemoField.Create(self);
          CAMPOS.FieldName := AnsiUpperCase(CAMPO(I));
          CAMPOS.DisplayLabel := CAMPO(I);
          CAMPOS.Name := SQLClientDataSet1.Name + CAMPOS.FieldName;
          CAMPOS.Index := SQLClientDataSet1.FieldCount;
          CAMPOS.DataSet := SQLClientDataSet1;
          CAMPOS.DisplayLabel := CAMPO(I);
        end;
      end;
    end;
    CreateDataSet;
    SaveToFile(ExtractFilePath(ParamStr(0)) + '\Tabela.xml', dfXML);
    Close;
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  with SQLClientDataSet1 do
  begin
    Close;
    LoadFromFile(ExtractFilePath(ParamStr(0)) + '\Tabela.xml');
    Open;
    WebBrowser1.Navigate(ExtractFilePath(ParamStr(0)) + 'Tabela.xml');
  end;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  ListBox1.Items.Add(EdtDescricao.Text+';'+EdtTipo.Text+';'+EdtSize.Text);
  EdtDescricao.Clear;
  EdtSize.Clear;
  EdtTipo.ItemIndex := 0;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  ListBox1.Items.Delete(ListBox1.ItemIndex);
end;

function TForm1.CAMPO(Index: Integer): string;
var
  X: string;
begin
  X := Copy(ListBox1.Items.Strings[Index],1,(Pos(';',ListBox1.Items.Strings[Index]) - 1));
  Result := X;
end;

function TForm1.TAMANHO(Index: Integer): string;
var
  X, Y: string;
begin
  X := Copy(ListBox1.Items.Strings[Index],(Pos(';',ListBox1.Items.Strings[Index]) + 1),Length(ListBox1.Items.Strings[Index]));
  Y := Copy(X,(Pos(';',X) + 1),Length(X));
  Result := Y;
end;

function TForm1.TIPO(Index: Integer): string;
var
  X, Y: string;
begin
  X := Copy(ListBox1.Items.Strings[Index],(Pos(';',ListBox1.Items.Strings[Index]) + 1),Length(ListBox1.Items.Strings[Index]));
  Y := Copy(X,0,(Pos(';',X)-1));
  Result := Y;
end;

procedure TForm1.SQLClientDataSet1AfterPost(DataSet: TDataSet);
begin
  Button2Click(nil);
end;

procedure TForm1.SQLClientDataSet1AfterUpdateRecord(Sender: TObject;
  SourceDS: TDataSet; DeltaDS: TCustomClientDataSet;
  UpdateKind: TUpdateKind);
begin
  Button2Click(nil);
end;

procedure TForm1.Button5Click(Sender: TObject);
var
  sHTML  : string;
  iCount, iColuna, iRegistros: Integer;
  Lista: TStringList;
begin
  iColuna := SQLClientDataSet1.Fields.Count;

  sHTML := '<html>'+#13#10+
            '<head>'+#13#10+
            '</head>'+#13#10+
            '<body>'+#13#10+
            '<center>'+
            '<b>'+
            '<font size="2" face="Verdana, Arial, Helvetica, sans-serif">'+
            Form1.Caption+
            '</font>'+
            '</b>'+
            '</center>'+
            '<br>'+#13#10+
            '<table width="100%"  border="1" cellspacing="0" cellpadding="4">'+#13#10+
            '<tr bgcolor="#000066">';

  iCount:= 0;

  for iCount := 0 to iColuna - 1 do
  begin
    sHTML := sHTML +#13#10+
                   '<th scope="col">'+
                   '<font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">'+
                   SQLClientDataSet1.Fields.Fields[iCount].DisplayLabel+
                   '</font>'+
                   '</th>';
  end;

  sHTML := sHTML +#13#10+ '</tr>';

  SQLClientDataSet1.First;
  while not SQLClientDataSet1.Eof do
  begin
    sHTML := sHTML +#13#10+ '<tr>';
    iCount:= 0;
    for iCount := 0 to iColuna - 1 do
    begin
      sHTML := sHTML +#13#10+
                     '<td>'+
                     '<div align="center">'+
                     '<strong>'+
                     '<font size="1" face="Verdana, Arial, Helvetica, sans-serif">'+
                     SQLClientDataSet1.Fields.Fields[iCount].AsString
                     +'</font>'+
                     '</strong>'+
                     '</div>'+
                     '</td>';
    end;
    sHTML := sHTML +#13#10+ '</tr>';
    SQLClientDataSet1.Next;
    Application.ProcessMessages;
  end;

  sHTML := sHTML + #13#10 + '<strong>'+
            '<font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">'+
            'Total:'+
            '</font>'+
            '</strong>' +
            '<strong>'+
            '<font size="1" face="Verdana, Arial, Helvetica, sans-serif"  color="#0000FF"> '+
            IntToStr(SQLClientDataSet1.RecordCount) +
            '</font>'+
            '</strong>'+
            '</table>'+#13#10;

  sHTML := sHTML + #13#10+ '<br>'+
            '<div align="center">'+
            '<strong><font size="1">'+
            '&copy; '+
            '<font color="#FF0000">'+
            'Ted'+
            '</font>'+
            'SoftWare'+
            '</font>'+
            '</strong>'+
            '</div>'+
            '</body>'+#13#10+
            '</html>';

  Lista := TStringList.Create;
  try
   Lista.Text := sHTML;
   Lista.SaveToFile(ExtractFilePath(ParamStr(0)) + '\XML.html');
  finally
   Lista.Free;
  end;
  ShellExecute(Handle,'Open',Pchar(ExtractFilePath(ParamStr(0)) + '\XML.html'),0,0,0);
end;

end.
