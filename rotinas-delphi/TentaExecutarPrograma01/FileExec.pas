function FileExec(const aCmdLine: String; aHide, aWait,bWait: Boolean):Boolean;
//
// Executa um arquivo
// aHide = Se vai ser exibido ou oculto
// aWait = Se o aplicativo será executado em segundo plano
// bWait = Se o Sistema deve esperar este aplicativo ser finalizado para
//         prosseguir ou não
//
var
StartupInfo : TStartupInfo;
ProcessInfo : TProcessInformation;
begin
FillChar(StartupInfo, SizeOf(TStartupInfo), 0);
with StartupInfo do
     begin
     cb:= SizeOf(TStartupInfo);
     dwFlags:= STARTF_USESHOWWINDOW or STARTF_FORCEONFEEDBACK;
     if aHide then
        begin
        wShowWindow:= SW_HIDE
        end
     else
        begin
        wShowWindow:= SW_SHOWNORMAL;
        end;
     end;
Result := CreateProcess(nil,PChar(aCmdLine), nil, nil, False,NORMAL_PRIORITY_CLASS, nil, nil, StartupInfo, ProcessInfo);
if aWait and Result then
   begin
   WaitForInputIdle(ProcessInfo.hProcess, INFINITE);
   if bWait then
      begin
      WaitForSingleObject(ProcessInfo.hProcess,INFINITE);
      end;
   end;
end;