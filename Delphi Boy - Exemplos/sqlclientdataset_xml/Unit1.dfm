object Form1: TForm1
  Left = -1
  Top = 1
  BorderStyle = bsSingle
  Caption = 'Exemplo XML'
  ClientHeight = 485
  ClientWidth = 797
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 9
    Top = 8
    Width = 41
    Height = 13
    Caption = 'Campos:'
  end
  object Label2: TLabel
    Left = 200
    Top = 8
    Width = 51
    Height = 13
    Caption = 'Descri'#231#227'o:'
  end
  object Label3: TLabel
    Left = 200
    Top = 88
    Width = 20
    Height = 13
    Caption = 'Size'
  end
  object Label4: TLabel
    Left = 200
    Top = 48
    Width = 24
    Height = 13
    Caption = 'Tipo:'
  end
  object Label5: TLabel
    Left = 336
    Top = 24
    Width = 55
    Height = 13
    Caption = 'Fonte XML:'
  end
  object Button1: TButton
    Left = 201
    Top = 157
    Width = 128
    Height = 25
    Caption = 'Criar XML'
    TabOrder = 5
    OnClick = Button1Click
  end
  object DBNavigator1: TDBNavigator
    Left = 552
    Top = 240
    Width = 234
    Height = 25
    DataSource = DataSource1
    VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast, nbInsert, nbDelete, nbEdit, nbPost, nbCancel]
    TabOrder = 8
  end
  object Button2: TButton
    Left = 201
    Top = 182
    Width = 128
    Height = 25
    Caption = 'Abrir XML'
    TabOrder = 6
    OnClick = Button2Click
  end
  object ListBox1: TListBox
    Left = 8
    Top = 24
    Width = 185
    Height = 209
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ItemHeight = 13
    ParentFont = False
    TabOrder = 9
  end
  object EdtDescricao: TEdit
    Left = 200
    Top = 24
    Width = 125
    Height = 21
    TabOrder = 0
  end
  object EdtSize: TEdit
    Left = 200
    Top = 104
    Width = 49
    Height = 21
    TabOrder = 2
  end
  object EdtTipo: TComboBox
    Left = 200
    Top = 64
    Width = 126
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    ItemIndex = 0
    TabOrder = 1
    Text = 'ftString'
    Items.Strings = (
      'ftString'
      'ftInteger'
      'ftFloat'
      'ftDate'
      'ftTime'
      'ftDateTime')
  end
  object Button3: TButton
    Left = 200
    Top = 128
    Width = 38
    Height = 26
    Caption = '+'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGreen
    Font.Height = -40
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 238
    Top = 128
    Width = 38
    Height = 26
    Caption = '-'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -40
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 4
    OnClick = Button4Click
  end
  object WebBrowser1: TWebBrowser
    Left = 336
    Top = 40
    Width = 457
    Height = 193
    TabOrder = 10
    ControlData = {
      4C0000003B2F0000F21300000000000000000000000000000000000000000000
      000000004C000000000000000000000001000000E0D057007335CF11AE690800
      2B2E126208000000000000004C0000000114020000000000C000000000000046
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000100000000000000000000000000000000000000}
  end
  object Button5: TButton
    Left = 201
    Top = 208
    Width = 128
    Height = 25
    Caption = 'Gerar HTML'
    TabOrder = 7
    OnClick = Button5Click
  end
  object DBGrid1: TDBGrid
    Left = 8
    Top = 272
    Width = 777
    Height = 201
    DataSource = DataSource1
    TabOrder = 11
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
  end
  object DataSource1: TDataSource
    DataSet = SQLClientDataSet1
    Left = 240
    Top = 336
  end
  object SQLClientDataSet1: TSQLClientDataSet
    Aggregates = <>
    Options = [poAllowCommandText]
    ObjectView = True
    Params = <>
    AfterPost = SQLClientDataSet1AfterPost
    AfterUpdateRecord = SQLClientDataSet1AfterUpdateRecord
    Left = 320
    Top = 336
  end
end
