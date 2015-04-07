object Form1: TForm1
  Left = 374
  Top = 290
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Str & Int Conversor - by Mr_Geek'
  ClientHeight = 96
  ClientWidth = 284
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 142
    Height = 96
    Align = alLeft
    Caption = 'String para Integer'
    TabOrder = 0
    object SpeedButton1: TSpeedButton
      Left = 3
      Top = 67
      Width = 134
      Height = 26
      Caption = 'Converter'
      Flat = True
      OnClick = SpeedButton1Click
    end
    object Edit1: TEdit
      Left = 8
      Top = 16
      Width = 121
      Height = 21
      TabOrder = 0
    end
    object SpinEdit1: TSpinEdit
      Left = 8
      Top = 40
      Width = 121
      Height = 25
      MaxValue = 0
      MinValue = 0
      ReadOnly = True
      TabOrder = 1
      Value = 0
    end
  end
  object GroupBox2: TGroupBox
    Left = 143
    Top = 0
    Width = 141
    Height = 96
    Align = alRight
    Caption = 'Integer para String'
    TabOrder = 1
    object SpeedButton2: TSpeedButton
      Left = 3
      Top = 67
      Width = 134
      Height = 26
      Caption = 'Converter'
      Flat = True
      OnClick = SpeedButton2Click
    end
    object Edit2: TEdit
      Left = 8
      Top = 44
      Width = 121
      Height = 21
      ReadOnly = True
      TabOrder = 0
    end
    object SpinEdit2: TSpinEdit
      Left = 8
      Top = 16
      Width = 121
      Height = 25
      MaxValue = 0
      MinValue = 0
      TabOrder = 1
      Value = 0
    end
  end
end
