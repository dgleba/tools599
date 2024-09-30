# =================================================

# run at specified time.

# =================================================

Write-Host "Starting  at  $((Get-Date).toString("yyyy-MM-dd_HH.mm.ss"))"


try
{
  do
  {
    # `-Timeout 10` is wait 10 seconds in loop.
    Write-Host "." -NoNewline
    Wait-Event -Timeout 10



    # Run between two times - 5 min window
      [int]$shr = 22
      [int]$smin = 51
      $min = Get-Date ("{0}:{1}:00" -f $shr, $smin )
      $max = Get-Date ("{0}:{1}:00" -f $shr, ($smin+5) ) 
      $now = Get-Date
      # Write-Host $min $max 
      Write-Host "5m times: now $now  min $min  max $max"
      if ( $now.TimeOfDay -ge $min.TimeOfDay  -and $now.TimeOfDay -le $max.TimeOfDay ) {
        Write-host "5m Run it now.."
        Write-Host " running task - now =  $((Get-Date).toString("yyyy-MM-dd_HH.mm.ss"))"
      }
    # .end. run between two times - 5 min window


    # Run between two times - 10 sec window
    #
      [int]$shr = get-date -format HH
      [int]$smin = 00
      $min = Get-Date ("{0}:{1}:00" -f $shr, $smin)
      $max = Get-Date ("{0}:{1}:10" -f $shr, $smin) 
      $now = Get-Date
      # Write-Host $min $max 
      Write-Host "10s times: now $now  min $min  max $max"
      # check if it is time to run it.
      if ( $now.TimeOfDay -ge $min.TimeOfDay  -and $now.TimeOfDay -le $max.TimeOfDay ) {
        Write-host "10s Run it now.."
        Write-Host "10s running task - now =  $((Get-Date).toString("yyyy-MM-dd_HH.mm.ss"))"
      }
    # .end. run between two times - 10 sec window
    #
    
    
    
    # # Run between two times - 10 sec window
      # [int]$shr = get-date -format HH
      # [int]$smin = 44
      # $min = Get-Date ("{0}:{1}:00" -f $shr, $smin)
      # $max = Get-Date ("{0}:{1}:10" -f $shr, $smin) 
      # $now = Get-Date
      # # Write-Host $min $max 
      # Write-Host "times: now $now  min $min  max $max"
      # if ( $now.TimeOfDay -ge $min.TimeOfDay  -and $now.TimeOfDay -le $max.TimeOfDay ) {
        # Write-host "Run it now.."
        # Write-Host " running task - now =  $((Get-Date).toString("yyyy-MM-dd_HH.mm.ss"))"
      # }
    # # .end. run between two times - 10 sec window


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
