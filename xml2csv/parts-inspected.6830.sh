#!/bin/bash

# see version info at bottom.

# purpose: report number of parts inspected per hour

# Note: started from by task schedule.. "C:\data\script\xml_to_csv_reports\6830_xml_to_csv_ml_vision.bat"

# usage:         /cygdrive/c/data/script/tools599/movefiles575/parts-inspected.6830.sh


# -----------------------------------------

s=2 ; read  -rsp $"Wait $s seconds or press Escape-key or Arrow key to continue..." -t $s -d $'\e'; echo;echo;


function dopartsinspected {

echo parts inspected

cd $ssc; pwd
mkdir -p $ddc/detail
fmin=-$((2*60*24+6)) # x*y*z+m -- example: x(days) y (60min/hr) z (say 24hr/day) m=minutes. time period to report
echo $fmin

rdate=$(date +"_%Y.%m.%d_%H.%M.%S")

# list the parts..
find . -mmin $fmin -type f -iname *.png -printf '%TY-%Tm-%Td %TH:%TM:%TS,%TY-%Tm-%Td-%TH,%f,%h\n'  | sort >${ddc}/detail/parts-inspected___filelist$rdate.csv

# sum/count by hour..
find . -mmin $fmin -type f -iname *.png -printf ',%TY-%Tm-%Td_%TH,%TY-%Tm-%Td,%TH\n'   | sort | uniq -c>>${ddc}/detail/partsinspectedbyhour$rdate.csv

# divide by 2 since there are 2 pics per part.
echo "cdatehour,cdate,chour,count_parts_inspected">>${ddc}/detail/partsinspectedbyhour.5$rdate.csv
find . -mmin $fmin -type f -iname *.png -printf '%TY-%Tm-%Td_%TH,%TY-%Tm-%Td,%TH,\n'   | sort | uniq -c | awk '{(val=$1/2);  print $2,int(val)}'>>${ddc}/detail/partsinspectedbyhour.5$rdate.csv

ydate=$(date -d "yesterday 13:00" '+%Y-%m-%d')
echo $ydate

# filter by date for the final report..
cat ${ddc}/detail/partsinspectedbyhour.5$rdate.csv|grep $ydate  >${ddc}/partsinspectedbyhour.5_$ydate.csv

}


# -----------------------------------------


function cleanup {

# copy log file created in windows scheduler to timestamped file..
set -x

echo "cleanup running at  $(date +"_%Y.%m.%d_%H.%M.%S")"
echo "cleanup running at  $(date +"_%Y.%m.%d_%H.%M.%S")">> ${tempdir}/cleanup.partsinspected.run$(date +"_%Y.%m.%d").log
s=56 ; read  -rsp $"Wait $s seconds or press Escape-key or Arrow key to continue..." -t $s -d $'\e'; echo;echo;
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

dopartsinspected

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
