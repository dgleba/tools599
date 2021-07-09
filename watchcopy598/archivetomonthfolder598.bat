@echo off

:: Settings ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

set sourcefolder=C:\crib\watch598testfolder




:: date ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


REM :Prepare date. must be usa locale
REM set timea=%TIME: =0%
REM set ymd=%date:~12,2%%date:~4,2%%date:~7,2%&set dhms=%date:~12,2%%date:~4,2%%date:~7,2%_%time:~0,2%%time:~3,2%%time:~6,2%
REM set yr=%date:~12,2%
REM set mon=%date:~4,2%
REM :: c: & md c:\temp\ & cd c:\temp 
REM :: & md c:\temp\log & md c:\temp\log\"%dhms%"  & cd c:\temp\log\"%dhms%"

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


:: calculate ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

calculate 



::Move files older than minage..

Need to calculate month minus 1.  eg: 07 -1 = 06
robocopy C:\crib\watch598testfolder C:\crib\watch598archive\%ts_yr%-%ts_mon_prev% /s /MOVe /MINAGE:30 /IS /R:3 /W:4 > NUL


