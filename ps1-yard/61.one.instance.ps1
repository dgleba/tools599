
=================================================

1.

If the script was launched using the powershell.exe -File switch, you can detect all powershell instances that have the script name present in the process commandline property:

Get-WmiObject Win32_Process -Filter "Name='powershell.exe' AND CommandLine LIKE '%script.ps1%'"


=================================================


2.

I had trouble with this..

$otherScriptInstances=get-wmiobject win32_process | where{$_.processname -eq 'powershell.exe' -and $_.ProcessId -ne $pid -and $_.commandline -match $($MyInvocation.MyCommand.Path)}
if ($otherScriptInstances -ne $null)
{
    "Already running"
    cmd /c pause
}else
{
    "Not yet running"
    cmd /c pause
}

=================================================
