# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Status: works from windows task scheduler

# Purpose:  watch a folder for changes and copy files.

# https://community.idera.com/database-tools/powershell/powertips/b/tips/posts/using-filesystemwatcher-correctly-part-2


#  SETTINGS  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


$global:interimfolder =  "C:\data\cmm\system\interimfolder"

$global:copyToQCcalc =  "C:\data\cmm\watchedoutput\qccalc"

$global:copyToGeneral = "C:\data\cmm\watchedoutput\general"

$global:copyToLitmus = "C:\data\cmm\watchedoutput\litmus"

$global:temp3file = 'C:\data\cmm\system\temp3file'


$global:thisNickName = "watch598-b-cmm-ps1"

$global:rundate = (Get-Date).toString("yyyy-MM-dd")

$global:logpath="c:\data\logs\watch598cmmresults"
$global:pathPMRL = 'C:\data\logs\watch598cmmresults\processmonitor598-runlog.txt'
#
# i can't get this to work..
$global:translogpath = "c:\data\logs\watch598cmmresults\debug\watch598_debugtranscrpt"
# trouble getting this to work. "{0}\de...
# $global:transcriptlogpath = "{0}\debug\watch598_debugtranscrpt" -f $logpath
# $global:transcriptlogpath = "$global:logpath\debug\watch598_debugtranscrpt"
# add this in place below. $global:transcriptlogpath_$((Get-Date).toString("yyyy-MM-dd_HH.mm.ss")).log

# $global:copyToA2 = "C:\data\cmm\system\A2"

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
Start-Transcript -Path c:\data\logs\watch598cmmresults\debug\watch598_debugtranscrpt_$((Get-Date).toString("yyyy-MM-dd_HH.mm.ss")).log
# path not working in this..
# Start-Transcript -Path $global:logpath_$((Get-Date).toString("yyyy-MM-dd_HH.mm.ss")).log
#Start-Transcript -Path $global:translogpath_$((Get-Date).toString("yyyy-MM-dd_HH.mm.ss")).log
# write-host $global:translogpath_$((Get-Date).toString("yyyy-MM-dd_HH.mm.ss")).log


cmd /c mkdir $PathToMonitor
cmd /c mkdir $interimfolder
cmd /c mkdir $copyToQCcalc
cmd /c mkdir $copyToGeneral
cmd /c mkdir $global:copyToLitmus
cmd /c mkdir $global:temp3file
# cmd /c mkdir $global:copyToA2


# save process id to file. Could use this to check later that is still running.
$tsdhms = $((Get-Date).toString("yyyy-MM-dd_HH.mm.ss"))
$carg = "echo {0}, {1}>>{2}\{3}_{4}_pid__log.txt" -f $pid, $tsdhms, $logpath,$(gc env:computername), $thisNickName
cmd /c $carg

$carg = "echo {0}>{1}\{2}_{3}_pid.txt" -f $pid, $logpath,$(gc env:computername), $thisNickName
cmd /c $carg

$mts = (Get-Date).toString("yyyyMMdd_HH.mm.ss")
$cmd = "cmd /c echo Starting watch598 at $mts>>$logpath\$(gc env:computername)-$thisNickName--run-log.txt"
Invoke-expression $cmd

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#  Main code ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


# on startup, handle chr,fet,hdr files in folder A

# Get last modification time of general folder to find when the last files were added
$lastModTimeGeneral = (Get-item $copyToGeneral).lastwritetime
Write-Host $lastModTimeGeneral

# find all files that have a modification time later than lastmodificationtime in A and move them to interim folder
get-childitem -Path $PathToMonitor -Filter '*hdr.txt*' |  where-object {$_.LastWriteTime -gt $lastModTimeGeneral} | 
    copy-item -destination $interimfolder
get-childitem -Path $PathToMonitor -Filter '*chr.txt*' |  where-object {$_.LastWriteTime -gt $lastModTimeGeneral} | 
    copy-item -destination $interimfolder
get-childitem -Path $PathToMonitor -Filter '*fet.txt*' |  where-object {$_.LastWriteTime -gt $lastModTimeGeneral} | 
    copy-item -destination $interimfolder


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



$FileSystemWatcher = New-Object System.IO.FileSystemWatcher
$FileSystemWatcher.Path  = "$PathToMonitor"
$FileSystemWatcher.Filter  = $watch_file_filter
$FileSystemWatcher.IncludeSubdirectories = $false

# make sure the watcher emits events
$FileSystemWatcher.EnableRaisingEvents = $true

# define the code that should execute when a file change is detected
$Action = {
  $details = $event.SourceEventArgs
  $Name = $details.Name
  $FullPath = $details.FullPath
  $OldFullPath = $details.OldFullPath
  $OldName = $details.OldName
  $ChangeType = $details.ChangeType
  $Timestamp = $event.TimeGenerated

  $cmd = "cmd /c echo $FullPath, $ChangeType, $Timestamp>>$logpath\$(gc env:computername)-$thisNickName--run-log.txt"
  Invoke-expression $cmd
  # Write-Host ""
  # Write-Host $cmd
  
  # $carg = "echo {0}, {1}, {2}>>{3}\{4}_{5}_run-log.txt" -f $FullPath, $ChangeType, $Timestamp, $logpath, $(gc env:computername), $thisNickName
  # cmd /c $carg
  # Write-Host ""
  # Write-Host $carg


  $text = "{0} was {1} at {2} {3} " -f $FullPath, $ChangeType, $Timestamp, (get-date)
  Write-Host ""
  Write-Host $text -ForegroundColor Green
  
  # copy the files to both locations..
  
  Write-Host "wf: $watch_file_filter"
  Write-Host $Name
  
  # #debug..
  # Write-Host "$cmd"

  # you can also execute code based on change type here
  switch ($ChangeType)
    {
    'Changed' {

    $print = "changed switch: copying. file CHANGED  {0} {1}" -f (Get-Date), $FullPath
    $print | Out-File 'C:\data\logs\watch598cmmresults\changed598logs.txt' -Append

    # Check if file is correct type
    if ($Name -match 'chr.txt' -or $Name -match 'hdr.txt' -or $Name -match 'fet.txt') {

      # Get filename of changed file - ending filetype
      $nameSliced = $Name.Substring(0,$Name.Length-7)
      
      
      # Check if folder named nameSliced exists and if not, create folder
      $pathtemp3file = '{0}\{1}' -f $global:temp3file, $nameSliced
      If(!(test-path $pathtemp3file)) {
        New-Item -ItemType Directory -Force -Path $pathtemp3file
      }

      # Copy file to its corresponding temp3file folder
      robocopy $PathToMonitor $pathtemp3file $Name /xo
      Start-Sleep 1

      # Check if all 3 files have made it into temp3file folder
      $filechr = $nameSliced + "chr.txt"
      $filehdr = $nameSliced + "hdr.txt"
      $filefet = $nameSliced + "fet.txt"
      
      $chrfound = Test-Path -Path ($pathtemp3file + "\" + $filechr) -PathType Leaf
      $hdrfound = Test-Path -Path ($pathtemp3file + "\" + $filehdr) -PathType Leaf
      $fetfound = Test-Path -Path ($pathtemp3file + "\" + $filefet) -PathType Leaf
      write-host "DEBUG: $((Get-Date).toString("yyyy-MM-dd_HH.mm.ss")), namesliced:$nameSliced , filechr:$filechr , chrfound:$chrfound, pathtemp3file:$pathtemp3file"
      
      # If they are all present in the folder, process files and remove folder
      # if (2021-08-13_Fri_09.12-AM $chrfound -and $hdrfound -and $fetfound) {
      if ( $chrfound -and $hdrfound -and $fetfound) {
        Start-Sleep 8
        # Copy notified files from A to B
        $mts = (Get-Date).toString("yyyyMMdd_HH.mm.ss")
        robocopy $PathToMonitor $interimfolder $filechr $filehdr $filefet /mov /xo /is  /R:3 /W:4 /tee /log:$global:logpath\debug\robocopy.monitor-interim_$mts.txt
        # robocopy $PathToMonitor $interimfolder  $filehdr $filefet /tee /log+:$logpath.robocopy.interm.txt
        Start-Sleep 2

        # copy chr,hdr from B to E
        robocopy $interimfolder $copyToLitmus '*chr.txt*' '*hdr.txt*' /xo
        Start-Sleep 1

        # Copy all from B to C
        robocopy $interimfolder $copyToGeneral '*chr.txt*' '*hdr.txt*' '*fet.txt*' /xo
        Start-Sleep 1
        
        # Move all from B to D
        $mts = (Get-Date).toString("yyyyMMdd_HH.mm.ss")
        #robocopy $interimfolder $copyToQCcalc '*chr.txt*' '*hdr.txt*' '*fet.txt*' /mov /is /R:3 /W:4 /tee /log:$global:logpath\debug\robocopy.qcc_$mts.txt
        robocopy $interimfolder $copyToQCcalc  '*chr.txt*' '*hdr.txt*' '*fet.txt*' /mov /is /R:3 /W:4
        Start-Sleep 1

        # Delete temp3file folder and files
        $pathtrim = $pathtemp3file.Substring(0,$pathtemp3file.Length-1)
        Remove-Item $pathtrim -Recurse
        write-host "DEBUG: $((Get-Date).toString("yyyy-MM-dd_HH.mm.ss")), delete temp folder pathtemp3file=$pathtemp3file, pathtrim=$pathtrim"

      } 
      # If they arent all present continue looking
      else {
        break
      }
      
    } else {
      break
    }

    }
    'Created' { 
        $print = "FILE CREATED AT {0} {1}" -f (Get-Date), $FullPath
        $print | Out-File 'C:\data\logs\watch598cmmresults\created598logs.txt' -Append
    }
    'Deleted' { "DELETED"
    # uncomment the below to mimick a time intensive handler
    <#
    Write-Host "Deletion Handler Start" -ForegroundColor Gray
    Start-Sleep -Seconds 4    
    Write-Host "Deletion Handler End" -ForegroundColor Gray
    #>
   }
     'Renamed' { 
      # this executes only when a file was renamed
      $text = "File {0} was renamed to {1}" -f $OldName, $Name
      Write-Host $text -ForegroundColor Yellow
    }
    default { 
    Write-Host "default." -ForegroundColor Red -BackgroundColor White 
    Write-Host $_ -ForegroundColor Red -BackgroundColor White 
    }
  }
}


# add event handlers
$handlers = . {
  Register-ObjectEvent -InputObject $FileSystemWatcher -EventName Changed -Action $Action -SourceIdentifier FSChange
  Register-ObjectEvent -InputObject $FileSystemWatcher -EventName Created -Action $Action -SourceIdentifier FSCreate
  # Register-ObjectEvent -InputObject $FileSystemWatcher -EventName Deleted -Action $Action -SourceIdentifier FSDelete
  # Register-ObjectEvent -InputObject $FileSystemWatcher -EventName Renamed -Action $Action -SourceIdentifier FSRename
}

Write-Host "Watching for changes to $PathToMonitor, file filter:  $watch_file_filter" 

try
{
  do
  {
    # `-Timeout 10` is wait 10 seconds in loop.
    Write-Host "." -NoNewline
    Wait-Event -Timeout 10
      
    #  
    #  Check if process monitor is functioning..
    #  
    # run once per hour @ $smin
    [int]$shr = get-date -format HH
    [int]$smin = 18
    $min = Get-Date ("{0}:{1}:00" -f $shr, $smin)
    $max = Get-Date ("{0}:{1}:10" -f $shr, $smin) 
    $now = Get-Date
    if ( $now.TimeOfDay -ge $min.TimeOfDay  -and $now.TimeOfDay -le $max.TimeOfDay ) {
      Write-host "Do hourly stuff now..."
      # get last line of processmonitor run-log
      $last = Get-Item -Path $global:pathPMRL | Get-Content -Tail 1
      # If pathPMRL file is empty (prevents crash)
      if ($last.Length -lt 1){
        continue
      }
      else {
        # Convert time to date object
        $lastline = [datetime]$last
        #debug
        "$((Get-Date).toString("yyyy-MM-dd_HH.mm.ss")), last=$last, lastine=$lastline" | Out-File `
           $global:logpath\debug\watch598.debug_$((Get-Date).toString("yyyy-MM-dd")).txt  -Append

        # If current date > lastline + 10 mins report an error
        if ((Get-Date) -gt $lastline.AddMinutes(12)) {
          send-mailmessage -subject "[watch598] Error -- processmonitor problem." -body "An error (processmonitor_watch598 has stopped working) was detected. Please check it. `n`nRef: this msg from computer: $(gc env:computername)  file: C:\data\script\tools599\watchcopy598\processmonitor_watch598.ps1" -to @("dgleba@stackpole.com") -dno onFailure -smtpServer MESG06.stackpole.ca -from 'dgleba@stackpole.com'
        } else {
          continue
        }
      } 
      (Get-Date).toString("yyyy-MM-dd_HH.mm.ss")|Write-Host
    }
    # end. run once per hour  
    
    #
    # Once per day stop-start transcript log.
    #
    # Run between two times - 10 sec window
      [int]$shr = 00
      [int]$smin = 00
      $min = Get-Date ("{0}:{1}:00" -f $shr, $smin)
      $max = Get-Date ("{0}:{1}:10" -f $shr, $smin) 
      $now = Get-Date
      # Write-Host $min $max 
      # Write-Host "10s times: now $now  min $min  max $max"
      # check if it is time to run it.
      if ( $now.TimeOfDay -ge $min.TimeOfDay  -and $now.TimeOfDay -le $max.TimeOfDay ) {
        Write-host "once daily Run it now. stop-start transcript.."
        Stop-Transcript
        # Start-Sleep 1
        Start-Transcript -Path c:\data\logs\watch598cmmresults\debug\watch598_debugtranscrpt_$((Get-Date).toString("yyyy-MM-dd_HH.mm.ss")).log
      }
    # .end. run between two times - 10 sec window
    #
    
    
  } while ($true)
}

finally
{
  # this gets executed when user presses CTRL+C
  # remove the event handlers
  Unregister-Event -SourceIdentifier FSChange
  Unregister-Event -SourceIdentifier FSCreate
  # Unregister-Event -SourceIdentifier FSDelete
  # Unregister-Event -SourceIdentifier FSRename
  # remove background jobs
  $handlers | Remove-Job
  # remove filesystemwatcher
  $FileSystemWatcher.EnableRaisingEvents = $false
  $FileSystemWatcher.Dispose()
  "Event Handler disabled."
}
