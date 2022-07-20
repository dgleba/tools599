#!/bin/bash

# see version info at bottom.

# purpose: archive/move files from multiple sources to one central archive.

#
# assumptions.
#
# - see settings.
# - src_base must be different than dest_base
# - there is a common folder path for source and dest.

# - this can overwrite files of the same name. be careful. 
#       You may want -u option of avoid overwriting newer destination files.
#       But, that may leave orphans in the source.

# - moves files to destination but doesn't erase other files in the destination.
#


# usage:          bash /crib/tools599/movefiles575/rsyncarc.sh

# usage:          bash /cygdrive/d/data/script/tools599/playyard/rsyncarc.sh


echo "-+-+--+-+--+-+--+-+--+-+-  Starting running  $0 at  $(date +"_%Y.%m.%d_%H.%M.%S")"

# -----------------------------------------
# -----------------------------------------

# Settings:


# REM :source dir
# src_base=/mnt/nas2_ip10-4-56-190
src_base=/cygdrive/c/0

# REM :destination dir
# dest_base=/media/albe/vi641-001
dest_base=/cygdrive/c/0/tarch

# common_part=/mcdata/mc_6830_vision/image_data/inner_bore
common_part=/t/m1


mkdir -p ${dest_base}${common_part}

tempdir=/tmp/move-to-archiv
mkdir -p ${tempdir}
timestart=$(date +"%Y.%m.%d_%H.%M.%S")

tfc=${tempdir}/rsyncfiles${timestart}.txt



# -----------------------------------------
# -----------------------------------------

function_one() {

# REM :getfilelist mtime+1 is 2 days old.  mmim +2880 is two days old.
echo "function_one ${pwd}"
echo 
cd "${src_base}${common_part}"
# find must be run from . current folder to get the list formated for rsync to use it.
# https://www.timeanddate.com/date/timeduration.html
# find . -type f  -mtime +100 > ${tfc}
#
#the regex: -P=perl regex. "_22\d{4}T\d{6}" finds  date starting with _22 in the filename example: ./outer_surface_220501T235918.png
# find . -type f  -mtime +120 |grep -P "_21\d{4}T\d{6}" | sort -n > ${tfc}
find . -type f   | sort -n > ${tfc}

echo file list..
cat ${tfc}

s=0091 ; read  -rsp $"Wait $s seconds or press Escape-key or Arrow key to continue..." -t $s -d $'\e'; echo;echo;

# REM :movefiles
echo moving files..
set -vx # echo on
#-a was not preserving mod time stamp on nas#2. 2022-01-16 dgleba.
# --remove-source-files
rsync  -vtlr --remove-source-files  --log-file=${tempdir}/rsynclog${timestart}.log  --files-from=${tfc} . ${dest_base}${common_part} 

# sometimes with mindepth 1 it doesn't touch/delete them. but it did with mindepth removed. 2022-04-11.
#
#echo "some empty folders may have newer dates than they should. touching to older.."
#  offline..
#    ind "${src_base}${common_part}/"  -mindepth 1 -type d -empty -exec touch -t 202101010101  {} \;

#remove empty folders because rsync does not
# find "${ssc}" -type d -empty -delete -mtime +3 
# find ${ssc}/  -mindepth 1  -mtime +3  -type d -empty -delete
# find "${ssc}/"  -mindepth 1  -mmin +4310 -type d -empty -delete
# find "${ssc}/"  -mindepth 1  -mmin +$((2*60*24-1)) -type d -empty -delete
# find "${ssc}/"  -mindepth 1  -mmin +$((135*60*24-1)) -type d -empty -delete
#
# echo removing older empty folders..
#   offline..
#   find "${src_base}${common_part}/" -mindepth 2  -mtime +7 -type d -empty -delete

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



# -----------------------------------------
# -----------------------------------------
# -----------------------------------------


#  main entry starts here

# This is in lockdir stanze... trap "cleanup" EXIT

# cd to a temp folder in case some command is wrongly set to work on current folder.
cd /tmp ;mkdir -p ~/tmp; cd ~/tmp; pwd

#
# set lockdir so that script will only run one instance..
#
LOCKDIR=/tmp/lockdir_1instnce_$(basename -- "$0")
if mkdir ${LOCKDIR}; then
    Ensure that if we "grabbed a lock", we release it # Works for SIGTERM and SIGINT(Ctrl-C)
    trap "cleanup" EXIT
    echo "Acquired one-instance-only lock, running the content.."
  
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

# This can be used to make sample files for testing.

# bse=/cygdrive/c/0
# cd $bse
# mkdir t ; cd t
# mkdir m1 ; cd m1
# mkdir a ; cd a
# #echo hello1 >a1
# echo hello2 >a2
# cd ../..
# mkdir m2 ; cd m2
# mkdir a ; cd a
# mkdir b ; touch b/b1
# touch a2
# sleep 61 ; touch a2


# -----------------------------------------
# -----------------------------------------
# -----------------------------------------
# -----------------------------------------

# History:

# 2022-07-18 r01  start

# -----------------------------------------
