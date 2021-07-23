# This is:

https://github.com/dgleba/tools599/tree/main/watchcopy598


# watchcopy598

Copy a folder when files are added or changed within it. 
Then archive files older than 30 days to monthly folders.


Use windows 10 builtin tools.

Uses:
 - powershell
 - windows bat/cmd
 - robocopy
 - wmic
 
 
# to run it

Place the repository in C:\data\script

So the path to `watch598.ps1` will be `C:\data\script\tools599\watchcopy598\watch598.ps1`


Copy `watch598settings_example.conf` to `watch598settings.conf`
 
Read `watch598.ps1` for folder settings etc. and edit them to your needs.
 
Run watch598.ps1 and it will copy files in the watched folder to the output folders on file changes in the folder.

Put the watch598.ps1 in a scheduled task to start on login.

Set the task scheduler	
 - run even if not logged in (need admin user/pass to edit it)
 - remove all restrictions like run for 3 days, etc. This should just run forever with no restrictions.
 

# issues

 - 2021-07-12: I set the task scheduler to restart every minute if it fails. That seemed to result in 3 running in parallel in about 15 minutes. I need to investigate more.
 
 

# todo

 - finish the archivetomonthfolder script. create logic in the watch598 to run the archiving every day at a set time. Or, just create a task scheduler to run it daily.
 - devise a way to restart the powershell file if it should stop.
 - send email and log to file if it is found to be not running so we can know the size of the problem and deal with it.


