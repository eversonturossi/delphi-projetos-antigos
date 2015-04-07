unit UserSession;

{
  This is a DataModule where you can add components or declare fields that are specific to
  ONE user. Instead of creating global variables, it is better to use this datamodule. You can then
  access the it using UserSession.
}
interface

uses
  IWUserSessionBase, SysUtils, Classes, MainDM;

type
  TIWUserSession = class(TIWUserSessionBase)
  private
    { Private declarations }
  public
    DMMain: TDMMain;
    constructor Create(AOwner: TComponent); override;  
    { Public declarations }
  end;

implementation

{$R *.dfm}

{ TIWUserSession }

constructor TIWUserSession.Create(AOwner: TComponent);
begin
  inherited;
  DMMain := TDMMain.Create(AOwner);
end;

end.