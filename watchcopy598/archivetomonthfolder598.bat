@echo off

REM I might call this from watch598.ps1 once per day.

:: Settings ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

::set sourcefolder=c:\data\older\testcopy\cmm\result
set sourcefolder=C:\result

:: \\pmda-bkh70w2\data\archive\cmm
:: c:\data\archive\cmm


:: get date ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


:: using powershell
for /f "delims=" %%# in ('powershell get-date -format "{yyyy-MM-dd_HH.mm.ss}"') do @set ts_dhms=%%#
echo %ts_dhms% 
mkdir c:\temp
echo %ts_dhms% > c:\temp\%ts_dhms%.txt
for /f "delims=" %%# in ('powershell get-date -format "{yyyy-MM-dd}"') do @set ts_ymd=%%#
echo %ts_ymd% 
set ts_yr=%ts_dhms:~0,4%
echo ts_yr ... is %ts_yr%
set ts_mon=%ts_dhms:~5,2%
echo ts_mon ... is %ts_mon%



:: move ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


::Move files older than minage. minage:30 is 30 days..

robocopy %sourcefolder% C:\data\archive\cmm\calypso-c-result-archive\%ts_yr%-%ts_mon%-minus_lag /s /MOVE  /xf merge__*.txt /xf *.TMP /MINAGE:21 /IS /xo /R:3 /W:4  /tee /log:"C:\data\logs\watch598cmmresults\debug\rb-archi-calyp-%ts_dhms%-%random%"

robocopy C:\data\cmm\watchedoutput\general C:\data\archive\cmm\watch598data-archive-general\%ts_yr%-%ts_mon%-minus_lag /s /MOVE  /MINAGE:15 /IS /xo /R:3 /W:4  /tee /log:"C:\data\logs\watch598cmmresults\debug\rb-archi-general-%ts_dhms%-%random%"

robocopy C:\data\cmm\watchedoutput\qccalc C:\data\archive\cmm\watch598data-archive-qccalc\%ts_yr%-%ts_mon%-minus_lag /s /MOVE  /MINAGE:21 /IS /xo /R:3 /W:4  /tee /log:"C:\data\logs\watch598cmmresults\debug\rb-archi-qccalc-%ts_dhms%-%random%"

robocopy C:\data\logs C:\data\archive\data\logs\%ts_yr%-%ts_mon%-minus_lag /s /MOVE  /MINAGE:10 /IS /xo /R:3 /W:4  /tee /log:"C:\data\logs\watch598cmmresults\debug\rb-archi-logs-%ts_dhms%-%random%"



timeout 15

