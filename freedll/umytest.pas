unit umytest;

interface

uses
 Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
 Dialogs, tlhelp32;

type
 TForm1 = class(TForm)
 private
  { Private declarations }
 public
  { Public declarations }
 end;
 
var
 Form1: TForm1;
 
implementation

{$R *.dfm}

function IsRunning(ExeFileName: string): bool;
const
 PROCESS_TERMINATE = $0001;
var
 ContinueLoop: BOOL;
 FSnapshotHandle: THandle;
 FProcessEntry32: TProcessEntry32;
 Len: Integer;
 name1, name2, name3: string;
begin
 result := False;
 FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
 FProcessEntry32.dwSize := Sizeof(FProcessEntry32);
 ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);
 while integer(ContinueLoop) <> 0 do
  begin
   Len := Length(FProcessEntry32.szExeFile);
   Name1 := UpperCase(ExtractFileName(FProcessEntry32.szExeFile));
   Name2 := UpperCase(Copy(ExeFileName, 1, Len));
   Name3 := UpperCase(FProcessEntry32.szExeFile);

   if (Name1 = Name2) or (Name3 = Name2) then
    Result := True;

   ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
  end;
 
 CloseHandle(FSnapshotHandle);
end;

end.

