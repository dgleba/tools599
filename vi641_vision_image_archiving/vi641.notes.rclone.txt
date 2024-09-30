
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#@  
#@  rclone
#@  
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@   2022-08-01[Aug-Mon]10-49AM 


from cmd line, paste this..


ldir=/crib/log/rclone
mkdir -p $ldir
logf=movemcdata$(date +"__%Y.%m.%d_%b-%a_%H.%M.%S").log.txt
nohup rclone move --min-age=250d  --max-age=999d --delete-empty-src-dirs --order-by modtime,ascending \
  /mnt/nas2_ip10-4-56-190/mcdata /media/albe/vi641-001/mcdata   \
  --log-file=$ldir/$logf --log-level INFO &



#show log...

echo  $ldir/$logf
tail -f $ldir/$logf


    albe@pmda-dock-vi641:~$ jobs
    [1]+  Running     rclone move --min-age=180d --max-age=720d --delete-empty-src-dirs /mnt/nas2_ip10-4-56-190/mcdata /media/albe/vi641-001/mcdata --log-file=$ldir/movemcdata$(date +"__%Y.%m.%d_%b-%a_%H.%M.%S").log.txt --log-level INFO &
    albe@pmda-dock-vi641:~$


sftp://10.4.168.141
tail -f /crib/log/rclone/movemcdata__2022.08.26_Aug-Fri_18.02.18.log.txt

_____________


to stop..

kill %1
or
https://unix.stackexchange.com/questions/104821/how-to-terminate-a-background-process

=================================================






