unit uProcessMemMgr;

{

author: Michael Winter, delphi.net@gmx.net
ver:    0.8, 2001-11-20
desc:
Provides access to memory of other processes currently running on the same
machine. Memory can be allocated and deallocated inside the context of the
other process. Read and write operations supported, not limited to portions
of memory allocated by the object. Works for the own process, too.

notes:
You need one TProcessMemMgr object for each process.
Freeing the TProcessMemMgr frees all memory allocated for the appropriate
process.
The IPCThread unit, usually located in $(DELPHI)\Demos\Ipcdemos\ is
neccessary to compile this.
Please report any problems with this unit to the email address above.

}

interface

uses
  Windows, Classes, IPCThrd;

const
  MemMgrMemSize = 16*1024;

type
  TProcessMemMgr = class(TObject)
  public
    function AllocMem(Bytes: Cardinal): Pointer; virtual; abstract;
    procedure FreeMem(P: Pointer); virtual; abstract;
    procedure Read(Source: Pointer; var Dest; Bytes: Cardinal); virtual; abstract;
    function ReadStr(Source: PChar): String; virtual; abstract;
    procedure Write(const Source; Dest: Pointer; Bytes: Cardinal); virtual; abstract;
    procedure WriteStr(const Str: String; Dest: Pointer); virtual; abstract;
  end;

function CreateProcessMemMgr(ProcessID: Cardinal): TProcessMemMgr;
function CreateProcessMemMgrForWnd(Wnd: HWND): TProcessMemMgr;

implementation

uses
  SysUtils, Contnrs;

type
  EProcessMemMgr = class(Exception);

  TOwnProcessMemMgr = class(TProcessMemMgr)
  private
    FMemList: TThreadList;
  public
    constructor Create;
    destructor Destroy; override;
    function AllocMem(Bytes: Cardinal): Pointer; override;
    procedure FreeMem(P: Pointer); override;
    procedure Read(Source: Pointer; var Dest; Bytes: Cardinal); override;
    function ReadStr(Source: PChar): String; override;
    procedure Write(const Source; Dest: Pointer; Bytes: Cardinal); override;
    procedure WriteStr(const Str: String; Dest: Pointer); override;
  end;

  TForeignProcessMemMgr = class(TProcessMemMgr)
  private
    FProcess: THandle;
    FMemList: TThreadList;
  protected
    procedure NeedMoreMem(Bytes: Cardinal); virtual; abstract;
  public
    constructor Create(ProcessID: Cardinal);
    destructor Destroy; override;
    function AllocMem(Bytes: Cardinal): Pointer; override;
    procedure FreeMem(P: Pointer); override;
    procedure Read(Source: Pointer; var Dest; Bytes: Cardinal); override;
    function ReadStr(Source: PChar): String; override;
    procedure Write(const Source; Dest: Pointer; Bytes: Cardinal); override;
    procedure WriteStr(const Str: String; Dest: Pointer); override;
  end;

  TWin9xProcessMemMgr = class(TForeignProcessMemMgr)
  private
    FSharedList: TObjectList;
  protected
    procedure NeedMoreMem(Bytes: Cardinal); override;
  public
    constructor Create(ProcessID: Cardinal);
    destructor Destroy; override;
  end;

  TWinNTProcessMemMgr = class(TForeignProcessMemMgr)
  private
    FAllocList: TList;
  protected
    procedure NeedMoreMem(Bytes: Cardinal); override;
  public
    constructor Create(ProcessID: Cardinal);
    destructor Destroy; override;
  end;

  PMemRec = ^TMemRec;
  TMemRec = record
    Start: Pointer;
    Size: Cardinal;
    Group: Integer;
    Used: Boolean;
  end;

{ Win95 doesn't export these functions, thus we have to import them dynamically: }

var
  VirtualAllocEx: function (hProcess: THandle; lpAddress: Pointer;
    dwSize, flAllocationType: DWORD; flProtect: DWORD): Pointer; stdcall = nil;
  VirtualFreeEx: function(hProcess: THandle; lpAddress: Pointer;
        dwSize, dwFreeType: DWORD): Pointer; stdcall = nil;

procedure NeedVirtualAlloc;
var
  H: HINST;
begin
  if @VirtualFreeEx <> nil then exit;
  H := GetModuleHandle(kernel32);
  if H = 0 then
    RaiseLastWin32Error;
  @VirtualAllocEx := GetProcAddress(H, 'VirtualAllocEx');
  if @VirtualAllocEx = nil then
    RaiseLastWin32Error;
  @VirtualFreeEx := GetProcAddress(H, 'VirtualFreeEx');
  if @VirtualFreeEx = nil then
    RaiseLastWin32Error;
end;

{ TOwnProcessMemMgr }

function TOwnProcessMemMgr.AllocMem(Bytes: Cardinal): Pointer;
begin
  Result := SysUtils.AllocMem(Bytes);
  FMemList.Add(Result);
end;

constructor TOwnProcessMemMgr.Create;
begin
  inherited;
  FMemList := TThreadList.Create;
end;

destructor TOwnProcessMemMgr.Destroy;
var
  i: Integer;
begin
  with FMemList.LockList do try
    for i := 0 to Count - 1 do
      System.FreeMem(Items[i]);
  finally
    FMemList.UnlockList;
  end;
  FMemList.Free;
  inherited;
end;

procedure TOwnProcessMemMgr.FreeMem(P: Pointer);
begin
  FMemList.Remove(P);
  System.FreeMem(P);
end;

procedure TOwnProcessMemMgr.Read(Source: Pointer; var Dest; Bytes: Cardinal);
begin
  System.Move(Source^, Dest, Bytes);
end;

function TOwnProcessMemMgr.ReadStr(Source: PChar): String;
begin
  Result := Source;
end;

procedure TOwnProcessMemMgr.Write(const Source; Dest: Pointer; Bytes: Cardinal);
begin
  System.Move(Source, Dest^, Bytes);
end;

procedure TOwnProcessMemMgr.WriteStr(const Str: String; Dest: Pointer);
begin
  StrPCopy(Dest, Str);
end;

{ TForeignProcessMemMgr }

function TForeignProcessMemMgr.AllocMem(Bytes: Cardinal): Pointer;
var
  t: Integer;
  i: Integer;
  Rec, NewRec: PMemRec;
  Remain: Cardinal;
begin
  Result := nil;
  with FMemList.LockList do try
    for t := 0 to 1 do begin
      for i := 0 to Count - 1 do begin
        Rec := Items[i];
        if not Rec^.Used and (Rec^.Size >= Bytes) then begin
          Remain := Rec^.Size - Bytes;
          Rec^.Size := Bytes;
          Rec^.Used := true;
          Result := Rec^.Start;
          if Remain > 0 then begin
            New(NewRec);
            NewRec^.Start := Pointer(Cardinal(Result) + Cardinal(Bytes));
            NewRec^.Size := Remain;
            NewRec^.Group := Rec^.Group;
            NewRec^.Used := false;
            Insert(i + 1, NewRec);
          end;
          exit;
        end;
      end;
      NeedMoreMem(Bytes);
    end;
    raise EProcessMemMgr.Create('ProcessMemMgr.AllocMem: not enough memory');
  finally
    FMemList.UnlockList;
  end;
end;

constructor TForeignProcessMemMgr.Create(ProcessID: Cardinal);
begin
  inherited Create;
  FProcess := OpenProcess(PROCESS_VM_OPERATION or PROCESS_VM_READ or PROCESS_VM_WRITE, false, ProcessID);
  if FProcess = 0 then RaiseLastWin32Error;
  FMemList := TThreadList.Create;
end;

destructor TForeignProcessMemMgr.Destroy;
begin
  FMemList.Free;
  CloseHandle(FProcess);
  inherited;
end;

procedure TForeignProcessMemMgr.FreeMem(P: Pointer);
var
  i, j: Integer;
  Rec, NextRec: PMemRec;
begin
  with FMemList.LockList do try
    for i := 0 to Count - 1 do begin
      Rec := Items[i];
      if Rec^.Start = P then begin
        Rec^.Used := false;
        j := i + 1;
        while j < Count do begin
          NextRec := Items[j];
          if NextRec^.Used then exit;
          if NextRec^.Group <> Rec^.Group then exit;
          inc(Rec^.Size, NextRec^.Size);
          Dispose(NextRec);
          Delete(j);
        end;
        exit;
      end;
    end;
    Assert(false, 'ProcessMemMgr.FreeMem: unknown pointer');
  finally
    FMemList.UnlockList;
  end;
end;

procedure TForeignProcessMemMgr.Read(Source: Pointer; var Dest; Bytes: Cardinal);
var
  BytesRead: Cardinal;
begin
  if not ReadProcessMemory(FProcess, Source, @Dest, Bytes, BytesRead) then
    RaiseLastWin32Error;
end;

function TForeignProcessMemMgr.ReadStr(Source: PChar): String;
var
  BytesRead: Cardinal;
  OldSz, DeltaSz, NewSz: Integer;
  Buf: PChar;
  i: Integer;
  Found: Integer;
begin
  Result := '';
  if Source = nil then exit;
  Buf := nil;
  OldSz := 0;
  DeltaSz := $1000 - (Cardinal(Source) and $FFF);
  Found := -1;
  try
    while Found < 0 do begin
      NewSz := OldSz + DeltaSz;
      System.ReallocMem(Buf, NewSz);
      if not ReadProcessMemory(FProcess, Source + OldSz, Buf + OldSz , DeltaSz, BytesRead) then
        RaiseLastWin32Error;
      for i := OldSz to NewSz - 1 do begin
        if Buf[i] = #0 then begin
          Found := i;
          break;
        end;
      end;
      DeltaSz := $1000;
    end;
    SetLength(Result, Found);
    if Found > 0 then
      System.Move(Buf^, Result[1], Found);
  finally
    System.FreeMem(Buf);
  end;
end;

procedure TForeignProcessMemMgr.Write(const Source; Dest: Pointer; Bytes: Cardinal);
var
  BytesWritten: Cardinal;
begin
  if not WriteProcessMemory(FProcess, Dest, @Source, Bytes, BytesWritten) then
    RaiseLastWin32Error;
end;

procedure TForeignProcessMemMgr.WriteStr(const Str: String; Dest: Pointer);
begin
  Write(PChar(Str)^, Dest, Length(Str) + 1);
end;

{ TWin9xProcessMemMgr }

constructor TWin9xProcessMemMgr.Create(ProcessID: Cardinal);
begin
  inherited;
  FSharedList := TObjectList.Create;
end;

destructor TWin9xProcessMemMgr.Destroy;
begin
  FSharedList.Free;
  inherited;
end;

procedure TWin9xProcessMemMgr.NeedMoreMem(Bytes: Cardinal);
var
  Ix: Integer;
  Share: TSharedMem;
  Rec: PMemRec;
begin
  if Bytes < MemMgrMemSize then
    Bytes := MemMgrMemSize
  else
    Bytes := (Bytes + $FFF) and not $FFF;
  Ix := FSharedList.Count;
  Share := TSharedMem.Create('', Bytes);
  FSharedList.Add(Share);
  New(Rec);
  Rec^.Start := Share.Buffer;
  Rec^.Size := Bytes;
  Rec^.Group := Ix;
  Rec^.Used := false;
  FMemList.Add(Rec);
end;

{ TWinNTProcessMemMgr }

constructor TWinNTProcessMemMgr.Create(ProcessID: Cardinal);
begin
  inherited;
  NeedVirtualAlloc;
  FAllocList := TList.Create;
end;

destructor TWinNTProcessMemMgr.Destroy;
var
  i: Integer;
begin
  for i := 0 to FAllocList.Count - 1 do
    VirtualFreeEx(FProcess, FAllocList[i], 0, MEM_RELEASE);
  FAllocList.Free;
  inherited;
end;

procedure TWinNTProcessMemMgr.NeedMoreMem(Bytes: Cardinal);
var
  Ix: Integer;
  Alloc: Pointer;
  Rec: PMemRec;
begin
  if Bytes < MemMgrMemSize then
    Bytes := MemMgrMemSize
  else
    Bytes := (Bytes + $FFF) and not $FFF;
  Ix := FAllocList.Count;
  Alloc := VirtualAllocEx(FProcess, nil, MemMgrMemSize, MEM_COMMIT, PAGE_READWRITE);
  if Alloc = nil then RaiseLastWin32Error;
  FAllocList.Add(Alloc);
  New(Rec);
  Rec^.Start := Alloc;
  Rec^.Size := Bytes;
  Rec^.Group := Ix;
  Rec^.Used := false;
  FMemList.Add(Rec);
end;

function CreateProcessMemMgr(ProcessID: Cardinal): TProcessMemMgr;
begin
  if ProcessID = GetCurrentProcessId then begin
    Result := TOwnProcessMemMgr.Create;
  end else begin
    if Win32Platform = VER_PLATFORM_WIN32_NT then
      Result := TWinNTProcessMemMgr.Create(ProcessID)
    else
      Result := TWin9xProcessMemMgr.Create(ProcessID);
  end;
end;

function CreateProcessMemMgrForWnd(Wnd: HWND): TProcessMemMgr;
var
  PID: Cardinal;
begin
  PID := 0;
  GetWindowThreadProcessId(Wnd, @PID);
  Result := CreateProcessMemMgr(PID);
end;

end.
