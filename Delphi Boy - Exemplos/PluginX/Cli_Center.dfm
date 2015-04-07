object FrmCenter: TFrmCenter
  Left = 205
  Top = 116
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Cliente'
  ClientHeight = 339
  ClientWidth = 339
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
    Width = 25
    Height = 13
    Caption = 'Host:'
  end
  object Label2: TLabel
    Left = 8
    Top = 48
    Width = 28
    Height = 13
    Caption = 'Porta:'
  end
  object Label3: TLabel
    Left = 8
    Top = 72
    Width = 25
    Height = 13
    Caption = 'Nick:'
  end
  object Edit1: TEdit
    Left = 48
    Top = 16
    Width = 121
    Height = 21
    TabOrder = 0
    Text = 'localhost'
  end
  object Edit2: TEdit
    Left = 48
    Top = 40
    Width = 121
    Height = 21
    TabOrder = 1
    Text = '5075'
  end
  object Edit3: TEdit
    Left = 48
    Top = 64
    Width = 121
    Height = 21
    TabOrder = 2
    Text = 'MeuNick'
  end
  object Button1: TButton
    Left = 192
    Top = 24
    Width = 75
    Height = 25
    Caption = 'Conectar'
    TabOrder = 3
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 192
    Top = 48
    Width = 75
    Height = 25
    Caption = 'Desconectar'
    TabOrder = 4
    OnClick = Button2Click
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 104
    Width = 321
    Height = 49
    Caption = ' Enviar texto '
    TabOrder = 5
    object Edit4: TEdit
      Left = 8
      Top = 16
      Width = 305
      Height = 21
      TabOrder = 0
      Text = 'Mensagem Teste'
      OnKeyDown = Edit4KeyDown
      OnKeyPress = Edit4KeyPress
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 208
    Width = 321
    Height = 129
    Caption = ' Log '
    TabOrder = 6
    object Memo1: TMemo
      Left = 8
      Top = 16
      Width = 305
      Height = 105
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 0
    end
  end
  object GroupBox3: TGroupBox
    Left = 8
    Top = 160
    Width = 321
    Height = 41
    Caption = ' Pedir Informa'#231#245'es '
    TabOrder = 7
    object Button3: TButton
      Left = 16
      Top = 16
      Width = 65
      Height = 17
      Caption = 'Info Server'
      TabOrder = 0
      OnClick = Button3Click
    end
    object Button4: TButton
      Left = 88
      Top = 16
      Width = 75
      Height = 17
      Caption = 'DateTime'
      TabOrder = 1
      OnClick = Button4Click
    end
    object Button5: TButton
      Left = 168
      Top = 16
      Width = 105
      Height = 17
      Caption = 'Mostra Info Client'
      TabOrder = 2
      OnClick = Button5Click
    end
  end
  object ClientSocket1: TClientSocket
    Active = False
    ClientType = ctNonBlocking
    Port = 0
    OnConnect = ClientSocket1Connect
    OnDisconnect = ClientSocket1Disconnect
    OnRead = ClientSocket1Read
    Left = 280
    Top = 24
  end
end
