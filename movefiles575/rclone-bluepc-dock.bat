
::# purpose: copy bluepc to dock

:Prepare date and temp folders
set timea=%TIME: =0%
set ymd=%date:~12,2%%date:~4,2%%date:~7,2%&set dhms=%date:~12,2%%date:~4,2%%date:~7,2%_%timea:~0,2%%timea:~3,2%%timea:~6,2%
c: & md c:\temp\ & cd c:\temp & md c:\temp\log & md c:\temp\log\"%ymd%"  & cd c:\temp\log\"%ymd%"
@echo off
@REM set title to the batch file name. set date variables. Set logfile dir. cd to c:\temp so log files are placed there.
(setlocal enableDelayedExpansion & for /f %%a in ('wmic os get localdatetime') do (for /F "tokens=1 delims=." %%b in ("%%a") do (echo %%b>%temp%\tmpdate987123.txt & set /p t3=<%temp%\tmpdate987123.txt&set dt=!t3:~0,8!&set ts=!t3:~8,6!&set rand1=%random%)))
echo date vars.. dt=%dt%  ts=%ts% rand=%rand1% utemp=%temp%
set logdir=c:\temp\log\%ymd%

:main
rem ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ run tasks 


: allow only one copy of this bat to run at one time..
:: Window title must be unique.
set batch_title=%~n0_001
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

d:\prg\rclone\rclone copy c:\  dock-vi641-ssh:/media/albe/vi641-002/backup/bluepc680/cdrive -vu --progress --stats=30s --log-file=%logdir%\rclone_c__%~n0_%dhms%.log.txt  
d:\prg\rclone\rclone copy d:\  dock-vi641-ssh:/media/albe/vi641-002/backup/bluepc680/ddrive -vu --progress --stats=30s --log-file=%logdir%\rclone_d__%~n0_%dhms%.log.txt  

 
timeout 145

goto end



:notes

To create rclone ssh connection:  -- d:\prg\rclone\rclone  config create dock-vi641-ssh sftp host 10.4.168.141 user albe pass the~password

REM --log-level NOTICE --order-by modtime,ascending --progress

--bwlimit=333k

:endnotes



:AlreadyRunning
echo %dhms% one.instance enforcement was invoked by tasklist window title checking.>>c:\temp\moveimg\one.instance.enforcement.log.txt
echo.
echo.
echo This cmd batch file is already running. exiting..
echo.
timeout 3623
endlocal

:end

