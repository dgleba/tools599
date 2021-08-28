
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
robocopy  %basename% %basename%_%dhms% /mov /e /s
:: rmdir /s /q %basename% 

set "basename=C:\data\logs\watch598cmmresults"
robocopy  %basename% %basename%_%dhms% /mov /e /s

set "basename=C:\data\logs\debug"
robocopy  %basename% %basename%_%dhms% /mov /e /s

timeout 15
REM pause



:: start powershell watcher..

start powershell C:\data\script\tools599\watchcopy598\watch598.ps1

timeout 11


:: make files slowly

echo %dhms%>>"C:\data\cmm\results from calypso\n11.%dhms%_chr.txt"
timeout 1
echo %dhms%>>"C:\data\cmm\results from calypso\n11.%dhms%_hdr.txt"
timeout 1
echo %dhms%>>"C:\data\cmm\results from calypso\n11.%dhms%_fet.txt"
REM echo b>>"C:\data\cmm\results from calypso\n7.chr.txt

timeout 15
REM pause


:: make files slowly

setlocal EnableExtensions DisableDelayedExpansion
rem // Define constants here:
set "Pattern=*.txt"
set "CopyFrom=C:\data\cmm\testfiles\cm2"
set "CopyTo=C:\data\cmm\results from calypso"

for %%F in ("%CopyFrom%\%Pattern%") do (
    :: copy "%%~F" "%CopyTo%\F%%~nF\"
    copy "%%~F" "%CopyTo%\"
	timeout 2
)
endlocal

timeout 16
REM pause


:: make file fast by copying..

robocopy C:\data\cmm\testfiles\cm1 "C:\data\cmm\results from calypso\ " 


timeout 234
pause
pause
