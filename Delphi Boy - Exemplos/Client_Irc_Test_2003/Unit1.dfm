object Form1: TForm1
  Left = 192
  Top = 107
  Width = 544
  Height = 375
  Caption = 'Cliente IRC'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 421
    Top = 0
    Height = 304
    Align = alRight
  end
  object RichEdit1: TRichEdit
    Left = 0
    Top = 0
    Width = 421
    Height = 304
    Align = alClient
    HideSelection = False
    HideScrollBars = False
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object ListBox1: TListBox
    Left = 424
    Top = 0
    Width = 112
    Height = 304
    Align = alRight
    ItemHeight = 13
    TabOrder = 1
  end
  object Panel1: TPanel
    Left = 0
    Top = 304
    Width = 536
    Height = 25
    Align = alBottom
    TabOrder = 2
    object Edit1: TEdit
      Left = 128
      Top = 2
      Width = 401
      Height = 21
      TabOrder = 0
      OnKeyDown = Edit1KeyDown
      OnKeyPress = Edit1KeyPress
    end
    object ComboBox1: TComboBox
      Left = 8
      Top = 4
      Width = 113
      Height = 21
      ItemHeight = 13
      TabOrder = 1
      Text = 'Canal'
      Items.Strings = (
        'DelphiX'
        'SourceX'
        'Geeks'
        'Teste')
    end
  end
  object MainMenu1: TMainMenu
    Left = 152
    Top = 88
    object Conexo1: TMenuItem
      Caption = 'Conex'#227'o'
      object Conectar1: TMenuItem
        Caption = 'Conectar'
        OnClick = Conectar1Click
      end
      object Desconectar1: TMenuItem
        Caption = 'Desconectar'
        OnClick = Desconectar1Click
      end
      object Info: TMenuItem
        Caption = 'Informa'#231#245'es'
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Sair1: TMenuItem
        Caption = 'Sair'
        OnClick = Sair1Click
      end
    end
    object Opes1: TMenuItem
      Caption = 'Op'#231#245'es'
      object Join1: TMenuItem
        Caption = 'Join'
        OnClick = Join1Click
      end
      object Part1: TMenuItem
        Caption = 'Part'
        OnClick = Part1Click
      end
      object Notice1: TMenuItem
        Caption = 'Notice'
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object Quit1: TMenuItem
        Caption = 'Quit'
        OnClick = Quit1Click
      end
    end
    object Sobre1: TMenuItem
      Caption = 'Sobre'
    end
  end
  object ClientSocket: TClientSocket
    Active = False
    ClientType = ctNonBlocking
    Port = 0
    OnConnecting = ClientSocketConnecting
    OnConnect = ClientSocketConnect
    OnDisconnect = ClientSocketDisconnect
    OnRead = ClientSocketRead
    Left = 200
    Top = 104
  end
end
