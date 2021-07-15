# =================================================

# run at specified time.


# =================================================


# =================================================

try
{
  do
  {
    # -Timeout 3 is wait 3 seconds in loop.
    Wait-Event -Timeout 5
    Write-Host "." -NoNewline
      
    # run once per day  
    $min = Get-Date '20:24:00'
    $max = Get-Date '20:24:05'
    $now = Get-Date
    if ($min.TimeOfDay -le $now.TimeOfDay -and $max.TimeOfDay -ge $now.TimeOfDay) {
      Write-host "doit"
      (Get-Date).toString("yyyy-MM-dd_HH.mm.ss")|Write-Host
    }
    # end. run once per day  
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

