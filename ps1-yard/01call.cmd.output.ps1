# =================================================

# =================================================

# option 1

$mts = (Get-Date).toString("yyyy-MM-dd_HH.mm.ss")
$mtsymd = (Get-Date).toString("yyyy-MM-dd")
$ma = "ma"
$mb = "memoryvar b"
$mf = "callcmdwithpsvariables-log.txt"
$marg = "echo {0}, {1}, {2}, {3} >>{4}_{5}" -f $mts, $ma, $mb, $(gc env:computername), $mtsymd, $mf
cmd /c $marg

# =================================================

# option 2


$mb = "memoryvar b"
$cmd = "cmd /c echo $mb foo '2>&1'"
$cmd = "cmd /c robocopy c:\0\1 c:\0\2 /e  '2>&1'"
$cmd = "cmd /c robocopy c:\0\1 c:\0\2 /e  "
Invoke-expression $cmd

# out:
# 	memoryvar b foo

# =================================================

# ending..

cmd /c timeout 21
# Start-Sleep -Seconds 1

