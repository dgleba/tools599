#!/bin/bash

# see version info at bottom.

# purpose: duplicate disk 2 to 2b


# usage:         nohup bash /crib/tools599/movefiles575/rclone-dock002-to-dock002b.sh &


# note:
# use --log-file instead of tee..  sftp://10.4.168.141/crib/tools599/movefiles575/rclone-nas2-dock_02_uselog.sh

echo "-+-+--+-+--+-+--+-+--+-+-  Starting $0 base:$(basename -- "$0") at  $(date +"_%Y.%m.%d_%H.%M.%S")"

# -----------------------------------------

# settings 



tempdir=/crib/log/rclone
mkdir -p ${tempdir}
timestart=$(date +"%Y.%m.%d_%H.%M.%S")
rslognamepart=$(basename -- "$0")
tfc=${tempdir}/rclonefiles_${rslognamepart}_${timestart}.txt
logf=${tempdir}/rclonelog_${rslognamepart}_${timestart}.log


# end settings.

# -----------------------------------------

# -----------------------------------------

function_one() {

echo "function_one running."

pwd; ls -la;
rclone copy   /media/albe/vi641-002/mcdata   /media/albe/vi641-002b/mcdata   --log-file=$logf --log-level INFO \
    --multi-thread-cutoff 64M    --multi-thread-streams 12  --transfers=12

}

# notes:

# --min-age=300d  --max-age=302d  --bwlimit 5k  

# sftp://10.4.168.141/mnt/nas1_pmda-sgenas01/mcdata
# sftp://10.4.168.141/mnt/nas1_pmda-sgenas01/training_library_in_development  /media/albe/vi641-001/mcdata/nas_1/training_library_in_development
# sftp://10.4.168.141/mnt/nas1_pmda-sgenas01/training_library_SGE-Rotor6365  /media/albe/vi641-001/mcdata/nas_1/training_library_SGE-Rotor6365

#   --log-file=$logf --log-level INFO


# -----------------------------------------

function cleanup {

# copy log file created in windows scheduler to timestamped file..
set -x

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


#  main - start here


# cd to a temp folder in case some command is wrongly set to work on current folder.
cd /tmp ;mkdir -p ~/tmp; cd ~/tmp; pwd


#
# set lockdir so that script will only run one instance..
#
LOCKDIR=/crib/log/lockdir_oneinstance_$(basename -- "$0")
if mkdir ${LOCKDIR}; then
    #Ensure that if we "grabbed a lock", we release it # Works for SIGTERM and SIGINT(Ctrl-C)
    trap "cleanup" EXIT
    echo "Acquired one-instance-only lock, running the content.."
    ## echo "disabled, but made one-instance-only lock using windows window-title, running the content.."
    
    #Main Processing starts here 
    function_one
else
    #I had problems in cygwin. See how it goes in ubuntu. I think it has been good in the past..
	#2021-05-27 having trouble. lockdir too often is not removed.
	#disabled here by running function_one no matter what.
	#see C:\data\script\movefiles575\start-move-files-575.bat
	echo "Could not create one-instance lock directory '$LOCKDIR'. Is it already running?"
	echo "Could not create one-instance lock directory '$LOCKDIR' at  $(date +"_%Y.%m.%d_%H.%M.%S")">> ${tempdir}/one_instance$(date +"_%Y.%m.%d").log
    exit 1
fi

# -----------------------------------------
# -----------------------------------------
# -----------------------------------------
# -----------------------------------------

# History:

# 2022-08-27 r00  start

# -----------------------------------------
