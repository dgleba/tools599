# c:\prg\cygwin64\bin\bash.exe -l -c  "/cygdrive/c/data/script/tools599/movefiles575/cfiletodo.sh"

tempdir=/cygdrive/c/temp/moveimg
mkdir -p ${tempdir}
timestart=$(date +"%Y.%m.%d_%H.%M.%S")
tfc=${tempdir}/rsyncfiles_ctodo_${timestart}.txt
# REM :source dir
ssc=/cygdrive/d/data/vision_6830/image_data
cd "${ssc}"

# find . -type f  -mtime +72 > ${tfc}
# find . -type f  -mtime +67 > ${tfc}
# files older than -mtime 67days - show oldest files last...

# number of days to report on..
tnum=+27
echo $tnum
#
find . -type f  -mtime $tnum  -print0 | xargs -0 stat --printf='%.16y\t%A %a %h \t%s\t%n\n' |sort -n -r  | tee -a ${tfc}
#cat ${tfc}
cat ${tfc}| wc -l | tee -a ${tfc}

#show file size disk usage by date..
find .  -mtime $tnum -type f -printf '%TY-%Tm-%Td %s\n' | awk '{b[$1]+=$2} END{for (date in b) printf "%s %11.1f MiB\n", date, b[date]/1024**2}' | sort | tee -a  ${tfc}
echo $tnum | tee -a ${tfc}

