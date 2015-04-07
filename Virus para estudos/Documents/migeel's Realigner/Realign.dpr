program Realign;

{$APPTYPE CONSOLE}

uses Windows, ImageHlp;

function RealignPE(AddressOfMapFile: Pointer;dwFsize: DWORD;bRealignMode:Byte):dword;
          stdcall; external 'realign.dll';
function WipeReloc(AddressOfMapFile: Pointer;dwFSize: DWORD):DWORD;
          stdcall; external 'realign.dll';

var hFile, hMap: THandle;
    dwFsize,dwNewFSize,dwRet: dword;
    pMap: pointer;
    pImageHeaders: PImageNtHeaders;
begin
  writeln('            _              __');
  writeln('   A __ _  (_)__ ____ ___ / /');
  writeln('    /  '' \/ / _ `/ -_) -_) /');
  writeln('   /_/_/_/_/\_, /\__/\__/_/');
  writeln('           /___/  SOLUTiON');
  writeln;
  writeln('       EXE Realigner');
  writeln('   Copyright (c) 2003 migeel');
  writeln('             Michal Strehovsky');
  writeln;
  writeln('  Uses Yoda''s Realign engine');
  writeln; writeln;

  if ParamCount=0 then
  begin
    writeln('Usage: realign.exe yourfile.exe');
    exit;
  end;

  hFile:=CreateFile(PChar(ParamStr(1)),GENERIC_READ+GENERIC_WRITE,
    FILE_SHARE_READ+FILE_SHARE_WRITE,nil,OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL,0);
  if hFile=INVALID_HANDLE_VALUE then
  begin
    writeln('File IO-Error!');
    exit;
  end;

  dwFsize:=GetFileSize(hFile,nil);
  writeln('-> Old size: ',dwFsize);

  hMap:=CreateFileMapping(hFile,nil,PAGE_READWRITE,0,0,nil);
  CloseHandle(hFile);

  pMap:=MapViewOfFile(hMap,FILE_MAP_READ or FILE_MAP_WRITE,0,0,0);
  CloseHandle(hMap);

  dwNewFsize:=dwFsize;

  writeln('-> Realign');
  dwRet:=RealignPE(pMap, dwNewFsize, 1);
  dwNewFsize:=dwRet;

  writeln('-> Wipe relocation table');
  dwRet:=WipeReloc(pMap, dwNewFSize);
  dwNewFSize:=dwRet;

  writeln('-> New size: ',dwNewFSize);

  pImageHeaders:=ImageNtHeader(pMap);
  
  UnmapViewOfFile(pMap);

  hFile:=CreateFile(PChar(ParamStr(1)),
          GENERIC_READ+GENERIC_WRITE,FILE_SHARE_READ+FILE_SHARE_WRITE,
          nil,OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL,0);
  SetFilePointer(hFile,dwNewFsize,nil,FILE_BEGIN);
  SetEndOfFile(hFile);
  CloseHandle(hFile);

end.
