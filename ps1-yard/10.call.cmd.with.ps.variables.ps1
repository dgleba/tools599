# =================================================

# ps call cmd with ps variables as parameters

# https://stackoverflow.com/questions/809333/powershell-command-processing-passing-in-variables

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
$cmd = "cmd /c echo $mb foo"
Invoke-expression $cmd

# out:
# 	memoryvar b foo



# =================================================

# issue



# i am having trouble passing the variables to the arguments of the robocopy call.

# $carg = "robocopy {0} {1} /e {2}" -f $PathToMonitor, $copyToPath, $watch_file_filter
# & $carg

# $cmd = "cmd /c robocopy  $PathToMonitor $copyToPath  /e $watch_file_filter"
# Invoke-expression $cmd

# $mexe = "cmd";
# [Array]$mparams = "/c", "robocopy", $PathToMonitor, $copyToPath,  "/e", $watch_file_filter;
# & $mexe $mparams;






# =================================================
# =================================================
# =================================================

# ending..

cmd /c timeout 1
# Start-Sleep -Seconds 1

