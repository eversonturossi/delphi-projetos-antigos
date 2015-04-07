object Form1: TForm1
  Left = 461
  Top = 260
  Width = 386
  Height = 128
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 8
    Top = 16
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 120
    Top = 72
    Width = 75
    Height = 25
    Caption = 'O1K'
    TabOrder = 1
    OnClick = Button2Click
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 5000
    OnTimer = Timer1Timer
    Left = 88
    Top = 16
  end
  object Timer2: TTimer
    Enabled = False
    Interval = 2500
    OnTimer = Timer2Timer
    Left = 120
    Top = 16
  end
end
