

#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#@  
#@  setup nas mount on ubuntu vi641
#@  
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@   2022-07-19[Jul-Tue]10-41AM 

_____________


see secrets.txt

_____________

    3  sudo adduser albe
    4  id albe
    5  sudo usermod -a -G sudo albe
    6  id albe
    
_____________


on vi641 PC.
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
password=
HEREDOC
sudo chown root: $vcred
sudo chmod 600 $vcred

sudo mount /mnt/nas2_ip10-4-56-190




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
password=
HEREDOC
sudo chown root: $vcred
sudo chmod 600 $vcred

sudo mount /mnt/nas1_pmda-sgenas01



# fixed..
# albe@vi641a:/tmp$ sudo mount /mnt/nas1_pmda-sgenas01
# mount error(113): could not connect to 192.168.18.2 mount error(113): could not connect to 192.168.11.2 albe@vi641a:/tmp$



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


=================================================


