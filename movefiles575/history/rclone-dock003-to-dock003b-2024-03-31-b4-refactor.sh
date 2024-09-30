#!/bin/bash

# see version info at bottom.

# purpose: duplicate disk 2 to 2b


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function blockcomment_usage {
: <<'BLOCKCOMMENT'

# basic usage:               nohup    bash /ap/script/tools599/movefiles575/rclone-dock003-to-dock003b.sh    &

# for cron..

echo before-listing.. ; crontab         -l ; # list;
echo removing..  ;         crontab  -l | grep -v 'rclone-dock003-to-dock003b'  | crontab -; # remove ;
echo after-remove-listing.. ; crontab         -l ; # list;
#echo adding.. ; crontab -l | { cat; echo "58 */2 * * 0-6 "bash /ap/script/tools599/movefiles575/rclone-dock003-to-dock003b.sh" "; } | crontab - ; # add ;
echo adding.. ; crontab -l | { cat; echo "03   * * * 0-6 "bash /ap/script/tools599/movefiles575/rclone-dock003-to-dock003b.sh" "; } | crontab - ; # add ;
echo post-listing.. ;  crontab         -l ; # list;

BLOCKCOMMENT
}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


echo "-+-+--+-+--+-+--+-+--+-+-  Starting $0 base:$(basename -- "$0") $USER at  $(date +"_%Y.%m.%d_%H.%M.%S")"

# -----------------------------------------

# settings 



tempdir=/ap/log/rclone
mkdir -p ${tempdir}
timestart=$(date +"%Y.%m.%d_%H.%M.%S")
rslognamepart=$(basename -- "$0")
tfc=${tempdir}/rclonefiles_${rslognamepart}_${timestart}.txt
logf=${tempdir}/rclonelog_${rslognamepart}_${timestart}.log


# end settings.

# -----------------------------------------

# -----------------------------------------

function_one() {

echo "function_one is running..."

pwd; ls -la;
rclone copy   /media/albe/vi641-003   /media/albe/vi641-003b --log-file=$logf --log-level INFO 

     #     --multi-thread-cutoff 64M    --multi-thread-streams 12  --transfers=12

}

# notes:

# --min-age=300d  --max-age=302d  --bwlimit 5k  

# sftp://10.4.168.141/mnt/nas1_pmda-sgenas01/mcdata
# sftp://10.4.168.141/mnt/nas1_pmda-sgenas01/training_library_in_development  /media/albe/vi641-001/mcdata/nas_1/training_library_in_development
# sftp://10.4.168.141/mnt/nas1_pmda-sgenas01/training_library_SGE-Rotor6365  /media/albe/vi641-001/mcdata/nas_1/training_library_SGE-Rotor6365

#   --log-file=$logf --log-level INFO


# -----------------------------------------


function archive1 {
    echo running archive1..
    # because timestamp is in the filename of most files, archive based on date. logrotate not best here.
    srcdir=$tempdir
    # set basedir $bse for archive
    bse=/ap/log/archive
    # arcdir=$bse/$(date +"%Y-%m")
    arcdir=$bse/$(date -dlast-monday +%Y%m%d)
    mkdir -p $arcdir
    # move the files..
    # older than..
    daysold=1
    find $srcdir/*  -type f -mtime +${daysold} -exec mv --backup=numbered '{}' $arcdir/ \; 
    # bigger than and newer than.. {bc some files dont have timestamp in filename.}
    find $srcdir/* -type f -size +100k   -mtime -${daysold} -exec mv --backup=numbered '{}' $arcdir/ \; 
    
    # remove 0 size files more than n day old..
    # find $srcdir -type f -mtime +90 -size 0 -delete

    # garbage old `archive-folder` files - rm files older than n days = mtime +n
    find $bse/* -mtime +120 -exec rm {} \;
}


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

function cleanup2 {
set -x
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




# flock start here
#
func_exit () {
  echo "One instance lock attempt failed  $(date +"_%Y.%m.%d_%H.%M.%S")">> ${tempdir}/oneinstance$(date +"_%Y.%m.%d").log
  echo "One instance lock attempt failed.. Exiting, maybe another instance is running."; exit 1
}
#
trap "cleanup2" EXIT
(
  flock -n 9 || func_exit
  # 2024-03-14 put commands executed under lock here...
  echo "Attempting one-instance-only lock to run the content.."
  # call function here to run the content..
  function_one
  archive1
) 9>"/var/lock/lockfile_2023-02-28__$(basename -- "$0")"





# -----------------------------------------
# -----------------------------------------
# -----------------------------------------
# -----------------------------------------

# History:

# 2022-08-27 r00  start

# -----------------------------------------



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function blockcomment21 {
: <<'BLOCKCOMMENT'

# notes:


# note:
# use --log-file instead of tee..  sftp://10.4.168.141/crib/tools599/movefiles575/rclone-nas2-dock_02_uselog.sh


=================================================


#
# set lockdir so that script will only run one instance..
#
LOCKDIR=/tmp/lockdir_oneinstance_$(basename -- "$0")
if mkdir ${LOCKDIR}; then
    #Ensure that if we "grabbed a lock", we release it # Works for SIGTERM and SIGINT(Ctrl-C)
    trap "cleanup" EXIT
    echo "Acquired one-instance-only lock, running the content.."
 
    # Main Processing starts here 
    # 
    # [use flock instead 2024-03-14_Thu_14.36-PM]    function_one
else
  #I had problems in cygwin. See how it goes in ubuntu. I think it has been good in the past..
	#2021-05-27 having trouble. lockdir too often is not removed.
	#disabled here by running function_one no matter what.
	#see C:\data\script\movefiles575\start-move-files-575.bat
	echo "Could not create one-instance lock directory '$LOCKDIR'. Is it already running?"
	echo "Could not create one-instance lock directory '$LOCKDIR' at  $(date +"_%Y.%m.%d_%H.%M.%S")">> ${tempdir}/one_instance$(date +"_%Y.%m.%d").log
    exit 1
fi


BLOCKCOMMENT
}
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

