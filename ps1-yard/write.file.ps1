# =================================================

# write to file with ps variables



# =================================================

# option 1

$mts = (Get-Date).toString("yyyy-MM-dd_HH.mm.ss")
$mtsymd = (Get-Date).toString("yyyy-MM-dd")
$ma = "ma"
$mb = "memoryvar b"
$mf = "callcmdwithpsvariables-log.txt"
$marg = "echo {0}, {1}, {2}, {3} >>{4}_{5}" -f $mts, $ma, $mb, $(gc env:computername), $mtsymd, $mf

$logpath = "c:\data\test\logs"
cmd /c mkdir $logpath>NULL
$nickname = "writefile"

$mtext = "{0}, {1}, {2}" -f $mts, $ma, $mb
$mlogfile2 = "{0}\{1}_{2}_runlog.txt" -f $logpath, $(gc env:computername), $nickname
$mtext | Out-File -FilePath  $mlogfile2 -Append
Write-Host $mtext 
Write-Host $mlogfile2


# =================================================

# option 2



# =================================================



# =================================================
# =================================================
# =================================================

# ending..

cmd /c timeout 1
# Start-Sleep -Seconds 1

