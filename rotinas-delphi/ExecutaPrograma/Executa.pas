function Executa(Arquivo : String; Estado : Integer) : Integer;
//
// executa um programa e espera sua finalização
//
// Valores para Estdo: SW_SHOWNORMAL   Janela em modo normal
//                     SW_MAXIMIZE     Janela maximizada
//                     SW_MINIMIZE     Janela minimizada
//                     SW_HIDE         Janela Escondida
//
var
Programa : array [0..512] of char;
CurDir   : array [0..255] of char;
WorkDir  : String;
StartupInfo : TStartupInfo;
ProcessInfo : TProcessInformation;
begin
StrPCopy (Programa, Arquivo);
GetDir (0, WorkDir);
StrPCopy (CurDir, WorkDir);
FillChar (StartupInfo, Sizeof (StartupInfo), #0);
StartupInfo.cb := sizeof (StartupInfo);
StartupInfo.dwFlags := STARTF_USESHOWWINDOW;
StartupInfo.wShowWindow := Estado;
if not CreateProcess (nil, Programa, nil, nil, false, CREATE_NEW_CONSOLE or NORMAL_PRIORITY_CLASS, nil, nil, StartupInfo, ProcessInfo) then
   begin
   Result := -1;
   end
else
   begin
   WaitForSingleObject (ProcessInfo.hProcess, Infinite);
   GetExitCodeProcess (ProcessInfo.hProcess, Result);
    end;
end;
