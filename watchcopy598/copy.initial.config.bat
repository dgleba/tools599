@echo off

:: get date.
for /f "delims=" %%# in ('powershell get-date -format "{yyyy-MM-dd}"') do @set ymd=%%#
::echo %ymd% 
for /f "delims=" %%# in ('powershell get-date -format "{yyyy-MM-dd_HH.mm.ss}"') do @set dhms=%%#
echo %dhms% 



:main


echo. 
echo. 
echo copying example conf to conf..
echo. 
echo.
echo.
timeout 5
echo.
echo.
echo.
echo. Carefull - this could overwrite your existing config.
echo.
echo.
timeout 234


REM make folder to point qccalc at...
mkdir "C:\data\cmm\watchedoutput\qccalc"


::make backup..
mkdir backup >nul 2>&1
copy watch598settings.conf backup\watch598settings_%dhms%.backup.conf
copy watch598set-litmus.filecopy.list.conf backup\watch598set-litmus.filecopy.list_%dhms%.backup.conf


copy watch598set-litmus.filecopy.list_example.conf watch598set-litmus.filecopy.list.conf
copy watch598settings_pma-base.conf watch598settings.conf


echo. 
echo. 
echo Reached end of copying.
echo. 
echo Please read and edit the .conf files.
echo. 
echo. 
echo. 


:~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
:~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
:~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


: examples notes offline ..



:~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


:end

pause
pause
