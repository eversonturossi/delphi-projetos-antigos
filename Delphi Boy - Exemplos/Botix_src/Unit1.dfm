object Form1: TForm1
  Left = 192
  Top = 107
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Botix by Prodigy - [#DELPHIX] - irc.brasnet.org'
  ClientHeight = 350
  ClientWidth = 417
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label5: TLabel
    Left = 288
    Top = 16
    Width = 91
    Height = 13
    Caption = '[Desconectado]'
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 265
    Height = 201
    Caption = 'Conectar'
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 24
      Width = 39
      Height = 13
      Caption = 'Servidor'
    end
    object Label2: TLabel
      Left = 8
      Top = 48
      Width = 25
      Height = 13
      Caption = 'Porta'
    end
    object Label3: TLabel
      Left = 8
      Top = 72
      Width = 22
      Height = 13
      Caption = 'Nick'
    end
    object Label4: TLabel
      Left = 8
      Top = 96
      Width = 24
      Height = 13
      Caption = 'Ident'
    end
    object Label6: TLabel
      Left = 8
      Top = 120
      Width = 28
      Height = 13
      Caption = 'Nome'
    end
    object Edit1: TEdit
      Left = 56
      Top = 16
      Width = 121
      Height = 21
      TabOrder = 0
      Text = 'irc.brasnet.org'
    end
    object Edit2: TEdit
      Left = 56
      Top = 40
      Width = 121
      Height = 21
      TabOrder = 1
      Text = '6667'
    end
    object Button1: TButton
      Left = 56
      Top = 152
      Width = 75
      Height = 25
      Caption = 'Conectar'
      TabOrder = 2
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 136
      Top = 152
      Width = 75
      Height = 25
      Caption = 'Desconectar'
      TabOrder = 3
      OnClick = Button2Click
    end
    object Edit3: TEdit
      Left = 56
      Top = 64
      Width = 121
      Height = 21
      TabOrder = 4
      Text = 'BOTX123'
    end
    object Edit4: TEdit
      Left = 56
      Top = 88
      Width = 121
      Height = 21
      TabOrder = 5
      Text = 'DelphiX'
    end
    object Edit5: TEdit
      Left = 56
      Top = 112
      Width = 121
      Height = 21
      TabOrder = 6
      Text = 'Nome Real'
    end
  end
  object GroupBox2: TGroupBox
    Left = 0
    Top = 208
    Width = 265
    Height = 137
    Caption = ' Entrar/Sair '
    TabOrder = 1
    object ListBox1: TListBox
      Left = 8
      Top = 16
      Width = 121
      Height = 113
      ItemHeight = 13
      Items.Strings = (
        '#SourceX'
        '#DelphiX'
        '#Geeks')
      TabOrder = 0
    end
    object Button3: TButton
      Left = 136
      Top = 32
      Width = 75
      Height = 25
      Caption = 'Entrar'
      TabOrder = 1
      OnClick = Button3Click
    end
    object Button4: TButton
      Left = 136
      Top = 64
      Width = 75
      Height = 25
      Caption = 'Sair'
      TabOrder = 2
      OnClick = Button4Click
    end
  end
  object ClientS: TClientSocket
    Active = False
    ClientType = ctNonBlocking
    Port = 0
    OnConnecting = ClientSConnecting
    OnConnect = ClientSConnect
    OnDisconnect = ClientSDisconnect
    OnRead = ClientSRead
    Left = 296
    Top = 40
  end
end
