object Form1: TForm1
  Left = 192
  Top = 107
  Width = 208
  Height = 278
  AutoSize = True
  Caption = 'Skeletonize'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = 0
    Top = 32
    Width = 200
    Height = 200
  end
  object Button1: TButton
    Left = 0
    Top = 0
    Width = 75
    Height = 25
    Caption = 'Thin'
    Enabled = False
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 80
    Top = 0
    Width = 75
    Height = 25
    Caption = 'Undo'
    Enabled = False
    TabOrder = 1
    OnClick = Button2Click
  end
  object MainMenu1: TMainMenu
    Left = 8
    Top = 40
    object File1: TMenuItem
      Caption = 'File'
      object Open1: TMenuItem
        Caption = 'Open'
        OnClick = Open1Click
      end
      object SaveAs1: TMenuItem
        Caption = 'Save As'
        OnClick = SaveAs1Click
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object Animate1: TMenuItem
        Caption = 'Animate'
        Checked = True
        OnClick = Animate1Click
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Exit1: TMenuItem
        Caption = 'Exit'
        OnClick = Exit1Click
      end
    end
  end
  object OpenPictureDialog1: TOpenPictureDialog
    Filter = 'Bitmaps (*.bmp)|*.bmp'
    Left = 40
    Top = 40
  end
  object SavePictureDialog1: TSavePictureDialog
    DefaultExt = 'bmp'
    Filter = 'Bitmaps (*.bmp)|*.bmp'
    Left = 72
    Top = 40
  end
end
