object Form1: TForm1
  Left = 279
  Top = 124
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Form1'
  ClientHeight = 63
  ClientWidth = 384
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
  object lblInstalled: TLabel
    Left = 0
    Top = 42
    Width = 384
    Height = 21
    Align = alBottom
    Alignment = taCenter
    AutoSize = False
    Caption = 'Hook not installed'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Verdana'
    Font.Style = []
    ParentFont = False
  end
  object Button1: TButton
    Left = 56
    Top = 8
    Width = 75
    Height = 25
    Caption = '&InstallHook'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 154
    Top = 8
    Width = 75
    Height = 25
    Caption = '&UninstallHook'
    TabOrder = 1
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 252
    Top = 8
    Width = 75
    Height = 25
    Caption = '&Shutdown'
    TabOrder = 2
    OnClick = Button3Click
  end
end
