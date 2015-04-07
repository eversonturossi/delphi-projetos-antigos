object Form1: TForm1
  Left = 192
  Top = 107
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Visualizador de cursores e ícones v1.0'
  ClientHeight = 288
  ClientWidth = 521
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
  object Label1: TLabel
    Left = 8
    Top = 262
    Width = 32
    Height = 13
    Caption = 'Label1'
  end
  object Image1: TImage
    Left = 304
    Top = 8
    Width = 105
    Height = 65
  end
  object FileListBox1: TFileListBox
    Left = 152
    Top = 0
    Width = 145
    Height = 249
    ItemHeight = 13
    Mask = '*.ani;*.cur;*.ico'
    TabOrder = 0
    OnChange = FileListBox1Change
  end
  object DriveComboBox1: TDriveComboBox
    Left = 4
    Top = 0
    Width = 145
    Height = 19
    DirList = DirectoryListBox1
    TabOrder = 1
  end
  object DirectoryListBox1: TDirectoryListBox
    Left = 4
    Top = 48
    Width = 145
    Height = 201
    FileList = FileListBox1
    ItemHeight = 16
    TabOrder = 2
  end
  object FilterComboBox1: TFilterComboBox
    Left = 4
    Top = 24
    Width = 145
    Height = 21
    FileList = FileListBox1
    Filter = 
      'Cursores, Icones (*.ani , *.cur, *.ico)|*.ani;*.cur;*.ico|Cursor' +
      ' (*.cur)|*.cur|Cursor animado (*.ani)|*.ani|Icone (*.ico)|*.ico|' +
      'Todos (*.*)|*.*'
    TabOrder = 3
  end
  object Panel1: TPanel
    Left = 304
    Top = 167
    Width = 209
    Height = 81
    Color = clBlack
    TabOrder = 4
  end
  object Panel2: TPanel
    Left = 304
    Top = 82
    Width = 209
    Height = 81
    Color = clWhite
    TabOrder = 5
  end
end
