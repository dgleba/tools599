
:: get date.
for /f "delims=" %%# in ('powershell get-date -format "{yyyy-MM-dd}"') do @set ymd=%%#
echo %ymd% 
for /f "delims=" %%# in ('powershell get-date -format "{yyyy-MM-dd_HH.mm.ss}"') do @set dhms=%%#
echo %dhms% 


echo %dhms%>>"C:\data\cmm\results from calypso\n11.%dhms%.chr.txt
echo %dhms%>>"C:\data\cmm\results from calypso\n11.%dhms%.hdr.txt
echo %dhms%>>"C:\data\cmm\results from calypso\n11.%dhms%.fet.txt
REM echo b>>"C:\data\cmm\results from calypso\n7.chr.txt

timeout 15