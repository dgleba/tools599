:Prepare date and temp folders
:set ymd=%date:~12,2%%date:~4,2%%date:~7,2%&set dhms=%date:~12,2%%date:~4,2%%date:~7,2%_%time:~0,2%%time:~3,2%%time:~6,2%
:c: & md c:\temp\ & cd c:\temp & md c:\temp\log & md c:\temp\log\"%dhms%"  & cd c:\temp\log\"%dhms%"
:main
rem ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ resta

:shutdown -r — restarts
:shutdown -s — shutsdown
:shutdown -l — logoff
:shutdown -t xx — where xx is number of seconds to wait till shutdown/restart/logoff
:shutdown -i — gives you a dialog box to fill in what function you want to use
:shutdown -a — aborts the previous shutdown command....very handy!
:-f         Force running applications to close without forewarning users. The /f parameter is implied when a value greater than 0 is specified for the /t parameter.
 
           
echo off
cls
echo.
echo.
echo.
echo .  .  .  .  shutdown of this PC will commence...
echo.
echo .  .  .  .  press the x in the upper right corner of this window to stop the shutdown.
echo.
echo .  .  .  .  shutdown minus a    ..   aborts the previous shutdown command....very handy!
echo.
echo.
timeout 9
timeout 5
timeout 0
echo on

shutdown -t 3 -r 

rem ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ resta









:..........---- offline items................................................
goto end
goto end
goto end
goto :end
:#######

shutdown -a

:end
