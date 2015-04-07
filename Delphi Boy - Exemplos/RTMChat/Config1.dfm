object Config2: TConfig2
  Left = 192
  Top = 103
  Width = 289
  Height = 316
  BorderIcons = [biSystemMenu]
  Caption = 'Configura'#231#245'es do RTMChat 1.0'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 281
    Height = 289
    ActivePage = TabSheet2
    TabIndex = 1
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Pessoal'
      object Label1: TLabel
        Left = 32
        Top = 88
        Width = 25
        Height = 13
        Caption = 'Nick:'
      end
      object nick: TEdit
        Left = 64
        Top = 80
        Width = 137
        Height = 21
        TabOrder = 0
        Text = 'Guest'
      end
      object BitBtn2: TBitBtn
        Left = 184
        Top = 168
        Width = 75
        Height = 25
        Caption = '&Ok'
        TabOrder = 1
        OnClick = BitBtn2Click
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
    end
    object TabSheet2: TTabSheet
      Caption = 'Conex'#227'o'
      ImageIndex = 2
      object Label8: TLabel
        Left = 29
        Top = 72
        Width = 28
        Height = 13
        Caption = 'Porta:'
      end
      object Label9: TLabel
        Left = 1
        Top = 112
        Width = 55
        Height = 13
        Caption = 'Conectar '#224':'
      end
      object porta: TEdit
        Left = 64
        Top = 64
        Width = 137
        Height = 21
        TabOrder = 0
        Text = '666'
      end
      object ende: TEdit
        Left = 64
        Top = 104
        Width = 137
        Height = 21
        TabOrder = 1
      end
      object Conex: TBitBtn
        Left = 176
        Top = 168
        Width = 75
        Height = 25
        Caption = '&Conectar'
        TabOrder = 2
        OnClick = ConexClick
        Glyph.Data = {
          9E020000424D9E0200000000000036000000280000000E0000000E0000000100
          18000000000068020000C40E0000C40E00000000000000000000BFBFBFBFBFBF
          BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
          BF0060800000BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
          BFBFBFBFBFBFBFBFBFBF0060800060800000BFBFBFBFBFBFBFBFBFBFBFBFBFBF
          BF002F3FBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF00608000CFFF0060800000BFBF
          BFBFBFBFBFBFBFBFBFBF002F3F00A8DF002F3FBFBFBFBFBFBFBFBFBF00608000
          A8DF006080BFBFBF0000BFBFBFBFBFBFBFBFBFBFBFBF002F3F00A8DF00A8DF00
          2F3FBFBFBF00608000A8DF00CFFF006080BFBFBF0000BFBFBFBFBFBFBFBFBF00
          2F3F00A8DF00CFFF00A8DF00A8DF002F3F00789F00CFFF006080BFBFBFBFBFBF
          0000BFBFBFBFBFBFBFBFBF002F3F00A8DF00CFFF00CFFF00A8DF00789F00CFFF
          00A8DF006080BFBFBFBFBFBF0000BFBFBFBFBFBF002F3F00A8DF00CFFF2FEFFF
          2FEFFF00CFFF00A8DF00CFFF006080BFBFBFBFBFBFBFBFBF0000BFBFBFBFBFBF
          002F3F00A8DF00A8DF0060809FFFFF2FEFFF00CFFF00A8DF006080BFBFBFBFBF
          BFBFBFBF0000BFBFBF002F3F00A8DF00CFFF006080BFBFBF0060809FFFFF2FEF
          FF006080BFBFBFBFBFBFBFBFBFBFBFBF0000BFBFBF002F3F00CFFF006080BFBF
          BFBFBFBFBFBFBF0060809FFFFF006080BFBFBFBFBFBFBFBFBFBFBFBF0000002F
          3F2FEFFF006080BFBFBFBFBFBFBFBFBFBFBFBFBFBFBF006080BFBFBFBFBFBFBF
          BFBFBFBFBFBFBFBF0000002F3F002F3FBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
          BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF0000002F3FBFBFBFBFBFBFBF
          BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
          0000}
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'RTMChat'
      ImageIndex = 2
      object Label4: TLabel
        Left = 0
        Top = 0
        Width = 130
        Height = 13
        Caption = 'Cor do campo de digita'#231#227'o:'
      end
      object Label5: TLabel
        Left = 136
        Top = 0
        Width = 131
        Height = 13
        Caption = 'Cor do campo de conversa:'
      end
      object Label6: TLabel
        Left = 0
        Top = 88
        Width = 168
        Height = 13
        Caption = 'Cor da letra do campo de digita'#231#227'o:'
      end
      object Label7: TLabel
        Left = 0
        Top = 168
        Width = 169
        Height = 13
        Caption = 'Cor da letra do campo de conversa:'
      end
      object BitBtn1: TBitBtn
        Left = 192
        Top = 232
        Width = 75
        Height = 25
        Caption = '&Ok'
        TabOrder = 0
        OnClick = BitBtn1Click
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
      object Panel1: TPanel
        Left = 72
        Top = 34
        Width = 17
        Height = 17
        Color = clBlack
        TabOrder = 1
      end
      object Panel2: TPanel
        Left = 224
        Top = 34
        Width = 17
        Height = 17
        Color = clWhite
        TabOrder = 2
      end
      object Panel3: TPanel
        Left = 72
        Top = 122
        Width = 17
        Height = 17
        Color = clYellow
        TabOrder = 3
      end
      object Panel4: TPanel
        Left = 72
        Top = 210
        Width = 17
        Height = 17
        Color = clBlack
        TabOrder = 4
      end
      object ColorGrid1: TColorGrid
        Left = 0
        Top = 16
        Width = 64
        Height = 64
        TabOrder = 5
        OnChange = ColorGrid1Change
      end
      object ColorGrid2: TColorGrid
        Left = 136
        Top = 16
        Width = 64
        Height = 64
        ForegroundIndex = 15
        TabOrder = 6
        OnChange = ColorGrid2Change
      end
      object ColorGrid3: TColorGrid
        Left = 0
        Top = 104
        Width = 64
        Height = 64
        ForegroundIndex = 11
        TabOrder = 7
        OnChange = ColorGrid3Change
      end
      object ColorGrid4: TColorGrid
        Left = 0
        Top = 184
        Width = 64
        Height = 64
        ForegroundIndex = 1
        TabOrder = 8
        OnChange = ColorGrid4Change
      end
    end
  end
end
