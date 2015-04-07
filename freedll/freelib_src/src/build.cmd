@echo off

set PATH=c:\PROGRA~1\lcc\bin;

lcc.exe -O main.c
lcclnk.exe -o ..\bin\freelib.exe -nolibc -s -subsystem console main.obj

if exist main.obj del main.obj

pause