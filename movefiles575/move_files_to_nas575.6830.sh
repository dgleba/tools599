#!/bin/bash

# see version info at bottom.

# purpose: move older images to NAS

# usage:         /cygdrive/c/data/script/movefiles575/move_files_to_nas575.sh



# History of this file:
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
# find . -type f  -mmin +1920 > ${tfc}
# find . -type f  -mmin +99339 > ${tfc}
# find . -type f  -mtime +100 > ${tfc}
find . -type f  -mtime +51 > ${tfc}
echo file list..
cat ${tfc}

s=31 ; read  -rsp $"Wait $s seconds or press Escape-key or Arrow key to continue..." -t $s -d $'\e'; echo;echo;

# REM :movefiles
echo moving files..
set -vx # echo on
#-a was not preserving mod time stamp on nas#2. 2022-01-16 dgleba.
rsync  -vtlr -u --remove-source-files --log-file=${tempdir}/rsynclog${timestart}.log  --files-from=${tfc} . ${ddc} 
# rsync -avv --ignore-existing --remove-source-files   --files-from=${tfc} . ${ddc} 

# sometimes with mindepth 1 it doesn't touch/delete them. but it did with mindepth removed. 2022-04-11.
echo "some empty folders may have newer dates than they should. touching.."
find "${ssc}/"  -mindepth 1 -type d -empty -exec touch -t 202101010101  {} \;

#remove empty folders because rsync does not
# find "${ssc}" -type d -empty -delete -mtime +3 
# find ${ssc}/  -mindepth 1  -mtime +3  -type d -empty -delete
# find "${ssc}/"  -mindepth 1  -mmin +4310 -type d -empty -delete
# find "${ssc}/"  -mindepth 1  -mmin +$((2*60*24-1)) -type d -empty -delete
# find "${ssc}/"  -mindepth 1  -mmin +$((135*60*24-1)) -type d -empty -delete
echo removing older empty folders..
find "${ssc}/" -mindepth 2  -mtime +53 -type d -empty -delete
  
}


# -----------------------------------------


function checkdiskspace {


# Check disk space used.
df -H | grep -E 'cygwin' | awk '{ print $5 " " $1 }' | while read output;
do
  echo $output
  usep=$(echo $output | awk '{ print $1}' | cut -d'%' -f1  )
  partition=$(echo $output | awk '{ print $2 }' )
  if [ $usep -ge 85 ]; then
  echo "sending error email, ${usep}% on ${HOSTNAME} ..."
    # echo "Running out of space \"$partition ($usep%)\" on $(hostname) as on $(date)" | mail -s "Alert: Almost out of disk space $usep%" dgleba@stackpole.com
	# variables didnt pass through. Just go without.. /cygdrive/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe 'send-mailmessage -subject "test 491" -body "testing error email. ${usep}% on ${HOSTNAME}" -to "dgleba@stackpole.com" -dno onFailure -smtpServer MESG01.stackpole.ca -from "dgleba@stackpole.com"'
	/cygdrive/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe 'send-mailmessage -subject "Warning: Disk space on 6365 IPC" -body "C: drive on 6563 IPC may be running out of disk space. `nPlease check it. `n`nRef: this msg from 6365 IPC C:\data\script\movefiles575\move_files_to_nas575.sh" -to @("dgleba@stackpole.com", "kjarzecki@stackpole.com") -dno onFailure -smtpServer MESG01.stackpole.ca -from "dgleba@stackpole.com"'
  fi
done


#  disabled 2021-05-27  see lockdir section at bottom for more info..
#
# Check instance locks. Are there too many?
# wc -l  < ${tempdir}/one_instance$(date +"_%Y.%m.%d").log | while read output;
# do
  # echo $output
  # if [ $output -ge 10 ]; then
  # echo "sending error email instance count, ${usep}% on ${HOSTNAME} ..."
	#  /cygdrive/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe 'send-mailmessage -subject "Warning: instance lock count" -body "There seems to be more than 10 single instance lock errors logged today. That seems high. Please check it. `n`nRef: this msg from 6365 IPC C:\data\script\movefiles575\move_files_to_nas575.sh" -to @("dgleba@stackpole.com", "kjarzecki@stackpole.com") -dno onFailure -smtpServer MESG01.stackpole.ca -from "dgleba@stackpole.com"'
  # fi
# done



s=14 ; read  -rsp $"Wait $s seconds or press Escape-key or Arrow key to continue..." -t $s -d $'\e'; echo;echo;
}



function onetimeperday {

# Check system boot time at certain hour...
H=$(date +%H)
echo "bootcheck stuff at  $(date +"_%Y.%m.%d_%H.%M.%S")"
# Check the hour and run if matches..
if (( 9 == 10#$H )); then 
    dobootcheck
else
    echo dont check boottime at this time
fi
#s=216 ; read  -rsp $"Wait $s seconds or press Escape-key or Arrow key to continue..." -t $s -d $'\e'; echo;echo;

}


function dobootcheck {

echo Run the boottime check..
	echo "=============   At:   $timestart">>${tempdir}/boottime.log
	systeminfo|grep "Boot Time">>${tempdir}/boottime.log
uptime_seconds=`cat /proc/uptime | cut -f1 -d'.'`

echo uptime_seconds: $uptime_seconds
# 370000 seconds is about 4.3 days.
if [ $uptime_seconds -ge 370000 ]; then
echo "sending error email uptime, ${usep}% on ${HOSTNAME} ..."
/cygdrive/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe 'send-mailmessage -subject "Warning: uptime too long. 6365 vision." -body "There seems to be more than 4 days uptime. Please check it. `n`nRef: this msg from 6365 IPC C:\data\script\movefiles575\move_files_to_nas575.sh" -to @("dgleba@stackpole.com") -dno onFailure -smtpServer MESG01.stackpole.ca -from "dgleba@stackpole.com"'
fi

}


# -----------------------------------------


function cleanup {

# copy log file created in windows scheduler to timestamped file..
set -x
cp ${tempdir}/sched_rsynclog.log ${tempdir}/rsynclog${timestart}.wtasksch.log 


# remove old log files. +60 is older than 60 days ..
# find ${tempdir} -mtime +60 -iname "*" -exec rm {} \;
find ${tempdir} -mtime +90  -exec rm {} \;

mkdirbase() {
  echo "run mkdirbase"
  # put back empty camera name folders just in case they are not created if not exists.
  # cd "${ssc}"
  # c1='S1 Inner Rim'
  # c2='S1 Outer Surface'
  # c3='S1 Top View'
  # c4='S2 Inner Rim'
  # c5='S2 Top View'
  # mkdir -p  "${c1}"
  # mkdir -p  "${c2}"
  # mkdir -p  "${c3}"
  # mkdir -p  "${c4}"
  # mkdir -p  "${c5}"
  # touch "${ssc}"/"${c1}"/.keep
  # touch "${ssc}"/"${c2}"/.keep
  # touch "${ssc}"/"${c3}"/.keep
  # touch "${ssc}"/"${c4}"/.keep
  # touch "${ssc}"/"${c5}"/.keep
}

#Remove the lock directory
if rmdir ${LOCKDIR}; then
	echo "Finished"
	sleep 1
else
	echo "Failed to remove lock directory '$LOCKDIR'"
	exit 1
fi

echo "cleanup running at  $(date +"_%Y.%m.%d_%H.%M.%S")"
echo "cleanup running at  $(date +"_%Y.%m.%d_%H.%M.%S")">> ${tempdir}/cleanup.run$(date +"_%Y.%m.%d").log
s=16 ; read  -rsp $"Wait $s seconds or press Escape-key or Arrow key to continue..." -t $s -d $'\e'; echo;echo;
}





# -----------------------------------------
# -----------------------------------------
# -----------------------------------------




#  start here




trap "cleanup" EXIT

# cd to a temp folder in case some command is wrongly set to work on current folder.
cd /tmp ;mkdir -p ~/tmp; cd ~/tmp; pwd


# settings 


tempdir=/cygdrive/c/temp/moveimg
mkdir -p ${tempdir}
timestart=$(date +"%Y.%m.%d_%H.%M.%S")

# REM :source dir
# ssc="/cygdrive/c/0/t1"
# ssc=/cygdrive/c/Users/pmdacameras/My\ Documents/LabVIEW\ Data/SGE\ Rotor\ Vision
ssc=/cygdrive/d/data/vision_6830/image_data


# REM :destination dir
# temporary change to d drive 2021-07-19 ---  ddc="//pmda-sgenas01/PMDA-SGE/image_data/SGE_Rotor_6365"
# ddc="/cygdrive/d/image_data/SGE_Rotor_6365"
ddc="//10.4.65.190/Images/mc_6830_vision/image_data"
mkdir -p ${ddc}

# REM :tempfile
# mkdir -p ~/temp
tfc=${tempdir}/rsyncfiles${timestart}.txt

# check free disk space
checkdiskspace

# this will run something only at a specified hour.
onetimeperday


function_one


#
# set lockdir so that script will only run one instance..
#
# LOCKDIR=/cygdrive/c/temp/lockdir_oneinstance_lockdir_sgemove
# if mkdir ${LOCKDIR}; then
    # Ensure that if we "grabbed a lock", we release it # Works for SIGTERM and SIGINT(Ctrl-C)
    # trap "cleanup" EXIT
    #echo "Acquired one-instance-only lock, running the content.."
    # echo "disabled, but made one-instance-only lock, running the content.."
    #
    # Main Processing starts here
    #
    #disabled - using window title:   function_one
# else
	# 2021-05-27 having trouble. lockdir too often is not removed.
	# disabled here by running function_one no matter what.
	# see C:\data\script\movefiles575\start-move-files-575.bat
	# echo "Could not create one-instance lock directory '$LOCKDIR'. Is it already running?"
	# echo "Could not create one-instance lock directory '$LOCKDIR' at  $(date +"_%Y.%m.%d_%H.%M.%S")">> ${tempdir}/one_instance$(date +"_%Y.%m.%d").log
    # exit 1
# fi



# -----------------------------------------
# -----------------------------------------
# -----------------------------------------
# -----------------------------------------
# -----------------------------------------



# History:

# 2022-04-09 r42  remove ignore-existing
# 2022-04-08 r41  touch empty dirs to jan 1 2021 as some had newer dates and would not get removed.
# 2022-01-11 r40  add 6830
# 2021-07-27 r39  edit subject of uptime email, line ~124
# 2021-07-19 r38  change to d drive due to nas full. ~line 202
# 2021-07-06 r37  line 35 was 2000, now find . -type f  -mmin +1920 > ${tfc}
#					change cleanup call to line 183
# 2021-07-06 r36 minor changes
# 2021-07-05 r35  ~line 140 was: remove old log files.. find ${tempdir} -mtime +60 -iname "*" -exec rm {} \;
# 2021-07-05 r34  add boot time check
# 2021-06-24 reduce minutes of images  saved to 2000 from 2880. change space check to 85%.
# 2021-04-25_Sun_14.18-PM empty folders are being updated. deleter line~49 not removing them.
# 2021-05-26 changed disk check. addedfunction checkdiskspace. want it to run regardless of instance.lock
# 2021-05-26 set echo on and add echos.
# 2021-05-26 check number of instance lock errors.
# 2021-05-27 changed to bat file with title check in tasklist for one-instance logic
#            David Gleba started: 2021-03-29

# -----------------------------------------
