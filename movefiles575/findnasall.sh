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

# -----------------------------------------

#  start here

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



echo "  start date $(basename -- "$0")  $(date +"_%Y.%m.%d_%H.%M.%S")" >> $logf
cat ${tfc}  | xargs  -I{} stat {} --printf='%.16y\t%n\n' | grep "^2022-06"  > ${tfc}.dategrep3
echo "  end date $(basename -- "$0")  $(date +"_%Y.%m.%d_%H.%M.%S")" >> $logf


echo "  start 365 $(basename -- "$0")  $(date +"_%Y.%m.%d_%H.%M.%S")" >> $logf
find . -type f  -mtime +365 > ${tfc}.365
echo "  end 365 $(basename -- "$0")  $(date +"_%Y.%m.%d_%H.%M.%S")" >> $logf



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

