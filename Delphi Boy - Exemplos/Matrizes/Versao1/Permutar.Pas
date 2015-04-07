unit Permutar;

interface

uses
  Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, ComCtrls;

type
  TFormPermutar= class (TForm)
    Origem       : TUpDown;
    Destino      : TUpDown;
    Edit1        : TEdit;
    Edit2        : TEdit;
    BotaoOK      : TButton;
    BotaoCancelar: TButton;
    Bevel1       : TBevel;
    Label1       : TLabel;
    Label2       : TLabel;
  end;

var
  FormPermutar: TFormPermutar;

implementation

{$R *.DFM}

end.

// Final do Arquivo
