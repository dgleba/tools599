
#  SETTINGS  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

$global:PathToMonitor = "C:\data\cmm\system\temp3file"

#  SETTINGS end ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


# Get all folders/files  from folder A
$filesForA = Get-ChildItem $global:PathToMonitor   | Where-Object { $_.LastWriteTime -lt (Get-Date).AddMinutes(-11) } 
write-host "files.. $filesForA"

write-host "delete.."
if ($filesForA.Length -gt 0) {
    foreach ($f in $filesForA) {
        write-host " $global:PathToMonitor\$f "
        Remove-Item $global:PathToMonitor\$f -Recurse -force
    }
}

