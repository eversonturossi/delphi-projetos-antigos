object frmPrincipal: TfrmPrincipal
  Left = 192
  Top = 107
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Biomas Software v1.0 beta'
  ClientHeight = 541
  ClientWidth = 779
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  WindowState = wsMaximized
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object StatusBar1: TStatusBar
    Left = 0
    Top = 522
    Width = 779
    Height = 19
    Panels = <
      item
        Width = 50
      end>
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 779
    Height = 34
    Align = alTop
    TabOrder = 1
    object Label1: TLabel
      Left = 6
      Top = 10
      Width = 37
      Height = 13
      Caption = 'Nome:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object edtNome: TEdit
      Left = 48
      Top = 7
      Width = 381
      Height = 19
      Hint = 'Digite seu Nome aqui.'
      Ctl3D = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentCtl3D = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
    end
    object btnEntar: TButton
      Left = 435
      Top = 7
      Width = 75
      Height = 19
      Hint = 'Clica aqui de uma vez.'
      Caption = 'Entrar'
      Default = True
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = btnEntarClick
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 34
    Width = 779
    Height = 488
    Align = alClient
    TabOrder = 2
    Visible = False
    object progresso: TFlatGauge
      Left = 1
      Top = 467
      Width = 777
      Height = 20
      AdvColorBorder = 0
      ColorBorder = 8623776
      Progress = 0
      Align = alBottom
    end
    object lblTxt: TLabel
      Left = 56
      Top = 80
      Width = 435
      Height = 37
      Caption = 'Muito obrigado pela paci'#234'ncia.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -32
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      Visible = False
    end
    object edtResposta: TEdit
      Left = 8
      Top = 52
      Width = 673
      Height = 19
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 0
      Visible = False
    end
    object wPergunta: TMemo
      Left = 9
      Top = 7
      Width = 675
      Height = 41
      BorderStyle = bsNone
      Color = cl3DLight
      Ctl3D = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentCtl3D = False
      ParentFont = False
      ReadOnly = True
      TabOrder = 1
    end
    object wRespostaE: TFlatRadioButton
      Left = 9
      Top = 51
      Width = 500
      Height = 17
      Caption = 'Pergunta'
      TabOrder = 2
    end
    object wRespostaD: TFlatRadioButton
      Left = 9
      Top = 75
      Width = 500
      Height = 17
      Caption = 'Pergunta'
      TabOrder = 3
    end
    object wRespostaC: TFlatRadioButton
      Left = 9
      Top = 99
      Width = 500
      Height = 17
      Caption = 'Pergunta'
      TabOrder = 4
    end
    object wRespostaB: TFlatRadioButton
      Left = 9
      Top = 123
      Width = 500
      Height = 17
      Caption = 'Pergunta'
      TabOrder = 5
    end
    object wRespostaA: TFlatRadioButton
      Left = 9
      Top = 147
      Width = 500
      Height = 17
      Caption = 'Pergunta'
      TabOrder = 6
    end
    object btnProxima: TFlatButton
      Left = 8
      Top = 171
      Width = 250
      Height = 21
      Caption = 'Proxima pergunta >>'
      TabOrder = 7
      OnClick = btnProximaClick
    end
    object btnFinalizar: TFlatButton
      Left = 262
      Top = 171
      Width = 250
      Height = 21
      Caption = 'Finalizar Question'#225'rio'
      Enabled = False
      TabOrder = 8
      OnClick = btnFinalizarClick
    end
  end
  object FlatHint1: TFlatHint
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Left = 744
    Top = 458
  end
end
