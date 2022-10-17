#!/bin/bash

# # move files.  2021-03-25 rev:3

# usage:         /cygdrive/c/0/move.files.cygwinrsync6.sh

# https://www.davidjnice.com/cygwin_scheduled_tasks.html
#  eg:  /var/www/html/0docs-pmdsdata/scrapimport.sh 2>&1 | tee -a /home/albe/log/scrapimport1.log 
# c:\prg\cygwin64\bin\bash.exe -l -c "/cygdrive/c/0/move.files.cygwinrsync6.sh > /cygdrive/c/temp/moveimg/sched_rsynclog.log 2>&1"
# mkdir c:\temp\moveimg
# c:\prg\cygwin64\bin\bash.exe  -c "/cygdrive/c/data/script/movefiles575/move_files_to_nas575.sh | /cygdrive/c/prg/cygwin64/bin/tee /cygdrive/c/temp/moveimg/sched_rsynclog.log 2>&1"


# -----------------------------------------

function_one()
{

# REM :source dir
ssc="/cygdrive/c/0/t1"

# REM :destination dir
ddc="//pmda-sgenas01/PMDA-SGE/temp/t1"
mkdir -p ${ddc}

# REM :tempfile
mkdir -p ~/temp
tfc=~/temp/rsyncfiles

# REM :getfilelist mtime+1 is 2 days old
cd ${ssc}
find . -type f  -mtime +2 > ${tfc}
echo file list..
cat ${tfc}

s=1 ; read  -rsp $"Wait $s seconds or press Escape-key or Arrow key to continue..." -t $s -d $'\e'; echo;echo;

# REM :movefiles
rsync -avv --ignore-existing --remove-source-files --log-file=${tempdir}/rsynclog${timestart}.log  --files-from=${tfc} . ${ddc} 

}

# -----------------------------------------


function cleanup {

# copy log file created in windows scheduler to timestamped file..
cp ${tempdir}/sched_rsynclog.log ${tempdir}/rsynclog${timestart}.wtasksch.log 

# remove old log files..
find ${tempdir} -mtime +120 -iname "*.log" -exec rm {} \;


# Check disk space used.
df -H | grep -E 'cygwin' | awk '{ print $5 " " $1 }' | while read output;
do
  echo $output
  usep=$(echo $output | awk '{ print $1}' | cut -d'%' -f1  )
  partition=$(echo $output | awk '{ print $2 }' )
  if [ $usep -ge 80 ]; then
  echo "sending error email, ${usep}% on ${HOSTNAME} ..."
    # echo "Running out of space \"$partition ($usep%)\" on $(hostname) as on $(date)" | mail -s "Alert: Almost out of disk space $usep%" dgleba@stackpole.com
	# variables didnt pass through. Just go without.. /cygdrive/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe 'send-mailmessage -subject "test 491" -body "testing error email. ${usep}% on ${HOSTNAME}" -to "dgleba@stackpole.com" -dno onFailure -smtpServer MESG01.stackpole.ca -from "dgleba@stackpole.com"'
	/cygdrive/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe 'send-mailmessage -subject "Warning: Disk space on 6365 IPC" -body "C: drive on 6563 IPC may be running out to disk space. Please check it." -to @("dgleba@stackpole.com", "kjarzecki@stackpole.com") -dno onFailure -smtpServer MESG01.stackpole.ca -from "dgleba@stackpole.com"'
  fi
done


#Remove the lock directory
    if rmdir ${LOCKDIR}; then
        echo "Finished"
        sleep 1
    else
        echo "Failed to remove lock directory '$LOCKDIR'"
        exit 1
    fi
}

# -----------------------------------------
# -----------------------------------------

#  start here

#
# set lock so that script will only run one instance..
#

timestart=$(date +"_%Y.%m.%d_%H.%M.%S")
tempdir=/cygdrive/c/temp/moveimg
mkdir -p ${tempdir}

LOCKDIR=/cygdrive/c/temp/lockdir_oneinstance_lockdir_sgemove

if mkdir ${LOCKDIR}; then
    # Ensure that if we "grabbed a lock", we release it # Works for SIGTERM and SIGINT(Ctrl-C)
    trap "cleanup" EXIT
    echo "Acquired one-instance-only lock, running the content.."
    #
    # Main Processing starts here
    #
    function_one
else
    echo "Could not create one-instance lock directory '$LOCKDIR'. Is it already running?"
    exit 1
fi

# -----------------------------------------

