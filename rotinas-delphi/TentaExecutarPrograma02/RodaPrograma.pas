function RodaPrograma(PathFileName: String): Integer;
//
// Tenta executar um aplicativo, Em caso negativo retorna
// o código de erro correspondente.
//
// Exemplo:
//
// procedure TForm1.Button1Click(Sender: TObject);
// var
// Result: Word;
// begin
// //Result := RunProgram('c:\windows\write.exe');
//  Result := RunProgram('c:\windows\desktop\wordpad.exe');
//  if Result <> 0 then
//     begin
//     raise Exception.Create('Error ' + IntToStr(Result) + ' executing program');
//     end;
// end;
//

var
Rslt: LongBool;
StartupInfo: TStartupInfo;
ProcessInfo: TProcessInformation;
begin
FillChar(StartupInfo, SizeOf(TStartupInfo), 0);
with StartupInfo do
     begin
     cb := SizeOf(TStartupInfo);
     dwFlags := STARTF_USESHOWWINDOW or STARTF_FORCEONFEEDBACK;
     wShowWindow := SW_SHOWNORMAL;
     end;
Rslt := CreateProcess(PChar(PathFileName), nil, nil, nil, False,NORMAL_PRIORITY_CLASS, nil, nil, StartupInfo, ProcessInfo);
if Rslt then
   begin
   with ProcessInfo do
        begin
        WaitForInputIdle(hProcess, INFINITE);
        CloseHandle(hThread);
        CloseHandle(hProcess);
        Result := 0;
        end;
    end
else
   begin
   Result := GetLastError;
   end;
end;
