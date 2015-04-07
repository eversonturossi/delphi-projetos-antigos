object Form1: TForm1
  Left = 192
  Top = 107
  Width = 416
  Height = 158
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'Usando o registro - [#DELPHIX]'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 16
    Width = 26
    Height = 13
    Caption = 'Local'
  end
  object Label2: TLabel
    Left = 8
    Top = 40
    Width = 31
    Height = 13
    Caption = 'Chave'
  end
  object Label3: TLabel
    Left = 8
    Top = 64
    Width = 24
    Height = 13
    Caption = 'Valor'
  end
  object Edit1: TEdit
    Left = 48
    Top = 8
    Width = 329
    Height = 21
    TabOrder = 0
    Text = '\Software\Microsoft\Internet Explorer\Main'
  end
  object Button1: TButton
    Left = 48
    Top = 88
    Width = 75
    Height = 25
    Caption = 'Modificar'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 136
    Top = 88
    Width = 75
    Height = 25
    Caption = 'Retornar'
    TabOrder = 2
    OnClick = Button2Click
  end
  object Edit2: TEdit
    Left = 48
    Top = 56
    Width = 329
    Height = 21
    TabOrder = 3
    Text = 'http://www.delphix.com.br/'
  end
  object Edit3: TEdit
    Left = 48
    Top = 32
    Width = 329
    Height = 21
    TabOrder = 4
    Text = 'Start Page'
  end
end
