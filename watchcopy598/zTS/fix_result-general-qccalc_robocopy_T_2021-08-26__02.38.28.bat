
:: date using powershell
for /f "delims=" %%# in ('powershell get-date -format "{yyyy-MM-dd_HH.mm.ss}"') do @set ts_dhms=%%#
echo %ts_dhms% 
mkdir c:\temp
echo %ts_dhms% > c:\temp\%ts_dhms%.txt
for /f "delims=" %%# in ('powershell get-date -format "{yyyy-MM-dd}"') do @set ts_ymd=%%#
echo %ts_ymd% 
::c: & md c:\temp\ & cd c:\temp & md c:\temp\log & md c:\temp\log\"%ymd%"  & cd c:\temp\log\"%ymd%"
FOR /F "usebackq" %%i IN (`hostname`) DO SET thishostname=%%i
ECHO %thishostname%



:main
rem ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 

:~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

: Purpose
:
: a bunch of files got copied to result and qccalc. Fix all the copies. 


:~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


:main

mkdir c:\data\logs\date\%ts_ymd%

set logf4="c:\data\logs\date\%ts_ymd%\rb-fixfoldrs_%dhms%
robocopy c:\result  c:\data\cmm\watchedoutput\general  /e   /xf *.tmp* /xd libre  /dst /fft /xo /ndl /np /r:0 /w:0 /tee /log:%logf4%_cmm10001-gen_%random%"

robocopy c:\result  c:\data\cmm\watchedoutput\litmus  /e   /xf *.tmp* /xd libre  /dst /fft /xo /ndl /np /r:0 /w:0 /tee /log:%logf4%_cmm10001-lit_%random%"

::REM robocopy c:\result  c:\data\archive\maybe-already-copied-to-qccalc-2021-08-26  /mov   /xf *.tmp* /xd libre  /dst /fft /xo /ndl /np /r:0 /w:0 /tee /log:%logf4%_cmm10001-qcct_%random%"



goto end

:~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
:~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
:~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

: notes 



:~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


:end

timeout 133
timeout 134
timeout 135


