
# Purpose: move files from SGE rotor IPC to NAS

##  2021-03-25 rev:3

This file:  c:\data\scripts\movefiles575\README.md

Machine asset num: 6565 
Name: SGE Rotor NDT

Terms:
IPC = Industrial PC
NAS = Network attached storage




# Cygwin quick install no-admin.

Cygwin is required.

Run these commands to install:

```
set packs=C:\prg\cygwinpackages
mkdir %packs% & cd %packs% & echo  %packs% 
curl -O "https://cygwin.org/setup-x86_64.exe"  
%packs%\setup-x86_64.exe --no-admin -q -n -N -d -R c:\prg\cygwin64 -l %packs%\cygwin64localpackages  -s http://cygwin.mirror.constant.com -P rsync git
```

```
To run cygwin:

bash prompt:

C:\prg\cygwin64\Cygwin.bat

Run rsync from scripts like this..

C:\prg\cygwin64\bin\rsync.exe
```

# Script	

see: c:\data\scripts\movefiles575\move_files_to_nas575.sh

This is set to run hourly using windows task scheduler using `start-move-files-575.xml`.


