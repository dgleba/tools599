
$folder="C:\Temp"

$r = Get-Childitem $folder *.chr.txt -Recurse | 
     Where-Object {$_.CreationTime -gt (Get-Date).Date } | 
     Measure-Object

if ($r.Count -ge 100) {
    write-host "More than 100 files created under $folder" 
} else {
    write-host "Less than 100 files created under $folder"
}

write-host $r.Count

$RequiredNumberOfFiles = 5
$a = (Get-ChildItem 'C:\temp'  *.chr.txt | Where-Object { $_.CreationTime -gt (get-date -format d)}).count
write-host $a
If ($a -eq $RequiredNumberOfFiles) {write-host "success"} else {write-host "fail"}

