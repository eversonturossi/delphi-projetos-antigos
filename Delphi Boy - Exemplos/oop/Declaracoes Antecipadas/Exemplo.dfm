object Form1: TForm1
  Left = 230
  Top = 132
  Width = 179
  Height = 116
  Caption = 'ResultPowerEx  : :  by Roberto'
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
    Left = 9
    Top = 9
    Width = 24
    Height = 13
    Caption = 'Base'
  end
  object Label2: TLabel
    Left = 82
    Top = 9
    Width = 45
    Height = 13
    Caption = 'Expoente'
  end
  object Button1: TButton
    Left = 6
    Top = 53
    Width = 75
    Height = 25
    Caption = 'Calcular'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Edit1: TEdit
    Left = 5
    Top = 25
    Width = 67
    Height = 21
    TabOrder = 1
    OnKeyPress = Edit1KeyPress
  end
  object Edit2: TEdit
    Left = 80
    Top = 25
    Width = 67
    Height = 21
    TabOrder = 2
  end
end
