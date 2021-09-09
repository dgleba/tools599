
# https://stackoverflow.com/questions/9223460/remove-empty-lines-from-text-file-with-powershell

$in = "watch598set-litmus.filecopy.list_example.conf"
$out = "out.txt"
$mtmp = "outtmp.txt"
$out2= "out2.txt"


# this didnt remove the last empty line
# [IO.File]::ReadAllText($in) -replace '\s+\r\n+', "`r`n" | Out-File $mtmp

# left a single space on last line.
(gc $in) -match '\S'  | out-file $out

# works. removes all whitelines
#Get-Content $in | Where { $_ } | Set-Content $out2
(Get-Content $in)  -match '\S'  | Where { $_ } | Set-Content $out2
