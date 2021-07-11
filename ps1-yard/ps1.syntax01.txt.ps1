
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#@  
#@  
#@  
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@   2021-07-11[Jul-Sun]15-09PM 



https://community.spiceworks.com/topic/613088-restart-service-via-ps-via-task-scheduler



$File = Get-ChildItem -file $Path | Where { $_.LastWriteTime -ge [datetime]::Now.AddMinutes(-30) }
If ($File)
{	
    
    $SMTPBody = "`nThe following files are not being swept into Succeeded or Failed files folder, the Avista Loan File Watch service on vm360Bancvue was restarted. If these files still aren't being swept troubleshoot further:`n`n"
	$File | ForEach { $SMTPBody += "$($_.FullName)`n" }
	Send-MailMessage @SMTPMessage -Body $SMTPBody
    #C:\AvistaSolutions\RestartAvistaService.bat.lnk
    Restart-Service -DisplayName 'Avista Loan File Watch' 
	
}
