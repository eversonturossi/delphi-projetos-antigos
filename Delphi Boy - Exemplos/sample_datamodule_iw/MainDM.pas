unit MainDM;

interface

uses
  {$IFDEF Linux}QForms, {$ELSE}Forms, {$ENDIF}
  SysUtils, Classes, DBXpress, FMTBcd, DB, DBClient, SimpleDS, SqlExpr,
  Provider;

type
  TDMMain = class(TDataModule)
    SQLConnection: TSQLConnection;
    SQLDataSet: TSQLDataSet;
    dsCustomer: TDataSource;
    dspCustomer: TDataSetProvider;
    cdsCustomer: TClientDataSet;
  private
  public
  end;

  function DataModule1: TDMMain;

implementation

uses UserSession, IWInit;

{$R *.dfm}

function DataModule1: TDMMain;
begin
  Result := TIWUserSession(WebApplication.Data).DMMain;
end;

end.
