# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Status: 

# Purpose:  move/copy files from windows task scheduler run once per minute.


#  SETTINGS  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

cmd /c cd 

$global:interimfolder =  "C:\data\cmm\system\interimfolder"

$global:copyToQCcalc =  "C:\data\cmm\watchedoutput\qccalc"
$global:copyToGeneral = "C:\data\cmm\watchedoutput\general"
$global:copyToLitmus = "C:\data\cmm\watchedoutput\litmus"

$global:thisNickName = "watch598e"

$global:logpath="c:\data\logs\watch598cmmresults"
$global:pathPMRL = 'C:\data\logs\watch598cmmresults\processmonitor598e-runlog.txt'
#
$global:translogpath = "c:\data\logs\watch598cmmresults\debug\watch598e_debugtranscrpt"

#  SETTINGS end ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


# settings-from-file ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# get path to monitor from settings file..
Get-Content watch598settings.conf | Foreach-Object{
   $var = $_.Split('=')
   New-Variable -Name $var[0] -Value $var[1]
}

$global:PathToMonitor = "$s_PathToMonitor"
$global:watch_file_filter = $s_watch_file_filter

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Prep ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

cmd /c mkdir $logpath
cmd /c mkdir $logpath\debug
#
# start transcript logging... 
Start-Transcript -Path c:\data\logs\watch598cmmresults\debug\watch598e_debugtranscrpt_$((Get-Date).toString("yyyy-MM-dd")).log -Append -NoClobber

write-host "Starting $thisNickName $(Get-date)  ----------"



# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Check for other instances running. Limit to only one....

# noworky: $otherScriptInstances=get-wmiobject win32_process | where{$_.processname -eq 'powershell.exe' -and $_.ProcessId -ne $pid -and $_.commandline -match $($MyInvocation.MyCommand.Path)}

$otherScriptInstances=Get-WmiObject Win32_Process -Filter "Name='powershell.exe' AND CommandLine LIKE '%watch598e.ps1%'" | where{$_.ProcessId -ne $pid }

write-host "others:$otherScriptInstances , pid:$pid"

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

$mts = (Get-Date).toString("yyyyMMdd_HH.mm.ss")
$cmd = "cmd /c echo Starting watch598e at $mts>>$logpath\$(gc env:computername)-$thisNickName--run-log.txt"
Invoke-expression $cmd

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#  Main code ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# find all files that have a modification time older than n minutes and move them to interim folder. 
# Don't move fresh files that might be unfinished.
get-childitem -Path $PathToMonitor -Filter '*.txt'| Where-Object { $_.LastWriteTime -lt (Get-Date).AddMinutes(-2) }  |
    move-item -destination $interimfolder -verbose

Start-Sleep 2

# copy chr,hdr from B to E
robocopy $interimfolder $copyToLitmus '*chr.txt*' '*hdr.txt*' /xo /is
Start-Sleep 2

# Copy all from B to C
robocopy $interimfolder $copyToGeneral '*chr.txt*' '*hdr.txt*' '*fet.txt*' /xo
Start-Sleep 2

# Move all from B to D
$mts = (Get-Date).toString("yyyyMMdd_HH.mm.ss")
#robocopy $interimfolder $copyToQCcalc '*chr.txt*' '*hdr.txt*' '*fet.txt*' /mov /is /R:3 /W:4 /tee /log:$global:logpath\debug\robocopy.qcc_$mts.txt
robocopy $interimfolder $copyToQCcalc  '*chr.txt*' '*hdr.txt*' '*fet.txt*' /mov /is /R:3 /W:4
Start-Sleep 2
  
timeout 8
