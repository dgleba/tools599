@ECHO OFF
md c:\temp
cls
echo.

systeminfo > C:\temp\SystemInfo99.txt

findstr  /C:"System Boot Time:"  /C:"OS Name:" /C:"OS Version:"  /C:"System Manufacturer:" /C:"System Model:"  /C:"System Locale:" /C:"Input Locale:" /C:"Time Zone:" /C:"NetWork Card"  C:\temp\SystemInfo99.txt > c:\temp\SystemInfo98.txt
type c:\temp\SystemInfo98.txt

echo.
::echo Boot up time at:
echo.

findstr  /C:"System Boot Time:"    C:\temp\SystemInfo99.txt

echo.
pause