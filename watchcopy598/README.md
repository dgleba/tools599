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
 
Read the scripts for folder settings etc. and edit them to your needs.
 
Run watch598.ps1 and it will copy files in the watched folder to the output folder on file changes in the folder.

Put the watch598.ps1 in a scheduled task to start on boot.


# Issues

 1. I noticed it stopped working after waking up after hibernation. The task is still in task manager shown as running, but it won't do anything. It won't log anything to the log file either. I don't know how to debug that.




# todo

 - devise a way to restart the powershell file if it should stop.
 - put settings in variables in one location in each script.
 
