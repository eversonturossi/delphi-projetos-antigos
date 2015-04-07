unit frmPrincipal;

interface

uses
 Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
 Dialogs, StdCtrls, ExtCtrls, Comobj;

type
 TForm1 = class(TForm)
  Edit1: TEdit;
  Label1: TLabel;
  Button1: TButton;
  Timer1: TTimer;
  Label2: TLabel;
  Edit2: TEdit;
  Button2: TButton;
  Button3: TButton;
  Button4: TButton;
  Timer2: TTimer;
  procedure Start;
  procedure Timer1Timer(Sender: TObject);
  procedure AbreNavegador;
  procedure Button2Click(Sender: TObject);
  procedure Button3Click(Sender: TObject);
  procedure Button1Click(Sender: TObject);
  procedure FechaIE;
  procedure Button4Click(Sender: TObject);
  procedure Timer2Timer(Sender: TObject);
 private
  { Private declarations }
 public
  { Public declarations }
 end;
 
var
 Form1: TForm1;
 IEApp: Variant;
 ContaVotos: integer;
implementation

{$R *.dfm}

procedure TForm1.Start;
begin
 if Button1.Caption = 'Start' then
  begin
   Timer1.Interval := 1000 * StrToInt(Edit2.Text);
   Timer1.Enabled := true;
   Button1.Caption := 'Stop';
  end
 else
  begin
   Timer1.Enabled := false;
   Button1.Caption := 'Start';
  end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
 if ContaVotos <= 30 then
  begin
   IEApp.stop;
   IEApp.Refresh;
   IEApp.StatusText := 'Votando no b0zo: voto nr ' + IntToStr(ContaVotos);
   Edit1.Text := IntToStr(ContaVotos);
   ContaVotos := ContaVotos + 1;
  end
 else
  begin
   FechaIE;
  end;
end;

procedure TForm1.AbreNavegador;
begin
 IEApp := CreateOLEObject('InternetExplorer.Application');
 IEApp.visible := true;
 IEApp.Top := 0;
 IEApp.Left := 0;
 IEApp.Navigate('http://www.gentefeia.com.br/rating.php?pid=121&rate=1');
 Button1.Enabled := true;
 ContaVotos := 1;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
 Timer1.Interval := 1000 * StrToInt(Edit2.Text);
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
 AbreNavegador;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
 start;
end;

procedure TForm1.FechaIE;
begin
 Timer1.Enabled := false;
 IEApp.quit;
 Sleep(20000);
 AbreNavegador;
 Sleep(20000);
 Timer2.Enabled := true;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
 FechaIE;
end;

procedure TForm1.Timer2Timer(Sender: TObject);
begin
 Timer1.Enabled := true;
 Timer2.Enabled := false;
end;

end.

