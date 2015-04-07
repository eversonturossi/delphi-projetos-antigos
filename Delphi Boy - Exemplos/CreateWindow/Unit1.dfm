object Form1: TForm1
  Left = 193
  Top = 105
  Width = 591
  Height = 441
  Caption = 'CreateWindowEx'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PopupMenu = PopupMenu1
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Button_Criar: TButton
    Left = 392
    Top = 80
    Width = 185
    Height = 25
    Caption = 'Criar'
    TabOrder = 0
    OnClick = Button_CriarClick
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 0
    Width = 185
    Height = 121
    Caption = ' Dimensões '
    TabOrder = 1
    object Label1: TLabel
      Left = 8
      Top = 24
      Width = 31
      Height = 13
      Caption = 'Height'
    end
    object Label2: TLabel
      Left = 8
      Top = 48
      Width = 28
      Height = 13
      Caption = 'Width'
    end
    object Label3: TLabel
      Left = 8
      Top = 72
      Width = 18
      Height = 13
      Caption = 'Left'
    end
    object Label4: TLabel
      Left = 8
      Top = 96
      Width = 19
      Height = 13
      Caption = 'Top'
    end
    object Edit1: TEdit
      Left = 56
      Top = 16
      Width = 121
      Height = 21
      TabOrder = 0
      Text = '100'
    end
    object Edit2: TEdit
      Left = 56
      Top = 40
      Width = 121
      Height = 21
      TabOrder = 1
      Text = '100'
    end
    object Edit3: TEdit
      Left = 56
      Top = 64
      Width = 121
      Height = 21
      TabOrder = 2
      Text = '20'
    end
    object Edit4: TEdit
      Left = 56
      Top = 88
      Width = 121
      Height = 21
      TabOrder = 3
      Text = '20'
    end
  end
  object RadioGroup1: TRadioGroup
    Left = 200
    Top = 0
    Width = 185
    Height = 121
    Caption = ' Classe '
    Columns = 2
    ItemIndex = 0
    Items.Strings = (
      'BUTTON'
      'COMBOBOX'
      'EDIT'
      'LISTBOX'
      'MDICLIENT'
      'SCROLLBAR'
      'STATIC'
      'TPUtilWindow'
      'Nula')
    TabOrder = 2
    OnClick = RadioGroup1Click
  end
  object GroupBox2: TGroupBox
    Left = 392
    Top = 0
    Width = 185
    Height = 73
    Caption = 'GroupBox2'
    TabOrder = 3
    object Label5: TLabel
      Left = 8
      Top = 24
      Width = 28
      Height = 13
      Caption = 'Nome'
    end
    object Label6: TLabel
      Left = 8
      Top = 48
      Width = 27
      Height = 13
      Caption = 'Texto'
    end
    object Edit5: TEdit
      Left = 48
      Top = 16
      Width = 121
      Height = 21
      TabOrder = 0
      Text = 'Janela1'
    end
    object Edit6: TEdit
      Left = 48
      Top = 40
      Width = 121
      Height = 21
      TabOrder = 1
      Text = 'Texto'
    end
  end
  object PageControl1: TPageControl
    Left = 8
    Top = 136
    Width = 569
    Height = 265
    ActivePage = TB_WindowStyles
    TabOrder = 4
    object TB_WindowStyles: TTabSheet
      Caption = 'Window Styles'
      ImageIndex = 7
      object Check_WindowStyle: TCheckListBox
        Left = 8
        Top = 16
        Width = 545
        Height = 209
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
    object TB_DialogBox: TTabSheet
      Caption = 'Dialog Box Style'
      ImageIndex = 9
      object Check_DialogBoxStyle: TCheckListBox
        Left = 8
        Top = 8
        Width = 545
        Height = 201
        Columns = 2
        ItemHeight = 13
        Items.Strings = (
          'DS_3DLOOK'
          'DS_ABSALIGN'
          'DS_CENTER'
          'DS_CENTERMOUSE'
          'DS_CONTEXTHELP'
          'DS_CONTROL'
          'DS_FIXEDSYS'
          'DS_LOCALEDIT'
          'DS_MODALFRAME'
          'DS_NOFAILCREATE'
          'DS_NOIDLEMSG'
          'DS_SETFONT'
          'DS_SETFOREGROUND'
          'DS_SYSMODAL')
        TabOrder = 0
      end
    end
    object TB_ExtendedStyle: TTabSheet
      Caption = 'Extended Style'
      ImageIndex = 8
      object Check_ExtendedStyle: TCheckListBox
        Left = 8
        Top = 8
        Width = 545
        Height = 201
        Columns = 2
        ItemHeight = 13
        Items.Strings = (
          'WS_EX_ACCEPTFILES'
          'WS_EX_APPWINDOW'
          'WS_EX_CLIENTEDGE'
          'WS_EX_CONTEXTHELP'
          'WS_EX_CONTROLPARENT'
          'WS_EX_DLGMODALFRAME'
          'WS_EX_LEFT'
          'WS_EX_LEFTSCROLLBAR'
          'WS_EX_LTRREADING'
          'WS_EX_MDICHILD'
          'WS_EX_NOPARENTNOTIFY'
          'WS_EX_OVERLAPPEDWINDOW'
          'WS_EX_PALETTEWINDOW'
          'WS_EX_RIGHT'
          'WS_EX_RIGHTSCROLLBAR'
          'WS_EX_RTLREADING'
          'WS_EX_STATICEDGE'
          'WS_EX_TOOLWINDOW'
          'WS_EX_TOPMOST'
          'WS_EX_TRANSPARENT'
          'WS_EX_WINDOWEDGE')
        TabOrder = 0
      end
    end
    object TB_BUTTON: TTabSheet
      Caption = 'BUTTON'
      object Check_Button: TCheckListBox
        Left = 8
        Top = 8
        Width = 545
        Height = 209
        Columns = 2
        ItemHeight = 13
        Items.Strings = (
          'BS_3STATE'
          'BS_AUTO3STATE'
          'BS_AUTOCHECKBOX'
          'BS_AUTORADIOBUTTON'
          'BS_CHECKBOX'
          'BS_DEFPUSHBUTTON'
          'BS_GROUPBOX'
          'BS_LEFTTEXT'
          'BS_OWNERDRAW'
          'BS_PUSHBUTTON'
          'BS_RADIOBUTTON'
          'BS_USERBUTTON'
          'BS_BITMAP'
          'BS_BOTTOM'
          'BS_CENTER'
          'BS_ICON'
          'BS_LEFT'
          'BS_MULTILINE'
          'BS_NOTIFY'
          'BS_PUSHLIKE'
          'BS_RIGHT'
          'BS_TEXT'
          'BS_TOP'
          'BS_VCENTER')
        TabOrder = 0
      end
    end
    object TB_COMBOBOX: TTabSheet
      Caption = 'COMBOBOX'
      ImageIndex = 1
      object Check_ComboBox: TCheckListBox
        Left = 8
        Top = 16
        Width = 545
        Height = 201
        Columns = 2
        ItemHeight = 13
        Items.Strings = (
          'CBS_AUTOHSCROLL'
          'CBS_DISABLENOSCROLL'
          'CBS_DROPDOWN'
          'CBS_DROPDOWNLIST'
          'CBS_HASSTRINGS'
          'CBS_LOWERCASE'
          'CBS_NOINTEGRALHEIGHT'
          'CBS_OEMCONVERT'
          'CBS_OWNERDRAWFIXED'
          'CBS_OWNERDRAWVARIABLE'
          'CBS_SIMPLE'
          'CBS_SORT'
          'CBS_UPPERCASE')
        TabOrder = 0
      end
    end
    object TB_EDIT: TTabSheet
      Caption = 'EDIT'
      ImageIndex = 2
      object Check_Edit: TCheckListBox
        Left = 8
        Top = 8
        Width = 545
        Height = 201
        ItemHeight = 13
        Items.Strings = (
          'ES_AUTOHSCROLL'
          'ES_AUTOVSCROLL'
          'ES_CENTER'
          'ES_LEFT'
          'ES_LOWERCASE'
          'ES_MULTILINE'
          'ES_NOHIDESEL'
          'ES_NUMBER'
          'ES_OEMCONVERT'
          'ES_PASSWORD'
          'ES_READONLY'
          'ES_RIGHT'
          'ES_UPPERCASE'
          'ES_WANTRETURN')
        TabOrder = 0
      end
    end
    object TB_LISTBOX: TTabSheet
      Caption = 'LISTBOX'
      ImageIndex = 3
      object Check_ListBox: TCheckListBox
        Left = 8
        Top = 8
        Width = 545
        Height = 201
        Columns = 2
        ItemHeight = 13
        Items.Strings = (
          'LBS_DISABLENOSCROLL'
          'LBS_EXTENDEDSEL'
          'LBS_HASSTRINGS'
          'LBS_MULTICOLUMN'
          'LBS_MULTIPLESEL'
          'LBS_NODATA'
          'LBS_NOINTEGRALHEIGHT'
          'LBS_NOREDRAW'
          'LBS_NOSEL'
          'LBS_NOTIFY'
          'LBS_OWNERDRAWFIXED'
          'LBS_OWNERDRAWVARIABLE'
          'LBS_SORT'
          'LBS_STANDARD'
          'LBS_USETABSTOPS'
          'LBS_WANTKEYBOARDINPUT')
        TabOrder = 0
      end
    end
    object TB_MDICLIENT: TTabSheet
      Caption = 'MDICLIENT'
      ImageIndex = 4
      object Check_MDIClient: TCheckListBox
        Left = 8
        Top = 8
        Width = 545
        Height = 201
        Columns = 2
        ItemHeight = 13
        Items.Strings = (
          'MDIS_ALLCHILDSTYLES')
        TabOrder = 0
      end
    end
    object TB_SCROLLBAR: TTabSheet
      Caption = 'SCROLLBAR'
      ImageIndex = 5
      object Check_ScrollBar: TCheckListBox
        Left = 8
        Top = 8
        Width = 545
        Height = 201
        Columns = 2
        ItemHeight = 13
        Items.Strings = (
          'SBS_BOTTOMALIGN'
          'SBS_HORZ'
          'SBS_LEFTALIGN'
          'SBS_RIGHTALIGN'
          'SBS_SIZEBOX'
          'SBS_SIZEBOXBOTTOMRIGHTALIGN'
          'SBS_SIZEBOXTOPLEFTALIGN'
          'SBS_SIZEGRIP'
          'SBS_TOPALIGN'
          'SBS_VERT')
        TabOrder = 0
      end
    end
    object TB_STATIC: TTabSheet
      Caption = 'STATIC'
      ImageIndex = 6
      object Check_Static: TCheckListBox
        Left = 8
        Top = 8
        Width = 545
        Height = 201
        Columns = 2
        ItemHeight = 13
        Items.Strings = (
          'SS_LEFT'
          'SS_CENTER'
          'SS_RIGHT'
          'SS_ICON'
          'SS_BLACKRECT'
          'SS_GRAYRECT'
          'SS_WHITERECT'
          'SS_BLACKFRAME'
          'SS_GRAYFRAME'
          'SS_WHITEFRAME'
          'SS_USERITEM'
          'SS_SIMPLE'
          'SS_LEFTNOWORDWRAP'
          'SS_BITMAP'
          'SS_OWNERDRAW'
          'SS_ENHMETAFILE'
          'SS_ETCHEDHORZ'
          'SS_ETCHEDVERT'
          'SS_ETCHEDFRAME'
          'SS_TYPEMASK'
          'SS_NOPREFIX'
          'SS_NOTIFY'
          'SS_CENTERIMAGE'
          'SS_RIGHTJUST'
          'SS_REALSIZEIMAGE'
          'SS_SUNKEN'
          'SS_ENDELLIPSIS'
          'SS_PATHELLIPSIS'
          'SS_WORDELLIPSIS'
          'SS_ELLIPSISMASK'
          'SS_RIGHT'
          'SS_RIGHTIMAGE'
          'SS_SIMPLE'
          'SS_WHITEFRAME'
          'SS_WHITERECT')
        TabOrder = 0
      end
    end
  end
  object Button1: TButton
    Left = 392
    Top = 104
    Width = 185
    Height = 25
    Caption = 'Kill'
    TabOrder = 5
    OnClick = Button1Click
  end
  object PopupMenu1: TPopupMenu
    Left = 216
    Top = 232
    object DesmarcarTudo1: TMenuItem
      Caption = 'Desmarcar Tudo'
    end
    object Padro1: TMenuItem
      Caption = 'Padrão'
      OnClick = Padro1Click
    end
    object Fechar1: TMenuItem
      Caption = 'Fechar'
    end
  end
end
