#!/bin/bash

#  rev: 04   David Gleba daterange: 2021-04-22 - 2021-04-22

# purpose: backup library

# usage:         /cygdrive/c/data/script/movefiles575/bkup-575f.sh


# echo "cleanup running at  $(date +"_%Y.%m.%d_%H.%M.%S")">> ${tempdir}/cleanup.run$(date +"_%Y.%m.%d").log
s=15 ; read  -rsp $"Wait $s seconds or press Escape-key or Arrow key to continue..." -t $s -d $'\e'; echo;echo;


# -----------------------------------------
# -----------------------------------------
# -----------------------------------------

#  start here

# cd to a temp folder in case some command is wrongly set to work on current folder.
cd /tmp ;mkdir -p ~/tmp; cd ~/tmp; pwd


# settings 


tempdir=/cygdrive/c/temp/moveimg
mkdir -p ${tempdir}
timestart=$(date +"_%Y.%m.%d_%H.%M.%S")

# REM :source dir
# ssc="/cygdrive/c/0/t1"
ssc=//pmda-sgenas01/PMDA-SGE/training_library_SGE-Rotor6365

# REM :destination dir
ddc="//pmda-sgenas01/PMDA-SGE/backup/bkup__training_library_SGE-Rotor6365"
mkdir -p ${ddc}

# REM :tempfile
# mkdir -p ~/temp
tfc=${tempdir}/rsyncfiles${timestart}.txt




cd $ssc
pwd

rsync -a --log-file=${tempdir}/bk_log${timestart}.log   . ${ddc} 



# -----------------------------------------

