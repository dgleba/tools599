@echo off

REM archive older logs.

:: Settings ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


:: date ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


REM : Using wmic - windows batch universal way to get region independent date time to environment variable
REM for /F "usebackq tokens=1,2 delims==" %%i in (`wmic os get LocalDateTime /VALUE 2^>NUL`) do if '.%%i.'=='.LocalDateTime.' set ts_in=%%j
REM echo %ts_in%
REM set ts_dhms=%ts_in:~0,4%-%ts_in:~4,2%-%ts_in:~6,2%_%ts_in:~8,2%.%ts_in:~10,2%.%ts_in:~12,2% 
REM set ts_ymd=%ts_in:~0,4%-%ts_in:~4,2%-%ts_in:~6,2%
REM set ts_mon=%ts_in:~4,2%
REM set ts_yr=%ts_in:~0,4%
REM echo ts_dhms... is %ts_dhms%%ts_dhms%
REM echo ts_ymd ... is %ts_ymd%
REM echo ts_yr ... is %ts_yr%
REM echo ts_mon ... is %ts_mon%


for /f "delims=" %%# in ('powershell get-date -format "{yyyy-MM-dd}"') do @set ymd=%%#
echo %ymd% 
for /f "delims=" %%# in ('powershell get-date -format "{yyyy-MM-dd_HH.mm.ss}"') do @set dhms=%%#
echo %dhms% 
::mkdir c:\temp\log\%ymd%


:: move ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


::Move files older than minage. minage=30 is 30 days..

robocopy C:\data\logs\watch598cmmresults  C:\data\archive\watch598cmmresultslogs\%dhms% /s /MOVE  /xf *pid*.txt /IS /R:3 /W:4  /tee /log:"C:\data\logs\watch598cmmresults\rb-archi-logs-%dhms%-%random%.log.txt"




timeout 14
