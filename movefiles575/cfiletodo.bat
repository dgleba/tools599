
::# purpose: startup -  cfiletodo - list the files to be backed up by date

::# usage:  run it.

:History:
:  see history at bottom of file.


:Prepare date and temp folders
set timea=%TIME: =0%
set ymd=%date:~12,2%%date:~4,2%%date:~7,2%&set dhms=%date:~12,2%%date:~4,2%%date:~7,2%_%timea:~0,2%%timea:~3,2%%timea:~6,2%
c: & md c:\temp\ & cd c:\temp 
::& md c:\temp\log & md c:\temp\log\"%dhms%"  & cd c:\temp\log\"%dhms%"
:main
rem ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ run tasks on yoga c740

REM @echo off

:: Window title must be unique.
set batch_title=cfiletodo-bat
:: Run tasklist in verbose mode (which returns window titles) and search for the window title of this batch file:
tasklist /V /NH /FI "imagename eq cmd.exe"| find /I /C "%batch_title%" > nul
:: If the window title is found then the errorlevel variable will be 0, which means the process is already running:
if %errorlevel%==0 goto AlreadyRunning
:: If the process isn't already running then the window title can be set:
title %batch_title%


::Put your program here
:main01

echo Start main routine

c:\prg\cygwin64\bin\bash.exe -l -c "/cygdrive/c/data/script/tools599/movefiles575/cfiletodo.sh"
timeout 4

goto end



:notes  =================================================


x

:endnotes =================================================





:AlreadyRunning
echo.
echo %dhms% one.instance enforcement was invoked by tasklist window title checking.>>c:\temp\moveimg\one.instance.enforcement.log.txt

echo This cmd batch file is already running. exiting..
timeout 6
endlocal

:end


:: History:


:: 2022-06-22 start
