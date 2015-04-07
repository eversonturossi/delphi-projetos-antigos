object Form1: TForm1
  Left = 869
  Top = 397
  Width = 112
  Height = 69
  BorderIcons = []
  Caption = 'Clicator'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lblSegundos: TLabel
    Left = 11
    Top = 8
    Width = 13
    Height = 29
    Caption = '0'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -24
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object TimerEncontraBotao: TTimer
    Enabled = False
    Interval = 500
    OnTimer = TimerEncontraBotaoTimer
    Left = 112
    Top = 8
  end
end
