:Prepare date and temp folders [ this silly stuff requires the region to be Enginsh United States so the datetime format is  M/d/yyyy ]
set timea=%TIME: =0%
set ymd=%date:~12,2%%date:~4,2%%date:~7,2%&set dhms=%date:~12,2%%date:~4,2%%date:~7,2%_%timea:~0,2%%timea:~3,2%%timea:~6,2%
c: & md c:\temp\ & cd c:\temp & md c:\temp\log & md c:\temp\log\"%ymd%"  & cd c:\temp\log\"%ymd%"
set rand9=%random%  rem set one random for the whole job
:: hostname
FOR /F "usebackq" %%i IN (`hostname`) DO SET thishostname=%%i
ECHO %thishostname%

:main
rem ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ dropbox to seaf mir

:~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

: Purpose
:
: backup 598 project files 


:~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


:main




set logf4="c:\temp\log\%ymd%\rb-move_wtch598_bu-%dhms%


:: /L option =  dry run.
robocopy c:\data\script\tools599    "\\PMDA-FS01\Dept Shares\Engineering\0000_File transfer\dgleba\script\tools599 "  /e  /xf watch598settings.conf /xf watch598set-litmus.filecopy.list.conf /xd libre /xf *_T_* /xd backup /xd .git /dst /fft /xo /ndl /np /r:2 /w:2 /tee /eta /log:%logf4%_engd_%random%"
timeout   35


::robocopy \\%thishostname%\c\data\script  c:\backup\%thishostname%\c_data_script  /e   /xf *._sync* /xd libre  /dst /fft /xo /ndl /np /r:0 /w:0 /tee /eta /log:%logf4%
robocopy \\PMDA-BKH70W2\data\script  c:\backup\PMDA-BKH70W2\c_data_script  /e   /xf *._sync* /xd libre  /dst /fft /xo /ndl /np /r:0 /w:0 /tee /eta /log:%logf4%_10001c_%random%"
timeout 9
robocopy \\PMDA-BKH70W2\data\script  \\PMDA-BKH70W2\data\backup\PMDA-BKH70W2\c_data_script  /e  /xf *._sync* /xd libre  /dst /fft /xo /ndl /np /r:0 /w:0 /tee /eta /log:%logf4%_10001_%random%"


robocopy c:\data\script\tools599    \\PMDA-BKH70W2\data\script\tools599  /e /L   /xf watch598settings.conf /xd libre /xf *_T_* /xd backup /dst /fft /xo /ndl /np /r:2 /w:2 /tee /eta /log:%logf4%_10001d_%random%"


timeout  132
robocopy \\PMDA-BKH70W2\data\script\tools599  c:\data\script\tools599     /e   /L /xf *._sync* /xd libre /xf *_T_*  /dst /fft /xo /ndl /np /r:2 /w:2 /tee /eta /log:%logf4%_10001d_%random%"


:~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
:~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
:~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


: examples notes offline ..



:~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


:end

timeout  133
timeout  134
timeout  135

REM echo endof rbcp dbxseaf.bat>"c:\temp\log\%ymd%\rb-dbxseafbatend-%dhms%-%random%"

