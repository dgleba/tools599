# ps call cmd with ps variables as parameters

$mts = (Get-Date).toString("yyyy-MM-dd_HH.mm.ss")
$ma = "ma"
$mb = "memoryvar b"
$mf = "log.2021-07-11.ccwpvp.log.txt"
$marg = "echo {0}, {1}, {2} >>{3}" -f $mts, $ma, $mb, $mf
cmd /c $marg

cmd /c timeout 3

Start-Sleep -Seconds 1

