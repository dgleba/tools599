
for /f "delims=" %%# in ('powershell get-date -format "{yyyy-MM-dd}"') do @set ymd=%%#
echo %ymd% 
for /f "delims=" %%# in ('powershell get-date -format "{yyyy-MM-dd_HH.mm.ss}"') do @set dhms=%%#
echo %dhms% 
::mkdir c:\temp\log\%ymd%

::robocopy "C:\data\cmm\results from calypso " C:\data\cmm\watchedoutput\general  /L /e   /fft /dst /xo /ndl /r:1 /w:1 /tee /log:"c:\temp\log\%dhms%\rb-compare.calypso-general-%dhms%-%random%"

robocopy c:\result c:\data\older\testcopy\cmm\result  /e   /fft /dst /xo /ndl /r:1 /w:1 /tee /log:"C:\data\logs\watch598cmmresults\rb-getresultcp-%dhms%-%random%"

timeout 60