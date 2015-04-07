object Form1: TForm1
  Left = 192
  Top = 107
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'HTML Gen 1.0'
  ClientHeight = 373
  ClientWidth = 536
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 16
    Width = 100
    Height = 13
    Caption = 'Diretório de arquivos:'
  end
  object Label2: TLabel
    Left = 8
    Top = 40
    Width = 105
    Height = 13
    Caption = 'Template Anterior:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 8
    Top = 152
    Width = 109
    Height = 13
    Caption = 'Template de Links:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label4: TLabel
    Left = 8
    Top = 240
    Width = 111
    Height = 13
    Caption = 'Template Posterior:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label5: TLabel
    Left = 128
    Top = 152
    Width = 58
    Height = 13
    Caption = '$PATHARQ'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label6: TLabel
    Left = 187
    Top = 152
    Width = 47
    Height = 13
    Caption = '=Caminho'
  end
  object Label7: TLabel
    Left = 128
    Top = 168
    Width = 60
    Height = 13
    Caption = '$TAMANHO'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label8: TLabel
    Left = 188
    Top = 168
    Width = 51
    Height = 13
    Caption = '=Tamanho'
  end
  object Label9: TLabel
    Left = 248
    Top = 152
    Width = 61
    Height = 13
    Caption = '$NOMEARQ'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label10: TLabel
    Left = 310
    Top = 152
    Width = 34
    Height = 13
    Caption = '=Nome'
  end
  object Label11: TLabel
    Left = 248
    Top = 168
    Width = 58
    Height = 13
    Caption = '$DATAARQ'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label12: TLabel
    Left = 306
    Top = 168
    Width = 29
    Height = 13
    Caption = '=Data'
  end
  object Label13: TLabel
    Left = 408
    Top = 336
    Width = 87
    Height = 13
    Caption = 'Glauber A. Dantas'
  end
  object Label14: TLabel
    Left = 408
    Top = 352
    Width = 114
    Height = 13
    Cursor = crHandPoint
    Hint = 'www.delphix.com.br'
    Caption = 'www.delphix.com.br'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    OnClick = Label14Click
  end
  object Label15: TLabel
    Left = 416
    Top = 232
    Width = 28
    Height = 13
    Caption = 'Links:'
  end
  object Label16: TLabel
    Left = 448
    Top = 232
    Width = 8
    Height = 13
    Caption = '0'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Edit1: TEdit
    Left = 112
    Top = 8
    Width = 257
    Height = 21
    TabOrder = 0
  end
  object Button1: TButton
    Left = 369
    Top = 7
    Width = 22
    Height = 23
    Caption = '...'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Memo1: TMemo
    Left = 8
    Top = 56
    Width = 385
    Height = 89
    Lines.Strings = (
      '<html>'
      ''
      '<head>'
      '<meta http-equiv="Content-Type" content="text/html; '
      'charset=windows-1252">'
      '<meta name="GENERATOR" content="Microsoft FrontPage 4.0">'
      '<meta name="ProgId" content="FrontPage.Editor.Document">'
      '<title>New Page 3</title>'
      '<link rel=stylesheet href=menu.css>'
      '</head>'
      ''
      '<body>'
      ''
      
        '<p align="center"><img border="0" src="ex/exgp3.png" width="616"' +
        ' '
      'height="156"></p>'
      '<table border="0" width="663" cellspacing="1" cellpadding="0" '
      'bgcolor="#000000">'
      '  <tr>'
      '    <td bgcolor="#0000FF" width="341">'
      '      <p align="center"><b><font face="Verdana" size="1" '
      'color="#C8C8C8">.: </font><font face="Verdana" size="1" '
      'color="#C8C8C8">Nome'
      '      :.</font></b></p>'
      '    </td>'
      '    <td bgcolor="#0000FF" width="173">'
      '      <p align="center"><b><font face="Verdana" size="1" '
      'color="#C8C8C8">.:'
      '      Tamanho :.</font></b>'
      '    </td>'
      '    <td bgcolor="#0000FF" width="135">'
      '      <p align="center"><b><font face="Verdana" size="1" '
      'color="#C8C8C8">.: Data</font><font face="Verdana" size="1" '
      'color="#C8C8C8">'
      '      :.</font></b>'
      '    </td>'
      '  </tr>')
    ScrollBars = ssVertical
    TabOrder = 2
  end
  object Memo2: TMemo
    Left = 8
    Top = 184
    Width = 385
    Height = 49
    Lines.Strings = (
      '  <tr>'
      '    <td bgcolor="#FFFFFF" width="341">'
      
        '      <font face="Verdana" size="1"><img border="0" src="ex/bs.g' +
        'if" '
      'align="middle" width="16" height="16">'
      '      <a href="$PATHARQ">$NOMEARQ</font>'
      '    </td>'
      '    <td bgcolor="#FFFFFF" width="173">'
      '      <font face="Verdana" size="1">$TAMANHO</font>'
      '    </td>'
      '    <td bgcolor="#FFFFFF" width="135">'
      '      <font face="Verdana" size="1">$DATAARQ</font>'
      '    </td>'
      '  </tr>')
    ScrollBars = ssVertical
    TabOrder = 3
  end
  object Memo3: TMemo
    Left = 8
    Top = 256
    Width = 385
    Height = 113
    Lines.Strings = (
      '</table>'
      '<hr color="#C8C8C8">'
      
        '<p align="center"><font size="1" face="Verdana" color="#000000">' +
        'bogus '
      'Page -'
      'Texto por _bogus_.<br>'
      '©Copyright 2003 - Todos os Direitos Reservados.</font></p>'
      ''
      '</body>'
      ''
      '</html>')
    ScrollBars = ssVertical
    TabOrder = 4
  end
  object ListBox1: TListBox
    Left = 400
    Top = 8
    Width = 129
    Height = 209
    ItemHeight = 13
    TabOrder = 5
  end
  object Button2: TButton
    Left = 424
    Top = 264
    Width = 75
    Height = 25
    Caption = 'Gerar HTML'
    TabOrder = 6
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 424
    Top = 288
    Width = 75
    Height = 25
    Caption = 'Sair'
    TabOrder = 7
    OnClick = Button3Click
  end
end
