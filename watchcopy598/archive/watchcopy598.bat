@echo off


:: Settings ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

set sourcefolder=C:\crib\watch598testfolder



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


:main
rem ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ copy watched folder


:: purpose: duplicate folder

robocopy  %sourcefolder% C:\crib\watch598testcopy /e

echo watchcopy598.bat ran at %ts_dhms%>>C:\crib\watch598testcopy\watchcopy598run.log
timeout 9

