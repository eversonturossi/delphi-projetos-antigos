function CPUSpeed: Double;
//
// Retorna a frequencia do processador usado
//
const
DelayTime = 500; // measure time in ms
var
TimerHi, TimerLo: DWORD;
PriorityClass, Priority: Integer;
begin
PriorityClass := GetPriorityClass(GetCurrentProcess);
Priority := GetThreadPriority(GetCurrentThread);
SetPriorityClass(GetCurrentProcess, REALTIME_PRIORITY_CLASS);
SetThreadPriority(GetCurrentThread, THREAD_PRIORITY_TIME_CRITICAL);
Sleep(10);
asm
dw 310Fh // rdtsc
mov TimerLo, eax
mov TimerHi, edx
end;
Sleep(DelayTime);
asm
dw 310Fh // rdtsc
sub eax, TimerLo
sbb edx, TimerHi
mov TimerLo, eax
mov TimerHi, edx
end;
SetThreadPriority(GetCurrentThread, Priority);
SetPriorityClass(GetCurrentProcess, PriorityClass);
Result := TimerLo / (1000.0 * DelayTime);
end;
