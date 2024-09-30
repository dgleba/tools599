
# move from path01 to 2

#  SETTINGS  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



$path01 = "C:\data\move\test02"
$path02 = "C:\data\move\test01"


$path01 = "C:\data\move\test01"
$path02 = "C:\data\move\test02"




#  SETTINGS end ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# $files01 = Get-ChildItem  -File -Path $path01 -ErrorAction SilentlyContinue | Where-Object { $_.CreationTime.Date -lt (Get-Date).Date } | Sort LastWriteTime -Descending | Select-Object -First 10 CreationTime,FullName | Format-Table -Wrap -verbose

$files01a = Get-ChildItem  -File -Path $path01  | Sort LastWriteTime -Descending | Select-Object -First 9 CreationTime, LastWriteTime,FullName 
foreach ($f in $files01a) {
    write-host "source file: $path01\ $f "
}

timeout 91

$files01 = Get-ChildItem  -File -Path $path01 | Sort LastWriteTime -Descending 
write-host $files01

timeout 199

# Get all folders/files  from folder A
# $files01 = Get-ChildItem $global:PathToMonitor   | Where-Object { $_.LastWriteTime -lt (Get-Date).AddMinutes(-2) } 
# write-host "files.. $filesForA"

write-host "move.."
if ($files01.Length -gt 0) {
    foreach ($f in $files01) {
        write-host "source file: $path01\$f "
        move-Item $path01\$f $path02 -verbose
        timeout 5
    }
}



