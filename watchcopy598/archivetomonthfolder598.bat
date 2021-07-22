@echo off

REM I might call this from watch598.ps1 once per day.

:: Settings ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

set sourcefolder=C:\data\cmm\results


:: date ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


: Using wmic - windows batch universal way to get region independent date time to environment variable
for /F "usebackq tokens=1,2 delims==" %%i in (`wmic os get LocalDateTime /VALUE 2^>NUL`) do if '.%%i.'=='.LocalDateTime.' set ts_in=%%j
echo %ts_in%
set ts_dhms=%ts_in:~0,4%-%ts_in:~4,2%-%ts_in:~6,2%_%ts_in:~8,2%.%ts_in:~10,2%.%ts_in:~12,2% 
set ts_ymd=%ts_in:~0,4%-%ts_in:~4,2%-%ts_in:~6,2%
set ts_mon=%ts_in:~4,2%
set ts_yr=%ts_in:~0,4%
echo ts_dhms... is %ts_dhms%
echo ts_ymd ... is %ts_ymd%
echo ts_yr ... is %ts_yr%
echo ts_mon ... is %ts_mon%


:: move ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


::Move files older than minage. minage=30 is 30 days..

robocopy %sourcefolder% C:\data\test\watch598data-archive\%ts_yr%-%ts_mon%-minus30 /s /MOVE /MINAGE:30 /IS /R:3 /W:4 



timeout 14
