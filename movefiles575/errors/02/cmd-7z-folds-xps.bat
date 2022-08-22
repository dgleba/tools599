::# purpose: start ...

:Prepare date and temp folders
set timea=%TIME: =0%
set ymd=%date:~12,2%%date:~4,2%%date:~7,2%&set dhms=%date:~12,2%%date:~4,2%%date:~7,2%_%timea:~0,2%%timea:~3,2%%timea:~6,2%
c: & md c:\temp\ & cd c:\temp & md c:\temp\log & md c:\temp\log\"%ymd%"  & cd c:\temp\log\"%ymd%"
@echo off
@REM set title to the batch file name. set date variables. Set logfile dir. cd to c:\temp so log files are placed there.
title %~n0
REM (setlocal enableDelayedExpansion & for /f %%a in ('wmic os get localdatetime') do (for /F "tokens=1 delims=." %%b in ("%%a") do (echo %%b>%temp%\tmpdate987123.txt & set /p t3=<%temp%\tmpdate987123.txt&set dt=!t3:~0,8!&set ts=!t3:~8,6!&set rand1=%random%)))
REM echo date vars.. dt=%dt%  ts=%ts% rand=%rand1% utemp=%temp%
::(setlocal enableDelayedExpansion&set logdir=c:\temp\movelog&mkdir !logdir!>nul 2>nul)
::c:&cd c:\temp&echo on
set logdir=c:\temp\log\"%ymd%"

:main
rem ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ run tasks 


echo Start main routine


@echo on
::@echo off
set fold00="D:\0\Jun\6670"
set fold00="D:\Archive Record\images\year2021\Sep"
set fold00="D:\0\Jun"
d:
cd %fold00%
for /D %%G in (%fold00%\*) DO ( 
echo "---------- "%%~nxG
echo %%G
C:\prg\7-zip\7za a -sdel -m0=Copy %%~nxG.7z  %%G
)



pause
pause
pause
pause
pause
goto end

=================================================

@echo on
d:
set tm01=%dhms%
set fold00="D:\Archive Record\images\year2021\Jun\Day30\Shift3\2960"
cd %fold00%
cd&dir
C:\prg\7-zip\7za a -m0=Copy bad0.7z  %fold00%\bad 
dir
@REM>%logdir%\zipfolds_%tm01%_log.txt 2>&1
print %logdir%\zipfolds_%tm01%_log.txt

REM good
set fold00="D:\Archive Record\images\year2021\Jun\Day30\Shift3\2960"
cd %fold00%
cd&dir
C:\prg\7-zip\7za a -m0=Copy good0.7z  %fold00%\good 
dir
@REM>%logdir%\zipfolds_%tm01%_log.txt 2>&1
print %logdir%\zipfolds_%tm01%_log.txt

pause
REM timeout 445

goto end


:end
endlocal

