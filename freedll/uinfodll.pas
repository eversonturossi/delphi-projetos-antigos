unit uinfodll;

interface

uses
 Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
 Dialogs, StdCtrls;

type
 TForm1 = class(TForm)
  Button1: TButton;
  procedure Button1Click(Sender: TObject);
 private
  { Private declarations }
 public
  { Public declarations }
 end;
 PDLLVerInfo = ^TDLLVersionInfo;
 TDLLVersionInfo = record
  cbSize, // Size of the structure, in bytes.
  dwMajorVersion, // Major version of the DLL
  dwMinorVersion, // Minor version of the DLL
  dwBuildNumber, // Build number of the DLL
  dwPlatformID: DWord; // Identifies the platform for which the DLL was built
 end;
 
var
 Form1: TForm1;
 DllGetVersion: function(dvi: PDLLVerInfo): PDLLVerInfo; stdcall;
 
implementation

{$R *.dfm}

function GetDllVersion(DllName: string; var DLLVersionInfo: TDLLVersionInfo): Boolean;
var
 hInstDll: THandle;
 p: pDLLVerInfo;
begin
 Result := False; // Get a handle to the DLL module. // das Handle zum DLL Modul ermitteln.
 hInstDll := LoadLibrary(PChar(DllName));
 if (hInstDll = 0) then
  Exit; // Return the address of the specified exported (DLL) function. // Adresse der Dll-Funktion ermitteln
 @DllGetVersion := GetProcAddress(hInstDll, 'DllGetVersion'); // If the handle is not valid, clean up an exit. // Wenn das Handle ungültig ist, wird die Funktion verlassen
 if (@DllGetVersion) = nil then
  begin
   FreeLibrary(hInstDll);
   Exit;
  end;
 new(p);
 try
  ZeroMemory(p, SizeOf(p^));
  p^.cbSize := SizeOf(p^); // Call the DllGetVersion function  // Die DllGetVersion() Funktion aufrufen
  DllGetVersion(p);
  DLLVersionInfo.dwMajorVersion := p^.dwMajorVersion;
  DLLVersionInfo.dwMinorVersion := p^.dwMinorVersion;
  @DllGetVersion := nil;
  Result := True;
 finally
  dispose(P);
 end; // Free the DLL module. // Dll wieder freigeben.
 FreeLibrary(hInstDll);
end;

// Example to get version info from comctl32.dll
// Beispiel, um von comctl32 Versions/Informationen zu erhalten

procedure TForm1.Button1Click(Sender: TObject);
var
 DLLVersionInfo: TDLLVersionInfo;
begin
 if not GetDllVersion('minhadll.dll', DLLVersionInfo) then
  begin
   DLLVersionInfo.dwMajorVersion := 4;
   DLLVersionInfo.dwMinorVersion := 0;
  end;
 with DLLVersionInfo do
  ShowMessage(Format('Version: %d.%d / Build: %d', [dwMajorVersion, dwMinorVersion, dwBuildNumber]))
end;

end.

