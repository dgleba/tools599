# =================================================

# keep writing to a file

# =================================================

# note

# https://sion-it.co.uk/tech/powershell/loop-until-a-certain-time/


# =================================================


$logpath = "C:\crib\c598"
# shows output.... md -Path $logpath -Force
cmd /c if not exist $logpath mkdir $logpath 
$nickname = "writeinfini"
$mlogfile2 = "{0}\{1}_{2}.chr.txt" -f $logpath, $(gc env:computername), $nickname

try
{
  do
  {
  $mts = (Get-Date).toString("yyyy-MM-dd_HH.mm.ss")
  $mts | Out-File -FilePath  $mlogfile2 -Append
  } while ($true)
}
finally
{
  # this gets executed when user presses CTRL+C
}

# =================================================

# ending..

cmd /c timeout 19
# Start-Sleep -Seconds 1

