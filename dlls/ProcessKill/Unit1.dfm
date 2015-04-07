object Form1: TForm1
  Left = 283
  Top = 127
  Width = 620
  Height = 405
  Caption = 'Process Killer'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  DesignSize = (
    612
    378)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 591
    Height = 33
    Alignment = taCenter
    Anchors = [akLeft, akTop, akRight, akBottom]
    AutoSize = False
    Caption = 'Process Killer'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlue
    Font.Height = -27
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    Layout = tlCenter
  end
  object Label2: TLabel
    Left = 8
    Top = 8
    Width = 51
    Height = 13
    Caption = 'Vers'#227'o 1.2'
  end
  object Label3: TLabel
    Left = 8
    Top = 24
    Width = 99
    Height = 13
    Hint = 'Autor do sistema'
    Caption = 'Autor : Richard Natal'
  end
  object Label4: TLabel
    Left = 555
    Top = 8
    Width = 47
    Height = 13
    Alignment = taRightJustify
    Anchors = [akTop, akRight, akBottom]
    Caption = 'Criado em'
  end
  object Label5: TLabel
    Left = 544
    Top = 24
    Width = 58
    Height = 13
    Alignment = taRightJustify
    Anchors = [akTop, akRight]
    Caption = '09/04/2000'
  end
  object StringGrid1: TStringGrid
    Left = 8
    Top = 48
    Width = 595
    Height = 289
    Hint = 'Lista de processos'
    Anchors = [akLeft, akTop, akRight, akBottom]
    ColCount = 3
    DefaultRowHeight = 20
    FixedCols = 0
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect]
    TabOrder = 0
    ColWidths = (
      59
      49
      602)
  end
  object Panel1: TPanel
    Left = 0
    Top = 340
    Width = 612
    Height = 38
    Align = alBottom
    TabOrder = 1
    object BitBtn1: TBitBtn
      Left = 520
      Top = 9
      Width = 81
      Height = 25
      Hint = 'Sai do sistema'
      Caption = '&Sair'
      TabOrder = 0
      OnClick = BitBtn1Click
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00330000000000
        03333377777777777F333301BBBBBBBB033333773F3333337F3333011BBBBBBB
        0333337F73F333337F33330111BBBBBB0333337F373F33337F333301110BBBBB
        0333337F337F33337F333301110BBBBB0333337F337F33337F333301110BBBBB
        0333337F337F33337F333301110BBBBB0333337F337F33337F333301110BBBBB
        0333337F337F33337F333301110BBBBB0333337F337FF3337F33330111B0BBBB
        0333337F337733337F333301110BBBBB0333337F337F33337F333301110BBBBB
        0333337F3F7F33337F333301E10BBBBB0333337F7F7F33337F333301EE0BBBBB
        0333337F777FFFFF7F3333000000000003333377777777777333}
      NumGlyphs = 2
    end
    object BitBtn2: TBitBtn
      Left = 432
      Top = 9
      Width = 81
      Height = 25
      Hint = 'Finaliza o processo selecionado'
      Caption = '&Finalizar'
      TabOrder = 1
      OnClick = BitBtn2Click
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00370777033333
        3330337F3F7F33333F3787070003333707303F737773333373F7007703333330
        700077337F3333373777887007333337007733F773F333337733700070333333
        077037773733333F7F37703707333300080737F373333377737F003333333307
        78087733FFF3337FFF7F33300033330008073F3777F33F777F73073070370733
        078073F7F7FF73F37FF7700070007037007837773777F73377FF007777700730
        70007733FFF77F37377707700077033707307F37773F7FFF7337080777070003
        3330737F3F7F777F333778080707770333333F7F737F3F7F3333080787070003
        33337F73FF737773333307800077033333337337773373333333}
      NumGlyphs = 2
    end
    object BitBtn3: TBitBtn
      Left = 344
      Top = 9
      Width = 81
      Height = 25
      Hint = 'Atualiza a lista de processos'
      Caption = '&Atualizar'
      TabOrder = 2
      OnClick = BitBtn3Click
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555555555555
        555555555555555555555555555555555555555555FF55555555555559055555
        55555555577FF5555555555599905555555555557777F5555555555599905555
        555555557777FF5555555559999905555555555777777F555555559999990555
        5555557777777FF5555557990599905555555777757777F55555790555599055
        55557775555777FF5555555555599905555555555557777F5555555555559905
        555555555555777FF5555555555559905555555555555777FF55555555555579
        05555555555555777FF5555555555557905555555555555777FF555555555555
        5990555555555555577755555555555555555555555555555555}
      NumGlyphs = 2
    end
    object RadioGroup1: TRadioGroup
      Left = 8
      Top = 1
      Width = 321
      Height = 33
      Hint = 'Configura a atualiza'#231#227'o autom'#225'tica'
      Caption = ' Atualiza'#231#227'o autom'#225'tica '
      Columns = 2
      ItemIndex = 1
      Items.Strings = (
        'N'#227'o'
        'A cada 5 segundos')
      TabOrder = 3
      OnClick = RadioGroup1Click
    end
  end
  object Timer1: TTimer
    Interval = 5000
    OnTimer = Timer1Timer
    Left = 16
    Top = 288
  end
end
