object DMMain: TDMMain
  OldCreateOrder = False
  Left = 352
  Top = 203
  Height = 253
  Width = 357
  object SQLConnection: TSQLConnection
    ConnectionName = 'IBConnection'
    DriverName = 'Interbase'
    GetDriverFunc = 'getSQLDriverINTERBASE'
    LibraryName = 'dbexpint.dll'
    LoginPrompt = False
    Params.Strings = (
      'DriverName=Interbase'
      'Database=C:\Delphi 7\Borland Shared\Data\EMPLOYEE.GDB'
      'RoleName=RoleName'
      'User_Name=SYSDBA'
      'Password=masterkey'
      'ServerCharSet='
      'SQLDialect=3'
      'ErrorResourceFile='
      'LocaleCode=0000'
      'BlobSize=-1'
      'CommitRetain=False'
      'WaitOnLocks=True'
      'Interbase TransIsolation=ReadCommited'
      'Trim Char=False')
    VendorLib = 'gds32.dll'
    Connected = True
    Left = 43
    Top = 24
  end
  object SQLDataSet: TSQLDataSet
    CommandText = 'select * from Customer'
    MaxBlobSize = -1
    Params = <>
    SQLConnection = SQLConnection
    Left = 46
    Top = 69
  end
  object dsCustomer: TDataSource
    AutoEdit = False
    DataSet = cdsCustomer
    Left = 124
    Top = 74
  end
  object dspCustomer: TDataSetProvider
    DataSet = SQLDataSet
    Left = 48
    Top = 119
  end
  object cdsCustomer: TClientDataSet
    Active = True
    Aggregates = <>
    Params = <>
    ProviderName = 'dspCustomer'
    Left = 122
    Top = 26
  end
end
