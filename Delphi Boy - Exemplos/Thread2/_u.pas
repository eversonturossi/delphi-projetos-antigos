unit _u;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  extctrls, StdCtrls, Buttons, SyncObjs;

type
  TMainForm = class(TForm)
    BitBtn1: TBitBtn;
    FinishLine: TShape;
    edt_NumberOfTurtles: TEdit;
    Label2: TLabel;
    lbl_finish: TLabel;
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TTurtleThread = class (TThread)
    private
      Caption_Number : TLabel;
      Turtle : TShape;
      Progress : integer;
    protected
      Procedure Execute; override;
      Constructor Create (CreateSuspended : Boolean);
      Procedure Atualizar;
    end;

var
  MainForm: TMainForm;
  TurtleTop : integer = 30;
  CriticalSection : TCriticalSection;
  TurtleNumber : integer = 1;
  Race_Finished : boolean = false;
  CriticalFlag : boolean = false;

implementation

{$R *.DFM}

{ TTurtleThread }


procedure TTurtleThread.Atualizar;
begin
  Turtle.Left:=Progress;
  Caption_Number.left:=progress+7;
  if not Race_Finished then
   if Progress>=MainForm.FinishLine.Left then
   begin
     MainForm.Lbl_finish.Caption:='Turtle '+IntToStr(Turtle.Tag)+' win!';
     race_finished:=true;
   end;
end;

constructor TTurtleThread.Create(CreateSuspended: Boolean);
begin
   inherited;
   Progress:=0;
   Turtle:=TShape.create(MainForm);
   Turtle.parent:=MainForm;
   Turtle.Brush.Color:=clTeal;
   Turtle.Pen.Color:=clGreen;
   Turtle.Shape:=stEllipse;
   Turtle.Width:=33;
   Turtle.Height:=17;
   Turtle.top:=TurtleTop;
   inc(TurtleTop,30);
   Turtle.Tag:=TurtleNumber;
   inc(TurtleNumber);
   Caption_Number:=TLabel.create(MainForm);
   Caption_Number.parent:=MainForm;
   Caption_Number.Caption:=inttostr(Turtle.tag);
   Caption_Number.color:=clwhite;
   Caption_Number.Font.color:=clblack;
   Caption_Number.Font.size:=9;
   Caption_Number.Font.style:=[fsbold];
   Caption_Number.top:=Turtle.top+2;
end;

procedure TTurtleThread.Execute;
begin
  FreeOnTerminate:=true;
  repeat
     Progress:=Progress+random(10);
     sleep(100);
     Synchronize(Atualizar);
  until Progress>=MainForm.Width-50;
end;


procedure TMainForm.BitBtn1Click(Sender: TObject);
var
 loop,NumberOfTurtles : integer;
begin
  BitBtn1.Enabled:=false;
  edt_NumberOfTurtles.Enabled:=false;
  NumberOfTurtles:=strtoint(edt_NumberOfTurtles.Text);
  if (NumberOfTurtles>14) or
     (NumberOfTurtles<1) then
     NumberOfTurtles:=14;
  for loop:=1 to NumberOfTurtles do
     TTurtleThread.create(false);
end;

end.
