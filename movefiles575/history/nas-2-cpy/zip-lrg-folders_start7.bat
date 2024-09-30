::# purpose: start ...

:Prepare date and temp folders
set timea=%TIME: =0%
set ymd=%date:~12,2%%date:~4,2%%date:~7,2%&set dhms=%date:~12,2%%date:~4,2%%date:~7,2%_%timea:~0,2%%timea:~3,2%%timea:~6,2%
c: & md c:\temp\ & cd c:\temp & md c:\temp\log & md c:\temp\log\"%ymd%"  & cd c:\temp\log\"%ymd%"
@echo off
@REM set title to the batch file name. set date variables. Set logfile dir. cd to c:\temp so log files are placed there.
title %~n0
(setlocal enableDelayedExpansion & for /f %%a in ('wmic os get localdatetime') do (for /F "tokens=1 delims=." %%b in ("%%a") do (echo %%b>%temp%\tmpdate987123.txt & set /p t3=<%temp%\tmpdate987123.txt&set dt=!t3:~0,8!&set ts=!t3:~8,6!&set rand1=%random%)))
echo date vars.. dt=%dt%  ts=%ts% rand=%rand1% utemp=%temp%
::(setlocal enableDelayedExpansion&set logdir=c:\temp\movelog&mkdir !logdir!>nul 2>nul)
::c:&cd c:\temp&echo on
set logdir=c:\temp\log\"%ymd%"

:main
rem ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ run tasks 



::Put your program here
:main01
echo Start main routine

c:\prg\python\python \\10.4.65.190\Images\sw\copyof\data_script\tools599\movefiles575\zip-lrg-folders7.py >%logdir%\zipfolds7_%dhms%_log.txt 2>&1

REM c:\prg\python\python \\10.4.65.190\Images\sw\copyof\data_script\tools599\movefiles575\zip-lrg-folders-b.py >%logdir%\zipfolds-b_%dhms%_log.txt 2>&1
REM c:\prg\python\python \\10.4.65.190\Images\sw\copyof\data_script\tools599\movefiles575\zip-lrg-folders.py 

timeout 45

goto end





:end
endlocal





