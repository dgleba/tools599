# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Status: 

# Purpose:  test rb copy to central

#  SETTINGS  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

cmd /c cd 

$global:watchversion='944'

# Number of minutes old the modified timestamp is on the files to handle.
$global:minutesold=-1

$global:interimfolder =  "C:\data\cmm\system\interimfolder"

$global:copyToQCcalc =  "C:\data\cmm\watchedoutput\qccalc"
$global:copyToGeneral = "C:\data\cmm\watchedoutput\general"
$global:copyToLitmus = "C:\data\cmm\watchedoutput\litmus"
$global:litmusfromother = "C:\data\cmm\system\litmus-from-other-cmm"

# temporarily copy some files here for my interest.
$global:copyToLitmust3 = "C:\data\cmm\system\litmus_tmp3"
$global:copyToLitmust4 = "C:\data\cmm\system\litmus_tmp4"

$global:thisNickName = "watch598e"

# log paths..

$global:pathPMRL = 'C:\data\logs\watch598cmmresults\processmonitor598e-runlog.txt'
#
$global:logpath="c:\data\logs\watch598cmmresults"
#
# start transcript logging... 
# I cannot get this to accept $logpath. Only accepting hard coded path..
Start-Transcript -Path c:\data\logs\watch598cmmresults\debug\watch598e_debugtranscrpt_$((Get-Date).toString("yyyy-MM-dd_HH")).log -Append -NoClobber

$global:translogpath = "c:\data\logs\watch598cmmresults\debug\watch598e_debugtranscrpt"


#  SETTINGS end ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# settings-from-file ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# get variables from settings file..
Get-Content watch598settings.conf | Foreach-Object{
   $var = $_.Split('=')
   New-Variable -Name $var[0] -Value $var[1] -Scope "global" -Force
}

$global:PathToMonitor = "$s_PathToMonitor"
$global:watch_file_filter = $s_watch_file_filter

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

$mts = (Get-Date).toString("yyyyMMdd_HH.mm.ss")
$cmd = "cmd /c echo Starting watch598e at $mts>>$logpath\$(gc env:computername)-$thisNickName--run-log_$((Get-Date).toString("yyyy-MM-dd")).txt"
Invoke-expression $cmd

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#  Main code ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    # to litmus-from-other-cmm
    # if these settings refer to valid hosts present in your system, move the litmus files to destination computer for litmus to pick them up. 
    if ( $global:s_litmus_move_from_host_array.contains($(gc env:computername)) ) {
      echo 'moving to cmm 10001...'
      # copying to cmm10001 \result means that qccalc will ingest the files twice. once on on the source cmm and once on the destination.
      # copy to \litmus-data-cmm
      robocopy $copyToLitmus  "\\$s_litmus_destination_host\litmus-from-other-cmm\"  /mov /is /R:3 /W:4 | C:\prg\cygwin64\bin\grep.exe  -v '*EXTRA File'
    }
    else {
      echo 'Not moving litmus to central pc.'
    }


timeout 623

