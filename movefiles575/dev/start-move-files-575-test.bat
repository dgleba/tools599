
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

REM c:\prg\cygwin64\bin\cygstart.exe --showminimized   c:\prg\cygwin64\bin\bash.exe -l -c "/cygdrive/c/data/script/movefiles575/move_files_to_nas575.sh>/cygdrive/c/temp/moveimg/sched_rsynclog.log 2>&1"

REM c:\prg\cygwin64\bin\cygstart.exe --showminimized   
c:\prg\cygwin64\bin\bash.exe -l -c "/cygdrive/c/data/script/movefiles575/move_files_to_nas575.sh>/cygdrive/c/temp/moveimg/sched_rsynclog.log 2>&1"


:loop
echo 575>>startmovefile575.log.txt
timeout 3
goto loop

timeout 9876

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
echo This cmd batch file is already running. exiting..
timeout 6
endlocal

:end


