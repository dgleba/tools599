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
      
    # run once per hour @ $smin
    [int]$shr = get-date -format HH
    [int]$smin = 48
    $min = Get-Date ("{0}:{1}:00" -f $shr, $smin)
    $max = Get-Date ("{0}:{1}:10" -f $shr, $smin) 
    $now = Get-Date
    # Write-Host $min $max 
    Write-Host $now $min $max
    if ( $now.TimeOfDay -ge $min.TimeOfDay  -and $now.TimeOfDay -le $max.TimeOfDay ) {
      Write-host "do it now!"
      (Get-Date).toString("yyyy-MM-dd_HH.mm.ss")|Write-Host
    }
    # end. run once per hour  
  } while ($true)
}
finally
{
  # this gets executed when user presses CTRL+C
  cmd /c echo running finally.
}


# =================================================

# ending..

timeout 19
# Start-Sleep -Seconds 1
