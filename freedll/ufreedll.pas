unit ufreedll;

interface

uses
 Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
 Dialogs, StdCtrls;

type
 TDllRegisterServer = function: HResult; stdcall;
 TForm1 = class(TForm)
  Button1: TButton;
  Button2: TButton;
  Button3: TButton;
  procedure Button1Click(Sender: TObject);
  procedure Button2Click(Sender: TObject);
  procedure Button3Click(Sender: TObject);
 private
  { Private declarations }
 public
  { Public declarations }
 end;
 
var
 Form1: TForm1;
 
implementation

{$R *.dfm}

function UnRegisterOCX(FileName: string): Boolean;
var
 OCXHand: THandle;
 RegFunc: TDllRegisterServer;
begin
 OCXHand := LoadLibrary(PChar(FileName));
 RegFunc := GetProcAddress(OCXHand, 'DllUnregisterServer');
 if @RegFunc <> nil then
  Result := RegFunc = S_OK
 else
  Result := False;
 FreeLibrary(OCXHand);
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
 
 if UnRegisterOCX('C:\WINDOWS\Downloaded Program Files\minhadll.dll') then
  ShowMessage('unregistred')
 else
  ShowMessage('nao foi possivel');
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
 if UnRegisterOCX('C:\WINDOWS\Downloaded Program Files\minhadll2.dll') then
  ShowMessage('unregistred')
 else
  ShowMessage('nao foi possivel');
end;

function RegisterServer(const aDllFileName: string): Boolean;
type
 TRegProc = function: HResult;
 stdcall;
var
 vLibHandle: THandle;
 vRegProc: TRegProc;
begin
 Result := False;
 vLibHandle := LoadLibrary(PChar(aDllFileName));
 if vLibHandle = 0 then
  Exit;
 @vRegProc := GetProcAddress(vLibHandle, 'DllUnregisterServer');
 if @vRegProc <> nil then
  Result := vRegProc = S_OK;
 FreeLibrary(vLibHandle);
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
// if RegisterServer('C:\WINDOWS\Downloaded Program Files\minhadll.dll') then
if RegisterServer('minhadll.dll') then
  ShowMessage('unregistred');
end;

end.

