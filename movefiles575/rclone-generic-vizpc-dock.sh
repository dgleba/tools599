#!/bin/bash

# purpose: rclone for 6365 and all vision computers move older images to archive (drive dock for example)

# use --log-file instead of tee..  sftp://10.4.168.141/crib/tools599/movefiles575/rclone-nas2-dock_02_uselog.sh

# usage:         nohup bash /ap/script/tools599/movefiles575/rclone-generic-vizpc-dock.sh &




myNOTES__function() {

echo notes..

35 * * * 0-6 bash /ap/script/tools599/movefiles575/rclone-generic-vizpc-dock.sh 2>&1 | tee -a /ap/log/rclone_generic-vizpc-dock-sh.log

# add users to the other users group to help with permissions..
nuser=qualisense&&  sudo usermod -a -G albe  $nuser; 
nuser=albe&&  sudo usermod -a -G qualisense  $nuser; 


# sftp://10.4.168.141/mnt/nas1_pmda-sgenas01/mcdata
# sftp://10.4.168.141/mnt/nas1_pmda-sgenas01/training_library_in_development  /media/albe/vi641-001/mcdata/nas_1/training_library_in_development
# sftp://10.4.168.141/mnt/nas1_pmda-sgenas01/training_library_SGE-Rotor6365  /media/albe/vi641-001/mcdata/nas_1/training_library_SGE-Rotor6365

#   --log-file=$logf --log-level INFO

}



echo "-+-+--+-+--+-+--+-+--+-+-  Starting $0 base:$(basename -- "$0") at  $(date +"_%Y.%m.%d_%H.%M.%S")"

# -----------------------------------------
# -----------------------------------------
# -----------------------------------------
# -----------------------------------------


# settings 


tempdir=/ap/log/rclone
logdir=/ap/log
mkdir -p ${tempdir}
timestart=$(date +"%Y.%m.%d_%H.%M.%S")
rslognamepart=$(basename -- "$0")
tfc=${tempdir}/rclonefiles_${rslognamepart}_${timestart}.txt


#logs too big. just use one file. overwrite each time it starts.
# was 2024-12-14_Sat_11.28-AM: logf=${tempdir}/rclonelog_${rslognamepart}_${timestart}.log
logf=${tempdir}/rclonelog_${rslognamepart}.log

# cd to a temp folder in case some command is wrongly set to work on current folder.
cd /tmp ;mkdir -p ~/tmp; cd ~/tmp; pwd


# end settings.

# -----------------------------------------
# -----------------------------------------
# -----------------------------------------
# -----------------------------------------



function_one() {

echo "function_one running."



# backup copy recent smaller files to dock pc - pmvis772 combined
rclone copy  --max-age=90d --max-size=1M  -v /ap/pmvis772/  \
dock-vi641-ssh:/mnt/dsk2/pmvis772yard/backup/combinedcopy/pmvis772/  --log-file=/ap/log/pm-vis-772-yard-combine-rclone.log 

# backup copy recent smaller files to dock pc - pmvis772 -- using --backup-dir
dest=dock-vi641-ssh:/mnt/dsk2/pmvis772yard/backup/recents/pmvis772
rclone copy  --max-age=90d --max-size=1M  -v /ap/pmvis772/  \
${dest}/${HOSTNAME}/  --backup-dir=${dest}/backupdir/${HOSTNAME}/`date -I` --log-file=/ap/log/pm-vis-772-yard-recents-rclone.log 

# backup copy recent smaller files to dock pc - ap/script
rclone copy  --max-age=90d --max-size=1M  -v /ap/script/  \
dock-vi641-ssh:/mnt/dsk2/backup/ap-folder-yard/recents/ap-script/${HOSTNAME}/  --log-file=/ap/log/ap_folder_yard-recents-rclone.log 



pwd; ls -la;

# remove log file so it doesn't take up too much disk space.
rm $logf

minage=4
srcdir=/mnt/data

rclone move --min-age=${minage}d  --max-age=999d  --order-by modtime,ascending  -v ${srcdir} \
dock-vi641-ssh:/media/albe/vi641-9641/mcdata/${HOSTNAME}  --log-file=$logf 

# rclone  --delete-empty-src-dirs seemed to remove empty dirs newer than min-age. Use bash to rm empty dirs.
echo removing older empty folders..
find "${srcdir}/" -mindepth 2  -mtime +1 -type d -empty -delete

#rclone copy --min-age=24d  --max-age=999d  -v /leanai_data/leanai_aoi_outputs dock-vi641-ssh:/media/albe/vi641-002/mcdata/mc_6365_vision_2/image_data   --log-file=$logf 



}




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
    #find $srcdir/* -type f  -mtime +3  -size +100k   -exec mv --backup=numbered '{}' $arcdir/ \; 
    
    # remove 0 size files more than n day old..
    # find $srcdir -type f -mtime +90 -size 0 -delete

    # garbage old `archive-folder` files - rm files older than n days = mtime +n
    find $bse -mtime +3 -exec rm {} \;
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
# echo "cleanup running at  $(date +"_%Y.%m.%d_%H.%M.%S")">> ${tempdir}/cleanup.run$(date +"_%Y.%m.%d").log
echo "cleanup running at  $(date +"_%Y.%m.%d_%H.%M.%S")">> ${tempdir}/cleanup-run.log
s=16 ; read  -rsp $"Wait $s seconds or press Escape-key or Arrow key to continue..." -t $s -d $'\e'; echo;echo;
}


function cleanup2 {
set -x
echo "cleanup running at  $(date +"_%Y.%m.%d_%H.%M.%S")"
echo "cleanup running at  $(date +"_%Y.%m.%d_%H.%M.%S")">> ${logdir}/cleanup.run.rclone.log
s=16 ; read  -rsp $"Wait $s seconds or press Escape-key or Arrow key to continue..." -t $s -d $'\e'; echo;echo;
}


# -----------------------------------------
# -----------------------------------------
# -----------------------------------------
# -----------------------------------------


#  main - start here


# flock start here (prevent second instance from running the content.)
#
func_exit () {
  # $(date +"_%Y.%m.%d")
  echo "One instance lock attempt failed  $(date +"_%Y.%m.%d_%H.%M.%S")">> ${logdir}/oneinstance-rclone.log
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
  # turned off because there is only one log file ---  archive1
) 9>"/var/lock/lockfile_202-02-34__$(basename -- "$0")"




# #  not using lockdir method. use flock.
#
# # set lockdir so that script will only run one instance..
# #
# bse=/ap/log/tmp
# mkdir -p $bse;
# LOCKDIR=${bse}/lockdir_oneinstance_$(basename -- "$0"); echo $LOCKDIR;
# echo sleeping 8.. ; sleep 8
# if mkdir ${LOCKDIR}; then
  # #Ensure that if we "grabbed a lock", we release it # Works for SIGTERM and SIGINT(Ctrl-C)
  # trap "cleanup" EXIT
  # echo "Acquired one-instance-only lock, running the content.."
  # ## echo "disabled, but made one-instance-only lock using windows window-title, running the content.."
  
  # #Main Processing starts here 
  # function_one
  # archive1
# else
  # #I had problems in cygwin. See how it goes in ubuntu. I think it has been good in the past..
  # #2021-05-27 having trouble. lockdir too often is not removed.
  # #disabled here by running function_one no matter what.
  # #see C:\data\script\movefiles575\start-move-files-575.bat
	# echo "Could not create one-instance lock directory '$LOCKDIR'. Is it already running?"
	# echo "Could not create one-instance lock directory '$LOCKDIR' Is it already running? at  $(date +"_%Y.%m.%d_%H.%M.%S")">> ${tempdir}/one_instance$(date +"_%Y.%m.%d").log
    # exit 1
# fi

# -----------------------------------------
# -----------------------------------------

# Version 2025-02-08a

# -----------------------------------------
# -----------------------------------------
