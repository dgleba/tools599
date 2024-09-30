
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
set rand9=%random%  rem set one random for the whole job
echo "%ymd%" "%dhms%"
:main
rem ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 

:~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

: Purpose
:
: backup 575 project files to NAS


:~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


:main

set logf4="c:\temp\log\%ymd%\rb-move_575_bu-%dhms%-%random%"
robocopy c:\data\script\tools599  \\pmda-sgenas01\PMDA-SGE\backup\mc6365_c_data_script\tools599  /e     ^
 /xf *._sync* /xd venv001 6830_xml_to_csv_env vision_performance_tracker_report_env zTS .git  /dst /fft /xo /ndl /np /r:0 /w:0 /tee /eta /log:%logf4%


robocopy c:\data\script\tools599  \\10.4.65.190\Images\sw\copyof\data_script\tools599  /e     ^
 /xf *._sync* /xd venv001 6830_xml_to_csv_env vision_performance_tracker_report_env zTS .git  /dst /fft /xo /ndl /np /r:0 /w:0 /tee /eta /log:%logf4%




:~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
:~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
:~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


: examples notes offline ..



:~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


:end


pause
timeout  7831

REM echo endof rbcp dbxseaf.bat>"c:\temp\log\%ymd%\rb-dbxseafbatend-%dhms%-%random%"

