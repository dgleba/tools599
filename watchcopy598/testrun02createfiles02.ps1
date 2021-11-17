

try
{
  do
  {
		Write-Host "loop." -NoNewline
		
		$mts=(Get-Date).toString("yyyy-MM-dd_HH.mm.ss")
		$fpname='n11dgleba-prismo'
		
		$ts2=(Get-Date).toString("mm.ss")
		$ff = "C:\data\cmm\results from calypso\{0}.{1}___{2}_chr.txt" -f $fpname, $mts, $ts2
		"$mts Victor $ma $nickname  Ashiedu $mts" | Out-File $ff  -Append
		# cmd /c "echo $mts>>C:\data\cmm\results from calypso\n11.$mts_chr.txt"
		timeout 1

		# $ts2=(Get-Date).toString("mm.ss")
		$ff = "C:\data\cmm\results from calypso\{0}.{1}___{2}_hdr.txt" -f $fpname, $mts, $ts2
		"$mts Victor $ma $nickname  Ashiedu $mts" | Out-File $ff  -Append
		# echo $mts>>"C:\data\cmm\results from calypso\n11.$mts_hdr.txt"
		timeout 1

		# $ts2=(Get-Date).toString("mm.ss")
		$ff = "C:\data\cmm\results from calypso\{0}.{1}___{2}_fet.txt" -f $fpname, $mts, $ts2
		"$mts Victor $ma $nickname  Ashiedu $mts" | Out-File $ff  -Append
		# echo $mts>>"C:\data\cmm\results from calypso\n11.$mts_fet.txt"
		timeout 1

			echo 'finished a set of files. waiting 7..'
			Wait-Event -Timeout 7
		
  } while ($true)
}
finally
{
  # this gets executed when user presses CTRL+C
  cmd /c echo running finally.
}
