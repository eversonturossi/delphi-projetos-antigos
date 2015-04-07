object FrmWindow: TFrmWindow
  Left = 202
  Top = 162
  Width = 335
  Height = 272
  Caption = 'Visualizar Janela'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PopupMenu = PopupMenu1
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PopupMenu1: TPopupMenu
    Left = 136
    Top = 80
    object Mostrar1: TMenuItem
      Caption = 'Mostrar'
      OnClick = Mostrar1Click
    end
    object Esconder1: TMenuItem
      Caption = 'Esconder'
      OnClick = Esconder1Click
    end
    object Fechar1: TMenuItem
      Caption = 'Fechar'
      OnClick = Fechar1Click
    end
    object Mover1: TMenuItem
      Caption = 'Mover'
    end
    object NoTopo1: TMenuItem
      Caption = 'No Topo'
      OnClick = NoTopo1Click
    end
  end
end
