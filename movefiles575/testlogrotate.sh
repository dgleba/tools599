#!/bin/bash
echo "-+-+--+-+--+-+--+-+--+-+-  Starting $0 base:$(basename -- "$0") at  $(date +"_%Y.%m.%d_%H.%M.%S")"

# usage: bash /ap/script/tools599/movefiles575/testlogrotate.sh

dd=/ap/log/tmp/loga/
mkdir -p $dd; cd $dd
t="-+-+--+-+--+-+--+-+--+-+-  Starting $0 base:$(basename -- "$0") at  $(date +"_%Y.%m.%d_%H.%M.%S")"

# make some test files..
f=t3.log; echo $t>>$f ; touch -t 2012280159 $f;

f=t1.log; echo $t>>$f ; 


# remove 0 size files more than one day old..
find $dd -type f -mtime +1 -size 0 -delete

# ------------------------------------------------------------------------------------------


NOTES__function() {

echo NOTES.... 

# usage: bash /ap/script/tools599/movefiles575/testlogrotate.sh

=================================================

 test:

sudo tee /etc/logrotate.d/albe_rotate_tst2 <<EOF2
# rclone
/ap/log/tmp/loga/*.log  {
     su albe albe
     size=1
     rotate 30
     hourly
     missingok
     compress
       delaycompress
    #dateext
    #dateformat _%Y-%m-%d
}
EOF2

#dryrun:
sudo logrotate -dv /etc/logrotate.d/albe_rotate_tst2
sudo logrotate -v /etc/logrotate.d/albe_rotate_tst2

# sudo logrotate -f -v /etc/logrotate.d/albe_rotate01--xxx 
# sudo logrotate -f -v /etc/logrotate.d/albe_rotate_tst2 

dd=/ap/log/tmp/loga/
mkdir -p $dd; cd $dd
f=t2.log; echo xxxxxx.>>$f ; touch -t 2012280159 $f;
f=t1.log; echo xxxxxx.>>$f ; 


crontab -u albe -l | grep -v '575/testlogrotate.sh'  | crontab -u albe - #remove
crontab -u albe -l  # list
crontab -u albe -l | { cat; echo "01 * * * 0-6 bash /ap/script/tools599/movefiles575/testlogrotate.sh 2>&1 | tee -a /ap/log/tmp/loga/tsstlogrotate.log "; } | crontab -u albe -  #add
crontab -u albe -l  # list

# no need for this. logrotatehrly works.
# sudo crontab  -l | grep -v 'albe_rotate_tst2'  | crontab -u albe - #remove
# sudo crontab -u root -l | { cat; echo "31 * * * 0-6  logrotate -v /etc/logrotate.d/albe_rotate_tst2 2>&1 | tee -a /ap/log/tmp/loga/albe_rotate-tst2.log "; } | sudo crontab -u albe -  #add
# sudo crontab -u root -l  # list

mkdir -p /ap/script/tools599/movefiles575

=====

/usr/bin/run-parts  --help
/usr/bin/run-parts  --list /etc/cron.hourly

run-parts --test /etc/cron.daily 
run-parts --test /etc/cron.hourly

# copy logrotate to hourly since it is not there by default..
# sudo cp /etc/cron.daily/logrotate /etc/cron.hourly

sudo nano /etc/crontab

sudo nano /etc/cron.hourly/logrotate


# 2>&1 | tee -a /var/log/cron-hourly-dg.log 


albe@ubu703:/var/log$   
          sudo grep -in --color cron /var/log/syslog

sudo cat /var/lib/logrotate/status


ls -la /etc/cron.hourly
sh /etc/cron.hourly/logrotate

 2>&1 | tee -a /var/log/logrotatedglog


------------

  GNU nano 6.2           /etc/cron.hourly/logrotate *
#!/bin/sh
/usr/sbin/logrotate -v /etc/logrotate.conf 2>&1 | tee -a /var/log/logrotatedglog
EXITVALUE=$?

2023-05-07_Sun_12.47-PM:
tt="-+-+--+-+--+-+--+-+--+-+-=====  Starting $0 base:$(basename -- "$0") at  $(date +"_%Y.%m.%d_%H.%M.%S")"
ff=/var/log/logrotatedglog
echo $tt| tee -a $ff
echo DavidGleba| tee -a /var/log/logrotatedglog
/usr/sbin/logrotate -v /etc/logrotate.conf 2>&1 | tee -a $ff

------------

added to /etc/crontab.

# David Gleba try to get logrotate hourly.
02 *	* * *	root    /usr/sbin/logrotate -v /etc/logrotate.d/albe_rotate_tst2 2>&1 |tee -a /var/log/albe_rotate_tst-2_log 



------------ -------------------------------------------------
end notes
}


# --------------------------------------------------------------------------------------------------
