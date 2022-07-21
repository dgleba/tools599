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
