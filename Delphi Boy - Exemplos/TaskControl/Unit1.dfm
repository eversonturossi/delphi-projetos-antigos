object Form1: TForm1
  Left = 192
  Top = 107
  Width = 376
  Height = 316
  Caption = 'TaskBar List by Prodigy'
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
    Top = 8
    Width = 36
    Height = 13
    Caption = 'Caption'
  end
  object Button1: TButton
    Left = 72
    Top = 200
    Width = 75
    Height = 25
    Caption = 'Show Form2'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Edit1: TEdit
    Left = 8
    Top = 24
    Width = 337
    Height = 21
    TabOrder = 1
    Text = 'FormTeste'
  end
  object Button2: TButton
    Left = 272
    Top = 224
    Width = 75
    Height = 25
    Caption = 'List1'
    TabOrder = 2
    OnClick = Button2Click
  end
  object Memo1: TMemo
    Left = 8
    Top = 72
    Width = 337
    Height = 113
    ScrollBars = ssVertical
    TabOrder = 3
  end
  object Button3: TButton
    Left = 272
    Top = 256
    Width = 75
    Height = 25
    Caption = 'List2'
    TabOrder = 4
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 152
    Top = 200
    Width = 75
    Height = 25
    Caption = 'List OK'
    TabOrder = 5
    OnClick = Button4Click
  end
  object CheckBox1: TCheckBox
    Left = 8
    Top = 48
    Width = 97
    Height = 17
    Caption = 'Esconder Botão'
    TabOrder = 6
  end
end
