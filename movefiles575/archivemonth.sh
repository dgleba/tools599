#!/bin/bash
echo "-+-+--+-+--+-+--+-+--+-+-  Starting $0 base:$(basename -- "$0") at  $(date +"_%Y.%m.%d_%H.%M.%S")"

# usage: bash /ap/script/tools599/movefiles575/archivemonth.sh

# Use case: log files. move files to archive folders. 

function archive1 {
    echo running archive1..
    srcdir=/ap/log/tmp/loga
    # set basedir $bse for archive
    bse=/ap/log/archive
    arcd=$bse/$(date +"%Y-%m-%d")
    mkdir -p $arcd
    # move the files..
    mv /$srcdir/* $arcd
    
    # remove 0 size files more than n day old..
    find $srcdir -type f -mtime +90 -size 0 -delete

    # garbage old files - rm files older than n days = mtime +n
    find $bse/* -mtime +1000 -exec rm {} \;
}

function onehourperday {

# check for certain hour...
H=$(date +%H)
echo "hourchk at  $(date +"_%Y.%m.%d_%H.%M.%S")"
# Check if the hour  matches..
if (( 13 == 10#$H )); then 
    echo matched. do stuff.
    archive1
else
    echo not matched
fi
s=6 ; read  -rsp $"Wait $s seconds or press Escape-key or Arrow key to continue..." -t $s -d $'\e'; echo;echo;
}

function onedaypermonth {

# Check certain day of month...
day1=$(date +%d)
echo "daycheck at  $(date +"_%Y.%m.%d_%H.%M.%S")"
# Check the day and run if matches..
if (( 7 == 10#$day1 )); then 
    echo matched today. 
    onehourperday
else
    echo not today
fi
}



# -----------------------------------------------------------------
NOTES__function() {

echo NOTES.... 

# 

------------ -------------------------------------------------
end notes
}
# -------------------------------------------------------------------

onedaypermonth

