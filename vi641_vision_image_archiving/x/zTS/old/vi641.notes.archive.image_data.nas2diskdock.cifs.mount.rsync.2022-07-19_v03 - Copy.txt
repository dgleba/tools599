

#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#@  
#@  setup nas mount on ubuntu vi641
#@  
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@   2022-07-19[Jul-Tue]10-41AM 

_____________

secrets in this file 
  
  ubuntu: user: albe  pass:  Stackpole1325
  vnc  - see readme...txt

_____________

    3  sudo adduser albe
    4  id albe
    5  sudo usermod -a -G sudo albe
    6  id albe
    
_____________


on vi641 laptop.
install ubuntu 22.04
  use 20.04 next time. I have not yet adjusted to new changes in 22.04. eg: vnc connection. gnome extensions install.
plug in disk dock with 20Tb disk working and accessible.

_____________



install cifs and mount nas windows share...


sudo apt install cifs-utils


vd21='/mnt/nas2_ip10-4-56-190'
sudo mkdir -p $vd21

sudo tee -a /etc/fstab <<- 'HEREDOC'
#
# <file system>             <dir>              <type> <options>                                                   <dump>  <pass>
//10.4.65.190/Images  /mnt/nas2_ip10-4-56-190  cifs  credentials=/etc/nas2_ip10-4-56-190-credentials,file_mode=0777,dir_mode=0777 0       0
HEREDOC



vcred=/etc/nas2_ip10-4-56-190-credentials
sudo tee  $vcred  <<- 'HEREDOC'
username=Vision
password=Stackpole1325
HEREDOC
sudo chown root: $vcred
sudo chmod 600 $vcred

sudo mount /mnt/nas2_ip10-4-56-190


ref:
username=user
password=password
domain=domain

=================================================

vd21='/mnt/nas1_pmda-sgenas01'
sudo mkdir -p $vd21


sudo tee -a /etc/fstab <<- 'HEREDOC'
#
# <file system>             <dir>              <type> <options>                                                   <dump>  <pass>
//10.4.65.131/PMDA-SGE  /mnt/nas1_pmda-sgenas01  cifs  credentials=/etc/nas1_pmda-sgenas01-credentials,file_mode=0777,dir_mode=0777 0       0
HEREDOC



vcred=/etc/nas1_pmda-sgenas01-credentials
sudo tee  $vcred  <<- 'HEREDOC'
username=vision
password=Stackpole1325
HEREDOC
sudo chown root: $vcred
sudo chmod 600 $vcred

sudo mount /mnt/nas1_pmda-sgenas01


albe@vi641a:/tmp$ sudo mount /mnt/nas1_pmda-sgenas01
mount error(113): could not connect to 192.168.18.2 mount error(113): could not connect to 192.168.11.2 albe@vi641a:/tmp$



=================================================

_____________

albe@vi641a:/mnt$ df
Filesystem             1K-blocks        Used   Available Use% Mounted on
tmpfs                    1627304        2048     1625256   1% /run
/dev/sda2              982862268    14131308   918730628   2% /
..
/dev/sdb             19453055256          36 18476447580   1% /media/albe/vi641-001
//10.4.65.190/Images 10447560552 10447560416         136 100% /mnt/nas2_ip10-4-56-190
albe@vi641a:/mnt$

_____________


sudo mkdir -p /crib
sudo chown albe:albe /crib

sudo apt update
sudo apt install git mc ncdu


git clone https://github.com/dgleba/tools599.git

cd /crib/tools599/movefiles575

_____________

To copy files..
See 
D:\data\script\tools599\movefiles575\move_files_to_arc-a.sh
or
albe@vi641a:/crib/tools599/movefiles575$

_____________


bash /crib/tools599/movefiles575/move_files_to_arc-a.sh



# use these..

#cron..  arc-c
sudo crontab -u albe -l | grep -v 'movefiles575/move_files_to_arc-c.sh'  | sudo crontab -u albe - #remove
sudo crontab -u albe -l | { cat; echo "16 6 * * 0 "bash /crib/tools599/movefiles575/move_files_to_arc-c.sh" 2>&1 | tee -a /crib/log/albelogs/move-arc-c.log"; } | sudo crontab -u albe -  #add

#cron..  arc-d
sudo crontab -u albe -l | grep -v 'movefiles575/move_files_to_arc-d.sh'  | sudo crontab -u albe - #remove
sudo crontab -u albe -l | { cat; echo "40 16 * * 0-6 "bash /crib/tools599/movefiles575/move_files_to_arc-d.sh" 2>&1 | tee -a /crib/log/albelogs/move-arc-d.log"; } | sudo crontab -u albe -  #add

#cron..  arc-e-nas1
sudo crontab -u albe -l | grep -v 'movefiles575/move_files_to_arc-e-nas1.sh'  | sudo crontab -u albe - #remove
sudo crontab -u albe -l | { cat; echo "33 21 * * 0-6 "bash /crib/tools599/movefiles575/move_files_to_arc-e-nas1.sh" 2>&1 | tee -a /crib/log/albelogs/move-arc-e-nas1.log"; } | sudo crontab -u albe -  #add

#cron..  findall
sudo crontab -u albe -l | grep -v 'movefiles575/findnasall.sh'  | sudo crontab -u albe - #remove
sudo crontab -u albe -l | { cat; echo "42 10 * * 0-6 "bash /crib/tools599/movefiles575/findnasall.sh" 2>&1 | tee -a /crib/log/albelogs/findnas-all-sh.log"; } | sudo crontab -u albe -  #add

sudo crontab -u albe -l  # list


mkdir -p /crib/log/albelogs

_____________
_____________


# dont use these..

#cron.. test02
mkdir -p /tmp/albelogs
sudo crontab -u albe -l | grep -v 'movefiles575/move_files_to_arc-a-test02.sh'  | sudo crontab -u albe - #remove
sudo crontab -u albe -l | { cat; echo "56 * * * 0-6 "bash /crib/tools599/movefiles575/move_files_to_arc-a-test02.sh" 2>&1 | tee -a /var/log/albelogs/movetest02.log"; } | sudo crontab -u albe -  #add
#cron.. test02 tmp/albelogs
sudo crontab -u albe -l | { cat; echo "30 * * * 0-6 "bash /crib/tools599/movefiles575/move_files_to_arc-a-test02.sh" 2>&1 | tee -a /tmp/albelogs/movetest02.log"; } | sudo crontab -u albe -  #add

#cron.. arc-b
mkdir -p /tmp/albelogs
sudo crontab -u albe -l | grep -v 'movefiles575/move_files_to_arc-b.sh'  | sudo crontab -u albe - #remove
sudo crontab -u albe -l | { cat; echo "31 6 * * 0-6 "bash /crib/tools599/movefiles575/move_files_to_arc-b.sh" 2>&1 | tee -a /tmp/albelogs/move-arc-b.log"; } | sudo crontab -u albe -  #add


_____________

noworky..

killall -9 /crib/tools599/movefiles575/move_files_to_arc-a-test01.sh

_____________


=================================================

regex

 "_21\d{4}T\d{6}"
 
_210231T000101
_200101T000101
_220102T000101
_220309T000101
_220209T000101
_200101T000101
_210231T
_200101T123456000101a
_210231T000101a
_220102T000101a
_220209T000101a
_220309T000101a
_200101T000101


# year 21, year 21, month 2201...
"_21\d{4}T\d{6}|_20\d{4}T\d{6}|_2201\d{2}T\d{6}"

"_21\d{4}T\d{6}|_20\d{4}T\d{6}"

=================================================


mv move-arc-b.log move-arc-b-2022-07-20.log

mv move-arc-c.log move-arc-c-2022-07-20.log


albe@vi641a:/var/log$ 
sudo mkdir -p /var/log/albelogs
sudo chown 1000:1000 /var/log/albelogs

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

current:

sudo tee /etc/logrotate.d/albe_tmpalbelogs <<EOF
/tmp/albelogs/*.log {
    su 1000 1000
    rotate 11
    daily
    size 1k
    missingok
    nocompress
    notifempty
    addextension .old
}
/tmp/albelogs/*.old {
    su 1000 1000
    weekly
    compress
    delaycompress
    rotate 21
}
EOF



sudo logrotate -d /etc/logrotate.d/albe_tmpalbelogs
cat /etc/logrotate.d/albe_tmpalbelogs

# sudo logrotate  /etc/logrotate.d/albe_tmpalbelogs  2>&1 | tee /tmp/logrotate.cl$(date +"__%Y.%m.%d_%b-%a_%H.%M.%S").log.txt


What is -f option?
sudo logrotate -d -v /etc/logrotate.conf  2>&1 | tee /tmp/logrotate.cl$(date +"__%Y.%m.%d_%b-%a_%H.%M.%S").log.txt


example:

delay compression more..
One option could be to use logrotate to rotate to a different extension, then use logrotate to rotate into compressed files:
/var/log/raw.log {
  daily
  nocompress
  extension .old
  }
/var/log/*.old {
  weekly
  compress
  delaycompress
  rotate 10
  }

=================================================

adj.to 22.04 - not done.

sudo apt update
sudo apt install gnome-shell-extensions

https://extensions.gnome.org/extension/4338/allow-locked-remote-desktop/


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

_____________

# pslist and rkill..
#  sudo apt install pslist


fnd='findnasall.sh'
echo $fnd
apid=$(ps aux | grep $fnd | awk '{print $2}')
echo $apid
#for each item in space separated list..
for item in `echo $apid`; do
  echo $item
  sudo rkill $item
  kill -9  $item
done
ps -ef |grep $fnd
ls /tmp |grep lockdir



output:
albe@drivedockpc-OptiPlex-790:~$ echo $apid
4104736 4105066

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



_____________




_____________



=================================================






















