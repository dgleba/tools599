
# This should list files older than n days.


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
find . -type f  -mtime +67  -print0 | xargs -0 stat --printf='%.16y\t%A %a %h \t%s\t%n\n' |sort -n -r > ${tfc}
cat ${tfc}
cat ${tfc}| wc -l

#show file size disk usage by date..
find .  -mtime +67 -type f -printf '%TY-%Tm-%Td %s\n' | awk '{b[$1]+=$2} END{for (date in b) printf "%s %11.1f MiB\n", date, b[date]/1024**2}' | sort
