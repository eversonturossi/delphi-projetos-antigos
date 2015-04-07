object Form1: TForm1
  Left = 192
  Top = 107
  Width = 395
  Height = 247
  Caption = 'Exemplo - #DelphiX'
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
    Left = 24
    Top = 104
    Width = 32
    Height = 13
    Caption = 'Label1'
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 201
    Width = 387
    Height = 19
    Panels = <>
    SimplePanel = False
  end
  object Edit1: TEdit
    Left = 24
    Top = 24
    Width = 121
    Height = 21
    TabOrder = 1
    Text = 'Edit1'
  end
  object Button1: TButton
    Left = 168
    Top = 64
    Width = 105
    Height = 25
    Caption = 'OnMouseMove'
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 168
    Top = 88
    Width = 105
    Height = 25
    Caption = 'Nenhuma'
    TabOrder = 3
    OnClick = Button2Click
  end
end
