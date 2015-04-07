function getport(p:word):byte; stdcall;
begin
asm
   push edx
   push eax
   mov  dx,p
   in   al,dx
   mov  @result,al
   pop  eax
   pop  edx
end;
end;


Procedure Setport(p:word;b:byte);Stdcall;
begin
asm
  push  edx
  push	eax
  mov   dx,p
  mov   al,b
  out   dx,al
  pop   eax
  pop   edx
end;
end;
