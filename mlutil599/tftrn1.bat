@echo off
:: set title to the batch file name.
title %~n0
@REM set date variables. cd to c:\temp so log files are placed there.
(setlocal enableDelayedExpansion & for /f %%a in ('wmic os get localdatetime') do (for /F "tokens=1 delims=." %%b in ("%%a") do (echo %%b>%temp%\tmpdate987123.txt & set /p t3=<%temp%\tmpdate987123.txt&set dt=!t3:~0,8!&set ts=!t3:~8,6!&set rand1=%random%)))
echo date vars.. dt=%dt%  ts=%ts% rand=%rand1%
(setlocal enableDelayedExpansion&set tmpdir=c:\temp\mllog&mkdir !tmpdir!>nul 2>nul)
c:&cd c:\temp&echo on



@REM robocopy /L is dry run


:: =============================================
robocopy        d:\crib\tf1_train_master             ^
  d:\crib\traintf1-01  /e ^
  /dst /fft /xo /ndl /np /r:0 /w:0 /tee /eta /log:%tmpdir%\rb-tftt01_%dt%-%ts%_%rand1%.log.txt


REM :: =============================================
REM robocopy        \\10.4.100.207\pmda\tf1_train_master              ^
  REM d:\crib\tf1_train_master  /e ^
  REM /dst /fft /xo /ndl /np /r:0 /w:0 /tee /eta /log:%tmpdir%\rb-tftm-2c_%dt%-%ts%_%rand1%.log.txt


REM :: =============================================
REM robocopy                    \\pmda-sgenas01\PMDA-SGE\training_library_in_development  ^
  REM \\corp-fs01\CORP-PM\data_eng\ml_lib\ml_lib_6365sge\training_library_in_development  /e ^
  REM /dst /fft /xo /ndl /np /r:0 /w:0 /tee /eta /log:%tmpdir%\rb-sgelibidev-2crp_%dt%-%ts%_%rand1%.log.txt

:: /L ^

timeout 9987
pause

