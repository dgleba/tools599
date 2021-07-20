# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Status: indev

# Purpose:  this will be a script to check that watch598 is working correctly.

 # - This will be a task scheduler running every 1 minutes. It is separate from watch598
 # - it runs once and stops. 
 # - check that file sizes are equal. see  C:\data\script\tools599\ps1-yard\24.cmpfilesize.ps1. log it.
 # - send email upon failure. write marker file saying email was sent. send it only once per n hours. use setting for frequency.
 # - call 24.cmpfilesize.ps1 cmpfilesize598.ps1

 # - once per day start  C:\data\script\tools599\watchcopy598\archivetomonthfolder598.bat
     # if time is greater than 23:35:00 and less than 23:36:00 then start it. see C:\data\script\tools599\ps1-yard\12.run.between.two.times.hours.seconds.ps1



 # - may not need heartbeat.
 # - check that watch598 heartbeat file timestamp string written in the file is changing. log it.

 # - later: restart it.




# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#  SETTINGS  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


$script:logpath="c:\data\logs\watch598cmmresults"

$script:rundate = (Get-Date).toString("yyyy-MM-dd")


#  SETTINGS end ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


# Prep ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#  Main code ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


# I will let it run without checking right now.


#  run archiving ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



