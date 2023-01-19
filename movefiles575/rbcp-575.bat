:Prepare date and temp folders [ this silly stuff requires the region to be Enginsh United States so the datetime format is  M/d/yyyy ]
set timea=%TIME: =0%
set ymd=%date:~8,2%%date:~3,2%%date:~0,2%&set dhms=%date:~8,2%%date:~3,2%%date:~0,2%_%timea:~0,2%%timea:~3,2%%timea:~6,2%
c: & md c:\temp\ & cd c:\temp & md c:\temp\log & md c:\temp\log\"%ymd%"  & cd c:\temp\log\"%ymd%"
set rand9=%random%  rem set one random for the whole job
echo "%ymd%" "%dhms%"
:main
rem ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ dropbox to seaf mir

:~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

: Purpose
:
: backup 575 project files to NAS


:~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


:main

set logf4="c:\temp\log\%ymd%\rb-move_575_bu-%dhms%-%random%"
robocopy d:\data\script\tools599  \\pmda-sgenas01\PMDA-SGE\backup\mc6365_c_data_script\tools599  /e     ^
 /xf *._sync* /xd venv001 6830_xml_to_csv_env vision_performance_tracker_report_env zTS .git  /dst /fft /xo /ndl /np /r:0 /w:0 /tee /eta /log:%logf4%


robocopy d:\data\script\tools599  \\10.4.65.190\Images\sw\copyof\data_script\tools599  /e     ^
 /xf *._sync* /xd venv001 6830_xml_to_csv_env vision_performance_tracker_report_env zTS .git  /dst /fft /xo /ndl /np /r:0 /w:0 /tee /eta /log:%logf4%




:~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
:~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
:~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


: examples notes offline ..



:~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


:end

timeout  7831

REM echo endof rbcp dbxseaf.bat>"c:\temp\log\%ymd%\rb-dbxseafbatend-%dhms%-%random%"

