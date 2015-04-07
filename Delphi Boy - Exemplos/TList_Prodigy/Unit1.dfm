object Form1: TForm1
  Left = 192
  Top = 107
  Width = 353
  Height = 255
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Button2: TButton
    Left = 24
    Top = 184
    Width = 75
    Height = 25
    Caption = 'Listar'
    TabOrder = 0
    OnClick = Button2Click
  end
  object Memo1: TMemo
    Left = 16
    Top = 16
    Width = 233
    Height = 153
    Lines.Strings = (
      'Memo1')
    ScrollBars = ssVertical
    TabOrder = 1
  end
  object Button1: TButton
    Left = 104
    Top = 184
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 2
    OnClick = Button1Click
  end
end
