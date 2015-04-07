function GetCpuSpeed: Extended;
//
// Retorna a frequencia do processador usado
//
// Deve ser usada assim:
//
// function TForm1.GetCpuSpeed: Extended;
//
// Declare-a na clausua Private do form
//
var
 t: DWORD;
 mhi, mlo, nhi, nlo: DWORD;
 t0, t1, chi, clo, shr32: Comp;
begin
 shr32 := 65536;
 shr32 := shr32 * 65536;
 t := GetTickCount;
 while t = GetTickCount do
  begin
  end;
 asm
   DB 0FH
   DB 031H
   mov mhi,edx
   mov mlo,eax
 end;
 while GetTickCount < (t + 1000) do
  begin
  end;
 asm
   DB 0FH
   DB 031H
   mov nhi,edx
   mov nlo,eax
 end;
 chi := mhi;
 if mhi < 0 then
  begin
   chi := chi + shr32;
  end;
 clo := mlo;
 if mlo < 0 then
  begin
   clo := clo + shr32;
  end;
 t0 := chi * shr32 + clo;
 chi := nhi;
 if nhi < 0 then
  begin
   chi := chi + shr32;
  end;
 clo := nlo;
 if nlo < 0 then
  begin
   clo := clo + shr32;
  end;
 t1 := chi * shr32 + clo;
 Result := (t1 - t0) / 1E6;
end;

