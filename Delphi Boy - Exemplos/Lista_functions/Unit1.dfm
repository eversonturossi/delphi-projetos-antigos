object Form1: TForm1
  Left = 192
  Top = 107
  Width = 529
  Height = 352
  Caption = 'Lista Functions'
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
  object DriveComboBox1: TDriveComboBox
    Left = 8
    Top = 0
    Width = 153
    Height = 19
    DirList = DirectoryListBox1
    TabOrder = 0
  end
  object DirectoryListBox1: TDirectoryListBox
    Left = 8
    Top = 19
    Width = 153
    Height = 118
    FileList = FileListBox1
    ItemHeight = 16
    TabOrder = 1
  end
  object FileListBox1: TFileListBox
    Left = 8
    Top = 160
    Width = 153
    Height = 161
    ItemHeight = 13
    Mask = '*.exe;*.dll'
    TabOrder = 2
    OnChange = FileListBox1Change
  end
  object FilterComboBox1: TFilterComboBox
    Left = 8
    Top = 137
    Width = 153
    Height = 21
    FileList = FileListBox1
    Filter = 
      'Executáveis, DLL (*.exe,*.dll)|*.exe;*.dll|OCX,SYS,CPL,BPL,AX|*.' +
      'ocx;*.sys;*.cpl;*.bpl;,*.ax|Todos (*.*)|*.*'
    TabOrder = 3
  end
  object Memo1: TMemo
    Left = 165
    Top = 0
    Width = 352
    Height = 321
    ScrollBars = ssVertical
    TabOrder = 4
  end
end
