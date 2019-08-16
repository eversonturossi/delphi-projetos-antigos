object Form1: TForm1
  Left = 192
  Top = 107
  Width = 870
  Height = 500
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 528
    Top = 0
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 0
    OnClick = Button1Click
  end
  object ListBox1: TListBox
    Left = 0
    Top = 0
    Width = 201
    Height = 454
    Align = alLeft
    ItemHeight = 13
    TabOrder = 1
  end
  object ListBox2: TListBox
    Left = 648
    Top = 0
    Width = 214
    Height = 454
    Align = alRight
    ItemHeight = 13
    TabOrder = 2
  end
  object Button3: TButton
    Left = 312
    Top = 0
    Width = 75
    Height = 25
    Caption = 'Button3'
    TabOrder = 3
    OnClick = Button3Click
  end
  object MainMenu1: TMainMenu
    Left = 136
    Top = 56
    object fazerasporra1: TMenuItem
      Caption = 'fazer as porra'
      OnClick = fazerasporra1Click
    end
  end
end
