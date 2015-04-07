object FrmDepurador: TFrmDepurador
  Left = 206
  Top = 262
  AutoScroll = False
  Caption = 'Depurador'
  ClientHeight = 183
  ClientWidth = 793
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object MemDepurador: TMemo
    Left = 0
    Top = 0
    Width = 793
    Height = 183
    TabStop = False
    Align = alClient
    Color = clWhite
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Fixedsys'
    Font.Style = []
    ParentFont = False
    PopupMenu = MnuOpMemDepurador
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object MnuOpMemDepurador: TPopupMenu
    Left = 8
    Top = 8
    object Limpar1: TMenuItem
      Caption = 'Limpar'
      OnClick = Limpar1Click
    end
    object Salvaremarquivo1: TMenuItem
      Caption = 'Salvar em arquivo'
      OnClick = Salvaremarquivo1Click
    end
  end
  object SalvarLog: TSaveDialog
    DefaultExt = '*.txt'
    Filter = 'Arquivos de texto|*.txt|Todos os arquivos|*.*'
    Title = 'Salvar log do depurador'
    Left = 48
    Top = 8
  end
end
