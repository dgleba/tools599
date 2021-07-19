# =================================================

# write to file with ps variables



# =================================================

# option 1

$mts = (Get-Date).toString("yyyy-MM-dd_HH.mm.ss")
$mtsymd = (Get-Date).toString("yyyy-MM-dd")
$ma = "ma"
$mb = "mb--memoryvar b"

# _____________


$logpath = "c:\data\test\logs"
# shows output.... md -Path $logpath -Force
cmd /c if not exist $logpath mkdir $logpath 
# >1NUL  #2>&1
# new-item -Name $logpath -ItemType directory
$nickname = "writefile"
$mtext = "{0}, {1}, {2}" -f $mts, $ma, $mb
$mlogfile2 = "{0}\{1}_{2}_runlog.txt" -f $logpath, $(gc env:computername), $nickname
$mtext | Out-File -FilePath  $mlogfile2 -Append
Write-Host $mtext ";;" $mlogfile2


# =================================================

# option 2



# =================================================



# =================================================
# =================================================
# =================================================

# ending..

cmd /c timeout 3
# Start-Sleep -Seconds 1

