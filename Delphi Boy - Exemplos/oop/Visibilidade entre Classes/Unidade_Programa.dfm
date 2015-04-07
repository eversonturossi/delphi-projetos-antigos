object Form1: TForm1
  Left = 194
  Top = 132
  Width = 450
  Height = 380
  Caption = 'Messagens Orientadas a Objetos : : Clube Delphi'
  Color = clMenu
  Constraints.MaxHeight = 380
  Constraints.MaxWidth = 450
  Constraints.MinHeight = 380
  Constraints.MinWidth = 450
  Ctl3D = False
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 162
    Top = 34
    Width = 98
    Height = 13
    Caption = 'Corpo da Mensagem'
  end
  object Label2: TLabel
    Left = 313
    Top = 34
    Width = 96
    Height = 13
    Caption = 'Titulo da Mensagem'
  end
  object Label3: TLabel
    Left = 186
    Top = 203
    Width = 64
    Height = 13
    Caption = 'Primeiro Valor'
  end
  object Label4: TLabel
    Left = 187
    Top = 241
    Width = 70
    Height = 13
    Caption = 'Segundo Valor'
  end
  object RadioGroupTipoIcone: TRadioGroup
    Left = 3
    Top = 45
    Width = 151
    Height = 105
    Caption = ' Selecione o Tipo de Icone '
    ItemIndex = 0
    Items.Strings = (
      'Informação'
      'Perguntar'
      'Parar'
      'Perigo')
    TabOrder = 0
  end
  object Button1: TButton
    Left = 5
    Top = 156
    Width = 101
    Height = 25
    Caption = 'Exibir Mensagem'
    TabOrder = 1
    OnClick = Button1Click
  end
  object MemoCorpoMsg: TMemo
    Left = 159
    Top = 50
    Width = 147
    Height = 100
    ScrollBars = ssBoth
    TabOrder = 2
  end
  object CheckBoxMesagem: TCheckBox
    Left = 7
    Top = 19
    Width = 72
    Height = 17
    Caption = 'Mesagem'
    TabOrder = 3
    OnClick = CheckBoxMesagemClick
  end
  object EditTituloMsg: TEdit
    Left = 312
    Top = 51
    Width = 121
    Height = 19
    TabOrder = 4
  end
  object CheckBoxOperacao: TCheckBox
    Left = 6
    Top = 191
    Width = 113
    Height = 17
    Caption = 'Tipo de Operação'
    TabOrder = 5
    OnClick = CheckBoxOperacaoClick
  end
  object RadioGroupTipoOperacao: TRadioGroup
    Left = 7
    Top = 213
    Width = 168
    Height = 105
    Caption = ' Selecione o Tipo da Operacao '
    ItemIndex = 0
    Items.Strings = (
      'Somar'
      'Subtrair'
      'Multiplicar'
      'Dividir')
    TabOrder = 6
  end
  object Calcular: TButton
    Left = 9
    Top = 324
    Width = 75
    Height = 25
    Caption = 'Calcular'
    TabOrder = 7
    OnClick = CalcularClick
  end
  object EditPrimeiroValor: TEdit
    Left = 184
    Top = 218
    Width = 121
    Height = 19
    TabOrder = 8
    OnKeyPress = EditPrimeiroValorKeyPress
  end
  object EditSegundoValor: TEdit
    Left = 186
    Top = 255
    Width = 121
    Height = 19
    TabOrder = 9
    OnKeyPress = EditPrimeiroValorKeyPress
  end
end
