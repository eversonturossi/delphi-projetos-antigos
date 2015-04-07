object FrmCenter: TFrmCenter
  Left = 203
  Top = 107
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Servidor Plugin X'
  ClientHeight = 343
  ClientWidth = 363
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 16
    Width = 28
    Height = 13
    Caption = 'Porta:'
  end
  object Label2: TLabel
    Left = 176
    Top = 8
    Width = 40
    Height = 13
    Caption = 'Clientes:'
  end
  object Edit1: TEdit
    Left = 40
    Top = 8
    Width = 121
    Height = 21
    TabOrder = 0
    Text = '5075'
  end
  object Button1: TButton
    Left = 8
    Top = 40
    Width = 75
    Height = 25
    Caption = 'Ativar'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 82
    Top = 40
    Width = 74
    Height = 25
    Caption = 'Desativar'
    TabOrder = 2
    OnClick = Button2Click
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 134
    Width = 363
    Height = 209
    Align = alBottom
    Caption = ' Log '
    TabOrder = 3
    object Memo1: TMemo
      Left = 6
      Top = 13
      Width = 347
      Height = 192
      ScrollBars = ssVertical
      TabOrder = 0
    end
  end
  object Button3: TButton
    Left = 8
    Top = 64
    Width = 148
    Height = 25
    Caption = 'Plugins'
    TabOrder = 4
    OnClick = Button3Click
  end
  object ListBox1: TListBox
    Left = 176
    Top = 24
    Width = 177
    Height = 105
    ItemHeight = 13
    TabOrder = 5
  end
  object ServerSocket1: TServerSocket
    Active = True
    Port = 5075
    ServerType = stNonBlocking
    OnListen = ServerSocket1Listen
    OnClientConnect = ServerSocket1ClientConnect
    OnClientDisconnect = ServerSocket1ClientDisconnect
    OnClientRead = ServerSocket1ClientRead
    Left = 48
    Top = 168
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 112
    Top = 168
  end
end
