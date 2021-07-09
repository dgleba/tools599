
# David Gleba # 2021-07-08
# this tool should only need built in windows 10 tools. No need to install anything.

# orginal post..
# https://stackoverflow.com/questions/29066742/watch-file-for-changes-and-run-command-with-powershell

# :: notes ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


# naming the watcher?
# https://devblogs.microsoft.com/powershell-community/a-reusable-file-system-event-watcher-for-powershell/
# -SourceIdentifier "watchtest598a" 
# https://powershell.one/tricks/filesystem/filesystemwatcher

# https://mcpmag.com/articles/2019/05/01/monitor-windows-folder-for-new-files.aspx
# We can view all existing subscribed events by using the Get-EventSubscriber command. Then, to remove them, use the Unregister-Event cmdlet.

# list events
# Get-EventSubscriber

# remove all..
# Get-EventSubscriber | Unregister-Event



# :: prep ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# run this once..
# 		mkdir C:\crib\watch598testfolder


# :: Settings ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

$watchedfolder = "C:\crib\watch598testfolder"


# :: Functions ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


Function Register-Watcher {
    param ($folder)
    $filter = "*.*" #all files
    $watcher = New-Object IO.FileSystemWatcher $folder,  $filter -Property @{ 
        IncludeSubdirectories = $false
        EnableRaisingEvents = $true
    }

    $changeAction = [scriptblock]::Create('
        # This is the code which will be executed every time a file change is detected
        $path = $Event.SourceEventArgs.FullPath
        $name = $Event.SourceEventArgs.Name
        $changeType = $Event.SourceEventArgs.ChangeType
        $timeStamp = $Event.TimeGenerated
        Write-Host "The file $name was $changeType at $timeStamp"
        # https://ss64.com/ps/call.html
        & C:\data\script\tools599\watchcopy598\watchcopy598.bat
    ')

    Register-ObjectEvent $Watcher -EventName "Changed" -Action $changeAction -SourceIdentifier "w598changed" 
    Register-ObjectEvent $Watcher -EventName "Created" -Action $changeAction -SourceIdentifier "w598created" 
}



# :: Main ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


# Watch this folder, then copy it..
Register-Watcher $watchedfolder
