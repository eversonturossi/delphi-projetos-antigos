object Form1: TForm1
  Left = 192
  Top = 107
  Width = 544
  Height = 267
  Caption = 'INI Files Exemplo'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 200
    Top = 8
    Width = 329
    Height = 145
    Caption = ' Informações do arquivo INI '
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 24
      Width = 36
      Height = 13
      Caption = 'Seções'
    end
    object Label2: TLabel
      Left = 8
      Top = 48
      Width = 29
      Height = 13
      Caption = 'Idents'
    end
    object Label3: TLabel
      Left = 8
      Top = 72
      Width = 24
      Height = 13
      Caption = 'Valor'
    end
    object ComboBox1: TComboBox
      Left = 48
      Top = 16
      Width = 113
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 0
      OnChange = ComboBox1Change
    end
    object ComboBox2: TComboBox
      Left = 48
      Top = 40
      Width = 113
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 1
      OnChange = ComboBox2Change
    end
    object Button1: TButton
      Left = 8
      Top = 96
      Width = 121
      Height = 25
      Caption = 'Salvar modificações'
      TabOrder = 2
      OnClick = Button1Click
    end
    object Edit4: TEdit
      Left = 48
      Top = 64
      Width = 273
      Height = 21
      TabOrder = 3
    end
    object Button2: TButton
      Left = 160
      Top = 16
      Width = 49
      Height = 21
      Caption = 'Apagar'
      TabOrder = 4
      OnClick = Button2Click
    end
    object Button3: TButton
      Left = 160
      Top = 40
      Width = 49
      Height = 21
      Caption = 'Apagar'
      TabOrder = 5
      OnClick = Button3Click
    end
    object Button6: TButton
      Left = 136
      Top = 96
      Width = 121
      Height = 25
      Caption = 'Atualizar Form'
      TabOrder = 6
      OnClick = Button6Click
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 8
    Width = 185
    Height = 145
    Caption = ' Valores '
    TabOrder = 1
    object Label6: TLabel
      Left = 8
      Top = 96
      Width = 30
      Height = 13
      Caption = 'Fonte:'
    end
    object LBL_Fonte: TLabel
      Left = 72
      Top = 96
      Width = 37
      Height = 13
      Caption = 'Fonte X'
    end
    object Label8: TLabel
      Left = 8
      Top = 48
      Width = 30
      Height = 13
      Caption = 'Texto:'
    end
    object Label9: TLabel
      Left = 8
      Top = 72
      Width = 40
      Height = 13
      Caption = 'Numero:'
    end
    object Label7: TLabel
      Left = 8
      Top = 19
      Width = 46
      Height = 13
      Caption = 'Checado:'
    end
    object CheckBox1: TCheckBox
      Left = 64
      Top = 16
      Width = 97
      Height = 17
      Caption = 'CheckBox1'
      TabOrder = 0
    end
    object Edit1: TEdit
      Left = 48
      Top = 40
      Width = 129
      Height = 21
      TabOrder = 1
      Text = 'Texto'
    end
    object Edit2: TEdit
      Left = 48
      Top = 64
      Width = 129
      Height = 21
      TabOrder = 2
      Text = '12345'
    end
    object Button5: TButton
      Left = 8
      Top = 120
      Width = 49
      Height = 21
      Caption = 'Fonte...'
      TabOrder = 3
      OnClick = Button5Click
    end
  end
  object GroupBox3: TGroupBox
    Left = 8
    Top = 160
    Width = 521
    Height = 73
    Caption = ' Seção '
    TabOrder = 2
    object Label5: TLabel
      Left = 8
      Top = 24
      Width = 31
      Height = 13
      Caption = 'Seção'
    end
    object Label4: TLabel
      Left = 8
      Top = 52
      Width = 35
      Height = 13
      Caption = 'Valores'
    end
    object Button4: TButton
      Left = 172
      Top = 16
      Width = 75
      Height = 21
      Caption = 'Atualizar'
      TabOrder = 0
      OnClick = Button4Click
    end
    object ComboBox4: TComboBox
      Left = 48
      Top = 44
      Width = 465
      Height = 21
      ItemHeight = 13
      TabOrder = 1
    end
    object ComboBox3: TComboBox
      Left = 48
      Top = 16
      Width = 121
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 2
      OnChange = ComboBox3Change
    end
  end
  object FontDialog1: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MinFontSize = 0
    MaxFontSize = 0
    Left = 144
    Top = 104
  end
end
