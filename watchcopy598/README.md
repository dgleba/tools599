# This is:

https://github.com/dgleba/tools599/tree/main/watchcopy598


# watchcopy598

Copy a folder when files are added or changed within it. 
Then archive files older than 30 days to monthly folders.



Use windows 10 builtin tools.

Uses:
 - robocopy
 - powershell
 - wmic
 - windows bat
 
 
# to run it
 
Read the scripts for folder settings etc. and edit them to your needs.
 
Run watch598.ps1 and it will run the .bat file on file changes in the folder.

Put the watch598.ps1 in a scheduled task to start on boot.


# todo

 - devise a way to restart the powershell file if it should stop.
 - put settings in variables in one location in each script.
 
