object wIRCSecao: TwIRCSecao
  Left = 205
  Top = 128
  Width = 739
  Height = 535
  Caption = 'wIRCSecao'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Position = poDefault
  Visible = True
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object CmdTexto: TEdit
    Left = 0
    Top = 485
    Width = 585
    Height = 23
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Fixedsys'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
  end
  object MemTexto: TFatMemo
    Left = 0
    Top = 0
    Width = 513
    Height = 393
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'FixedSys'
    Font.Style = []
    ParentFont = False
    Color = clWhite
    BorderStyle = bsSingle
    TopIndex = 0
    LineHeight = 15
    DrawFlags = [dfWordWrap]
    StickText = stBottom
    PopupMenu = MenuContexto
    ScrollBarVert = True
    ScrollBarHoriz = False
  end
  object MenuContexto: TPopupMenu
    Left = 8
    Top = 8
    object Limpar1: TMenuItem
      Caption = 'Limpar'
    end
  end
end
