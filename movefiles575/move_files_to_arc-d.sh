#!/bin/bash

# see version info at bottom.

# purpose: TEST folder only...  move older images to archive (drive dock for example)

# usage:          bash /crib/tools599/movefiles575/move_files_to_arc-a-test02.sh



echo "-+-+--+-+--+-+--+-+--+-+-  Starting $0 base:$(basename -- "$0") at  $(date +"_%Y.%m.%d_%H.%M.%S")"


# -----------------------------------------

function_one() {

# REM :getfilelist mtime+1 is 2 days old.  mmim +2880 is two days old.
echo "function_one ${pwd}"
cd "${ssc}"
# find must be run from . current folder to get the list formated for rsync to use it.
# https://www.timeanddate.com/date/timeduration.html
# find . -type f  -mtime +100 > ${tfc}
#
#the regex: -P=perl regex. "_22\d{4}T\d{6}" finds  date starting with _22 in the filename example: ./outer_surface_220501T235918.png
#find . -type f  -mtime +120 |grep -P "_20\d{4}T\d{6}" | sort -n > ${tfc}
# doing find all then grep sort after was less than one hour vs. 10 hour in the above command..
find . -type f  > ${tfc}.a
echo "  start b $(basename -- "$0")  $(date +"_%Y.%m.%d_%H.%M.%S")" >> $logf
cat ${tfc}.a |grep -P "_2201\d{2}T\d{6}" | sort -n  > ${tfc}


echo file list..
cat ${tfc}

s=011 ; read  -rsp $"Wait $s seconds or press Escape-key or Arrow key to continue..." -t $s -d $'\e'; echo;echo;

# REM :movefiles
echo moving files..
set -vx # echo on
#-a was not preserving mod time stamp on nas#2. 2022-01-16 dgleba.
# --remove-source-files
rsync  -vtlr --remove-source-files  --log-file=$logf  --files-from=${tfc} . ${ddc} 

# sometimes with mindepth 1 it doesn't touch/delete them. but it did with mindepth removed. 2022-04-11.
echo "some empty folders may have newer dates than they should. touching.."
#find "${ssc}/"  -mindepth 1 -type d -empty -exec touch -t 202101010101  {} \;

#remove empty folders because rsync does not
# find "${ssc}" -type d -empty -delete -mtime +3 
# find ${ssc}/  -mindepth 1  -mtime +3  -type d -empty -delete
# find "${ssc}/"  -mindepth 1  -mmin +4310 -type d -empty -delete
# find "${ssc}/"  -mindepth 1  -mmin +$((2*60*24-1)) -type d -empty -delete
# find "${ssc}/"  -mindepth 1  -mmin +$((135*60*24-1)) -type d -empty -delete
echo removing older empty folders..
find "${ssc}/" -mindepth 2  -mtime +120 -type d -empty -delete
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



# This is in lockdir stanze... trap "cleanup" EXIT

# cd to a temp folder in case some command is wrongly set to work on current folder.
cd /tmp ;mkdir -p ~/tmp; cd ~/tmp; pwd



# -----------------------------------------

# settings 

#Check the find statement around line 29 to see what files it will select for moving..
# example: find . -type f  -mtime +120 |grep -P "_21\d{4}T\d{6}" | sort -n > ${tfc}


# REM :source dir
# ssc="/cygdrive/c/0/t1"
# ssc=/cygdrive/c/Users/pmdacameras/My\ Documents/LabVIEW\ Data/SGE\ Rotor\ Vision
#ssc="//10.4.65.190/Images/mc_6830_vision/image_data"
# ssc="//10.4.65.190/Images/mc_6830_vision/image_data"
# ssc="//10.4.65.190/Images/mc_6830_vision/image_data/inner_rim/nok/210602"
# ssc="/mnt/nas2_ip10-4-56-190/mcdata"
# ssc=/mnt/nas2_ip10-4-56-190/mcdata/mc_6830_vision/image_data/inner_bore
ssc=/mnt/nas2_ip10-4-56-190/test

# REM :destination dir
# temporary change to d drive 2021-07-19 ---  ddc="//pmda-sgenas01/PMDA-SGE/image_data/SGE_Rotor_6365"
# ddc="/cygdrive/d/image_data/SGE_Rotor_6365"
#ddc=/cygdrive/d/0/wdir/vision_6830/image_data
# ddc=albe@10.4.168.94:/media/albe/vi641-001/test_mcdata/image_data/t3
# ddc=/media/albe/vi641-001/mcdata/mc_6830_vision/image_data/inner_bore
ddc=/media/albe/vi641-001/test_mcdata

mkdir -p ${ddc}


tempdir=/tmp/moveimg
mkdir -p ${tempdir}
timestart=$(date +"%Y.%m.%d_%H.%M.%S")
rslognamepart=$(basename -- "$0")
tfc=${tempdir}/rsyncfiles_${rslognamepart}_${timestart}.txt
logf=${tempdir}/rsynclog_${rslognamepart}_${timestart}.log


# end settings.
# -----------------------------------------


#
# set lockdir so that script will only run one instance..
#
LOCKDIR=/tmp/lockdir_oneinstance_$(basename -- "$0")
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

# 2022-07-21 r02  just a test folder.
# 2022-07-18 r01  start

# -----------------------------------------
