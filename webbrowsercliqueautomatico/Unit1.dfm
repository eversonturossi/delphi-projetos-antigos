object Form1: TForm1
  Left = 254
  Top = 84
  Caption = 'Form1'
  ClientHeight = 374
  ClientWidth = 723
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  WindowState = wsMaximized
  PixelsPerInch = 96
  TextHeight = 13
  object WebBrowser1: TWebBrowser
    Left = 0
    Top = 41
    Width = 723
    Height = 333
    Align = alClient
    TabOrder = 0
    OnDocumentComplete = WebBrowser1DocumentComplete
    ExplicitWidth = 608
    ExplicitHeight = 545
    ControlData = {
      4C000000B94A00006B2200000000000000000000000000000000000000000000
      000000004C000000000000000000000001000000E0D057007335CF11AE690800
      2B2E126208000000000000004C0000000114020000000000C000000000000046
      8000000000000000000000000000000000000000000000000000000000000000
      00000000000000000100000000000000000000000000000000000000}
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 723
    Height = 41
    Align = alTop
    TabOrder = 1
    ExplicitWidth = 124
    object Button1: TButton
      Left = 448
      Top = 8
      Width = 153
      Height = 25
      Caption = '&Simular Clique'
      TabOrder = 0
      OnClick = Button1Click
    end
    object Edit1: TEdit
      Left = 8
      Top = 8
      Width = 433
      Height = 21
      TabOrder = 1
      Text = 'www.uol.com.br'
    end
  end
  object MainMenu1: TMainMenu
    Left = 304
    Top = 248
    object Arquivo1: TMenuItem
      Caption = 'Arquivo'
      object Jose1: TMenuItem
        Caption = 'Jose'
        ShortCut = 16497
      end
    end
  end
end
