object MainForm: TMainForm
  Left = -4
  Top = -4
  AutoSize = True
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Replace Word in DFM Files'
  ClientHeight = 509
  ClientWidth = 800
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu
  OldCreateOrder = False
  PopupMenu = PopupMenu
  Position = poDefault
  WindowState = wsMaximized
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 4
    Top = 0
    Width = 46
    Height = 13
    Caption = 'Files Path'
  end
  object Label4: TLabel
    Left = 625
    Top = 1
    Width = 52
    Height = 13
    Caption = 'File Names'
  end
  object ListBoxFiles: TListBox
    Left = 2
    Top = 14
    Width = 617
    Height = 115
    Anchors = [akLeft, akTop, akRight]
    Ctl3D = False
    ItemHeight = 13
    MultiSelect = True
    ParentCtl3D = False
    PopupMenu = PopupMenu
    TabOrder = 0
    OnClick = ListBoxFilesClick
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 490
    Width = 800
    Height = 19
    Panels = <
      item
        Bevel = pbRaised
        Width = 200
      end
      item
        Alignment = taCenter
        Width = 250
      end
      item
        Width = 50
      end>
    SimplePanel = False
  end
  object GroupBox1: TGroupBox
    Left = 2
    Top = 146
    Width = 259
    Height = 78
    Caption = ' [ Words Substitutes ] '
    Ctl3D = False
    ParentCtl3D = False
    PopupMenu = PopupMenu
    TabOrder = 2
    object Label2: TLabel
      Left = 135
      Top = 13
      Width = 51
      Height = 13
      Caption = 'New Word'
    end
    object Label3: TLabel
      Left = 5
      Top = 12
      Width = 45
      Height = 13
      Caption = 'Old Word'
    end
    object EditNewWord: TEdit
      Left = 132
      Top = 25
      Width = 121
      Height = 19
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 0
    end
    object EditOldWord: TEdit
      Left = 5
      Top = 25
      Width = 121
      Height = 19
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 1
    end
    object Button1: TButton
      Left = 7
      Top = 48
      Width = 75
      Height = 25
      Caption = 'Substitute'
      TabOrder = 2
      OnClick = ButtonSubstituteClick
    end
  end
  object PageControlContentFiles: TPageControl
    Left = 5
    Top = 229
    Width = 795
    Height = 261
    Anchors = [akLeft, akTop, akRight, akBottom]
    HotTrack = True
    PopupMenu = PopupMenu
    TabOrder = 3
    OnChange = PageControlContentFilesChange
  end
  object CheckBoxSelectAll: TCheckBox
    Left = 3
    Top = 129
    Width = 69
    Height = 17
    Caption = 'Select All'
    TabOrder = 4
    OnClick = CheckBoxSelectAllClick
  end
  object ListBoxFileNames: TListBox
    Left = 624
    Top = 14
    Width = 173
    Height = 115
    Ctl3D = False
    ItemHeight = 13
    ParentCtl3D = False
    TabOrder = 5
  end
  object MainMenu: TMainMenu
    Left = 104
    Top = 21
    object OpenFiles1: TMenuItem
      Caption = '&Sistem'
      Checked = True
      object Open1: TMenuItem
        Caption = '&Open Files'
        OnClick = Open1Click
      end
      object AutomaticSave1: TMenuItem
        Caption = 'Automatic Saving'
        Checked = True
        OnClick = AutomaticSave1Click
      end
      object About1: TMenuItem
        Caption = '&About'
        OnClick = About1Click
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Exit1: TMenuItem
        Caption = '&Exit'
        OnClick = Exit1Click
      end
    end
  end
  object OpenDialogFiles: TOpenDialog
    DefaultExt = '*.dfm'
    Filter = 'DFM(*.dfm)|*.dfm'
    InitialDir = 'D:\Programacao'
    Options = [ofHideReadOnly, ofAllowMultiSelect, ofEnableIncludeNotify, ofEnableSizing]
    Left = 53
    Top = 22
  end
  object PopupMenu: TPopupMenu
    Left = 159
    Top = 21
    object ReplaceWordinDFMFiles1: TMenuItem
      Caption = '. : : Replace Word in DFM Files : : .'
      Default = True
      Enabled = False
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object PopupSaveModifies1: TMenuItem
      Caption = '&Save All Files Modifies'
      OnClick = PopupSaveModifies1Click
    end
    object About2: TMenuItem
      Caption = '&About'
      OnClick = About1Click
    end
  end
end
