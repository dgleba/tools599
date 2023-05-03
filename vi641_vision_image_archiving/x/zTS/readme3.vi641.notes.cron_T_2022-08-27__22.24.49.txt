
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#@  
#@  cron editing and stop a cron task.
#@  
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@   2022-08-01[Aug-Mon]10-49AM 


# use these..

mkdir -p /crib/log/albelogs

#cron..  rclone
sudo crontab -u albe -l | grep -v 'movefiles575/rclone-nas2-dock_01.sh'  | sudo crontab -u albe - #remove
sudo crontab -u albe -l | { cat; echo "08 22 * * 0-6 "bash /crib/tools599/movefiles575/rclone-nas2-dock_01.sh" 2>&1 | tee -a /crib/log/albelogs/rclonenas2-dock01.log"; } | sudo crontab -u albe -  #add

sudo crontab -u albe -l  # list

mkdir -p /crib/log/albelogs


_____________

offline..

#cron..  arc-d
sudo crontab -u albe -l | grep -v 'movefiles575/move_files_to_arc-d.sh'  | sudo crontab -u albe - #remove
sudo crontab -u albe -l | { cat; echo "40 10 * * 0-6 "bash /crib/tools599/movefiles575/move_files_to_arc-d.sh" 2>&1 | tee -a /crib/log/albelogs/move-arc-d.log"; } | sudo crontab -u albe -  #add

#cron..  arc-e-nas1
sudo crontab -u albe -l | grep -v 'movefiles575/move_files_to_arc-e-nas1.sh'  | sudo crontab -u albe - #remove
sudo crontab -u albe -l | { cat; echo "33 21 * * 0-6 "bash /crib/tools599/movefiles575/move_files_to_arc-e-nas1.sh" 2>&1 | tee -a /crib/log/albelogs/move-arc-e-nas1.log"; } | sudo crontab -u albe -  #add

#cron..  findall
sudo crontab -u albe -l | grep -v 'movefiles575/findnasall.sh'  | sudo crontab -u albe - #remove
sudo crontab -u albe -l | { cat; echo "13 11 * * mon,thu "bash /crib/tools599/movefiles575/findnasall.sh" 2>&1 | tee -a /crib/log/albelogs/findnas-all-sh.log"; } | sudo crontab -u albe -  #add


=================================================


# pslist and rkill..
#  sudo apt install pslist


fnd='findnasall.sh'
fnd2='findnas'
echo $fnd
ps -ef |grep  findnas 
ps -ef |grep -v 'color=auto' CRON 
#get process id's of matching by command $fnd
apid=$(ps aux | grep $fnd2 | awk '{print $2}')
echo $apid
#for each item in space separated list..
for item in `echo $apid`; do
  ps -ef|grep $item |grep -v 'color=auto' 
done

#
#for each item in space separated list..
for item in `echo $apid`; do
  echo $item
  rkill $item
  #kill   $item
done
ps -ef |grep $fnd
ls /tmp |grep $fnd
rmdir /tmp/lockdir*$fnd
ps -ef|tail -n60


output:
albe@drivedockpc-OptiPlex-790:~$ echo $apid
4104736 4105066

_____________

#fnd=move_files_to_arc-d
fnd=move_files_to_doc2arc
#fnd='findnasall.sh'
#fnd2='findnas'
echo $fnd
ps -ef |grep  $fnd
ps -ef |grep -v 'color=auto' CRON 
#get process id's of matching by command $fnd
apid=$(ps aux | grep $fnd | awk '{print $2}')
echo $apid
#for each item in space separated list..
for item in `echo $apid`; do
  ps -ef|grep $item |grep -v 'color=auto' 
done

#
#for each item in space separated list..
for item in `echo $apid`; do
  echo $item
  rkill $item
  #kill   $item
done
ps -ef |grep $fnd
ls /tmp |grep $fnd
rmdir /tmp/lockdir*$fnd
ps -ef|tail -n60


_____________

root     2718614    1010  0 Jul31 ?        00:00:00 /usr/sbin/CRON -f
albe     2718615 2718614  0 Jul31 ?        00:00:00 /bin/sh -c bash /crib/tools599/movefiles575/findnasall.sh 2>&1 | tee -a /tmp/albelogs/findnas-all-sh.log
albe     2718616 2718615  0 Jul31 ?        00:00:00 bash /crib/tools599/movefiles575/findnasall.sh
albe     2718617 2718615  0 Jul31 ?        00:00:00 tee -a /tmp/albelogs/findnas-all-sh.log
albe     2749670 2718616  0 Jul31 ?        00:00:00 cat /tmp/moveimg/findallnas2_ip10-4-56-190.txt
albe     2749671 2718616  0 Jul31 ?        00:04:14 xargs -I{} stat {} --printf=%.16y\t%n\n
albe     2749672 2718616  0 Jul31 ?        00:00:40 grep ^2022-06

_____________


bash /crib/tools599/movefiles575/findnasall.sh 2>&1 | tee -a /tmp/albelogs/findnas-all-sh.log &


# have to use process number, but will kill all child..
pslist
sudo apt install pslist
rkill
https://manpages.debian.org/bullseye/psmisc/killall.1.en.html
Signals can be specified either by name (e.g. -HUP or -SIGHUP) or by number (e.g. -1) or by option -s.



=================================================

kill process by name:

pkill -9 -f arc-c

fnd='findnasall.sh'
fnd2='findnas'
echo $fnd
ps -ef |grep $fnd
ps -ef |grep $fnd2

#won't kill all child. and it won't allow cleanup.
#pkill -9 -f $fnd

=================================================


dock was not mounted, so files were being copied to local root disk. fix it.



#cron..  move_files_to_doc2arc /media/drivedockpc/* to archive
sudo crontab -u albe -l | grep -v 'movefiles575/move_files_to_doc2arc.sh'  | sudo crontab -u albe - #remove
#sudo crontab -u albe -l | { cat; echo "56 21 2 * * "bash /crib/tools599/movefiles575/move_files_to_doc2arc.sh" 2>&1 | tee -a /crib/log/albelogs/move-log_files_to_doc2arc.log"; } | sudo crontab -u albe -  #add


bash /crib/tools599/movefiles575/move_files_to_doc2arc.sh 2>&1 | tee -a /crib/log/albelogs/move-log_files_to_doc2arc.log

tail -f /crib/log/albelogs/move-log_files_to_doc2arc.log

find . -type d -empty -delete

=================================================






















