object FrmConfiguracoes: TFrmConfiguracoes
  Left = 254
  Top = 184
  BorderStyle = bsToolWindow
  Caption = 'Configurações'
  ClientHeight = 334
  ClientWidth = 562
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object BtnGravar: TIAeverButton
    Left = 186
    Top = 300
    Width = 81
    Height = 25
    Caption = '&Gravar'
    Default = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnClick = BtnGravarClick
    ButtonAngle = 0
    ButtonWidth = 81
    ButtonHeight = 25
    CaptionAngle = 0
    Transparent = False
    UserRGNAUTO = True
    RotationPointX = 0
    RotationPointY = 0
    Rotated = False
    CaptionFixed = False
    GradientFixed = False
    GradientBitmapLine = 0
    Caption3dKind = ckSimple
    RadiusRatio = 0.5
    ArcAngle = 2.0943951023932
  end
  object BtnCancelar: TIAeverButton
    Left = 298
    Top = 300
    Width = 81
    Height = 25
    Cancel = True
    Caption = 'Cance&lar'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnClick = BtnCancelarClick
    ButtonAngle = 0
    ButtonWidth = 81
    ButtonHeight = 25
    CaptionAngle = 0
    Transparent = False
    UserRGNAUTO = True
    RotationPointX = 0
    RotationPointY = 0
    Rotated = False
    CaptionFixed = False
    GradientFixed = False
    GradientBitmapLine = 0
    Caption3dKind = ckSimple
    RadiusRatio = 0.5
    ArcAngle = 2.0943951023932
  end
  object PageControl1: TPageControl
    Left = 8
    Top = 8
    Width = 545
    Height = 281
    ActivePage = TabSheet1
    TabOrder = 2
    object TabSheet1: TTabSheet
      Caption = 'Geral'
      object Label1: TLabel
        Left = 3
        Top = 18
        Width = 42
        Height = 13
        Caption = 'Servidor:'
        Transparent = True
      end
      object Label2: TLabel
        Left = 176
        Top = 18
        Width = 28
        Height = 13
        Caption = 'Porta:'
        Transparent = True
      end
      object Label3: TLabel
        Left = 3
        Top = 184
        Width = 25
        Height = 13
        Caption = 'Nick:'
        Transparent = True
      end
      object Label4: TLabel
        Left = 3
        Top = 72
        Width = 31
        Height = 13
        Caption = 'Nome:'
        Transparent = True
      end
      object Label5: TLabel
        Left = 3
        Top = 128
        Width = 31
        Height = 13
        Caption = 'E-mail:'
        Transparent = True
      end
      object EdtServidor: TEdit
        Left = 9
        Top = 33
        Width = 151
        Height = 21
        TabOrder = 0
        Text = '127.0.0.1'
      end
      object EdtPorta: TEdit
        Left = 182
        Top = 33
        Width = 57
        Height = 21
        TabOrder = 1
        Text = '6666'
      end
      object EdtNick: TEdit
        Left = 9
        Top = 199
        Width = 192
        Height = 21
        TabOrder = 2
        Text = '_-Waack3-_'
      end
      object EdtNome: TEdit
        Left = 9
        Top = 87
        Width = 232
        Height = 21
        TabOrder = 3
        Text = 'Waack3 Master'
      end
      object EdtEmail: TEdit
        Left = 9
        Top = 143
        Width = 192
        Height = 21
        TabOrder = 4
        Text = 'waack3@gmx.net'
      end
    end
  end
end
