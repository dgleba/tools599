
# Archive vision images to drive dock 20TB HDD's at PMA

2022-07-12 David Gleba
 
# Disk:
 
Number HDD's
vi641-001
vi641-002
etc

 
Seagate Iron Wolf 20 TB disks
disk format: ext4 

# Dock:

https://www.startech.com/en-ca/hdd/sdock2u313


# Laptop:

hostname: vi641a
[Was PMDS maintenance laptop]
ubuntu 22.04 desktop (use 20.04 next time)
user: albe password:handy
ip address: tbd


# Scripts:

Scripts to archive vision images are here:
tbd


# images from:

1. 6830 DV6
2. 6365 SGE 10R


# Enable ssh access:

https://linuxhint.com/enable-use-ssh-ubuntu/

sudo apt install openssh-server -y


# Remote desktop

1.
in ubu 20.04 settings gui 
-sharing screen enable
2.
-do:
gsettings reset org.gnome.Vino network-interface 
gsettings set org.gnome.Vino require-encryption false
3.
-use tigntvnc for windows client as we do for windows pc's with tightvncserver installed.

==
note: i was able to connect to ubu22.04 screen sharing using tiger vnc windows becasue it has tls encryption
==

We could try RDP:
I found this didn't work every time.
  https://ubuntuhandbook.org/index.php/2022/04/ubuntu-22-04-remote-desktop-control/

Not this one.
  https://serverspace.io/support/help/install-tightvnc-server-on-ubuntu-20-04/
    but let's try without the xfce4 stuff.. apt install xfce4 xfce4-goodies
don't Do this:
sudo ufw allow 5901/tcp
sudo apt install  tightvncserver
#Configuring TightVNC Server
vncserver
#Set a password and confirm it. 
#We can set the autorun stuff later if we stick with vncserver.




