object Form2: TForm2
  Left = 253
  Top = 193
  BorderStyle = bsDialog
  Caption = 'Items'
  ClientHeight = 156
  ClientWidth = 300
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
    Left = 128
    Top = 8
    Width = 27
    Height = 13
    Caption = 'Texto'
  end
  object Label2: TLabel
    Left = 128
    Top = 32
    Width = 36
    Height = 13
    Caption = 'Largura'
  end
  object Label3: TLabel
    Left = 128
    Top = 56
    Width = 26
    Height = 13
    Caption = 'Index'
  end
  object Label4: TLabel
    Left = 176
    Top = 56
    Width = 6
    Height = 13
    Caption = '0'
  end
  object ListBox1: TListBox
    Left = 0
    Top = 0
    Width = 121
    Height = 153
    ItemHeight = 13
    TabOrder = 0
    OnClick = ListBox1Click
    OnKeyDown = ListBox1KeyDown
  end
  object Button1: TButton
    Left = 192
    Top = 80
    Width = 75
    Height = 25
    Caption = 'Novo'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Edit1: TEdit
    Left = 176
    Top = 0
    Width = 121
    Height = 21
    TabOrder = 2
    Text = 'Item'
    OnChange = Edit1Change
  end
  object Edit2: TEdit
    Left = 176
    Top = 24
    Width = 121
    Height = 21
    TabOrder = 3
    Text = '50'
    OnChange = Edit1Change
  end
  object Button2: TButton
    Left = 192
    Top = 104
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 4
    OnClick = Button2Click
  end
end
