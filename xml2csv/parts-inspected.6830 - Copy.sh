#!/bin/bash

# see version info at bottom.

# purpose: report number of parts inspected per hour

# Note: started from by task schedule.. "C:\data\script\xml_to_csv_reports\6830_xml_to_csv_ml_vision.bat"

# usage:         /cygdrive/c/data/script/tools599/movefiles575/parts-inspected.6830.sh


# -----------------------------------------

s=2 ; read  -rsp $"Wait $s seconds or press Escape-key or Arrow key to continue..." -t $s -d $'\e'; echo;echo;

function onetimeperday {

# Check system boot time at certain hour...
H=$(date +%H)
echo "report at:  $(date +"_%Y.%m.%d_%H.%M.%S")"
# Check the hour and run if matches..

dopartsinspected

# if (( 23 == 10#$H )); then 
#     dopartsinspected   
# else
#     echo "dont report at this time"
# fi

#s=216 ; read  -rsp $"Wait $s seconds or press Escape-key or Arrow key to continue..." -t $s -d $'\e'; echo;echo;

}


function dopartsinspected {

echo parts inspected

cd $ssc; pwd
fmin=-$((1*60*24+5)) # x*60*24*y -- x=days y=minutes. x y time period to report
echo $fmin
find . -mmin $fmin -type f -iname *.png -printf '%TY-%Tm-%Td %TH:%TM:%TS,%TY-%Tm-%Td-%TH,%f,%h\n'  | sort >${ddc}/parts-inspected___filelist$(date +"_%Y.%m.%d_%H.%M.%S").csv
find . -mmin $fmin -type f -iname *.png -printf ',%TY-%Tm-%Td_%TH,%TY-%Tm-%Td,%TH\n'        | sort | uniq -c>${ddc}/partsinspectedbyhour$(date +"_%Y.%m.%d_%H.%M.%S").csv

}


# -----------------------------------------


function cleanup {

# copy log file created in windows scheduler to timestamped file..
set -x

echo "cleanup running at  $(date +"_%Y.%m.%d_%H.%M.%S")"
echo "cleanup running at  $(date +"_%Y.%m.%d_%H.%M.%S")">> ${tempdir}/cleanup.partsinspected.run$(date +"_%Y.%m.%d").log
s=6 ; read  -rsp $"Wait $s seconds or press Escape-key or Arrow key to continue..." -t $s -d $'\e'; echo;echo;
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
# ssc=/cygdrive/c/Users/pmdacameras/My\ Documents/LabVIEW\ Data/SGE\ Rotor\ Vision
ssc=/cygdrive/d/data/vision_6830/image_data/top_surface

# REM :destination dir
ddc="/cygdrive/d/data/vision_6830/xml_to_csv_reports"
mkdir -p ${ddc}

# this will run something only at a specified hour.

onetimeperday
date

# -----------------------------------------
# -----------------------------------------
# -----------------------------------------
# -----------------------------------------
# -----------------------------------------


# History:

# 2022-04-09 r01  ..
#            David Gleba started: 2022-04-09

# -----------------------------------------
