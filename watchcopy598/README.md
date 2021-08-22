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

 
 
# To run it

Place the repository in C:\data\script


## watch598.ps1

So the path to `watch598.ps1` will be `C:\data\script\tools599\watchcopy598\watch598.ps1`


Copy `watch598settings_example.conf` to `watch598settings.conf`
 
Read `watch598.ps1` for folder settings etc. and edit them to your needs.
 
Run watch598.ps1 and it will copy files in the watched folder to the output folders on file changes in the folder.

Put the watch598.ps1 in a scheduled task to start on login.

Set the task scheduler	
 - run even if not logged in (need admin user/pass to edit it)
 - remove all restrictions like run for 3 days, etc. This should just run forever with no restrictions.
 
 

## processmonitor_watch598.ps1
 
This monitors the watcher to check that it is functioning.

There is a task scheduler export `watch_598_process_monitor.xml`

That can be imported to the windows task scheduler or you can read it and create a task based on the contents of the xml file.


 
# Troubleshooting

 1. if powershell is not enabled.
    ```
    Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Unrestricted
    ```
    This can be run without admin rights and works permanently as far as my experience goes.


# Issues

 - 2021-07-12: I set the task scheduler to restart every minute if it fails. That seemed to result in 3 running in parallel in about 15 minutes. I need to investigate more.
 
 

# Todo

 - finish the archivetomonthfolder script. create logic in the watch598 to run the archiving every day at a set time. Or, just create a task scheduler to run it daily.
 - send email and log to file if it is found to be not running so we can know the size of the problem and deal with it.


