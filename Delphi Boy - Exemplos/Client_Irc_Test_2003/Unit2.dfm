object FrmConect: TFrmConect
  Left = 265
  Top = 166
  Width = 336
  Height = 345
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'Conectar..'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel
    Left = 192
    Top = 16
    Width = 25
    Height = 13
    Caption = 'Porta'
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 168
    Width = 193
    Height = 145
    Caption = ' Proxy '
    TabOrder = 3
    object Label7: TLabel
      Left = 8
      Top = 48
      Width = 22
      Height = 13
      Caption = 'Host'
    end
    object Label8: TLabel
      Left = 8
      Top = 72
      Width = 25
      Height = 13
      Caption = 'Porta'
    end
    object Label9: TLabel
      Left = 8
      Top = 96
      Width = 36
      Height = 13
      Caption = 'User ID'
    end
    object Label10: TLabel
      Left = 8
      Top = 120
      Width = 31
      Height = 13
      Caption = 'Senha'
    end
    object CheckBox1: TCheckBox
      Left = 8
      Top = 16
      Width = 97
      Height = 17
      Caption = 'Usar Proxy'
      TabOrder = 0
    end
    object EProxy_Host: TEdit
      Left = 56
      Top = 40
      Width = 121
      Height = 21
      TabOrder = 1
      Text = '200.161.190.58'
    end
    object EProxy_Porta: TEdit
      Left = 56
      Top = 64
      Width = 121
      Height = 21
      TabOrder = 2
      Text = '6588'
    end
    object EProxy_User: TEdit
      Left = 56
      Top = 88
      Width = 121
      Height = 21
      TabOrder = 3
    end
    object EProxy_Pass: TEdit
      Left = 56
      Top = 112
      Width = 121
      Height = 21
      TabOrder = 4
    end
  end
  object SpinEdit1: TSpinEdit
    Left = 224
    Top = 8
    Width = 57
    Height = 22
    MaxValue = 0
    MinValue = 0
    TabOrder = 0
    Value = 6667
  end
  object Button1: TButton
    Left = 216
    Top = 192
    Width = 75
    Height = 25
    Caption = '&OK'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 216
    Top = 224
    Width = 75
    Height = 25
    Caption = '&Cancelar'
    TabOrder = 2
    OnClick = Button2Click
  end
  object GroupBox2: TGroupBox
    Left = 0
    Top = 0
    Width = 193
    Height = 161
    Caption = ' Informações '
    TabOrder = 4
    object Label1: TLabel
      Left = 4
      Top = 24
      Width = 39
      Height = 13
      Caption = 'Servidor'
    end
    object Label3: TLabel
      Left = 4
      Top = 48
      Width = 22
      Height = 13
      Caption = 'Nick'
    end
    object Label4: TLabel
      Left = 4
      Top = 96
      Width = 28
      Height = 13
      Caption = 'Nome'
    end
    object Label5: TLabel
      Left = 4
      Top = 120
      Width = 29
      Height = 13
      Caption = 'E-Mail'
    end
    object Label6: TLabel
      Left = 4
      Top = 144
      Width = 38
      Height = 13
      Caption = 'Ident ID'
    end
    object Label11: TLabel
      Left = 5
      Top = 72
      Width = 28
      Height = 13
      Caption = 'Nick2'
    end
    object E_Server: TEdit
      Left = 48
      Top = 16
      Width = 137
      Height = 21
      TabOrder = 0
      Text = 'Unisys.RJ.BRASnet.org'
    end
    object E_Nick: TEdit
      Left = 48
      Top = 40
      Width = 121
      Height = 21
      TabOrder = 1
      Text = 'Nick354'
    end
    object E_Nome: TEdit
      Left = 48
      Top = 88
      Width = 121
      Height = 21
      TabOrder = 2
      Text = 'Nome'
    end
    object E_Mail: TEdit
      Left = 48
      Top = 112
      Width = 121
      Height = 21
      TabOrder = 3
      Text = 'me@x.com.br'
    end
    object Edit1: TEdit
      Left = 48
      Top = 136
      Width = 121
      Height = 21
      TabOrder = 4
    end
    object E_AltNick: TEdit
      Left = 48
      Top = 64
      Width = 121
      Height = 21
      TabOrder = 5
      Text = 'Teste354'
    end
  end
end
