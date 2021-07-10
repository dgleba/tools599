

::https://stackoverflow.com/questions/6359820/how-to-set-commands-output-as-a-variable-in-a-batch-file


:: for multi line returned output.


SETLOCAL ENABLEDELAYEDEXPANSION
SET count=1
FOR /F "tokens=* USEBACKQ" %%F IN (`powershell ls`) DO (
  SET var!count!=%%F
  SET /a count=!count!+1
)
ECHO 1-- %var1%
ECHO 2--  %var2%
ECHO 4--  %var4%
ENDLOCAL


REM timeout 3

REM ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


FOR /F "tokens=* USEBACKQ" %%F IN (`powershell date`) DO (
SET var=%%F )
ECHO %var%

REM ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


for /f "delims=" %%# in ('powershell get-date -format "{yyyy-mm-dd_HH.mm.ss}"') do @set dhms=%%#
echo %dhms%

pause
