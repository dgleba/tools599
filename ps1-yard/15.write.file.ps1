# =================================================

# write to file with ps variables



# =================================================

# option 1

$mts = (Get-Date).toString("yyyy-MM-dd_HH.mm.ss")
$mtsymd = (Get-Date).toString("yyyy-MM-dd")
$ma = "mem-a"
$mb = "mb--memoryvar b"

# _____________


$logpath = "c:\data\logs\test\"
# shows output.... md -Path $logpath -Force
cmd /c if not exist $logpath mkdir $logpath 


# >1NUL  #2>&1
# new-item -Name $logpath -ItemType directory
$nickname = "writefile"
$mtext = "{0}, {1}, {2}" -f $mts, $ma, $mb
$mlogfile2 = "{0}\{1}_{2}_runlog.txt" -f $logpath, $(gc env:computername), $nickname
$mtext | Out-File -FilePath  $mlogfile2 -Append
Write-Host $mtext ";;" $mlogfile2



#cannot do this..
# $mts ",hello, " $ma | Out-File -FilePath  $logpath\15log2.txt -Append

cmd /c echo "hello " $ma " 23 "2>&1>>c:\data\logs\test\15writeb.txt
cmd /c echo `"hello 2,$ma, 33 ,`" 2>&1>>c:\data\logs\test\15writeb.txt
cmd /c echo hello 4","$ma"," 44 2>&1>>c:\data\logs\test\15writeb.txt

echo " test $ma 35"

# =================================================

# option 2

$mtsymd = (Get-Date).toString("yyyy-MM-dd")
"Victor $ma $nickname  Ashiedu" | Out-File c:\data\logs\test\15writeb.$mtsymd.txt  -Append
"Sictor $ma $nickname $((Get-Date).toString("yyyy-MM-dd_HH.mm.ss")) VAshiedu" | Out-File c:\data\logs\test\15writec.$((Get-Date).toString("yyyy-MM-dd")).txt  -Append
#-Encoding utf8



# =================================================


$otherScriptInstances=Get-WmiObject Win32_Process -Filter "Name='powershell.exe' AND CommandLine LIKE '%watch598b.ps1%'"
write-host "others $otherScriptInstances"


# =================================================
# =================================================
# =================================================

# ending..

cmd /c timeout 3
# Start-Sleep -Seconds 1
timeout 433
