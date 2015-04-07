object Form1: TForm1
  Left = 205
  Top = 96
  Width = 480
  Height = 409
  Caption = 'Msctls_statusbar32 - by Prodigy_- [#.D.E.L.P.H.I.X]'
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
  object Label1: TLabel
    Left = 192
    Top = 16
    Width = 36
    Height = 13
    Caption = 'Caption'
  end
  object Button1: TButton
    Left = 192
    Top = 64
    Width = 161
    Height = 25
    Caption = 'Criar!'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Edit1: TEdit
    Left = 232
    Top = 8
    Width = 121
    Height = 21
    TabOrder = 1
    Text = 'StatusBar'
  end
  object Button2: TButton
    Left = 232
    Top = 32
    Width = 75
    Height = 25
    Caption = 'Items...'
    TabOrder = 2
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 192
    Top = 88
    Width = 161
    Height = 25
    Caption = 'Liberar'
    TabOrder = 3
    OnClick = Button3Click
  end
  object PageControl1: TPageControl
    Left = 8
    Top = 128
    Width = 425
    Height = 225
    ActivePage = TabSheet1
    TabIndex = 0
    TabOrder = 4
    object TabSheet1: TTabSheet
      Caption = 'Window Style'
      object Check_WindowStyle: TCheckListBox
        Left = 0
        Top = 4
        Width = 417
        Height = 189
        Columns = 2
        ItemHeight = 13
        Items.Strings = (
          'WS_BORDER'
          'WS_CAPTION'
          'WS_CHILD'
          'WS_CHILDWINDOW'
          'WS_CLIPCHILDREN'
          'WS_CLIPSIBLINGS'
          'WS_DISABLED'
          'WS_DLGFRAME'
          'WS_GROUP'
          'WS_HSCROLL'
          'WS_ICONIC'
          'WS_MAXIMIZE'
          'WS_MAXIMIZEBOX'
          'WS_MINIMIZE'
          'WS_MINIMIZEBOX'
          'WS_OVERLAPPED'
          'WS_OVERLAPPEDWINDOW'
          'WS_POPUP'
          'WS_POPUPWINDOW'
          'WS_SIZEBOX'
          'WS_SYSMENU'
          'WS_TABSTOP'
          'WS_THICKFRAME'
          'WS_TILED'
          'WS_TILEDWINDOW'
          'WS_VISIBLE'
          'WS_VSCROLL')
        TabOrder = 0
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'msctls_statusbar32'
      ImageIndex = 2
      object Check_Status: TCheckListBox
        Left = 0
        Top = 4
        Width = 417
        Height = 189
        ItemHeight = 13
        Items.Strings = (
          'SBARS_SIZEGRIP'
          'SBT_TOOLTIPS'
          'CCS_TOP'
          'CCS_NOMOVEY'
          'CCS_BOTTOM'
          'CCS_NORESIZE'
          'CCS_NOPARENTALIGN'
          'CCS_ADJUSTABLE'
          'CCS_NODIVIDER'
          'CCS_VERT'
          'CCS_LEFT'
          'CCS_RIGHT'
          'CCS_NOMOVEX')
        TabOrder = 0
      end
    end
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 185
    Height = 121
    Caption = ' Dimens'#245'es '
    TabOrder = 5
    object Label3: TLabel
      Left = 8
      Top = 24
      Width = 31
      Height = 13
      Caption = 'Height'
    end
    object Label4: TLabel
      Left = 8
      Top = 48
      Width = 28
      Height = 13
      Caption = 'Width'
    end
    object Label5: TLabel
      Left = 8
      Top = 72
      Width = 18
      Height = 13
      Caption = 'Left'
    end
    object Label6: TLabel
      Left = 8
      Top = 96
      Width = 19
      Height = 13
      Caption = 'Top'
    end
    object Edit3: TEdit
      Left = 56
      Top = 16
      Width = 121
      Height = 21
      TabOrder = 0
      Text = '100'
    end
    object Edit4: TEdit
      Left = 56
      Top = 40
      Width = 121
      Height = 21
      TabOrder = 1
      Text = '100'
    end
    object Edit5: TEdit
      Left = 56
      Top = 64
      Width = 121
      Height = 21
      TabOrder = 2
      Text = '20'
    end
    object Edit6: TEdit
      Left = 56
      Top = 88
      Width = 121
      Height = 21
      TabOrder = 3
      Text = '20'
    end
  end
  object Button4: TButton
    Left = 360
    Top = 64
    Width = 75
    Height = 25
    Caption = 'Color Teste'
    TabOrder = 6
    OnClick = Button4Click
  end
end
