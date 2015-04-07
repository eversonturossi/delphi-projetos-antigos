unit uVolMain;


(******************************************************************
    How To Detect Multimedia Devices and Set their Volume

       by Alex Simonetti Abreu - simonet@bhnet.com.br
*******************************************************************

  The purpose of the Hot-To Project is to teach Delphi developers
  how it is possible to detect the number and names of auxiliary
  multimedia devices and, optionally, set their volume using a
  track bar (or any other similar) component.

  The point why there are two applications for this project is
  because you cannot set a device's (for example, the CD) volume
  if you don't know it's device ID (for most systems, the CD
  player has the device ID of 2, but that can change).

  The method for setting the volume (basically its math) was written
  by me a long time ago (when I was still getting started in VB), and
  still has its flaws. I left it here the way it was orinally (but not
  in Basic, of course!) and haven't given it too much thought since
  then. If you find a better way for setting the correct values for the
  low and high words that make up the value to be passed to
  AuxSetVolume, please let me know.

  This application was tested on a Pentium with a Creative Labs Sound
  Blaster AWE 64 and a total of 7 devices were detected: Wave, Midi,
  CD, Line In, Mic, Master (for the master volume) and PC speaker.

  To check if it works for real (besides "hearing" the volume changes),
  open Windows' volume taskbar control and this application at the same time.
  By changing the volume in the application, you'll see how Windows reacts
  to those changes. 


     Best regards.

        Alex Simonetti Abreu
        Belo Horizonte, MG, Brazil

        August, 1998


*)



interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls;

type
  TFrmMMVolMain = class(TForm)
    RadioGroup1: TRadioGroup;
    Panel1: TPanel;
    GroupBox5: TGroupBox;
    lbName: TLabel;
    tbVolLeft: TTrackBar;
    tbVolRight: TTrackBar;
    cblock: TCheckBox;
    Label1: TLabel;
    Label2: TLabel;
    Button1: TButton;
    Panel2: TPanel;
    Label3: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SetVolume(Sender : TObject);
    procedure Label6Click(Sender: TObject);
    procedure Label7Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmMMVolMain: TFrmMMVolMain;

implementation

uses ShellAPI, MMSystem;

{$R *.DFM}

procedure TFrmMMVolMain.FormCreate(Sender: TObject);
var
	cct, NumAux : shortint;
  AuxCaps     : TAuxCaps;
begin
  // This will list all multimedia devices and add their names to the
  // radio group that allows for multimedia device selection.
  // Only Auxiliary devices will be displayed (not the main ones).
	NumAux := AuxGetNumDevs;
  if (NumAux <= 0) then
  begin
     application.messagebox('No multimedia devices are present', 'Multimedia Volume', MB_ICONHAND + MB_OK);
     exit;
  end;
  RadioGroup1.items.beginupdate;
  RadioGroup1.items.clear;
  for cct:= 0 to (NumAux-1) do
  begin
  	auxGetDevCaps(cct,  @AuxCaps, sizeof(AuxCaps));
    	RadioGroup1.items.add(AuxCaps.szPname);
  end;
  RadioGroup1.items.EndUpdate;
  RAdioGroup1.itemindex := 0;
end;




procedure TFrmMMVolMain.RadioGroup1Click(Sender: TObject);
var
	NumAux      : longint;
  AuxCaps     : TAuxCaps;
begin
	NumAux := RadioGroup1.itemindex;
  // Read the device capabilities for the selected device
	auxGetDevCaps(NumAux,  @AuxCaps, sizeof(AuxCaps));
  with AuxCaps do
  begin
     if (dwSupport and AUXCAPS_LRVOLUME) > 0 then
     begin
        // This device supports Left & Right volume control
        cbLock.enabled := true;
     end
     else
     begin
        cbLock.checked := true;
        cbLock.enabled := false;
     end;
     if (dwSupport and AUXCAPS_VOLUME) > 0 then
     begin
        // This device supports volume control
        GroupBox5.enabled := true;
        lbName.caption := RadioGroup1.items[RadioGroup1.itemindex];
     end
     else
     begin
        GroupBox5.enabled := false;
        lbName.caption := 'Volume control not supported';
     end;


  end;
end;



procedure TFrmMMVolMain.Button1Click(Sender: TObject);
begin
  Close;
end;

procedure TFrmMMVolMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TFrmMMVolMain.SetVolume(Sender : TObject);
var
   xlow, xhigh : longint;
   vol : DWORD;
begin
  // This is the routine that actually sets the volume of the
  // multimedia device selected.
  // I already planned for the DeviceID of the aux device to be
  // the same as its index in the RadioGroupBox (see the form's OnCreate event).
  if cblock.checked then
  begin
     if sender = tbVolLeft then
       tbVolRight.Position := tbVolLeft.Position;
     if sender = tbVolRight then
       tbVolLeft.position := tbVolRight.Position;
  end;
  // The left volume is in the low order word of the value passed to
  // AuxSetVolume, and the right volume word is in the high order word.
  xlow := abs(tbVolLeft.position+1)*4096 - 1;
  xhigh := abs(tbVolRight.position+1)*4096 shl 16 - 1;
  if abs(tbVolLeft.position)=0 then xlow:=0;
  if abs(tbVolRight.position)=0 then xhigh:=0;
  if abs(tbVolRight.position)=15 then xhigh:=$FFFF0000;
  if abs(tbVolLeft.position)=15 then xlow:=$FFFF;
  vol := xlow + xhigh;
  auxsetvolume(RadioGroup1.ItemIndex, vol);
end;

procedure TFrmMMVolMain.Label6Click(Sender: TObject);
begin
  // Bonus tip:
  // How to send e-mail using Delphi without using MAPI.
  // The line below will open the default e-mail program with a new messge addresses to
  // me (simonet@bhnet.com.br) and a subject of "Thanks for the Multimedia project"
  ShellExecute(handle, 'open', 'mailto:simonet@bhnet.com.br?Subject=Thanks for the Multimedia project ', nil, nil, SW_SHOWNORMAL);
end;

procedure TFrmMMVolMain.Label7Click(Sender: TObject);
begin
  // Bonus tip:
  // The line below will open the default Internet browser in the selected page
  // if there's not default application registered to process http: calls,
  // nothing (or maybe an error) will happen
  ShellExecute(handle, 'open', 'http://www.bhnet.com.br/~simonet', nil, nil, SW_SHOWNORMAL);
end;

end.
