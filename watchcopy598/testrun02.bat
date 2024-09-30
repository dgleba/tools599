
md C:\data\logs\x
cd C:\data\script\tools599\watchcopy598


:: get date.
for /f "delims=" %%# in ('powershell get-date -format "{yyyy-MM-dd}"') do @set ymd=%%#
echo %ymd% 
for /f "delims=" %%# in ('powershell get-date -format "{yyyy-MM-dd_HH.mm.ss}"') do @set dhms=%%#
echo %dhms% 


:: clean up

set "basename=C:\data\cmm\watchedoutput"
robocopy  %basename% %basename%_%dhms% /mov /e /s

set "basename=C:\data\cmm\system"
robocopy  %basename% "%basename%_%dhms% " /mov /s /e
:: rmdir /s /q %basename% 

set "basename=C:\data\logs\watch598cmmresults"
robocopy  %basename% %basename%_%dhms% /mov /e /s

set "basename=C:\data\logs\debug"
robocopy  %basename% %basename%_%dhms% /mov /e /s


powershell C:\data\script\tools599\ps1-yard\51.remove.temp3file.olderthan.ps1

timeout 15
REM pause



:: make files

start powershell -File .\testrun02createfiles02.ps1

timeout 11


:: start powershell watch-mover..

REM start powershell C:\data\script\tools599\watchcopy598\watch598e.ps1


timeout 236
pause
pause
