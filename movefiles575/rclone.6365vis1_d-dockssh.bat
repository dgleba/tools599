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
set batch_title=rclone_move6365vis1-dockssh
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

set pth=c:\prg\rclone\
%pth%\rclone move  --min-age 4h   -v --progress --stats=30s ^
 D:\data\vision_6365_1\image_data  ^
 dock-vi641-ssh:/media/albe/vi641-002/mcdata/mc_6365_vision_1  --transfers 2  ^
 --log-file=%logdir%\rclone6365vis1-dockssh_%dhms%.log.txt 

:: --delete-empty-src-dirs
:: for nas2.. Z:\mcdata\mc_6365_vision_1 ^
:: 2>&1|%pth%\tee %logdir%\rclonedockssh_%dhms%.log.txt
:: --log-file=%logdir%\rclonedockssh_%dhms%.log.txt


 
timeout 14

goto end



:How-to-create-rclone-sshs-sftp-connection
:: Just copy paste the following to create the connection. It doesn't run in this script.

set pth=c:\prg\rclone\
%pth%\rclone config create dock-vi641-ssh sftp host 10.4.168.141 user albe pass Stackpole1325



:notes

rclone copy C:\prg\xsearch dock-vi641-ssh:/tmp/rclonetst -vu

sftp://10.4.168.141/media/albe/vi641-001/mcdata/mc_6365_vision/image_data


REM --log-level NOTICE --order-by modtime,ascending --progress

--bwlimit=333k

@rem --log-level INFO

REM c:\prg\rclone\rclone move --min-age=180d  --max-age=999d --delete-empty-src-dirs  "D:\Archive Record\images" \\10.4.65.190\Images\mcdata\mc_6670_vision\image_data\vision-1\images -v --log-file=%logdir%\rclone_%dhms%.log.txt


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
timeout 9
