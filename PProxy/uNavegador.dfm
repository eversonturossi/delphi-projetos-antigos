object NavegadorProxy: TNavegadorProxy
  Left = 0
  Top = 0
  Width = 488
  Height = 361
  TabOrder = 0
  object EmbeddedWB1: TEmbeddedWB
    Left = 0
    Top = 20
    Width = 488
    Height = 328
    Align = alClient
    TabOrder = 0
    OnStatusTextChange = EmbeddedWB1StatusTextChange
    OnProgressChange = EmbeddedWB1ProgressChange
    OnDownloadBegin = EmbeddedWB1DownloadBegin
    OnBeforeNavigate2 = EmbeddedWB1BeforeNavigate2
    OnDocumentComplete = EmbeddedWB1DocumentComplete
    DownloadOptions = [DownloadImages, DownloadVideos, DownloadBGSounds]
    UserInterfaceOptions = []
    OnShowMessage = EmbeddedWB1ShowMessage
    About = ' Embedded Web Browser from: http://bsalsa.com/'
    MessagesBoxes.InternalErrMsg = False
    OnScriptError = EmbeddedWB1ScriptError
    PrintOptions.Margins.Left = 19.050000000000000000
    PrintOptions.Margins.Right = 19.050000000000000000
    PrintOptions.Margins.Top = 19.050000000000000000
    PrintOptions.Margins.Bottom = 19.050000000000000000
    PrintOptions.Header = '&w&bP'#225'gina &p de &P'
    PrintOptions.HTMLHeader.Strings = (
      '<HTML></HTML>')
    PrintOptions.Footer = '&u&b&d'
    PrintOptions.Orientation = poPortrait
    UserAgent = ' Embedded Web Browser from: http://bsalsa.com/'
    ControlData = {
      4C000000FB390000271400000000000000000000000000000000000000000000
      000000004C000000000000000000000001000000E0D057007335CF11AE690800
      2B2E126208000000000000004C0000000114020000000000C000000000000046
      8000000000000000000000000000000000000000000000000000000000000000
      00000000000000000100000000000000000000000000000000000000}
  end
  object Panel1: TPanel
    Left = 0
    Top = 348
    Width = 488
    Height = 13
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object ProgressBar1: TProgressBar
      Left = 0
      Top = 0
      Width = 488
      Height = 13
      Align = alClient
      TabOrder = 0
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 488
    Height = 20
    Align = alTop
    Alignment = taLeftJustify
    BevelOuter = bvNone
    Color = 12615680
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
  end
  object TimerDownload: TTimer
    Enabled = False
    OnTimer = TimerDownloadTimer
    Left = 8
    Top = 24
  end
  object TimerFechaLimite: TTimer
    Interval = 100
    OnTimer = TimerFechaLimiteTimer
    Left = 16
    Top = 312
  end
  object TimerFechar: TTimer
    Enabled = False
    OnTimer = TimerFecharTimer
    Left = 48
    Top = 24
  end
end
