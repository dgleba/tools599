REM ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

REM get date as bat/cmd variable..

::https://stackoverflow.com/questions/6359820/how-to-set-commands-output-as-a-variable-in-a-batch-file


REM ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

@echo off

:Works..

:: get timestamp
for /f "delims=" %%# in ('powershell get-date -format "{yyyy-MM-dd_HH.mm.ss}"') do @set dhms=%%#
echo %dhms% 

mkdir c:\temp
echo %dhms% > c:\temp\%dhms%.txt

:: get year
for /f "delims=" %%# in ('powershell get-date -format "{yyyy}"') do @set ts_yr=%%#
echo %ts_yr% 

:: get month
for /f "delims=" %%# in ('powershell get-date -format "{MM}"') do @set ts_mon=%%#
echo %ts_mon% 

echo %ts_yr%-%ts_mon%

timeout 4
