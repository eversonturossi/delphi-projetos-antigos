object FrmPlugins: TFrmPlugins
  Left = 221
  Top = 126
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Plugins Carregados'
  ClientHeight = 320
  ClientWidth = 446
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 8
    Top = 176
    Width = 433
    Height = 137
    Caption = ' Info '
    TabOrder = 0
    object Label1: TLabel
      Left = 16
      Top = 32
      Width = 51
      Height = 13
      Caption = 'Descri'#231#227'o:'
    end
    object Label2: TLabel
      Left = 16
      Top = 16
      Width = 28
      Height = 13
      Caption = 'Autor:'
    end
    object LabAuthor: TLabel
      Left = 80
      Top = 16
      Width = 18
      Height = 13
      Caption = '------'
    end
    object Label4: TLabel
      Left = 16
      Top = 96
      Width = 47
      Height = 13
      Caption = 'Copyright:'
    end
    object LabCopy: TLabel
      Left = 80
      Top = 96
      Width = 18
      Height = 13
      Caption = '------'
    end
    object Label6: TLabel
      Left = 16
      Top = 112
      Width = 31
      Height = 13
      Caption = 'Home:'
    end
    object LabHome: TLabel
      Left = 80
      Top = 112
      Width = 18
      Height = 13
      Caption = '------'
    end
    object MemDesc: TMemo
      Left = 80
      Top = 32
      Width = 337
      Height = 49
      Color = clBtnFace
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 0
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 0
    Width = 433
    Height = 169
    Caption = ' Plugins '
    TabOrder = 1
    object ListView1: TListView
      Left = 8
      Top = 19
      Width = 417
      Height = 142
      Columns = <
        item
          Caption = 'Fun'#231#227'o'
          Width = 160
        end
        item
          Caption = 'Vers'#227'o'
          Width = 70
        end
        item
          Caption = 'Arquivo'
          Width = 110
        end
        item
          Caption = 'Tamanho'
          Width = 60
        end>
      ReadOnly = True
      TabOrder = 0
      ViewStyle = vsReport
      OnChange = ListView1Change
    end
  end
end
