object Form1: TForm1
  Left = 396
  Top = 297
  Width = 319
  Height = 268
  Caption = 'Vote no b0zo no gente feia'
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
    Left = 16
    Top = 140
    Width = 27
    Height = 13
    Caption = 'Votos'
  end
  object Label2: TLabel
    Left = 8
    Top = 104
    Width = 33
    Height = 13
    Caption = 'Tempo'
  end
  object Edit1: TEdit
    Left = 48
    Top = 136
    Width = 121
    Height = 21
    TabOrder = 0
  end
  object Button1: TButton
    Left = 48
    Top = 60
    Width = 121
    Height = 25
    Caption = 'Start'
    Enabled = False
    TabOrder = 1
    OnClick = Button1Click
  end
  object Edit2: TEdit
    Left = 48
    Top = 100
    Width = 121
    Height = 21
    TabOrder = 2
    Text = '2'
  end
  object Button2: TButton
    Left = 176
    Top = 104
    Width = 75
    Height = 19
    Caption = 'Reaplicar'
    TabOrder = 3
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 48
    Top = 24
    Width = 121
    Height = 25
    Caption = 'Abre IE'
    TabOrder = 4
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 208
    Top = 24
    Width = 75
    Height = 25
    Caption = 'Fecha IE'
    TabOrder = 5
    OnClick = Button4Click
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 200
    Top = 136
  end
  object Timer2: TTimer
    Enabled = False
    OnTimer = Timer2Timer
    Left = 232
    Top = 192
  end
end
