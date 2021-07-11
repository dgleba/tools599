
Get-WmiObject Win32_Process -Filter "Name='powershell.exe' AND CommandLine LIKE '%598%'" > C:\temp\getwmiobject.ps.598.r434.txt

cmd /c md c:\temp

`cmd /c findstr  /C:"System Boot Time:"  /C:"OS Name:" /C:"OS Version:"  /C:"System Manufacturer:" /C:"System Model:"  /C:"System Locale:" /C:"Input Locale:" /C:"Time Zone:" /C:"NetWork Card"  C:\temp\SystemInfo99.txt > c:\temp\SystemInfo98.txt
type c:\temp\SystemInfo98.txt


findstr  /C:"System Boot Time:"    C:\temp\SystemInfo99.txt

echo.
pause

