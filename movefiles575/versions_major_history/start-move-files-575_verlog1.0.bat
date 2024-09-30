
::# see revision history at bottom.

::# purpose: startup -  move_files_to_nas575.sh

::# usage:   in task scheduler:  command:  %SystemRoot%\system32\wscript.exe  
::            parameters: "C:\data\script\movefiles575\invisible.vbs"  "C:\data\script\movefiles575\start-move-files-575.bat" //nologo



:History:
: 2021-05-27 see history at bottom of file.


:Prepare date and temp folders
set timea=%TIME: =0%
set ymd=%date:~12,2%%date:~4,2%%date:~7,2%&set dhms=%date:~12,2%%date:~4,2%%date:~7,2%_%timea:~0,2%%timea:~3,2%%timea:~6,2%
c: & md c:\temp\ & cd c:\temp 
::& md c:\temp\log & md c:\temp\log\"%dhms%"  & cd c:\temp\log\"%dhms%"
:main
rem ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ run tasks on yoga c740


REM @echo off

:: Window title must be unique.
set batch_title=start-move-files-575_bat
:: Run tasklist in verbose mode (which returns window titles) and search for the window title of this batch file:
tasklist /V /NH /FI "imagename eq cmd.exe"| find /I /C "%batch_title%" > nul
:: If the window title is found then the errorlevel variable will be 0, which means the process is already running:
if %errorlevel%==0 goto AlreadyRunning
:: If the process isn't already running then the window title can be set:
title %batch_title%



::Put your program here
:main01

echo Start main routine

:loop
echo %dhms% starting move575>>c:\temp\moveimg\startmovefile575.log.txt
timeout 3
::goto loop


::REM c:\prg\cygwin64\bin\cygstart.exe --showminimized   c:\prg\cygwin64\bin\bash.exe -l -c "/cygdrive/c/data/script/movefiles575/move_files_to_nas575.sh>/cygdrive/c/temp/moveimg/sched_rsynclog.log 2>&1"
c:\prg\cygwin64\bin\bash.exe -l -c "/cygdrive/c/data/script/movefiles575/move_files_to_nas575.sh>/cygdrive/c/temp/moveimg/sched_rsynclog.log 2>&1"
timeout 4

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
echo %dhms% one.instance enforcement was invoked by tasklist window title checking.>>c:\temp\moveimg\one.instance.enforcement.log.txt

echo This cmd batch file is already running. exiting..
timeout 6
endlocal

:end


:: History:


:: 2021-07-06 r4  line ~75 renamed to one.instance.enforcement.log.txt
:: 2021-05-28     add one.instance.enforcement.%ymd%.log.txt
:: # move files.  rev:  David Gleba daterange: 2021-05-28 -- 
