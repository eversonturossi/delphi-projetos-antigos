object Form1: TForm1
  Left = 192
  Top = 107
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Code by Prodigy - [#DelphiX]'
  ClientHeight = 234
  ClientWidth = 361
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
    Width = 31
    Height = 13
    Caption = 'Janela'
  end
  object Edit1: TEdit
    Left = 48
    Top = 8
    Width = 233
    Height = 21
    TabOrder = 0
    Text = 'Sem Título - Bloco de notas'
  end
  object Memo1: TMemo
    Left = 8
    Top = 40
    Width = 345
    Height = 153
    ScrollBars = ssVertical
    TabOrder = 1
  end
  object Button1: TButton
    Left = 8
    Top = 200
    Width = 89
    Height = 25
    Caption = 'Retorna Texto'
    TabOrder = 2
    OnClick = Button1Click
  end
end
