# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Status: indev

# Purpose:  this will be a script to check that watch598 is working correctly.

 # - This will be a task scheduler running every 1 minutes. It is separate from watch598
 # - it runs once and stops. 
 # - check that file sizes are equal. see  C:\data\script\tools599\ps1-yard\24.cmpfilesize.ps1. log it.
 # - send email upon failure. write marker file saying email was sent. send it only once per n hours. use setting for frequency.
 # - call 24.cmpfilesize.ps1 cmpfilesize598.ps1

 # - once per day start  C:\data\script\tools599\watchcopy598\archivetomonthfolder598.bat
     # if time is greater than 23:35:00 and less than 23:36:00 then start it. see C:\data\script\tools599\ps1-yard\12.run.between.two.times.hours.seconds.ps1



 # - may not need heartbeat.
 # - check that watch598 heartbeat file timestamp string written in the file is changing. log it.

 # - later: restart it.




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

$script:errorLogs = 'C:\data\logs\watch598cmmresults\processmonitor598-errorLogs.txt'

$script:lastErrorEmailSent = "C:\data\logs\watch598cmmresults\LastErrorEmailSent.txt"


#  SETTINGS end ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


# Prep ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


# Create LastErrorEmailSent if it does not exist (For first run)
if (!(Test-Path $script:lastErrorEmailSent))
{
   New-Item -path $script:lastErrorEmailSent -type "file" -value ""
}

# Create ErrorLogs if it does not exist
if (!(Test-Path $script:errorLogs))
{
   New-Item -path $script:errorLogs -type "file" -value ""
}


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#  Main code ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Itterate through folder A looking for files older than 2 minute

# Get all files containing fet from folder A
# $filesForA = Get-ChildItem $global:PathToMonitor -Filter '*fet.txt*' | Where-Object {$f.LastWriteTime -lt (Get-Date).AddMinutes(-2)} | Where-Object {$f.LastWriteTime -gt (Get-Date).AddMinutes(-122)}
$filesForA = Get-ChildItem $global:PathToMonitor -Filter '*fet.txt*' | Where-Object {$_.LastWriteTime -lt (Get-Date).AddMinutes(-2) -and $_.LastWriteTime -ge (Get-Date).AddMinutes(-30} 
(Get-Date) | Out-File $script:logpath\pm598dgts1.txt -Append

# Check if file > 1 minute old in A is also in general (WORKING I THINK)
if ($filesForA.Length -gt 0) {
    foreach ($f in $filesForA) {
        
        $testpath = 'C:\data\cmm\watchedoutput\general\{0}' -f $f
        write-host $f
        $f  | Out-File $script:logpath\pm598dgts1.txt -Append
        
        # If file is found in A that is not in General, An error will occur
        if ((Test-Path -Path $testpath -PathType Leaf) -eq $false) {
            $print = "Error Occured at {0} with file {1}" -f (Get-Date), $f
            $print | Out-File $script:errorLogs -Append
            write-host $print
            
            # Read lastEmailSend from LastErrorEmailSent.txt and assign it to variable
            $lastEmailSend = [IO.File]::ReadAllText($script:lastErrorEmailSent)
            # If LastErrorEmailSent.txt is not empty (not the first time being run) convert lastEmailSend to a date object
            if ($lastEmailSend -ne ""){
                $lastEmailSendDate = [datetime]$lastEmailSend
            }

            # First time error occurs, email will be sent and lastemailsend will be updated in textfile
            if ($lastEmailSend -eq "") {
                send-mailmessage -subject "Warning: error detected by processmonitor_watch598." -body "An error (LastEmailSent File is Blank) was detected. Cause of error: $f Please check it. `n`nRef: this msg from computer: $(gc env:computername)  file:   C:\data\script\tools599\watchcopy598\processmonitor_watch598" -to @("dgleba@stackpole.com") -dno onFailure -smtpServer MESG06.stackpole.ca -from 'dgleba@stackpole.com'
                Set-Content  -Path $script:lastErrorEmailSent -Value (Get-Date)
            } 
            # If error is found, and time is greater than lastEmailSendDate + errorEmailFrequencyMinutes, send email and update lastemailsend textfile
            elseif ((Get-Date) -gt $lastEmailSendDate.AddMinutes([int]$errorEmailFrequencyMinutes)) {
                # If error is detected and time is greater than lastemailsend + errorfrequencyminutes, send email and update file
                send-mailmessage -subject "Warning: error detected by processmonitor_watch598." -body "An error (File $f was not found in General) was detected. Please check it. `n`nRef: this msg from computer: $(gc env:computername)  file: C:\Users\dgleba\Desktop\tools599-main\watchcopy598\processmonitor_watch598" -to @("dgleba@stackpole.com") -dno onFailure -smtpServer MESG06.stackpole.ca -from 'dgleba@stackpole.com'
                Set-Content  -Path $script:lastErrorEmailSent -Value (Get-Date)
            }
        }  
    }
}



#  run archiving ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



timeout 5
