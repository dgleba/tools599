
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#@  
#@  
#@  
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@   2022-07-25[Jul-Mon]18-48PM 

see vi641...txt for more..

D:\n\sfile\corp-sf\projects\vi641_vision_image_archiving\vi641.notes.archive.image_data.nas2diskdock.cifs.mount.rsync.2022-07-19.txt

#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#@  
#@  
#@  
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@   2022-07-25[Jul-Mon]18-48PM 





# https://www.tecmint.com/install-logrotate-to-manage-log-rotation-in-linux/

sudo tee /etc/logrotate.d/albe_test <<EOF
/tmp/testalbe/*.log {
    su 1000 1000
    rotate 8
    daily
    size 1
    missingok
    nocompress
    notifempty
    addextension .old
}
/tmp/testalbe/*.old {
    su 1000 1000
    weekly
    compress
    delaycompress
    rotate 50
}
EOF

#---
    size 1K   [ size 1 means 1 byte ] size overrides daily
#may not do this date, but works..
    dateext
    dateformat -%Y-%m-%d.
#---
mkdir -p /tmp/testalbe
cp /tmp/albelogs/movetest02.log /tmp/testalbe/c.log
echo 2201031305 >>/tmp/testalbe/c.log
touch -t 2201051303 /tmp/testalbe/c.log
#touch  /tmp/testalbe/x.old
ll /tmp/testalbe

#dryrun:
logrotate -d /etc/logrotate.d/albe_test

sudo logrotate  /etc/logrotate.d/albe_test

ll /tmp/testalbe
