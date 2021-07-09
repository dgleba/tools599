
# David Gleba # 2021-07-08
# https://stackoverflow.com/questions/29066742/watch-file-for-changes-and-run-command-with-powershell
# this tool should only need built in windows 10 tools. No need to install anything.
# 		mkdir C:\crib\watch598testfolder


# :: Settings ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

$watchedfolder = "C:\crib\watch598testfolder"


# :: Functions ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


Function Register-Watcher {
    param ($folder)
    $filter = "*.*" #all files
    $watcher = New-Object IO.FileSystemWatcher $folder, $filter -Property @{ 
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

    Register-ObjectEvent $Watcher -EventName "Changed" -Action $changeAction
    Register-ObjectEvent $Watcher -EventName "Created" -Action $changeAction
}



# :: Main ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


# Watch this folder, then copy it..
Register-Watcher $watchedfolder
