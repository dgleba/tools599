

=================================================

This makes files in m1/.. m2/... 
it moves/archives the to m-arc without destroying existing archive. 
It will overwrite the same filename/path though.
This works since an image should not be edited anyway.
eg: 
D:\copyof\corp-fs01\CORP-PM\data_eng\ml_lib\ml_lib_6830\validate\outer_surface_2022-04-25\220501\ok\outer_surface_220501T235843.png


date
bse=/cygdrive/c/0
cd $bse

mkdir t ; cd t

mkdir m1 ; cd m1
mkdir a ; cd a
#echo hello1 >a1
echo hello2 >a2

cd ../..
mkdir m2 ; cd m2
mkdir a ; cd a
mkdir b ; touch b/b1
touch a2
#touch a3
sleep 61 ; touch a2

cd $bse/t
find . -mtime -929 -type f -print0 | xargs -0 stat --printf='%.16y %A %a %h %U %u\t %G %g\t %s\t %n\n' |sort -n

cd $bse/t
rsync -vtlr  --itemize-changes --remove-source-files  m2/ m-arc/
rsync -vtlr  --itemize-changes --remove-source-files  m1/ m-arc/

cd $bse/t
find . -mtime -929 -type f -print0 | xargs -0 stat --printf='%.16y %A %a %h %U %u\t %G %g\t %s\t %n\n' |sort -n |grep a2


_____________




no files in m-arc have been removed in the output below..

dgleba@SICS-GZPJL13 /cygdrive/c/0/t
$ find . -mtime -929 -type f -print0 | xargs -0 stat --printf='%.16y %A %a %h %U %u\t %G %g\t %s\t %n\n' |sort -n
2022-06-02 01:06 -rwxrwxr-x 775 1 dgleba 1058454         Domain Users 1049089    2369544         ./m-arc/a/outer_surface_220106T094608.png
2022-07-18 20:33 -rw-rw-r-- 664 1 dgleba 1058454         Domain Users 1049089    15340   ./m-arc/a/t5estforloop.txt
2022-07-18 20:33 -rw-rw-r-- 664 1 dgleba 1058454         Domain Users 1049089    1680    ./m-arc/a/testforloop.txt
2022-07-18 20:33 -rw-rw-r-- 664 1 dgleba 1058454         Domain Users 1049089    27300   ./m-arc/a/t6estforloop.txt
2022-07-18 20:33 -rw-rw-r-- 664 1 dgleba 1058454         Domain Users 1049089    3250    ./m-arc/a/a2
2022-07-18 20:33 -rw-rw-r-- 664 1 dgleba 1058454         Domain Users 1049089    3250    ./m-arc/a/t2estforloop.txt
2022-07-18 20:33 -rw-rw-r-- 664 1 dgleba 1058454         Domain Users 1049089    4680    ./m-arc/a/t3estforloop.txt
2022-07-18 20:33 -rw-rw-r-- 664 1 dgleba 1058454         Domain Users 1049089    6110    ./m-arc/a/t4estforloop.txt
2022-07-18 20:57 -rw-rw-r-- 664 1 dgleba 1058454         Domain Users 1049089    7       ./m-arc/a/a1
2022-07-18 20:58 -rw-rw-r-- 664 1 dgleba 1058454         Domain Users 1049089    0       ./m-arc/a/a3
2022-07-18 21:13 -rw-rw-r-- 664 1 dgleba 1058454         Domain Users 1049089    0       ./m-arc/a/b/b1
2022-07-19 12:47 -rwxrwxr-x 775 1 dgleba 1058454         Domain Users 1049089    0       ./m-arc/a/c.txt

dgleba@SICS-GZPJL13 /cygdrive/c/0/t
$

=================================================
=================================================
=================================================
=================================================
=================================================
=================================================
=================================================
=================================================



#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#@  
#@  report output..
#@  
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@   2022-07-19[Jul-Tue]12-52PM 


#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#@  
#@  0a toc
#@  
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@   2022-07-18[Jul-Mon]21-47PM 

contents
0a
1
2 manual copy of older to m1/a/a2
3


#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#@  
#@  0b code
#@  
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@   2022-07-18[Jul-Mon]21-49PM 



#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#@  
#@  1
#@  
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@   2022-07-18[Jul-Mon]21-47PM 



$ date
Mon, Jul 18, 2022  9:13:28 PM

dgleba@SICS-GZPJL13 /cygdrive/c/0/t
$ cd /cygdrive/c/0

dgleba@SICS-GZPJL13 /cygdrive/c/0
$

dgleba@SICS-GZPJL13 /cygdrive/c/0
$ mkdir t
mkdir: cannot create directory ‘t’: File exists

dgleba@SICS-GZPJL13 /cygdrive/c/0
$ cd t

dgleba@SICS-GZPJL13 /cygdrive/c/0/t
$

dgleba@SICS-GZPJL13 /cygdrive/c/0/t
$ mkdir m1
mkdir: cannot create directory ‘m1’: File exists

dgleba@SICS-GZPJL13 /cygdrive/c/0/t
$ cd m1

dgleba@SICS-GZPJL13 /cygdrive/c/0/t/m1
$ mkdir a
mkdir: cannot create directory ‘a’: File exists

dgleba@SICS-GZPJL13 /cygdrive/c/0/t/m1
$ cd a

dgleba@SICS-GZPJL13 /cygdrive/c/0/t/m1/a
$ #echo hello1 >a1

dgleba@SICS-GZPJL13 /cygdrive/c/0/t/m1/a
$ echo hello2 >a2

dgleba@SICS-GZPJL13 /cygdrive/c/0/t/m1/a
$

dgleba@SICS-GZPJL13 /cygdrive/c/0/t/m1/a
$ cd ../..

dgleba@SICS-GZPJL13 /cygdrive/c/0/t
$ mkdir m2
mkdir: cannot create directory ‘m2’: File exists

dgleba@SICS-GZPJL13 /cygdrive/c/0/t
$ cd m2

dgleba@SICS-GZPJL13 /cygdrive/c/0/t/m2
$ mkdir a
mkdir: cannot create directory ‘a’: File exists

dgleba@SICS-GZPJL13 /cygdrive/c/0/t/m2
$ cd a

dgleba@SICS-GZPJL13 /cygdrive/c/0/t/m2/a
$ mkdir b
mkdir: cannot create directory ‘b’: File exists

dgleba@SICS-GZPJL13 /cygdrive/c/0/t/m2/a
$ touch b/b1

dgleba@SICS-GZPJL13 /cygdrive/c/0/t/m2/a
$ touch a2

dgleba@SICS-GZPJL13 /cygdrive/c/0/t/m2/a
$ #touch a3

dgleba@SICS-GZPJL13 /cygdrive/c/0/t/m2/a
$ sleep 61

dgleba@SICS-GZPJL13 /cygdrive/c/0/t/m2/a
$ touch a2

dgleba@SICS-GZPJL13 /cygdrive/c/0/t/m2/a
$

dgleba@SICS-GZPJL13 /cygdrive/c/0/t/m2/a
$ cd /cygdrive/c/0/t

dgleba@SICS-GZPJL13 /cygdrive/c/0/t
$ find . -mtime -929 -type f -print0 | xargs -0 stat --printf='%.16y %A %a %h %U %u\t %G %g\t %s\t %n\n' |sort -n
2022-07-18 20:33 -rw-rw-r-- 664 1 dgleba 1058454         Domain Users 1049089    15340   ./m-arc/a/t5estforloop.txt
2022-07-18 20:33 -rw-rw-r-- 664 1 dgleba 1058454         Domain Users 1049089    1680    ./m-arc/a/testforloop.txt
2022-07-18 20:33 -rw-rw-r-- 664 1 dgleba 1058454         Domain Users 1049089    27300   ./m-arc/a/t6estforloop.txt
2022-07-18 20:33 -rw-rw-r-- 664 1 dgleba 1058454         Domain Users 1049089    3250    ./m-arc/a/t2estforloop.txt
2022-07-18 20:33 -rw-rw-r-- 664 1 dgleba 1058454         Domain Users 1049089    4680    ./m-arc/a/t3estforloop.txt
2022-07-18 20:33 -rw-rw-r-- 664 1 dgleba 1058454         Domain Users 1049089    6110    ./m-arc/a/t4estforloop.txt
2022-07-18 20:57 -rw-rw-r-- 664 1 dgleba 1058454         Domain Users 1049089    7       ./m-arc/a/a1
2022-07-18 20:57 -rw-rw-r-- 664 1 dgleba 1058454         Domain Users 1049089    7       ./m-arc/a/a2
2022-07-18 20:58 -rw-rw-r-- 664 1 dgleba 1058454         Domain Users 1049089    0       ./m-arc/a/a3
2022-07-18 20:58 -rw-rw-r-- 664 1 dgleba 1058454         Domain Users 1049089    0       ./m-arc/a/b/b1
2022-07-18 21:13 -rw-rw-r-- 664 1 dgleba 1058454         Domain Users 1049089    0       ./m2/a/b/b1
2022-07-18 21:13 -rw-rw-r-- 664 1 dgleba 1058454         Domain Users 1049089    7       ./m1/a/a2
2022-07-18 21:14 -rw-rw-r-- 664 1 dgleba 1058454         Domain Users 1049089    0       ./m2/a/a2

dgleba@SICS-GZPJL13 /cygdrive/c/0/t
$

dgleba@SICS-GZPJL13 /cygdrive/c/0/t
$ cd /cygdrive/c/0/t

dgleba@SICS-GZPJL13 /cygdrive/c/0/t
$ rsync -vtlr  --itemize-changes --remove-source-files  m2/ m-arc/
sending incremental file list
.d..t...... ./
.d..t...... a/
>f.st...... a/a2
.d..t...... a/b/
>f..t...... a/b/b1

sent 229 bytes  received 85 bytes  628.00 bytes/sec
total size is 0  speedup is 0.00

dgleba@SICS-GZPJL13 /cygdrive/c/0/t
$ rsync -vtlr  --itemize-changes --remove-source-files  m1/ m-arc/
sending incremental file list
.d..t...... ./
.d..t...... a/
>f.st...... a/a2

sent 151 bytes  received 54 bytes  410.00 bytes/sec
total size is 7  speedup is 0.03

dgleba@SICS-GZPJL13 /cygdrive/c/0/t
$

dgleba@SICS-GZPJL13 /cygdrive/c/0/t
$ cd /cygdrive/c/0/t

dgleba@SICS-GZPJL13 /cygdrive/c/0/t
$ find . -mtime -929 -type f -print0 | xargs -0 stat --printf='%.16y %A %a %h %U %u\t %G %g\t %s\t %n\n' |sort -n
2022-07-18 20:33 -rw-rw-r-- 664 1 dgleba 1058454         Domain Users 1049089    15340   ./m-arc/a/t5estforloop.txt
2022-07-18 20:33 -rw-rw-r-- 664 1 dgleba 1058454         Domain Users 1049089    1680    ./m-arc/a/testforloop.txt
2022-07-18 20:33 -rw-rw-r-- 664 1 dgleba 1058454         Domain Users 1049089    27300   ./m-arc/a/t6estforloop.txt
2022-07-18 20:33 -rw-rw-r-- 664 1 dgleba 1058454         Domain Users 1049089    3250    ./m-arc/a/t2estforloop.txt
2022-07-18 20:33 -rw-rw-r-- 664 1 dgleba 1058454         Domain Users 1049089    4680    ./m-arc/a/t3estforloop.txt
2022-07-18 20:33 -rw-rw-r-- 664 1 dgleba 1058454         Domain Users 1049089    6110    ./m-arc/a/t4estforloop.txt
2022-07-18 20:57 -rw-rw-r-- 664 1 dgleba 1058454         Domain Users 1049089    7       ./m-arc/a/a1
2022-07-18 20:58 -rw-rw-r-- 664 1 dgleba 1058454         Domain Users 1049089    0       ./m-arc/a/a3
2022-07-18 21:13 -rw-rw-r-- 664 1 dgleba 1058454         Domain Users 1049089    0       ./m-arc/a/b/b1
2022-07-18 21:13 -rw-rw-r-- 664 1 dgleba 1058454         Domain Users 1049089    7       ./m-arc/a/a2



#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#@  
#@  2
#@  
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@   2022-07-18[Jul-Mon]21-47PM 


bash: cd: /t: No such file or directory

dgleba@SICS-GZPJL13 /cygdrive/c/0/t
$ find . -mtime -929 -type f -print0 | xargs -0 stat --printf='%.16y %A %a %h %U %u\t %G %g\t %s\t %n\n' |sort -n
2022-07-18 20:33 -rw-rw-r-- 664 1 dgleba 1058454         Domain Users 1049089    15340   ./m-arc/a/t5estforloop.txt
2022-07-18 20:33 -rw-rw-r-- 664 1 dgleba 1058454         Domain Users 1049089    1680    ./m-arc/a/testforloop.txt
2022-07-18 20:33 -rw-rw-r-- 664 1 dgleba 1058454         Domain Users 1049089    27300   ./m-arc/a/t6estforloop.txt
2022-07-18 20:33 -rw-rw-r-- 664 1 dgleba 1058454         Domain Users 1049089    3250    ./m-arc/a/t2estforloop.txt
2022-07-18 20:33 -rw-rw-r-- 664 1 dgleba 1058454         Domain Users 1049089    4680    ./m-arc/a/t3estforloop.txt
2022-07-18 20:33 -rw-rw-r-- 664 1 dgleba 1058454         Domain Users 1049089    6110    ./m-arc/a/t4estforloop.txt
2022-07-18 20:33 -rwxrwxr-x 775 1 dgleba 1058454         Domain Users 1049089    3250    ./m1/a/a2
2022-07-18 20:57 -rw-rw-r-- 664 1 dgleba 1058454         Domain Users 1049089    7       ./m-arc/a/a1
2022-07-18 20:58 -rw-rw-r-- 664 1 dgleba 1058454         Domain Users 1049089    0       ./m-arc/a/a3
2022-07-18 21:13 -rw-rw-r-- 664 1 dgleba 1058454         Domain Users 1049089    0       ./m-arc/a/b/b1
2022-07-18 21:13 -rw-rw-r-- 664 1 dgleba 1058454         Domain Users 1049089    7       ./m-arc/a/a2

dgleba@SICS-GZPJL13 /cygdrive/c/0/t
$ find . -mtime -929 -type f -print0 | xargs -0 stat --printf='%.16y %A %a %h %U %u\t %G %g\t %s\t %n\n' |sort -n|grep a2
2022-07-18 20:33 -rwxrwxr-x 775 1 dgleba 1058454         Domain Users 1049089    3250    ./m1/a/a2
2022-07-18 21:13 -rw-rw-r-- 664 1 dgleba 1058454         Domain Users 1049089    7       ./m-arc/a/a2

dgleba@SICS-GZPJL13 /cygdrive/c/0/t
$ rsync -vtlr  --itemize-changes --remove-source-files  m1/ m-arc/
sending incremental file list
.d..t...... a/
>f.st...... a/a2

sent 3,390 bytes  received 47 bytes  6,874.00 bytes/sec
total size is 3,250  speedup is 0.95

dgleba@SICS-GZPJL13 /cygdrive/c/0/t
$ cd $bse/t
bash: cd: /t: No such file or directory

dgleba@SICS-GZPJL13 /cygdrive/c/0/t
$ find . -mtime -929 -type f -print0 | xargs -0 stat --printf='%.16y %A %a %h %U %u\t %G %g\t %s\t %n\n' |sort -n |grep a2
2022-07-18 20:33 -rw-rw-r-- 664 1 dgleba 1058454         Domain Users 1049089    3250    ./m-arc/a/a2

dgleba@SICS-GZPJL13 /cygdrive/c/0/t
$



#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#@  
#@  3
#@  
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@   2022-07-18[Jul-Mon]21-47PM 
















=================================================
=================================================
=================================================
=================================================
=================================================
=================================================
=================================================





=================================================


=================================================

older..


cd /cygdrive/c/0

mkdir t
cd t

mkdir m1
cd m1
mkdir a
cd a
echo hello1 >a1
echo hello2 >a2

cd ../..
mkdir m2
cd m2
mkdir a
cd a
mkdir b
touch b/b1
touch a2
touch a3
sleep 61
touch a2



cd /cygdrive/c/0/t
rsync -vtlr  --itemize-changes --remove-source-files  m2/ m-arc/

rsync -vtlr  --itemize-changes --remove-source-files  m1/ m-arc/

cd /cygdrive/c/0/t
find . -mtime -929 -type f -print0 | xargs -0 stat --printf='%.16y %A %a %h %U %u\t %G %g\t %s\t %n\n' |sort -n



=================================================




#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#@  
#@  
#@  
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@   2022-07-19[Jul-Tue]12-48PM 


#make some test files
#    /cygdrive/c/n/sfile/knowtes/2018/bash353/mk.test.files-make.folders.sh

cd 
# cd /c/0
# cd /cygdrive/c/0
