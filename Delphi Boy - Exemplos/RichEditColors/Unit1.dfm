object Form1: TForm1
  Left = 192
  Top = 107
  BorderStyle = bsDialog
  Caption = 'Richedit Exemplo - #DELPHIX'
  ClientHeight = 311
  ClientWidth = 432
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object RichEdit1: TRichEdit
    Left = 0
    Top = 0
    Width = 433
    Height = 265
    Lines.Strings = (
      '<HTML>'
      '<head>'
      '<title>Título da Página</title>'
      '</head>'
      ''
      '<body bgcolor="#FFF000">'
      'Texto'
      '</body>'
      ''
      '</HTML>')
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object Button1: TButton
    Left = 160
    Top = 272
    Width = 113
    Height = 25
    Caption = 'Fromatar HTML'
    TabOrder = 1
    OnClick = Button1Click
  end
end
