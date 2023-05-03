
# Archive vision images to drive dock 20TB HDD's at PMA

2022-07-12 David Gleba
 
=================================================
Secrets in this file:

ubuntu  -  user: albe   password: Stackpole1325
vnc  -  password: pmda1325

=================================================

# Info.. 
 
# Disk:
 
Number HDD's
vi641-001
vi641-002
etc

 
Seagate Iron Wolf 20 TB disks
disk format: ext4 

# Dock:

https://www.startech.com/en-ca/hdd/sdock2u313

=================================================

# Setup...

# Laptop:

hostname: pmda-dock-vi641
[an optiplex desktop - service tag: hpq0xv1]
ubuntu 20.04 desktop 
user: albe   password: Stackpole1325
ip address: 10.4.168.141

note: old. we are not using this: user: drivedock-pc  pass:Stackpole1325


# Scripts:

Scripts to archive vision images are here:
tbd


# images from:

1. 6830 DV6
2. 6365 SGE 10R


# Enable ssh access:

https://linuxhint.com/enable-use-ssh-ubuntu/

sudo apt update
sudo apt install openssh-server -y


# Remote desktop

1.
in ubu 20.04 settings gui 
-sharing screen enable
password: pmda1325
2.
-from bash command line:
gsettings reset org.gnome.Vino network-interface 
gsettings set org.gnome.Vino require-encryption false
3.
-use tigntvnc for windows client as we do for windows pc's with tightvncserver installed.
4.
enable autologin for albe user.


=================================================

More:

see readme2..  and readme3...


=================================================


