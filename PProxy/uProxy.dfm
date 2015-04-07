object Form1: TForm1
  Left = 322
  Top = 165
  Width = 775
  Height = 500
  Caption = 'Form1'
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
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 767
    Height = 473
    ActivePage = TabSheet4
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Navegador'
      object PanelNavegadores: TPanel
        Left = 0
        Top = 57
        Width = 759
        Height = 347
        Align = alClient
        BevelOuter = bvNone
        Color = 900351
        TabOrder = 0
      end
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 759
        Height = 57
        Align = alTop
        BevelOuter = bvNone
        Color = clSilver
        TabOrder = 1
        object Button1: TButton
          Left = 24
          Top = 16
          Width = 113
          Height = 25
          Caption = 'Criar Componentes'
          TabOrder = 0
          OnClick = Button1Click
        end
        object Button2: TButton
          Left = 144
          Top = 16
          Width = 129
          Height = 25
          Caption = 'Destruir Componentes'
          TabOrder = 1
          OnClick = Button2Click
        end
        object Button3: TButton
          Left = 280
          Top = 16
          Width = 75
          Height = 25
          Caption = 'Delete Cache'
          TabOrder = 2
          OnClick = Button3Click
        end
        object Button4: TButton
          Left = 360
          Top = 16
          Width = 75
          Height = 25
          Caption = 'Conta IE'
          TabOrder = 3
          OnClick = Button4Click
        end
      end
      object Panel2: TPanel
        Left = 0
        Top = 404
        Width = 759
        Height = 41
        Align = alBottom
        BevelOuter = bvNone
        Color = 8886432
        TabOrder = 2
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Proxy'
      ImageIndex = 1
      object Splitter1: TSplitter
        Left = 0
        Top = 89
        Width = 759
        Height = 4
        Cursor = crVSplit
        Align = alTop
      end
      object Proxys: TListBox
        Left = 0
        Top = 129
        Width = 759
        Height = 316
        Align = alClient
        ItemHeight = 13
        TabOrder = 0
      end
      object addProxy: TMemo
        Left = 0
        Top = 0
        Width = 759
        Height = 89
        Align = alTop
        ScrollBars = ssVertical
        TabOrder = 1
      end
      object Panel3: TPanel
        Left = 0
        Top = 93
        Width = 759
        Height = 36
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 2
        object btnAddProxy: TButton
          Left = 1
          Top = 4
          Width = 107
          Height = 26
          Caption = 'Adicionar'
          TabOrder = 0
          OnClick = btnAddProxyClick
        end
        object btnRemoverProxy: TButton
          Left = 113
          Top = 4
          Width = 107
          Height = 26
          Caption = 'Remover'
          TabOrder = 1
          OnClick = btnRemoverProxyClick
        end
        object btmRemoverTodos: TButton
          Left = 225
          Top = 4
          Width = 107
          Height = 26
          Caption = 'Remover Todos'
          TabOrder = 2
          OnClick = btmRemoverTodosClick
        end
      end
    end
    object TabSheet4: TTabSheet
      Caption = 'Downloads'
      ImageIndex = 3
      object GroupBox1: TGroupBox
        Left = 0
        Top = 0
        Width = 759
        Height = 49
        Align = alTop
        Caption = 'Gerenciar grupos'
        Ctl3D = True
        ParentCtl3D = False
        TabOrder = 0
        object edtGrupo: TEdit
          Left = 8
          Top = 19
          Width = 177
          Height = 23
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Fixedsys'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
        end
        object btnAdicionarGrupo: TButton
          Left = 191
          Top = 16
          Width = 97
          Height = 25
          Caption = 'Adicionar Grupo'
          TabOrder = 1
          OnClick = btnAdicionarGrupoClick
        end
        object btnRemoverGrupoSelecionado: TButton
          Left = 295
          Top = 16
          Width = 161
          Height = 25
          Caption = 'Remover Grupo Selecionado'
          TabOrder = 2
          OnClick = btnRemoverGrupoSelecionadoClick
        end
      end
      object GroupBox2: TGroupBox
        Left = 0
        Top = 49
        Width = 185
        Height = 362
        Align = alLeft
        Caption = 'Grupos'
        Ctl3D = True
        ParentCtl3D = False
        TabOrder = 1
        object Panel4: TPanel
          Left = 2
          Top = 15
          Width = 181
          Height = 345
          Align = alClient
          BevelOuter = bvNone
          BorderWidth = 2
          TabOrder = 0
          object GruposDownloadListBox: TListBox
            Left = 2
            Top = 2
            Width = 177
            Height = 341
            Align = alClient
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Fixedsys'
            Font.Style = []
            ItemHeight = 15
            ParentFont = False
            TabOrder = 0
            OnClick = GruposDownloadListBoxClick
          end
        end
      end
      object GroupBox3: TGroupBox
        Left = 191
        Top = 49
        Width = 568
        Height = 362
        Align = alClient
        Caption = 'Links para download do grupo selecionado'
        Ctl3D = True
        ParentCtl3D = False
        TabOrder = 2
        object Panel5: TPanel
          Left = 2
          Top = 15
          Width = 564
          Height = 345
          Align = alClient
          BevelOuter = bvNone
          BorderWidth = 2
          TabOrder = 0
          object LinksDownloadMemo: TMemo
            Left = 2
            Top = 2
            Width = 560
            Height = 341
            Align = alClient
            Enabled = False
            ScrollBars = ssBoth
            TabOrder = 0
          end
        end
      end
      object Panel8: TPanel
        Left = 185
        Top = 49
        Width = 6
        Height = 362
        Align = alLeft
        BevelOuter = bvNone
        TabOrder = 3
      end
      object Panel7: TPanel
        Left = 0
        Top = 441
        Width = 759
        Height = 4
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 4
      end
      object Panel6: TPanel
        Left = 0
        Top = 411
        Width = 759
        Height = 30
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 5
        object btnSalvarLinksDownloadMemo: TButton
          Left = 193
          Top = 4
          Width = 352
          Height = 25
          Caption = 'Salvar Links no Grupo'
          Enabled = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clMaroon
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
          OnClick = btnSalvarLinksDownloadMemoClick
        end
      end
    end
  end
end
