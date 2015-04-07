object IWServerController: TIWServerController
  OldCreateOrder = False
  OnCreate = IWServerControllerBaseCreate
  AuthBeforeNewSession = False
  AllowSubFolders = False
  AppName = 'MyApp'
  CacheExpiry = 2
  ComInitialization = ciNone
  Compression.Enabled = False
  Compression.Level = 6
  Description = 'My IntraWeb Application'
  EnableImageToolbar = False
  ExceptionDisplayMode = smAlert
  ExecCmd = 'EXEC'
  HistoryEnabled = False
  InternalFilesURL = '/'
  Browser32Behaviour.Netscape4As32 = True
  Browser32Behaviour.Netscape6As32 = True
  Browser32Behaviour.IExplorer4As32 = True
  Port = 8888
  ReEntryOptions.AutoCreateSession = False
  RestrictIPs = True
  ServerResizeTimeout = 0
  SessionTrackingMethod = tmURL
  ShowResyncWarning = True
  SessionTimeout = 10
  SupportedBrowsers = [brIE, brOpera, brNetscape6]
  SSLOptions.NonSSLRequest = nsAccept
  SSLOptions.Port = 0
  ThreadPoolSize = 32
  UnknownBrowserAction = ubReject
  Version = '7.0.11'
  OnNewSession = IWServerControllerBaseNewSession
  Left = 367
  Top = 314
  Height = 310
  Width = 342
  object Pool: TIWDataModulePool
    OnCreateDataModule = PoolCreateDataModule
    OnFreeDataModule = PoolFreeDataModule
    PoolCount = 20
    Active = False
    Version = '0.1.1b'
    Left = 60
    Top = 12
  end
end
