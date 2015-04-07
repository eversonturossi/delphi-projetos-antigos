unit MainFrm;

interface

uses
  Classes, SysUtils, IWAppForm, IWApplication, IWColor, IWTypes, Controls,
  IWVCLBaseControl, IWBaseControl, IWBaseHTMLControl, IWControl, IWGrids,
  IWDBGrids, IWDBStdCtrls, IWCompEdit, IWCompLabel;

type
  TIWForm2 = class(TIWAppForm)
    IWDBGrid1: TIWDBGrid;
    IWDBNavigator1: TIWDBNavigator;
    IWDBEdit1: TIWDBEdit;
    IWDBEdit2: TIWDBEdit;
    IWDBEdit3: TIWDBEdit;
    IWDBEdit4: TIWDBEdit;
    IWLabel1: TIWLabel;
    IWLabel2: TIWLabel;
    IWLabel3: TIWLabel;
    IWLabel4: TIWLabel;
  public
  end;

implementation

uses MainDM;

{$R *.dfm}


initialization
  TIWForm2.SetAsMainForm;

end.
