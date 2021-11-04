:Prepare date and temp folders [ this silly stuff requires the region to be Enginsh United States so the datetime format is  M/d/yyyy ]
@echo off
set timea=%TIME: =0%
set ymd=%date:~12,2%%date:~4,2%%date:~7,2%&set dhms=%date:~12,2%%date:~4,2%%date:~7,2%_%timea:~0,2%%timea:~3,2%%timea:~6,2%
c: & md c:\temp\ & cd c:\temp & md c:\temp\log & md c:\temp\log\"%ymd%"  & cd c:\temp\log\"%ymd%"
ECHO %thishostname%
echo.  
echo OK.
echo.  
echo.  

set rand9=%random%  rem set one random for the whole job
:: hostname
FOR /F "usebackq" %%i IN (`hostname`) DO SET thishostname=%%i

:main

:~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

: Purpose
:
: install/update watcher on a local PC.

:~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


:main


echo. 
echo. 
echo Installing / updating...
echo. 
echo.


set logf4="c:\temp\log\%ymd%\rb-move_wtch598_bu-%dhms%

:: /L option =  dry run.
robocopy  "\\PMDA-FS01\Dept Shares\Engineering\0000_File transfer\dgleba\script\tools599 " c:\data\script\tools599   /e  /xf watch598settings.conf /xf watch598set-litmus.filecopy.list.conf /xd libre /xf *_T_*  /dst /fft /xo /ndl /np /r:2 /w:2 /tee /eta /log:%inst-updat%_engd_%random%"



:: cygwin64 

if exist "C:\prg\cygwin64\bin\grep.exe" (
echo grep exists. OK. continuing..
goto ending
)

echo copying grep. This may take a few minutes...

copy  "\\PMDA-FS01\Dept Shares\Engineering\0000_File transfer\dgleba\script\cygwin64_smal_zipofinstalled_cygrunsrv.rsync.ssh_2021-08-30-c.zip" c:\prg 

powershell Expand-Archive -Path c:\prg\cygwin64_smal_zipofinstalled_cygrunsrv.rsync.ssh_2021-08-30-c.zip -DestinationPath C:\prg




:ending
echo. 
echo. 
echo Reached end of install or update.
echo. 
pause
pause


:~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
:~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
:~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


: examples notes offline ..



:~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


:end

