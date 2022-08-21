
::# see revision history at bottom.

::# purpose: startup -  move_files_to_nas575.sh

::# usage:   in task scheduler:  command:  %SystemRoot%\system32\wscript.exe  
::            parameters: "C:\data\script\movefiles575\invisible.vbs"  "C:\data\script\movefiles575\start-move-files-575.bat" //nologo


:Prepare date and temp folders
set timea=%TIME: =0%
set ymd=%date:~12,2%%date:~4,2%%date:~7,2%&set dhms=%date:~12,2%%date:~4,2%%date:~7,2%_%timea:~0,2%%timea:~3,2%%timea:~6,2%
c: & md c:\temp\ & cd c:\temp & md c:\temp\log & md c:\temp\log\"%dhms%"  & cd c:\temp\log\"%dhms%"
@echo off
@REM set title to the batch file name. set date variables. Set logfile dir. cd to c:\temp so log files are placed there.
::title %~n0
(setlocal enableDelayedExpansion & for /f %%a in ('wmic os get localdatetime') do (for /F "tokens=1 delims=." %%b in ("%%a") do (echo %%b>%temp%\tmpdate987123.txt & set /p t3=<%temp%\tmpdate987123.txt&set dt=!t3:~0,8!&set ts=!t3:~8,6!&set rand1=%random%)))
echo date vars.. dt=%dt%  ts=%ts% rand=%rand1% utemp=%temp%
::(setlocal enableDelayedExpansion&set logdir=c:\temp\mllog&mkdir !logdir!>nul 2>nul)
::c:&cd c:\temp&echo on
set logdir=c:\temp\log\"%dhms%"

:main
rem ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ run tasks 


REM @echo off

:: Window title must be unique.
set batch_title=move6670vis1-2-nas2
:: Run tasklist in verbose mode (which returns window titles) and search for the window title of this batch file:
tasklist /V /NH /FI "imagename eq cmd.exe"| find /I /C "%batch_title%" > nul
:: If the window title is found then the errorlevel variable will be 0, which means the process is already running:
if %errorlevel%==0 goto AlreadyRunning
:: If the process isn't already running then the window title can be set:
title %batch_title%



::Put your program here
:main01

echo Start main routine


echo %dhms% starting move6670vis1>>c:\temp\moveimg\startmovefile6670vis1.log.txt
timeout 3
::goto loop


::REM c:\prg\cygwin64\bin\cygstart.exe --showminimized   c:\prg\cygwin64\bin\bash.exe -l -c "/cygdrive/c/data/script/movefiles575/move_files_to_nas575.sh>/cygdrive/c/temp/moveimg/sched_rsynclog.log 2>&1"
::c:\prg\cygwin64\bin\bash.exe -l -c "/cygdrive/c/data/script/movefiles575/move_files_to_nas575.sh>/cygdrive/c/temp/moveimg/sched_rsynclog.log 2>&1"

REM Move files from 6670 vision #1 to nas 2.
REM 6670 vision1 pc is 32 bit. Not using cygin64 as 32 bit cygwin is nolonger supported.

cd %utemp&
robocopy /s /move /MINAGE:60 /dst "D:\Archive Record\images " ^
  \\10.4.65.190\Images\mcdata\mc_6670_vision\image_data\vision-1\images ^
    /r:5 /w:1 /tee /log:rb-6670vis1-2-nas2_%dt%-%ts%_%random%.log.txt


timeout 4345

goto end





:notes

	wmic process where "name like '%cmd%'" get processid,commandline

		C:\Windows\system32>wmic process where "name like '%cmd%'" get processid,commandline
		CommandLine                                                      ProcessId
		C:\Windows\system32\cmd.exe /c ""C:\prg\cygwin64\Cygwin.bat" "   13452
		C:\Windows\system32\cmd.exe /c ""C:\0\one.instance1d527a.cmd" "  25488
		"C:\Windows\system32\cmd.exe"                                    20312

:endnotes




:AlreadyRunning
echo.
echo.
echo.
echo %dhms% one.instance enforcement was invoked by tasklist window title checking.>>c:\temp\moveimg\one.instance.enforcement.log.txt
echo.
echo This cmd batch file is already running. exiting..
timeout 6
endlocal

:end


:: History:


:: 2022-08-17 r0  start 6670


