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
set logdir=c:\temp\log\%ymd%

:main
rem ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ run tasks 


REM @echo off

:: allow only one copy of this to run at one time..
:: Window title must be unique.
set batch_title=rclone_move6670vis1-2-nas2_180d
:: Run tasklist in verbose mode (which returns window titles) and search for the window title of this batch file:
tasklist /V /NH /FI "imagename eq cmd.exe"| find /I /C "%batch_title%" > nul
:: If the window title is found then the errorlevel variable will be 0, which means the process is already running:
if %errorlevel%==0 goto AlreadyRunning
:: If the process isn't already running then the window title can be set:
title %batch_title%


::Put your program here
:main01

echo Start main routine

@echo on


:: note: dgleba change from 150d to 390d 2023-06-13_Tue_06.55-AM

set pth=c:\prg\rclone\
%pth%\rclone move  --min-age=390d  --max-age=999d --order-by modtime,ascending "D:\Archive Record\images" dock-vi641-ssh:/media/albe/vi641-002/mcdata/mc_6670_vision/image_data/vision-1/images -v 2>&1|%pth%\tee %logdir%\rclonedockssh_%dhms%.log.txt


:: This option may not respect min-age --delete-empty-src-dirs.
:: use python..

c:\prg\python\python C:\data\script\tools599\movefiles575\rmdir-empty-dir-olderthan.py "D:\Archive Record\images"



timeout 145

goto end





:create-rclone-sshs-sftp-connection

set pth=c:\prg\rclone\
%pth%\rclone config create dock-vi641-ssh sftp host 10.4.64.7 user albe pass Stackpole1325




:notes

 --bwlimit=29k
 
::c:\prg\rclone\rclone move --min-age=180d  --max-age=999d --delete-empty-src-dirs  "D:\Archive Record\images" \\10.4.65.190\Images\mcdata\mc_6670_vision\image_data\vision-1\images -v --log-file=%logdir%\rclone_%dhms%.log.txt

REM --log-level NOTICE --order-by modtime,ascending --progress

@rem --log-level INFO
 
 
::c:\prg\fastcopy\FastCopy.exe /cmd=move  /from_date=-499D /to_date=-10D /no_ui /include="Bad\" /force_start=2 /filelog /no_confirm_stop /skip_empty_dir 
/logfile=%logdir%\fastlog%dhms%.log.txt  "D:\Archive Record\images" /to=\\10.4.65.190\Images\mcdata\mc_6670_vision\image_data\vision-1\images 
::c:\prg\fastcopy\FastCopy.exe /cmd=move  /from_date=-21D /to_date=-10D /no_ui /force_start=2 /filelog /no_confirm_stop /skip_empty_dir /logfile=%logdir%\fastlog%dhms%.log.txt  "D:\Archive Record\images" /to=\\10.4.65.190\Images\mcdata\mc_6670_vision\image_data\vision-1\images 

	wmic process where "name like '%cmd%'" get processid,commandline

		C:\Windows\system32>wmic process where "name like '%cmd%'" get processid,commandline
		CommandLine                                                      ProcessId
		C:\Windows\system32\cmd.exe /c ""C:\prg\cygwin64\Cygwin.bat" "   13452
		C:\Windows\system32\cmd.exe /c ""C:\0\one.instance1d527a.cmd" "  25488
		"C:\Windows\system32\cmd.exe"                                    20312

:endnotes



:AlreadyRunning
mkdir c:\temp\moveimg
echo %dhms% one.instance enforcement was invoked by tasklist window title checking.>>c:\temp\moveimg\one.instance.enforcement.log.txt
echo.
echo.
echo This cmd batch file is already running. exiting..
echo.
timeout 36
endlocal

:end

