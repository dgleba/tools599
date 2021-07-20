# =================================================

# run at specified time.

# =================================================

try
{
  do
  {
    # `-Timeout 10` is wait 10 seconds in loop.
    Write-Host "." -NoNewline
    Wait-Event -Timeout 10
      
    # run once per hour
    [int]$hr = get-date -format HH
    $min = Get-Date ("{0}:25:00" -f $hr)
    $max = Get-Date ("{0}:25:10" -f $hr)
    $now = Get-Date
    # Write-Host $min $max 
    Write-Host $now $min $max
    if ( $now.TimeOfDay -ge $min.TimeOfDay  -and $now.TimeOfDay -le $max.TimeOfDay ) {
      Write-host "doit"
      (Get-Date).toString("yyyy-MM-dd_HH.mm.ss")|Write-Host
    }
    # end. run once per hour  
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
