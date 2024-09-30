# =================================================

# in a loop, write heartbeat file every 55 seconds.
# the loop is 5 seconds. write heartbeat each 11 times.

# =================================================

# settings

$global:logpath = "c:\data\test\logs"
cmd /c if not exist $logpath mkdir $logpath 
$global:mlogfile2 = "{0}\{1}_{2}_heartbeat.txt" -f $logpath, $(gc env:computername), $nickname
$global:nickname = "23writelogeach55"
      
#initialize      
"'" | Out-File -FilePath  $mlogfile2
$cnt=0
      
# =================================================

$mts = (Get-Date).toString("yyyyMMdd_HH.mm.ss")
Write-Host $mts ";;" 

try
{
  do
  {
    # -Timeout 5 is wait 5 seconds in loop.
    Write-Host "." -NoNewline
    Wait-Event -Timeout 5
    
    # write heartbeat each 11 times. 11 * 5 = 55 seconds.
    $cnt = $cnt+1
    If ($cnt -eq 11) 
      {
      write-host "its 11"
      #write heartbeat log to file. process monitor will check if file changed and alert if no change.
      $mts = (Get-Date).toString("yyyyMMdd_HH.mm.ss")
      $mtext = "{0}" -f $mts
      $mtext | Out-File -FilePath  $mlogfile2
      Write-Host $mtext ";;" $mlogfile2
      #
      $cnt=0
      } 
    else {
    $ts01 = (Get-Date).toString("ss")
    write-host "$cnt,$ts01" -NoNewline}
    
  } while ($true)
}
finally
{
  # this gets executed when user presses CTRL+C
}

# =================================================

# ending..

cmd /c timeout 9
# Start-Sleep -Seconds 1
