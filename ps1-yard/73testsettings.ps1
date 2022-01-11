

Get-Content watch598settings.conf | Foreach-Object{
   $var = $_.Split('=')
   New-Variable -Name $var[0] -Value $var[1] -Scope "global" -Force
}



# get variables from settings file..     -match '\S'  | Where { $_ } | 
(Get-Content watch598settings.conf)  -match '\S'  | Where { $_ } | Foreach-Object{
   $var = $_.Split('=')
   New-Variable -Name $var[0] -Value $var[1] -Scope "global" -Force
}


$global:PathToMonitor = "$s_PathToMonitor"
$global:watch_file_filter = $s_watch_file_filter

cmd /c echo "$watch_file_filter, $PathToMonitor"


(Get-Content watch598settings.conf  )  -match '\S'  | Where { $_ } | Set-Content  out2.txt


timeout 987

