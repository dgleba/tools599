#!/bin/bash

# -----------------------------------------

# settings 
ssc=/mnt/nas2_ip10-4-56-190/mcdata

tempdir=/tmp/moveimg
mkdir -p ${tempdir}
timestart=$(date +"%Y.%m.%d_%H.%M.%S")
tfc=${tempdir}/findallnas2_ip10-4-56-190.txt
logf=${tempdir}/findallnas2_ip10-4-56-190.$(date +"_%Y.%m.%d").log

# end settings.
# -----------------------------------------

echo "-+-+--+-+-  Starting  $0  $(date +"_%Y.%m.%d_%H.%M.%S")" >> $logf


function_one() {

cd "${ssc}"
#find . -type f  |grep -P "_20\d{4}T\d{6}" | sort -n > ${tfc}
find . -type f  > ${tfc}.a

echo "  start b $(basename -- "$0")  $(date +"_%Y.%m.%d_%H.%M.%S")" >> $logf
cat ${tfc}.a | sort -n  > ${tfc}

echo "  start c $(basename -- "$0")  $(date +"_%Y.%m.%d_%H.%M.%S")" >> $logf
#cat ${tfc}.a |grep -P "_2201\d{2}T\d{6}" > ${tfc}.b
cat ${tfc} |grep -P "_19\d{4}T\d{6}|_20\d{4}T\d{6}|_21\d{4}T\d{6}" > ${tfc}.testregx

echo file list..
#cat ${tfc}.c
echo "  end $(basename -- "$0")  $(date +"_%Y.%m.%d_%H.%M.%S")" >> $logf


#this takes too long
# echo "  start date $(basename -- "$0")  $(date +"_%Y.%m.%d_%H.%M.%S")" >> $logf
# cat ${tfc}  | xargs  -I{} stat {} --printf='%.16y\t%n\n' | grep "^2022-06"  > ${tfc}.dategrep3
# echo "  end date $(basename -- "$0")  $(date +"_%Y.%m.%d_%H.%M.%S")" >> $logf


echo "  start 365 $(basename -- "$0")  $(date +"_%Y.%m.%d_%H.%M.%S")" >> $logf
find . -type f  -mtime +365 > ${tfc}.365
echo "  end 365 $(basename -- "$0")  $(date +"_%Y.%m.%d_%H.%M.%S")" >> $logf

}



example01 () {
find .  -type f >f.txt
# Pass output of command1 through xargs using substitution (the braces) to command2. xargs will call command2 for each thing found.
cat f.txt | xargs  -I{} stat {} --printf='%.16y\t%n\n' | grep 2022-07-30
}


example02 () {
    
cd ssc=/mnt/nas2_ip10-4-56-190/mcdata
tempdir=/tmp/moveimg
mkdir -p ${tempdir}
timestart=$(date +"%Y.%m.%d_%H.%M.%S")
tfc=${tempdir}/findallnas2_ip10-4-56-190.txt    
cat findallnas2_ip10-4-56-190.txt
cat ${tfc}  | xargs  -I{} stat {} --printf='%.16y\t%n\n' | grep "^2022-06"  > ${tfc}.dategrep 

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
echo "cleanup running at  $(date +"_%Y.%m.%d_%H.%M.%S")">> ${logf}
s=16 ; read  -rsp $"Wait $s seconds or press Escape-key or Arrow key to continue..." -t $s -d $'\e'; echo;echo;
}



# -----------------------------------------
# -----------------------------------------
# -----------------------------------------



#  start here


#
# set lockdir so that script will only run one instance..
#
LOCKDIR=/tmp/lockdir_oneinstance_$(basename -- "$0")
if mkdir ${LOCKDIR}; then
    #Ensure that if we "grabbed a lock", we release it # Works for SIGTERM and SIGINT(Ctrl-C)
    trap "cleanup" EXIT
    echo "Acquired one-instance-only lock, running the content at $(date +"_%Y.%m.%d_%H.%M.%S").."
    ## echo "disabled, but made one-instance-only lock using windows window-title, running the content.."
    
    #Main Processing starts here 
    function_one
else
    #I had problems in cygwin. See how it goes in ubuntu. I think it has been good in the past..
	#2021-05-27 having trouble. lockdir too often is not removed.
	#disabled here by running function_one no matter what.
	#see C:\data\script\movefiles575\start-move-files-575.bat
	echo "Could not create one-instance lock directory '$LOCKDIR'. at  $(date +"_%Y.%m.%d_%H.%M.%S"). Is it already running?"
	echo "Could not create one-instance lock directory '$LOCKDIR' at  $(date +"_%Y.%m.%d_%H.%M.%S")">> ${tempdir}/one_instance$(date +"_%Y.%m.%d").log
    exit 1
fi
