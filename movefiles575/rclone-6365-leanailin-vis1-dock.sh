#!/bin/bash

# see version info at bottom.

# purpose: rclone  for 6365 lean ai move older images to archive (drive dock for example)

# use --log-file instead of tee..  sftp://10.4.168.141/crib/tools599/movefiles575/rclone-nas2-dock_02_uselog.sh

# usage:         nohup bash /crib/tools599/movefiles575/rclone-nas1-dock_02_uselog.sh &


echo "-+-+--+-+--+-+--+-+--+-+-  Starting $0 base:$(basename -- "$0") at  $(date +"_%Y.%m.%d_%H.%M.%S")"

# -----------------------------------------

# settings 

# REM :source dir
# ssc="/mnt/nas2_ip10-4-56-190/mcdata"

# REM :destination dir
# ddc=/media/albe/vi641-001/mcdata

# mkdir -p ${ddc}


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

echo "function_one running."

pwd; ls -la;

minage=1
srcdir=/media/leanai/leanai_data/leanai_aoi_outputs

rclone move --min-age=${minage}d  --max-age=999d  --order-by modtime,ascending  -v ${srcdir} \
dock-vi641-ssh:/media/albe/vi641-003/mcdata/mc_6365_vision_1/image_data  --log-file=$logf 

# rclone  --delete-empty-src-dirs seemed to remove empty dirs newer than min-age. Use bash to rm empty dirs.
echo removing older empty folders..
# oddly some older date folders have their mod-date updated. Why?
find "${srcdir}/" -mindepth 2  -mtime +2 -type d -empty -delete

#this deleted empty date folders leaving camera folders.... find "${srcdir}/" -mindepth 4  -type d -empty   -delete  
#  eg:  /media/leanai/leanai_data/leanai_aoi_outputs/parts/10R60/node_2_inner_rim_results/20240311/OK
#after deleting as above mindepth 4 - This listed only camera folders.. find "${srcdir}/"  -type d -empty  
#  eg output:  /media/leanai/leanai_data/leanai_aoi_outputs/parts/10R60/node_2_inner_rim_results


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
    find $srcdir/* -type f -size +100k   -mtime -${daysold} -exec mv --backup=numbered '{}' $arcdir/ \; 
    
    # remove 0 size files more than n day old..
    # find $srcdir -type f -mtime +90 -size 0 -delete

    # garbage old `archive-folder` files - rm files older than n days = mtime +n
    find $bse/* -mtime +90 -exec rm {} \;
}


NOTES__function() {

echo NOTES.... 

# sftp://10.4.168.141/mnt/nas1_pmda-sgenas01/mcdata
# sftp://10.4.168.141/mnt/nas1_pmda-sgenas01/training_library_in_development  /media/albe/vi641-001/mcdata/nas_1/training_library_in_development
# sftp://10.4.168.141/mnt/nas1_pmda-sgenas01/training_library_SGE-Rotor6365  /media/albe/vi641-001/mcdata/nas_1/training_library_SGE-Rotor6365

#   --log-file=$logf --log-level INFO

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
echo "cleanup2 running at  $(date +"_%Y.%m.%d_%H.%M.%S")"
echo "cleanup2 running at  $(date +"_%Y.%m.%d_%H.%M.%S")">> ${tempdir}/cleanup.run$(date +"_%Y.%m.%d").log
s=16 ; read  -rsp $"Wait $s seconds or press Escape-key or Arrow key to continue..." -t $s -d $'\e'; echo;echo;
}


# -----------------------------------------
# -----------------------------------------
# -----------------------------------------


#  main - start here


# cd to a temp folder in case some command is wrongly set to work on current folder.
cd /tmp ;mkdir -p ~/tmp; cd ~/tmp; pwd




# flock start here 2024-03-30
#
func_exit () {
echo "Exiting, maybe another instance is running."; exit 1
}
#
trap "cleanup2" EXIT
(
  flock -n 9 || func_exit
  # 2024-03-30 put commands executed under lock here...
  echo "Attempting one-instance-only lock, running the content.."
  # call function here to run the content..
  function_one
  archive1
) 9>"/var/lock/lockfile_2023-02-28__$(basename -- "$0")"



# -----------------------------------------
# -----------------------------------------




#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function blockcomment21 {
: <<'BLOCKCOMMENT'

# notes:

2024-03-30: archived the following..
#
# set lockdir so that script will only run one instance at a time..
#
bse=/ap/log/tmp
mkdir -p $bse;
LOCKDIR=${bse}/lockdir_oneinstance_$(basename -- "$0"); echo $LOCKDIR;
echo sleeping 8.. ; sleep 8
if mkdir ${LOCKDIR}; then
    #Ensure that if we "grabbed a lock", we release it # Works for SIGTERM and SIGINT(Ctrl-C)
    trap "cleanup" EXIT
    echo "Acquired one-instance-only lock, running the content.."
    ## echo "disabled, but made one-instance-only lock using windows window-title, running the content.."
    
    #Main Processing starts here 
    function_one
    archive1
else
  #I had problems in cygwin. See how it goes in ubuntu. I think it has been good in the past..
	#2021-05-27 having trouble. lockdir too often is not removed.
	#disabled here by running function_one no matter what.
	#see C:\data\script\movefiles575\start-move-files-575.bat
	echo "Could not create one-instance lock dir '$LOCKDIR'. Is it already running?"
	echo "Could not create one-instance lock dir '$LOCKDIR'  Is it already running? at  $(date +"_%Y.%m.%d_%H.%M.%S")">> ${tempdir}/one_instance$(date +"_%Y.%m.%d").log
    exit 1
fi


BLOCKCOMMENT
}
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


# -----------------------------------------
# -----------------------------------------
# -----------------------------------------
# -----------------------------------------
# -----------------------------------------
# -----------------------------------------

# History:

# 2024-03-31      adust empty folder cleaning.
# 2022-08-27 r00  start

# -----------------------------------------
