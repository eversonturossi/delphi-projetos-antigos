object frmPrincipal: TfrmPrincipal
  Left = 192
  Top = 107
  Width = 870
  Height = 500
  ActiveControl = pnlFTPCounts
  Caption = 'frmPrincipal'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object Label8: TLabel
    Left = 213
    Top = 172
    Width = 46
    Height = 13
    Caption = 'Password'
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 454
    Width = 862
    Height = 19
    Panels = <
      item
        Width = 50
      end>
  end
  object pcPrincipal: TPageControl
    Left = 0
    Top = 0
    Width = 862
    Height = 454
    ActivePage = tbFTPAcontes
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    Style = tsFlatButtons
    TabOrder = 1
    object tbPrincipal: TTabSheet
      Caption = 'Principal'
      object pnlPrincipal: TPanel
        Left = 0
        Top = 0
        Width = 854
        Height = 423
        Align = alClient
        BorderStyle = bsSingle
        Ctl3D = False
        ParentCtl3D = False
        TabOrder = 0
        object pnlTeclado: TPanel
          Left = 264
          Top = 176
          Width = 341
          Height = 25
          BevelOuter = bvNone
          TabOrder = 0
          object FlatButton1: TFlatButton
            Left = 0
            Top = 0
            Width = 25
            Height = 25
            Caption = '1'
            TabOrder = 0
          end
          object FlatButton2: TFlatButton
            Left = 35
            Top = 0
            Width = 25
            Height = 25
            Caption = '2'
            TabOrder = 1
          end
          object FlatButton3: TFlatButton
            Left = 70
            Top = 0
            Width = 25
            Height = 25
            Caption = '3'
            TabOrder = 2
          end
          object FlatButton4: TFlatButton
            Left = 105
            Top = 0
            Width = 25
            Height = 25
            Caption = '4'
            TabOrder = 3
          end
          object FlatButton5: TFlatButton
            Left = 140
            Top = 0
            Width = 25
            Height = 25
            Caption = '5'
            TabOrder = 4
          end
          object FlatButton6: TFlatButton
            Left = 176
            Top = 0
            Width = 25
            Height = 25
            Caption = '6'
            TabOrder = 5
          end
          object FlatButton7: TFlatButton
            Left = 211
            Top = 0
            Width = 25
            Height = 25
            Caption = '7'
            TabOrder = 6
          end
          object FlatButton8: TFlatButton
            Left = 246
            Top = 0
            Width = 25
            Height = 25
            Caption = '8'
            TabOrder = 7
          end
          object FlatButton9: TFlatButton
            Left = 281
            Top = 0
            Width = 25
            Height = 25
            Caption = '9'
            TabOrder = 8
          end
          object FlatButton10: TFlatButton
            Left = 316
            Top = 0
            Width = 25
            Height = 25
            Caption = '0'
            TabOrder = 9
          end
        end
      end
    end
    object tbFTPAcontes: TTabSheet
      Caption = 'FTP Acounts'
      ImageIndex = 4
      object pnlFTPCounts: TPanel
        Left = 0
        Top = 0
        Width = 854
        Height = 423
        Align = alClient
        BorderStyle = bsSingle
        Ctl3D = False
        ParentCtl3D = False
        TabOrder = 0
        object FlatGroupBox1: TFlatGroupBox
          Left = 7
          Top = 3
          Width = 202
          Height = 409
          Caption = 'FTPS UPDATES'
          TabOrder = 0
          object Label11: TLabel
            Left = 8
            Top = 19
            Width = 33
            Height = 13
            Caption = 'Nome'
          end
          object Label12: TLabel
            Left = 8
            Top = 139
            Width = 37
            Height = 13
            Caption = 'Senha'
          end
          object Label13: TLabel
            Left = 8
            Top = 99
            Width = 32
            Height = 13
            Caption = 'Login'
          end
          object Label14: TLabel
            Left = 8
            Top = 59
            Width = 27
            Height = 13
            Caption = 'Host'
          end
          object FlatEdit8: TFlatEdit
            Left = 8
            Top = 37
            Width = 160
            Height = 19
            ColorFlat = clBtnFace
            ParentColor = True
            TabOrder = 0
          end
          object FlatEdit5: TFlatEdit
            Left = 8
            Top = 77
            Width = 160
            Height = 19
            ColorFlat = clBtnFace
            ParentColor = True
            TabOrder = 1
          end
          object FlatEdit6: TFlatEdit
            Left = 8
            Top = 117
            Width = 160
            Height = 19
            ColorFlat = clBtnFace
            ParentColor = True
            TabOrder = 2
          end
          object FlatEdit7: TFlatEdit
            Left = 8
            Top = 156
            Width = 160
            Height = 19
            ColorFlat = clBtnFace
            ParentColor = True
            TabOrder = 3
          end
          object ListBox3: TListBox
            Left = 8
            Top = 189
            Width = 160
            Height = 182
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ItemHeight = 13
            ParentFont = False
            TabOrder = 4
          end
        end
      end
    end
    object tbFTPmanager: TTabSheet
      Caption = 'FTPs Manager'
      ImageIndex = 5
      object Panel7: TPanel
        Left = 0
        Top = 0
        Width = 854
        Height = 423
        Align = alClient
        BorderStyle = bsSingle
        Ctl3D = False
        ParentCtl3D = False
        TabOrder = 0
      end
    end
    object tbUpdates: TTabSheet
      Caption = 'UPDATEs'
      ImageIndex = 1
      object Panel2: TPanel
        Left = 0
        Top = 0
        Width = 854
        Height = 423
        Align = alClient
        BorderStyle = bsSingle
        Ctl3D = False
        ParentCtl3D = False
        TabOrder = 0
        object Label1: TLabel
          Left = 196
          Top = 8
          Width = 40
          Height = 13
          Caption = 'Vers'#227'o'
        end
        object Label2: TLabel
          Left = 196
          Top = 92
          Width = 92
          Height = 13
          Caption = 'Nome aplicativo'
        end
        object Label3: TLabel
          Left = 196
          Top = 133
          Width = 89
          Height = 13
          Caption = 'Links download'
        end
        object Label10: TLabel
          Left = 196
          Top = 50
          Width = 92
          Height = 13
          Caption = 'Nome aplicativo'
        end
        object edtUVersao: TFlatSpinEditInteger
          Left = 196
          Top = 24
          Width = 50
          Height = 20
          ColorFlat = clBtnFace
          AutoSize = False
          MaxValue = 0
          MinValue = 0
          ParentColor = True
          TabOrder = 0
          Value = 0
        end
        object pnlUpdatesBaixo: TPanel
          Left = 1
          Top = 387
          Width = 850
          Height = 33
          Align = alBottom
          BevelOuter = bvNone
          TabOrder = 1
          object btnUSalvar: TFlatSpeedButton
            Left = 8
            Top = 4
            Width = 133
            Height = 25
            Caption = 'Salvar'
          end
          object btnUGera: TFlatSpeedButton
            Left = 176
            Top = 4
            Width = 133
            Height = 25
            Caption = 'Gerar Aosrquivos'
          end
        end
        object Panel6: TPanel
          Left = 1
          Top = 1
          Width = 172
          Height = 386
          Align = alLeft
          BevelOuter = bvNone
          TabOrder = 2
          object ListBox2: TListBox
            Left = 0
            Top = 0
            Width = 172
            Height = 386
            Align = alClient
            Color = clBtnFace
            Ctl3D = False
            ItemHeight = 13
            ParentCtl3D = False
            TabOrder = 0
          end
        end
        object edtUNome: TFlatEdit
          Left = 196
          Top = 108
          Width = 179
          Height = 19
          ColorFlat = clBtnFace
          ParentColor = True
          TabOrder = 3
        end
        object edtLinks: TMemo
          Left = 196
          Top = 151
          Width = 441
          Height = 153
          Color = clBtnFace
          TabOrder = 4
        end
        object edtUarquivo: TFlatEdit
          Left = 196
          Top = 66
          Width = 179
          Height = 19
          ColorFlat = clBtnFace
          ParentColor = True
          TabOrder = 5
        end
      end
    end
    object tbFtps: TTabSheet
      Caption = 'FTPs'
      ImageIndex = 2
      object Panel4: TPanel
        Left = 0
        Top = 0
        Width = 854
        Height = 423
        Align = alClient
        BorderStyle = bsSingle
        Ctl3D = False
        ParentCtl3D = False
        TabOrder = 0
        object Label4: TLabel
          Left = 213
          Top = 55
          Width = 54
          Height = 13
          Caption = 'Host FTP'
        end
        object Label5: TLabel
          Left = 213
          Top = 28
          Width = 40
          Height = 13
          Caption = 'Vers'#227'o'
        end
        object Label6: TLabel
          Left = 213
          Top = 81
          Width = 32
          Height = 13
          Caption = 'Login'
        end
        object Label7: TLabel
          Left = 213
          Top = 106
          Width = 55
          Height = 13
          Caption = 'Password'
        end
        object Label9: TLabel
          Left = 213
          Top = 133
          Width = 44
          Height = 13
          Caption = 'Arquivo'
        end
        object ListBox1: TListBox
          Left = 1
          Top = 1
          Width = 168
          Height = 386
          Align = alLeft
          Color = clBtnFace
          Ctl3D = False
          ItemHeight = 13
          ParentCtl3D = False
          TabOrder = 0
        end
        object FlatEdit1: TFlatEdit
          Left = 278
          Top = 51
          Width = 290
          Height = 19
          ColorFlat = clBtnFace
          ParentColor = True
          TabOrder = 1
        end
        object FlatSpinEditInteger2: TFlatSpinEditInteger
          Left = 278
          Top = 24
          Width = 50
          Height = 20
          ColorFlat = clBtnFace
          AutoSize = False
          MaxValue = 0
          MinValue = 0
          ParentColor = True
          TabOrder = 2
          Value = 0
        end
        object pnlFTPBaixo: TPanel
          Left = 1
          Top = 387
          Width = 850
          Height = 33
          Align = alBottom
          BevelOuter = bvNone
          TabOrder = 3
          object btnFSalvar: TFlatSpeedButton
            Left = 8
            Top = 4
            Width = 133
            Height = 25
            Caption = 'Salvar'
          end
          object btnFGera: TFlatSpeedButton
            Left = 176
            Top = 4
            Width = 133
            Height = 25
            Caption = 'Gerar Aosrquivos'
          end
        end
        object FlatEdit2: TFlatEdit
          Left = 278
          Top = 77
          Width = 290
          Height = 19
          ColorFlat = clBtnFace
          ParentColor = True
          TabOrder = 4
        end
        object FlatEdit3: TFlatEdit
          Left = 278
          Top = 102
          Width = 290
          Height = 19
          ColorFlat = clBtnFace
          ParentColor = True
          TabOrder = 5
        end
        object FlatEdit4: TFlatEdit
          Left = 278
          Top = 129
          Width = 290
          Height = 19
          ColorFlat = clBtnFace
          ParentColor = True
          TabOrder = 6
        end
      end
    end
    object tbFTPTest: TTabSheet
      Caption = 'Test'
      ImageIndex = 6
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 854
        Height = 423
        Align = alClient
        BorderStyle = bsSingle
        Ctl3D = False
        ParentCtl3D = False
        TabOrder = 0
      end
    end
    object tbStatus: TTabSheet
      Caption = 'Status'
      ImageIndex = 3
      object Panel3: TPanel
        Left = 0
        Top = 0
        Width = 854
        Height = 423
        Align = alClient
        BevelOuter = bvNone
        BorderStyle = bsSingle
        Ctl3D = False
        ParentCtl3D = False
        TabOrder = 0
        object FlatGauge1: TFlatGauge
          Left = 0
          Top = 396
          Width = 852
          Height = 25
          AdvColorBorder = 0
          ColorBorder = 8623776
          Progress = 25
          Align = alBottom
        end
        object pnlAtualizar: TPanel
          Left = 0
          Top = 0
          Width = 852
          Height = 100
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 0
          object btnAtualizar: TFlatSpeedButton
            Left = 8
            Top = 8
            Width = 138
            Height = 25
            Caption = 'Atualizar'
            OnClick = btnAtualizarClick
          end
          object btnParar: TFlatSpeedButton
            Left = 180
            Top = 8
            Width = 138
            Height = 25
            Caption = 'Parar'
            Enabled = False
            OnClick = btnPararClick
          end
        end
        object Memo1: TMemo
          Left = 0
          Top = 100
          Width = 852
          Height = 296
          Align = alClient
          TabOrder = 1
        end
      end
    end
  end
  object TimerAtualizando: TTimer
    Enabled = False
    OnTimer = TimerAtualizandoTimer
    Left = 660
    Top = 5
  end
  object FlatHint1: TFlatHint
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Left = 747
    Top = 4
  end
  object IdFTP1: TIdFTP
    MaxLineAction = maException
    ReadTimeout = 0
    ProxySettings.ProxyType = fpcmNone
    ProxySettings.Port = 0
    Left = 608
    Top = 8
  end
end
