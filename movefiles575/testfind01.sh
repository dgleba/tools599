#!/bin/bash

# #      cd /crib/tools599/movefiles575/ ;  bash testfind01.sh

# -----------------------------------------


example01 () {
find .  -type f >f.txt
# Pass output of command1 through xargs using substitution (the braces) to command2. xargs will call command2 for each thing found.
cat f.txt | xargs  -I{} stat {} --printf='%.16y\t%n\n' | grep 2022-07-30
}


example02 () {
    
cd /mnt/nas2_ip10-4-56-190/mcdata
tempdir=/tmp/moveimg
mkdir -p ${tempdir}
timestart=$(date +"%Y.%m.%d_%H.%M.%S")
tfc=${tempdir}/findallnas2_ip10-4-56-190.txt    
cat ${tfc}  | xargs  -I{} stat {} --printf='%.16y\t%n\n' | grep "^2022-06"  | tee  ${tfc}.dategrep2 

}


example02
