# This is:

https://github.com/dgleba/tools599/tree/main/watchcopy598


# watchcopy598

Handle files in a folder that are X minutes old every N minutes.  [It isn't a watcher anymore.]

Then archive files older than N days to monthly folders.


Use windows 10 builtin tools.

Uses:
 - powershell
 - windows bat/cmd
 - robocopy

# History

What is in a name?

This is called watch598 for two reasons.

1. 
It was `watch` because it was using a built-in powershell file watching system. That was problematic. It missed most of the files
when some thousands of files were dropped into the folder.

Now it simply moves files more than X minutes old when it is run once.
When run every minute from task scheduler, it does almost the same thing and it is more reliable.

The `previously` folder has a version that used the file watch system.


2. 
I use naming with a word and a number. It makes a unique name so I know what I am working on.
So, 598 is simply the next number in my list. I can more easily find my files for this project searching for watch 598 in my stuff.


 
# To install it

Place the repository in C:\data\script

So the path to `watch598e.ps1` will be `C:\data\script\tools599\watchcopy598\watch598e.ps1`


## Running watch598.ps1


Copy `watch598settings_example.conf` to `watch598settings.conf`

Copy `watch598set-litmus.filecopy.list_example.conf` to  `watch598set-litmus.filecopy.list.conf`

For: `watch598set-litmus.filecopy.list.conf` This is a list of files to copy to the litmus folder, rather than copy them all.

Edit the above files if needed.

 
Read `watch598e.ps1`. Notice the folders it uses for interal use and the final folders. It is preferred that these folders remain unchanged, as unintended results may occur if these are changed.
 
Run `watch598e.ps1` and it will copy files in the watched folder to the output folders on file changes in the folder.

Put the `watch598e.ps1` in a scheduled task to start on login.

Set the task scheduler
    - run once per minute

There is a task scheduler export `watch598e.xml`. This can be imported to the windows task scheduler or you can read it and create a task based on the contents you can read in the xml file.

## Handling some files to go to Litmus

Files from each cmm go to one cmm for ingestion to Litmus. The destination at the time of writing is `s_litmus_destination_host=PMDA-BKH70W2`

If you want the files on the cmm you are installing to go to litmus, edit the settings below..

`watch598settings.conf`

Include the cmm host name in the setting below.

```
s_litmus_move_from_host_array=@("PMA-CMM1","PMC-PRISMO1")
```

Reference: This is the code..
```    
# to litmus-from-other-cmm
# if these settings refer to valid hosts present in your system, move the litmus files to destination computer for litmus to pick them up. 
if ( $global:s_litmus_move_from_host_array.contains($(gc env:computername)) ) {
  echo 'moving to cmm 10001...'
  # copy to \litmus-data-cmm
  robocopy $copyToLitmus  "\\$s_litmus_destination_host\litmus-from-other-cmm\"  /mov /is /R:3 /W:4 | C:\prg\cygwin64\bin\grep.exe  -v '*EXTRA File'
```


## cygwin

cygwin64 grep is being used to reduce log file size by eliminating some repetitive lines.

It has to be installed at: C:\prg\cygwin64\bin\grep.exe

It can be installed on any computer and the folder `c:\prg\cygwin64` can be zipped up and copied over to the target computer.

The following will install a smallish cygwin with grep.

```
set packs=C:\prg\cygwinpackages
mkdir %packs% & cd %packs% & echo  %packs% 
curl -O "https://cygwin.org/setup-x86_64.exe" 
%packs%\setup-x86_64.exe --no-admin -q -n -N -d -R c:\prg\cygwin64 -l %packs%\cygwin64localpackages  -s https://cygwin.mirror.constant.com -P  rsync
```


## processmonitor_watch598.ps1
 
This monitors the watcher to check that it is functioning.

There is a task scheduler export `watch_598_process_monitor.xml`. That can be imported to the windows task scheduler or you can read it and create a task based on the contents of the xml file.


 
# Troubleshooting

 1. if powershell is not enabled.
 
    Run this..
    ```
    powershell Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Unrestricted
    ```
    This can be run without admin rights and works permanently as far as my experience goes.


# Issues

none listed at this time.


# Todo

1.  Processmonitor and archivetomonthfolders have hard coded paths that should be put into a settings section to avoid stating paths more than once.




