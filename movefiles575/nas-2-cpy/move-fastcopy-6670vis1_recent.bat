
::# purpose: startup -  move_files_to_nas


:Prepare date and temp folders
set timea=%TIME: =0%
set ymd=%date:~12,2%%date:~4,2%%date:~7,2%&set dhms=%date:~12,2%%date:~4,2%%date:~7,2%_%timea:~0,2%%timea:~3,2%%timea:~6,2%
c: & md c:\temp\ & cd c:\temp & md c:\temp\log & md c:\temp\log\"%ymd%"  & cd c:\temp\log\"%ymd%"
@echo off
@REM set title to the batch file name. set date variables. Set logfile dir. cd to c:\temp so log files are placed there.
::title %~n0
(setlocal enableDelayedExpansion & for /f %%a in ('wmic os get localdatetime') do (for /F "tokens=1 delims=." %%b in ("%%a") do (echo %%b>%temp%\tmpdate987123.txt & set /p t3=<%temp%\tmpdate987123.txt&set dt=!t3:~0,8!&set ts=!t3:~8,6!&set rand1=%random%)))
echo date vars.. dt=%dt%  ts=%ts% rand=%rand1% utemp=%temp%
::(setlocal enableDelayedExpansion&set logdir=c:\temp\movelog&mkdir !logdir!>nul 2>nul)
::c:&cd c:\temp&echo on
set logdir=c:\temp\log\"%ymd%"

:main
rem ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ run tasks 


REM @echo off

:: allow only one copy of this to run at one time..
:: Window title must be unique.
set batch_title=recent_fastcopy_move6670vis1-2-nas2
:: Run tasklist in verbose mode (which returns window titles) and search for the window title of this batch file:
tasklist /V /NH /FI "imagename eq cmd.exe"| find /I /C "%batch_title%" > nul
:: If the window title is found then the errorlevel variable will be 0, which means the process is already running:
if %errorlevel%==0 goto AlreadyRunning
:: If the process isn't already running then the window title can be set:
title %batch_title%



::Put your program here
:main01

echo Start main routine


::echo %dhms% starting move6670vis1>>c:\temp\moveimg\startmovefile6670vis1.log.txt
timeout 3
::goto loop


::REM c:\prg\cygwin64\bin\cygstart.exe --showminimized   c:\prg\cygwin64\bin\bash.exe -l -c "/cygdrive/c/data/script/movefiles575/move_files_to_nas575.sh>/cygdrive/c/temp/moveimg/sched_rsynclog.log 2>&1"
::c:\prg\cygwin64\bin\bash.exe -l -c "/cygdrive/c/data/script/movefiles575/move_files_to_nas575.sh>/cygdrive/c/temp/moveimg/sched_rsynclog.log 2>&1"

REM Move files from 6670 vision #1 to nas 2.
REM 6670 vision1 pc is 32 bit. Not using cygin64 as 32 bit cygwin is nolonger supported.

@echo on
c:\prg\fastcopy\FastCopy.exe /cmd=move  /from_date=-365D /to_date=-10D /no_ui /include="Bad\" /force_start=2 /filelog /no_confirm_stop /skip_empty_dir /logfile=%logdir%\fastlog%dhms%.log.txt  "D:\Archive Record\images" /to=\\10.4.65.190\Images\mcdata\mc_6670_vision\image_data\vision-1\images 

c:\prg\fastcopy\FastCopy.exe /cmd=move  /from_date=-18D /to_date=-10D /no_ui /force_start=2 /filelog /no_confirm_stop /skip_empty_dir /logfile=%logdir%\fastlog%dhms%.log.txt  "D:\Archive Record\images" /to=\\10.4.65.190\Images\mcdata\mc_6670_vision\image_data\vision-1\images 



timeout 345

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
echo %dhms% one.instance enforcement was invoked by tasklist window title checking.>>c:\temp\moveimg\one.instance.enforcement.log.txt
echo.
echo.
echo This cmd batch file is already running. exiting..
echo.
timeout 36
endlocal

:end




