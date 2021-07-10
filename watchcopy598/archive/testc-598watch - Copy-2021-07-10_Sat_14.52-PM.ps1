
# save process id to file. Could use this to check later that is still running.
    cmd /c echo $pid>c:\crib\logs\testc-598watch-ps1.pid
	
# https://community.idera.com/database-tools/powershell/powertips/b/tips/posts/using-filesystemwatcher-correctly-part-2


# make sure you adjust this to point to the folder you want to monitor
$PathToMonitor = "c:\crib\c598"

# explorer $PathToMonitor


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Cant get this to work.


# Function Write-Log {

# # https://stackoverflow.com/questions/7834656/create-log-file-in-powershell

	# $logfile = "c:\crib\logs\$(gc env:computername).log"

    # [CmdletBinding()]
    # Param(
    # [Parameter(Mandatory=$False)]
    # [ValidateSet("INFO","WARN","ERROR","FATAL","DEBUG")]
    # [String]
    # $Level = "INFO",

    # [Parameter(Mandatory=$True)]
    # [string]
    # $Message,

    # [Parameter(Mandatory=$False)]
    # [string]
    # $logfile
    # )

    # $Stamp = (Get-Date).toString("yyyy/MM/dd HH:mm:ss")
    # $Line = "$Stamp $Level $Message"
    # If($logfile) {
        # Add-Content $logfile -Value $Line
    # }
    # Else {
        # Write-Output $Line
    # }
# }


Function LogWrite
{

	$Logfile =  "c:\crib\logs\$(gc env:computername).log"
   Param ([string]$logstring)

	$Stamp = (Get-Date).toString("yyyy-MM-dd_HH.mm.ss")
    Add-content $Logfile -value $logstring 
	# $Stamp
}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~





$FileSystemWatcher = New-Object System.IO.FileSystemWatcher
$FileSystemWatcher.Path  = $PathToMonitor
$FileSystemWatcher.IncludeSubdirectories = $true

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
	# dgleba stamp
	$Stamp = (Get-Date).toString("yyyy-MM-dd_HH.mm.ss")
    $text = "{0} was {1} at {2} {3}" -f $FullPath, $ChangeType, $Timestamp, $Stamp

    cmd /c echo testc-598watch.ps1, $Stamp>>c:\crib\logs\$(gc env:computername)_testc-598watch-ps1.log
	& robocopy  C:\crib\c598 C:\crib\c598copy /e
	# LogWrite "hello"
	# LogWrite "ran C:\data\script\tools599\watchcopy598\testc-598watch.ps1"
 	#& echo ran $Stamp>>c:\crib\logs\log.testc-598watch.ps1-2.log
    
    Write-Host ""
    Write-Host $Stamp
    Write-Host $text -ForegroundColor Green

    # you can also execute code based on change type here
    switch ($ChangeType)
    {
        'Changed' { "CHANGE" }
        'Created' { "CREATED"}
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
