

:: move files slowly

setlocal EnableExtensions DisableDelayedExpansion
rem // Define constants here:
set "Pattern=*.txt"
set "CopyFrom=C:\data\move\test01"
set "CopyTo=C:\data\move\test02"

for %%F in ("%CopyFrom%\%Pattern%") do (
    :: copy "%%~F" "%CopyTo%\F%%~nF\"
    move "%%~F" "%CopyTo%\"
	timeout 3
)
endlocal

timeout 1622
pause



