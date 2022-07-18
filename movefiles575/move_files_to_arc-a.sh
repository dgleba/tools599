#!/bin/bash

# see version info at bottom.

# purpose: move older images to archive (drive dock for example)

# usage:         /cygdrive/c/data/script/movefiles575/move_files_to_ .... .sh


# History of this file:
# 2022-07-18 see bottom of file for history.


# -----------------------------------------

function_one() {

# REM :getfilelist mtime+1 is 2 days old.  mmim +2880 is two days old.
echo "function_one ${pwd}"
cd "${ssc}"
# find must be run from . current folder to get the list formated for rsync to use it.
# https://www.timeanddate.com/date/timeduration.html
# find . -type f  -mtime +100 > ${tfc}
find . -type f  -mtime +13 -iname *.xml > ${tfc}
echo file list..
cat ${tfc}

s=31 ; read  -rsp $"Wait $s seconds or press Escape-key or Arrow key to continue..." -t $s -d $'\e'; echo;echo;

# REM :movefiles
echo moving files..
set -vx # echo on
#-a was not preserving mod time stamp on nas#2. 2022-01-16 dgleba.
rsync  -vtlr -u  --log-file=${tempdir}/rsynclog${timestart}.log  --files-from=${tfc} . ${ddc} 

# sometimes with mindepth 1 it doesn't touch/delete them. but it did with mindepth removed. 2022-04-11.
echo "some empty folders may have newer dates than they should. touching.."
# find "${ssc}/"  -mindepth 1 -type d -empty -exec touch -t 202101010101  {} \;

#remove empty folders because rsync does not
# find "${ssc}" -type d -empty -delete -mtime +3 
# find ${ssc}/  -mindepth 1  -mtime +3  -type d -empty -delete
# find "${ssc}/"  -mindepth 1  -mmin +4310 -type d -empty -delete
# find "${ssc}/"  -mindepth 1  -mmin +$((2*60*24-1)) -type d -empty -delete
# find "${ssc}/"  -mindepth 1  -mmin +$((135*60*24-1)) -type d -empty -delete
echo removing older empty folders..
# find "${ssc}/" -mindepth 2  -mtime +30 -type d -empty -delete
  
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
ssc="//10.4.65.190/Images/mc_6830_vision/image_data"

# REM :destination dir
# temporary change to d drive 2021-07-19 ---  ddc="//pmda-sgenas01/PMDA-SGE/image_data/SGE_Rotor_6365"
# ddc="/cygdrive/d/image_data/SGE_Rotor_6365"
ssc=/cygdrive/d/0/vision_6830/image_data
mkdir -p ${ddc}

# REM :tempfile
# mkdir -p ~/temp
tfc=${tempdir}/rsyncfiles${timestart}.txt

function_one



# -----------------------------------------
# -----------------------------------------
# -----------------------------------------
# -----------------------------------------
# -----------------------------------------



# History:

# 2022-07-18 r01  start

# -----------------------------------------
