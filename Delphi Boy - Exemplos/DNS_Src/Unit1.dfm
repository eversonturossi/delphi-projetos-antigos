object Form1: TForm1
  Left = 192
  Top = 107
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'DNS - #DELPHIX'
  ClientHeight = 288
  ClientWidth = 320
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 8
    Top = 0
    Width = 305
    Height = 281
    TabOrder = 0
    object Memo1: TMemo
      Left = 8
      Top = 16
      Width = 289
      Height = 89
      ScrollBars = ssVertical
      TabOrder = 0
    end
    object GroupBox2: TGroupBox
      Left = 8
      Top = 192
      Width = 289
      Height = 73
      Caption = ' IP->Host '
      TabOrder = 1
      object Label2: TLabel
        Left = 8
        Top = 16
        Width = 13
        Height = 13
        Caption = 'IP:'
      end
      object Edit2: TEdit
        Left = 40
        Top = 12
        Width = 241
        Height = 21
        TabOrder = 0
      end
      object Button1: TButton
        Left = 40
        Top = 40
        Width = 241
        Height = 25
        Caption = 'Host'
        TabOrder = 1
        OnClick = Button1Click
      end
    end
    object GroupBox3: TGroupBox
      Left = 8
      Top = 112
      Width = 289
      Height = 73
      Caption = ' Host->IP '
      TabOrder = 2
      object Label1: TLabel
        Left = 8
        Top = 20
        Width = 25
        Height = 13
        Caption = 'Host:'
      end
      object Edit1: TEdit
        Left = 40
        Top = 12
        Width = 241
        Height = 21
        TabOrder = 0
      end
      object Button2: TButton
        Left = 40
        Top = 40
        Width = 241
        Height = 25
        Caption = 'IP Address'
        TabOrder = 1
        OnClick = Button2Click
      end
    end
  end
end
