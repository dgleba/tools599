#!/bin/bash











#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#@  
#@  
#@  
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@   2021-05-26[May-Wed]10-35AM 

# this edited for dg laptop. see dgxps. 2021-05-26_Wed_10.36-AM

#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#@  
#@  
#@  
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@   2021-05-26[May-Wed]10-35AM 



















# move files.  rev: 29   David Gleba daterange: 2021-03-29 - 2021-05-26_Wed_10.16-AM

# purpose: move older images to NAS

# usage:         /cygdrive/c/data/script/movefiles575/move_files_to_nas575.sh



# History:
# 2021-05-26 see bottom of file for history.



# https://www.davidjnice.com/cygwin_scheduled_tasks.html
# mkdir c:\temp\moveimg
# this won't write sched_rsynclog.log..
#   c:\prg\cygwin64\bin\cygstart.exe --showminimized   c:\prg\cygwin64\bin\bash.exe -l -c "/cygdrive/c/data/script/movefiles575/move_files_to_nas575.sh | /cygdrive/c/prg/cygwin64/bin/tee /cygdrive/c/temp/moveimg/sched_rsynclog.log 2>&1"
# Workaround.. works..
#   c:\prg\cygwin64\bin\cygstart.exe --showminimized   c:\prg\cygwin64\bin\bash.exe -l -c "/cygdrive/c/data/script/movefiles575/move_files_to_nas575.sh>/cygdrive/c/temp/moveimg/sched_rsynclog.log 2>&1"



# -----------------------------------------

function_one() {

# REM :getfilelist mtime+1 is 2 days old.  mmim +2880 is two days old.
echo "function_one ${pwd}"
cd "${ssc}"
# find must be run from . current folder to get the list formated for rsync to use it.
# https://www.timeanddate.com/date/timeduration.html
# find . -type f  -mtime +2 > ${tfc}
find . -type f  -mmin +2880 > ${tfc}
echo file list..
cat ${tfc}

s=1 ; read  -rsp $"Wait $s seconds or press Escape-key or Arrow key to continue..." -t $s -d $'\e'; echo;echo;

# REM :movefiles
echo moving files..
set -vx # echo on
rsync -avv --ignore-existing --remove-source-files --log-file=${tempdir}/rsynclog${timestart}.log  --files-from=${tfc} . ${ddc} 
# rsync -avv --ignore-existing --remove-source-files   --files-from=${tfc} . ${ddc} 

#remove empty folders because rsync does not
# find "${ssc}" -type d -empty -delete -mtime +3 
# find ${ssc}/  -mindepth 1  -mtime +3  -type d -empty -delete
# find "${ssc}/"  -mindepth 1  -mmin +4310 -type d -empty -delete
echo removing older empty folders..
find "${ssc}/"  -mindepth 1  -mmin +$((2*60*24-1)) -type d -empty -delete
 
}


# -----------------------------------------


function checkdiskspace {


# Check disk space used.
df -H | grep -E 'cygwin' | awk '{ print $5 " " $1 }' | while read output;
do
  echo $output
  usep=$(echo $output | awk '{ print $1}' | cut -d'%' -f1  )
  partition=$(echo $output | awk '{ print $2 }' )
  if [ $usep -ge 75 ]; then
  echo "sending error email, ${usep}% on ${HOSTNAME} ..."
    # echo "Running out of space \"$partition ($usep%)\" on $(hostname) as on $(date)" | mail -s "Alert: Almost out of disk space $usep%" dgleba@stackpole.com
	# variables didnt pass through. Just go without.. /cygdrive/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe 'send-mailmessage -subject "test 491" -body "testing error email. ${usep}% on ${HOSTNAME}" -to "dgleba@stackpole.com" -dno onFailure -smtpServer MESG01.stackpole.ca -from "dgleba@stackpole.com"'
	/cygdrive/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe 'send-mailmessage -subject "Warning: Disk space on 6365 IPC" -body "C: drive on 6563 IPC may be running out of disk space. `nPlease check it. `n`nRef: this msg from 6365 IPC C:\data\script\movefiles575\move_files_to_nas575.sh" -to @("dgleba@stackpole.com", "kjarzecki@stackpole.com") -dno onFailure -smtpServer MESG01.stackpole.ca -from "dgleba@stackpole.com"'
  fi
done


# Check instance locks. Are there too many?
wc -l  < ${tempdir}/one_instance$(date +"_%Y.%m.%d").log | while read output;
do
  echo $output
  if [ $output -ge 10 ]; then
  echo "sending error email instance count, ${usep}% on ${HOSTNAME} ..."
	/cygdrive/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe 'send-mailmessage -subject "dgxps.. Warning: instance lock count" -body "There seems to be more than 10 single instance lock errors logged today. That seems high. Please check it. `n`nRef: this msg from 6365 IPC C:\data\script\movefiles575\move_files_to_nas575.sh" -to @("dgleba@stackpole.com") -dno onFailure -smtpServer MESG01.stackpole.ca -from "dgleba@stackpole.com"'
  fi
done



s=14 ; read  -rsp $"Wait $s seconds or press Escape-key or Arrow key to continue..." -t $s -d $'\e'; echo;echo;
}



# -----------------------------------------


function cleanup {

# copy log file created in windows scheduler to timestamped file..
set -x
cp ${tempdir}/sched_rsynclog.log ${tempdir}/rsynclog${timestart}.wtasksch.log 


# remove old log files..
find ${tempdir} -mtime +60 -iname "*.log" -exec rm {} \;


# put back empty camera name folders just in case they are not created if not exists.
cd "${ssc}"
c1='S1 Inner Rim'
c2='S1 Outer Surface'
c3='S1 Top View'
c4='S2 Inner Rim'
c5='S2 Top View'
mkdir -p  "${c1}"
mkdir -p  "${c2}"
mkdir -p  "${c3}"
mkdir -p  "${c4}"
mkdir -p  "${c5}"
touch "${ssc}"/"${c1}"/.keep
touch "${ssc}"/"${c2}"/.keep
touch "${ssc}"/"${c3}"/.keep
touch "${ssc}"/"${c4}"/.keep
touch "${ssc}"/"${c5}"/.keep

#Remove the lock directory
if rmdir ${LOCKDIR}; then
	echo "Finished"
	sleep 1
else
	echo "Failed to remove lock directory '$LOCKDIR'"
	exit 1
fi

echo "cleanup running at  $(date +"_%Y.%m.%d_%H.%M.%S")">> ${tempdir}/cleanup.run$(date +"_%Y.%m.%d").log
s=16 ; read  -rsp $"Wait $s seconds or press Escape-key or Arrow key to continue..." -t $s -d $'\e'; echo;echo;
}


# -----------------------------------------
# -----------------------------------------
# -----------------------------------------

#  start here

# cd to a temp folder in case some command is wrongly set to work on current folder.
cd /tmp ;mkdir -p ~/tmp; cd ~/tmp; pwd


# settings 


tempdir=/cygdrive/c/temp/moveimg
mkdir -p ${tempdir}
timestart=$(date +"_%Y.%m.%d_%H.%M.%S")

# REM :source dir
# ssc="/cygdrive/c/0/t1"
ssc=/cygdrive/c/Users/pmdacameras/My\ Documents/LabVIEW\ Data/SGE\ Rotor\ Vision


# REM :destination dir
ddc="//pmda-sgenas01/PMDA-SGE/image_data/SGE_Rotor_6365"
mkdir -p ${ddc}

# REM :tempfile
# mkdir -p ~/temp
tfc=${tempdir}/rsyncfiles${timestart}.txt



H=$(date +%H)
if (( 9 == 10#$H )); then 
    echo Run the boottime check..
	echo "=============          At:   $timestart">>${tempdir}/boottime.log
	systeminfo|grep "Boot Time">>${tempdir}/boottime.log
else
    echo dont check boot time at this run
fi

echo "bootcheck stuff at  $(date +"_%Y.%m.%d_%H.%M.%S")"
s=2216 ; read  -rsp $"Wait $s seconds or press Escape-key or Arrow key to continue..." -t $s -d $'\e'; echo;echo;




# check free disk space
checkdiskspace


#
# set lockdir so that script will only run one instance..
#

LOCKDIR=/cygdrive/c/temp/lockdir_oneinstance_lockdir_sgemove

if mkdir ${LOCKDIR}; then
    # Ensure that if we "grabbed a lock", we release it # Works for SIGTERM and SIGINT(Ctrl-C)
    trap "cleanup" EXIT
    echo "Acquired one-instance-only lock, running the content.."
    #
    # Main Processing starts here
    #
			# 2021-07-01 offline for now. --  function_one
else
    echo "Could not create one-instance lock directory '$LOCKDIR'. Is it already running?"
	echo "Could not create one-instance lock directory '$LOCKDIR' at  $(date +"_%Y.%m.%d_%H.%M.%S")">> ${tempdir}/one_instance$(date +"_%Y.%m.%d").log
    exit 1
fi

# -----------------------------------------
# -----------------------------------------
# -----------------------------------------
# -----------------------------------------
# -----------------------------------------


# History:
# 2021-04-25_Sun_14.18-PM empty folders are being updated. deleter line~49 not removing them.
# 2021-05-26 changed disk check. addedfunction checkdiskspace. want it to run regardless of instance.lock
# 2021-05-26 set echo on and add echos.
# 2021-05-26 check number of instance lock errors.

# -----------------------------------------
