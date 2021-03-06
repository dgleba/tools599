
# Status: 

# Purpose:  watch a folder for changes and copy files. Can be edited to use for cmm chr files.

# https://community.idera.com/database-tools/powershell/powertips/b/tips/posts/using-filesystemwatcher-correctly-part-2

# Settings ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# make sure you adjust this to point to the folder you want to monitor
$PathToMonitor = "c:\crib\d598"

$copypath = "C:\crib\d598copy"

$thispsfilename= "d598watch-ps1"


# Settings ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


# save process id to file. Could use this to check later that is still running.
$Stamp = (Get-Date).toString("yyyy-MM-dd_HH.mm.ss")
cmd /c echo $pid "," $Stamp>>c:\crib\logs\""$thispsfilename__pid"".log
cmd /c echo $pid>c:\crib\logs\$thispsfilename__pid.txt
	
	
cmd /c mkdir $copypath	
cmd /c mkdir c:\crib\logs	
	
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



$FileSystemWatcher = New-Object System.IO.FileSystemWatcher
$FileSystemWatcher.Path  = $PathToMonitor
$FileSystemWatcher.Filter  = "*chr.txt"
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
    Start-Sleep -Seconds 1
    $text = "{0} was {1} at {2} " -f $FullPath, $ChangeType, $Timestamp
    Write-Host ""
    Write-Host $Stamp
    Write-Host $text -ForegroundColor Green

    # you can also execute code based on change type here
    switch ($ChangeType)
    {
        'Changed' { "CHANGE" 
		}
        'Created' { "CREATED"
			# dgleba stamp
			$Stamp = (Get-Date).toString("yyyy-MM-dd_HH.mm.ss")
			cmd /c echo $thispsfilename, $Stamp, $FullPath>>"c:\crib\logs\"$(gc env:computername)"_"$thispsfilename".log"
			# & robocopy  C:\crib\c598 C:\crib\c598copy /e
			cmd /c copy $Fullpath" "$copypath
					
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
        default { Write-Host $_ -ForegroundColor Red -BackgroundColor White }
    }
}

# add event handlers
$handlers = . {
    Register-ObjectEvent -InputObject $FileSystemWatcher -EventName Changed -Action $Action -SourceIdentifier FSChange
    Register-ObjectEvent -InputObject $FileSystemWatcher -EventName Created -Action $Action -SourceIdentifier FSCreate
    Register-ObjectEvent -InputObject $FileSystemWatcher -EventName Deleted -Action $Action -SourceIdentifier FSDelete
    Register-ObjectEvent -InputObject $FileSystemWatcher -EventName Renamed -Action $Action -SourceIdentifier FSRename
}

Write-Host "Watching for changes to $PathToMonitor"

try
{
    do
    {
		# 3 is wait 3 seconds in loop.
        Wait-Event -Timeout 3
        Write-Host "." -NoNewline
        
    } while ($true)
}
finally
{
    # this gets executed when user presses CTRL+C
    # remove the event handlers
    Unregister-Event -SourceIdentifier FSChange
    Unregister-Event -SourceIdentifier FSCreate
    Unregister-Event -SourceIdentifier FSDelete
    Unregister-Event -SourceIdentifier FSRename
    # remove background jobs
    $handlers | Remove-Job
    # remove filesystemwatcher
    $FileSystemWatcher.EnableRaisingEvents = $false
    $FileSystemWatcher.Dispose()
    "Event Handler disabled."
}
