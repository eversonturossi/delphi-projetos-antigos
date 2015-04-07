object Form1: TForm1
  Left = 192
  Top = 107
  Width = 335
  Height = 257
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
  object Label1: TLabel
    Left = 8
    Top = 24
    Width = 31
    Height = 13
    Caption = 'Janela'
  end
  object Button1: TButton
    Left = 16
    Top = 184
    Width = 75
    Height = 25
    Caption = 'Setar Texto'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Memo1: TMemo
    Left = 8
    Top = 56
    Width = 273
    Height = 121
    Lines.Strings = (
      '#DelphiX o melhor canal de programação!!!')
    TabOrder = 1
  end
  object Edit1: TEdit
    Left = 56
    Top = 16
    Width = 225
    Height = 21
    TabOrder = 2
    Text = 'Sem Título - Bloco de notas'
  end
end
