
# David Gleba # 2021-07-08
# https://stackoverflow.com/questions/29066742/watch-file-for-changes-and-run-command-with-powershell

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
        @ c:\data\script\tools599\watchcopy598.bat 
    ')

    Register-ObjectEvent $Watcher -EventName "Changed" -Action $changeAction
    Register-ObjectEvent $Watcher -EventName "Created" -Action $changeAction
}
Register-Watcher "c:\0"
