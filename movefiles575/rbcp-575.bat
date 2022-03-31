:Prepare date and temp folders [ this silly stuff requires the region to be Enginsh United States so the datetime format is  M/d/yyyy ]
set timea=%TIME: =0%
set ymd=%date:~12,2%%date:~4,2%%date:~7,2%&set dhms=%date:~12,2%%date:~4,2%%date:~7,2%_%timea:~0,2%%timea:~3,2%%timea:~6,2%
c: & md c:\temp\ & cd c:\temp & md c:\temp\log & md c:\temp\log\"%ymd%"  & cd c:\temp\log\"%ymd%"
set rand9=%random%  rem set one random for the whole job
:main
rem ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ dropbox to seaf mir

:~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

: Purpose
:
: backup 575 project files to NAS


:~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


:main

set logf4="c:\temp\log\%ymd%\rb-move_575_bu-%dhms%-%random%"
robocopy C:\data\script  \\pmda-sgenas01\PMDA-SGE\backup\mc6365_c_data_script  /e   /xf *._sync* /xd libre 6830_xml_to_csv_env /dst /fft /xo /ndl /np /r:0 /w:0 /tee /eta /log:%logf4%




:~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
:~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
:~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


: examples notes offline ..



:~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


:end

timeout  7831

REM echo endof rbcp dbxseaf.bat>"c:\temp\log\%ymd%\rb-dbxseafbatend-%dhms%-%random%"

