

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


:Works..

for /f "delims=" %%# in ('powershell get-date -format "{yyyy-MM-dd_HH.mm.ss}"') do @set dhms=%%#
echo %dhms% 

mkdir c:\temp
echo %dhms% > c:\temp\%dhms%.txt

for /f "delims=" %%# in ('powershell get-date -format "{yyyy-MM-dd}"') do @set ymd=%%#
echo %ymd% 

set ts_yr=%dhms:~0,4%
echo ts_yr ... is %ts_yr%

set ts_mon=%dhms:~5,2%
echo ts_mon ... is %ts_mon%

set ts_hr=%dhms:~11,2%
echo ts_hr ... is %ts_hr%

# position
#yy-MM-dd_HH.mm.ss
#23456789012345

pause
