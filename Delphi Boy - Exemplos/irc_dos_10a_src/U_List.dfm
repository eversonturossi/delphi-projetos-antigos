object FrmList: TFrmList
  Left = 331
  Top = 117
  BorderStyle = bsDialog
  Caption = 'Lista'
  ClientHeight = 309
  ClientWidth = 166
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object LBNicks: TListBox
    Left = 0
    Top = 0
    Width = 166
    Height = 309
    Align = alClient
    ItemHeight = 13
    TabOrder = 0
    OnClick = LBNicksClick
  end
end
