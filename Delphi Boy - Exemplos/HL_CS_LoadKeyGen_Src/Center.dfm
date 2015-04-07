object Form1: TForm1
  Left = 192
  Top = 107
  BorderStyle = bsDialog
  Caption = 'LoadKeyGen by Prodigy_-'
  ClientHeight = 142
  ClientWidth = 341
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 160
    Height = 13
    Caption = 'HL CS Key Generator executável:'
  end
  object Label2: TLabel
    Left = 200
    Top = 8
    Width = 26
    Height = 13
    Caption = 'Keys:'
  end
  object Label3: TLabel
    Left = 200
    Top = 48
    Width = 88
    Height = 13
    Caption = 'Salvar em arquivo:'
  end
  object Label4: TLabel
    Left = 8
    Top = 48
    Width = 80
    Height = 13
    Caption = 'Título da Janela:'
  end
  object Label5: TLabel
    Left = 16
    Top = 120
    Width = 156
    Height = 13
    Cursor = crHandPoint
    Caption = '#DELPHIX - irc.brasnet.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    OnClick = Label5Click
  end
  object Label6: TLabel
    Left = 264
    Top = 8
    Width = 39
    Height = 13
    Caption = 'Método:'
  end
  object Edit1: TEdit
    Left = 8
    Top = 24
    Width = 177
    Height = 21
    TabOrder = 0
    Text = 'HL_CS_keygenerator.exe'
  end
  object Edit2: TEdit
    Left = 200
    Top = 24
    Width = 57
    Height = 21
    TabOrder = 2
    Text = '10'
  end
  object Edit3: TEdit
    Left = 200
    Top = 64
    Width = 129
    Height = 21
    TabOrder = 4
    Text = 'keys.txt'
  end
  object Button1: TButton
    Left = 200
    Top = 88
    Width = 65
    Height = 25
    Caption = 'Load!'
    TabOrder = 5
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 200
    Top = 112
    Width = 65
    Height = 25
    Caption = 'Sobre'
    TabOrder = 7
    OnClick = Button2Click
  end
  object Edit4: TEdit
    Left = 8
    Top = 64
    Width = 177
    Height = 21
    TabOrder = 1
    Text = 'Halflife CD-KEYGEN RAZOR 1911'
  end
  object Button4: TButton
    Left = 264
    Top = 88
    Width = 65
    Height = 25
    Caption = 'Cancelar'
    TabOrder = 6
    OnClick = Button4Click
  end
  object Button3: TButton
    Left = 264
    Top = 112
    Width = 65
    Height = 25
    Caption = 'Fechar'
    TabOrder = 8
    OnClick = Button3Click
  end
  object Panel1: TPanel
    Left = 8
    Top = 96
    Width = 177
    Height = 17
    Alignment = taLeftJustify
    BevelOuter = bvLowered
    TabOrder = 9
  end
  object ComboBox1: TComboBox
    Left = 264
    Top = 24
    Width = 65
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 3
    Items.Strings = (
      '1'
      '2'
      '3'
      '4')
  end
end
