object Form1: TForm1
  Left = 192
  Top = 107
  Caption = 'Form1'
  ClientHeight = 461
  ClientWidth = 854
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object PopupMenu1: TPopupMenu
    Left = 128
    Top = 24
    object Lloyd1: TMenuItem
      Caption = 'Lloyd'
      OnClick = Lloyd1Click
    end
    object close1: TMenuItem
      Caption = 'close'
      OnClick = CLOSE1Click
    end
  end
end
