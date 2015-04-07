@echo off

freelib.exe minha.dll

echo.
echo Just... paused!
pause > nul

gacutil /nologo /u sample
regsvcs /u /nologo minha.dll

gacutil /nologo /i minha.dll
regsvcs /fc /nologo minha.dll

echo.
echo Press any key to close this console window
pause > nul