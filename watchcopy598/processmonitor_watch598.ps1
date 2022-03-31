# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Status: works from task scheduler

# Purpose:  this will be a script to check that watch598 is working correctly.

 # - This will be a task scheduler running every 15 minutes. It is separate from watch598
 # - it runs once and stops. 
 # - check that files are present in destination compared to source. 
 # - send email upon failure. write marker file saying email was sent. send it only once per n minutes. use setting for frequency.

 # - once per day start  C:\data\script\tools599\watchcopy598\archivetomonthfolder598.bat
     # if time is greater than 23:35:00 and less than 23:36:00 then start it. see C:\data\script\tools599\ps1-yard\12.run.between.two.times.hours.seconds.ps1

 # - check that watch598 heartbeat file timestamp string written in the file is changing. log it.



# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#  SETTINGS  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Get Contents from watch598settings
Get-Content watch598settings.conf | Foreach-Object{
    $var = $_.Split('=')
    New-Variable -Name $var[0] -Value $var[1]
 }

$global:PathToMonitor = "$s_PathToMonitor"

$global:errorEmailFrequencyMinutes = "$errorEmailFrequencyMinutes"

$script:logpath="c:\data\logs\watch598cmmresults"

$script:rundate = (Get-Date).toString("yyyy-MM-dd")

$script:lastErrorEmailSent = "C:\data\logs\watch598cmmresults\LastErrorEmailSent.txt"


$script:errorLogs = 'C:\data\logs\watch598cmmresults\processmonitor598-errorLogs.txt'
$script:debuglogpath = 'C:\data\logs\debug\'
$script:processmonitor598_runlog = 'C:\data\logs\watch598cmmresults\processmonitor598-runlog.txt'

#  SETTINGS end ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Check for other instances running. Limit to only one....

# noworky: $otherScriptInstances=get-wmiobject win32_process | where{$_.processname -eq 'powershell.exe' -and $_.ProcessId -ne $pid -and $_.commandline -match $($MyInvocation.MyCommand.Path)}

$otherScriptInstances=Get-WmiObject Win32_Process -Filter "Name='powershell.exe' AND CommandLine LIKE '%processmonitor_watch598.ps1%'" | where{$_.ProcessId -ne $pid }

write-host "PID:$pid , others:$otherScriptInstances ."
echo "PID:$pid , others:$otherScriptInstances ."| Out-File $script:debuglogpath\pm598_$mts2.txt -Append


if ($otherScriptInstances -ne $null)
{
    $mts = (Get-Date).toString("yyyyMMdd_HH.mm.ss")
    "Already running another instance. This will exit now."
    "$mts Already running another instance. This will exit now." | Out-File $global:logpath\processmonitor_oneinstancelog_$((Get-Date).toString("yyyy-MM-dd")).log.txt -Append -NoClobber
    timeout 15
    exit  
}else
{
    "No other instances running. Continue.."
    timeout 9
}
 
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


# Prep ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

cmd /c mkdir $logpath
cmd /c mkdir $debuglogpath


# Create LastErrorEmailSent if it does not exist (For first run) set content to date 400 days ago
if (!(Test-Path $script:lastErrorEmailSent))
{
   New-Item -path $script:lastErrorEmailSent -type "file" -value ""
   Set-Content -Path $script:lastErrorEmailSent -Value (Get-Date).AddDays(-400)
}

# Create ErrorLogs if it does not exist
if (!(Test-Path $script:errorLogs))
{
   New-Item -path $script:errorLogs -type "file" -value ""
}

# Write current date at run time to processmonitor run log
if (!(Test-Path $script:processmonitor598_runlog))
{
   New-Item -path $script:processmonitor598_runlog -type "file" -value ""
}

Add-Content  -Path $script:processmonitor598_runlog -Value (Get-Date)

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



function task598restart {
                write-host "taskrestt"
                $taskName = "Watch598"
                # If task is still running but error occurs
                if (($task=Get-ScheduledTask $taskName).State -eq "Running"){
                    # Stop the current scheduled task
                    Stop-ScheduledTask $taskName

                    Start-Sleep 10

                    # Start new instance of scheduled task
                    Start-ScheduledTask $taskName
                    
                    # If task is Disabled and error occurs
                } elseif (($task=Get-ScheduledTask $taskName).State -eq "Disabled") {
                    # Enable Scheduled Task
                    Enable-ScheduledTask $taskName
                    
                    Start-Sleep 10

                    # Start Scheduled Task
                    Start-ScheduledTask $taskName
                
                    # If task is ready and error occurs
                } elseif (($task=Get-ScheduledTask $taskName).State -eq "Ready") {
                    # Start Scheduled Task
                    Start-ScheduledTask $taskName
                } else {
                    continue
                }
}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#  Main code ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


# Itterate through folder A looking for files older than x minute

# Get all files containing fet from folder A
$filesForA = Get-ChildItem $global:PathToMonitor -Filter '*fet.txt*' | Where-Object {$_.LastWriteTime -lt (Get-Date).AddMinutes(-60) -and $_.LastWriteTime -ge (Get-Date).AddMinutes(-100)} 

$mts = (Get-Date).toString("yyyyMMdd_HH.mm.ss")
$mts2 = (Get-Date).toString("yyyyMMdd_HH")

(Get-Date) | Out-File $script:debuglogpath\pm598_$mts2.txt -Append
echo "filesfora = $filesForA lt= $((Get-Date).AddMinutes(-60)) ge= $((Get-Date).AddMinutes(-105))"| Out-File $script:debuglogpath\pm598_$mts2.txt -Append
echo "filesfora = $filesForA lt= $((Get-Date).AddMinutes(-60)) ge= $((Get-Date).AddMinutes(-105))"

# Check if file > x minute old in A is also in general (WORKING I THINK)
if ($filesForA.Length -gt 0) {
    foreach ($f in $filesForA) {
        

        $testpath = "C:\data\cmm\watchedoutput\general\{0}" -f $f
        write-host "dollarf: $f"
        "dollarf: $f"  | Out-File $script:debuglogpath\pm598_$mts2.txt -Append
        
        # If file is found in A that is not in General, An error will occur
        if ((Test-Path -Path $testpath -PathType Leaf) -eq $false) {
            $print = "Error Occured at {0} with file {1}" -f (Get-Date), $f
            $print | Out-File $script:errorLogs -Append
            write-host $print
            "$print"  | Out-File $script:debuglogpath\pm598_$mts2.txt -Append
             
            # Read lastEmailSend from LastErrorEmailSent.txt and assign it to variable
            $lastEmailSend = [IO.File]::ReadAllText($script:lastErrorEmailSent)
            # Convert lastEmailSend to a date object
            $lastEmailSendDate = [datetime]$lastEmailSend

            # If error is found, and time is greater than lastEmailSendDate + errorEmailFrequencyMinutes, send email and update lastemailsend textfile
            if ((Get-Date) -gt $lastEmailSendDate.AddMinutes([int]$errorEmailFrequencyMinutes)) {
                # If error is detected and time is greater than lastemailsend + errorfrequencyminutes, send email and update file
                send-mailmessage -subject "Warning: error detected by processmonitor_watch598." -body "An error (File $f was not found in General) was detected. Please check it. `n`nRef: this msg from computer: $(gc env:computername)  file: C:\data\script\tools599\watchcopy598\processmonitor_watch598.ps1" -to @("dgleba@stackpole.com") -dno onFailure -smtpServer MESG06.stackpole.ca -from 'dgleba@stackpole.com'
                Set-Content  -Path $script:lastErrorEmailSent -Value (Get-Date)

                # turnedoff 2021-08-29_Sun_13.23-PM..  task598restart
                
                Write-Host ""

            }
        }  Write-Host $filesForA.Length
    }
}




#  run at specified time frame ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


# run between two times @ ..
  [int]$shr = 23
  [int]$smin = 44
  $min = Get-Date ( "{0}:{1}:00" -f $shr, $smin )
  $max = Get-Date ( "{0}:{1}:00" -f $shr, ($smin+15) ) 
  $now = Get-Date
  # Write-Host $min $max 
  Write-Host "times: now $now  min $min  max $max"
  if ( $now.TimeOfDay -ge $min.TimeOfDay  -and $now.TimeOfDay -le $max.TimeOfDay ) {
    Write-host "Run it now.."
    #  run archiving ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    cmd /c archivetomonthfolder598.bat
    Write-Host " ran task at =  $((Get-Date).toString("yyyy-MM-dd_HH.mm.ss"))"
  }
# end. run between two times


# pause for 11 minutes so it will only run every 15 minutes.
# this is all thanks to how slow prismo1 cmm computer is.
timeout 680
