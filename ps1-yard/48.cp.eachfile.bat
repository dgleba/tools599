
setlocal EnableExtensions DisableDelayedExpansion
rem // Define constants here:
set "Pattern=*.txt"
set "CopyFrom=C:\data\cmm\testfiles\cm2"
set "CopyTo=C:\data\cmm\results from calypso"

for %%F in ("%CopyFrom%\%Pattern%") do (
    REM copy "%%~F" "%CopyTo%\F%%~nF\"
    copy "%%~F" "%CopyTo%\"
	timeout 2
)
endlocal