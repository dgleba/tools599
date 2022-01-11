# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Status: 

# Purpose:  move/copy files from windows task scheduler run once per minute.


#  SETTINGS  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

cmd /c cd 

$global:watchversion='47'


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


# definitions:

# 1.
# if you want some cmm's to have their litmus files moved to a particular cmm for ingestion to litmus..
#
# s_litmus_destination_host=@("pma-cmm1","nextcmmnamehere")
#
# list of hosts to move litmus files to one cmm to be picked up by litmus - cmm 10001 is \\pmda-bkh70w2 (its an array)
# just use s_litmus_destination_host="this_turned_off" and s_litmus_destination_host="this_turned_off"  if you don't want to use this feature.
# "SICS-GZPJL13" is dgleba laptop for testing.
#
# 2.
# s_litmus_destination_host="pmda-bkh70w2"
#
# destination host to move litmus files.


# get variables from settings file..     
# (Get-Content watch598settings.conf)  -match '\S'  | Where { $_ } | Foreach-Object{
Get-Content watch598settings.conf | Foreach-Object{
   $var = $_.Split('=')
   New-Variable -Name $var[0] -Value $var[1] -Scope "global" -Force
}

$global:PathToMonitor = "$s_PathToMonitor"
$global:watch_file_filter = $s_watch_file_filter

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Prep ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

cmd /c mkdir $logpath
cmd /c mkdir $logpath\debug

write-host "Starting $thisNickName $(Get-date)  $((Get-Date).toString("yyyyMMdd_HH.mm.ss")) Version $watchversion  ----------"



# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Check for other instances running. Limit to only one....

# noworky: $otherScriptInstances=get-wmiobject win32_process | where{$_.processname -eq 'powershell.exe' -and $_.ProcessId -ne $pid -and $_.commandline -match $($MyInvocation.MyCommand.Path)}

$otherScriptInstances=Get-WmiObject Win32_Process -Filter "Name='powershell.exe' AND CommandLine LIKE '%watch598e.ps1%'" | where{$_.ProcessId -ne $pid }

write-host "PID:$pid , others:$otherScriptInstances ."

if ($otherScriptInstances -ne $null)
{
    $mts = (Get-Date).toString("yyyyMMdd_HH.mm.ss")
    "Already running another instance. This will exit now."
    "$mts Already running another instance. This will exit now." | Out-File $global:logpath\watch598e_oneinstancelog_$((Get-Date).toString("yyyy-MM-dd")).log.txt -Append -NoClobber
    timeout 15
    exit  
}else
{
    "No other instances running. Continue.."
    timeout 2
}
 
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



cmd /c mkdir $PathToMonitor
cmd /c mkdir $interimfolder
cmd /c mkdir $copyToQCcalc
cmd /c mkdir $copyToGeneral
cmd /c mkdir $global:copyToLitmus
cmd /c mkdir $global:copyToLitmust3

$mts = (Get-Date).toString("yyyyMMdd_HH.mm.ss")
$cmd = "cmd /c echo Starting watch598e at $mts>>$logpath\$(gc env:computername)-$thisNickName--run-log_$((Get-Date).toString("yyyy-MM-dd")).txt"
Invoke-expression $cmd

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#  Main code ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Make a list of files N minutes old.
$isfile = get-childitem -Path $PathToMonitor -Filter '*.txt'| Where-Object { $_.LastWriteTime -lt (Get-Date).AddMinutes($minutesold) } | where-object fullname -notlike "merge_*.txt"

# if there are files to process, then do so..
if ($isfile.Length -gt 0) {
    
    # find all files that have a modification time older than N minutes and move them to interim folder. 
    # Don't move fresh files that might be unfinished.
    # This is what defines how old the files must be to be handled by this system.
    get-childitem -Path $PathToMonitor -Filter '*.txt'| Where-Object { $_.LastWriteTime -lt (Get-Date).AddMinutes($minutesold) }  |
        move-item -destination $interimfolder -verbose

    Start-Sleep 4

    # copy chr,hdr from B to E
    # remove all whitelines
    # For litmus, handle only the file names listed in the file: watch598set-litmus.filecopy.list.conf
    #
    (Get-Content watch598set-litmus.filecopy.list.conf )  -match '\S'  | Where { $_ } | Set-Content  $global:logpath\litmusfilecopylist.txt
    foreach ($item in Get-Content $global:logpath\litmusfilecopylist.txt) {
        # write-host  $item
        if (Test-Path $interimfolder\$item -PathType leaf) {
            write-host "found: $item. Copying.."
            cmd /c robocopy $interimfolder $copyToLitmus   "$item" /xo /is |  C:\prg\cygwin64\bin\grep.exe  -v '*EXTRA File'
            cmd /c robocopy $interimfolder $copyToLitmust4 "$item" /xo /is |  C:\prg\cygwin64\bin\grep.exe  -v '*EXTRA File'
        }
        else {
            write-host "NOT found: $item . do nothing."
        }
        #cmd /c robocopy $interimfolder $copyToLitmus '72.7018*chr.txt*' '72.7018*hdr.txt*' /xo /is |  C:\prg\cygwin64\bin\grep.exe  -v '*EXTRA File'
        #cmd /c robocopy $interimfolder $copyToLitmus '72.1077*chr.txt*' '72.1077*hdr.txt*' /xo /is |  C:\prg\cygwin64\bin\grep.exe  -v '*EXTRA File'
    }
    # copy all PSP part numbers to t3 for my reference temporarily. dgleba. 2021-09-09
    cmd /c robocopy $interimfolder $copyToLitmust3  '72.1077*.txt*' '72.7018*.txt*' '72.9623*.txt*' /xo  |  C:\prg\cygwin64\bin\grep.exe  -v '*EXTRA File'
    
    
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

    # from litmus-from-other-cmm
    # if this is cmm10001 - pmda-bkh70w2 - move from litmus-from-other-cmm to litmus
    # this is a local operation and should be less risk of a partial file being taken by the next process.
    echo .
    echo 'Litmus from other 2'
    echo $global:s_litmus_destination_host - ($(gc env:computername)) 
    if ( $global:s_litmus_destination_host -match ($(gc env:computername)) ) {
      echo 'moving to litmus from litmus-from-other-cmm...'
      $isfile2 = get-childitem -Path $litmusfromother -Filter '*.txt'| Where-Object { $_.CreationsTime -lt (Get-Date).AddMinutes($minutesold) } | where-object fullname -notlike "merge_*.txt"
      echo "is- $isfile2, otherfold- $litmusfromother, minut- $minutesold"
      echo " islen= $isfile2.Length"
      write-host $isfile2.Length
      if ($isfile2) {
        echo 'moving 185..'
        cmd /c robocopy  $litmusfromother $copyToLitmus /mov /is /R:3 /W:4 | C:\prg\cygwin64\bin\grep.exe  -v '*EXTRA File'
        echo "ps1 moveitem 190.."
        move-item $litmusfromother\*.txt $copyToLitmus
      }
    }
    else {
      echo 'Not moving litmus from other.'
    }
    # echo 'moving 193'
    # cmd /c robocopy  $litmusfromother $copyToLitmus /mov /is /R:3 /W:4 | C:\prg\cygwin64\bin\grep.exe  -v '*EXTRA File'

    Start-Sleep 1

    echo 'Copy all from B to C'
    cmd /c robocopy $interimfolder $copyToGeneral '*chr.txt*' '*hdr.txt*' '*fet.txt*' /xo  |  C:\prg\cygwin64\bin\grep.exe  -v '*EXTRA File'
    Start-Sleep 1

    # Move all from B to D
    $mts = (Get-Date).toString("yyyyMMdd_HH.mm.ss")
    #cmd /c robocopy $interimfolder $copyToQCcalc  '*chr.txt*' '*hdr.txt*' '*fet.txt*' /mov /is /R:3 /W:4      /log:$global:logpath\debug\robocopy.qcc_$mts.txt |  C:\prg\cygwin64\bin\grep.exe  -v '*EXTRA File'
    #cmd /c robocopy $interimfolder $copyToQCcalc  '*chr.txt*' '*hdr.txt*' '*fet.txt*' /mov /is /R:3 /W:4 /tee /log:$global:logpath\debug\robocopy.qcc_$mts.txt
    cmd /c robocopy $interimfolder $copyToQCcalc  '*chr.txt*' '*hdr.txt*' '*fet.txt*' /mov /is /R:3 /W:4 | C:\prg\cygwin64\bin\grep.exe  -v '*EXTRA File'
} else {
    write-host "--------------  NO files to process. ---------------------"
}

Stop-Transcript
timeout 6



