
echo copy paste, dont run this file.

exit

=================================================
=================================================


cd //pmda-bkh70w2/result
find  . -mtime -1121 -type f -print0 | xargs -0 stat --printf='%.16y %A %a %h %U %u\t %G %g\t %s\t %n\n'  | sort -n


cd //pmda-bkh70w2/result
find  . -type f -print0 | xargs -0 stat --printf='%.16y\t%A\t%a\t%h\t%U\t%u\t%G\t%g\t%s\t%n\n' 


good.

cd //pmda-bkh70w2/result
find  . -type f -print0 | xargs -0 stat --printf='%.16y\t%A\t%U\t%G\t%s\t%n\n' >/cygdrive/c/data/cmm10001-result.files_$(date +"__%Y.%m.%d_%H.%M.%S").txt


=================================================

compare directory

https://serverfault.com/questions/177001/find-files-in-one-directory-not-in-another


good:


dir1='//pmda-bkh70w2/result'
dir2='//pmda-bkh70w2/data/cmm/watchedoutput/qccalc'
diff --brief  $dir1/ $dir2/  | tee /cygdrive/c/data/logs/cmm10001-diffdir_$(date +"__%Y.%m.%d_%H.%M.%S").txt


output..
	dgleba@SICS-GZPJL13 //pmda-bkh70w2/data/cmm/watchedoutput/qccalc
	$ diff --brief  $dir1/ $dir2/
	Files //pmda-bkh70w2/result/~QC-CALC Real-Time.Tmp and //pmda-bkh70w2/data/cmm/watchedoutput/qccalc/~QC-CALC Real-Time.Tmp differ
	Files //pmda-bkh70w2/result/~QC-HDR.TMP and //pmda-bkh70w2/data/cmm/watchedoutput/qccalc/~QC-HDR.TMP differ
	Only in //pmda-bkh70w2/result/: 10R60 Gear Machining 1st Off_1442_chr.txt
	Only in //pmda-bkh70w2/result/: 10R60 Gear Machining 1st Off_1449_chr.txt



no.

# compares contents too.
diff //pmda-bkh70w2/result  //pmda-bkh70w2/data/cmm/watchedoutput/qccalc | tee /cygdrive/c/0/cmm10001-diff.2021-08-26a.txt

no.

dir1='//pmda-bkh70w2/result'
dir2='//pmda-bkh70w2/data/cmm/watchedoutput/qccalc'
diff <(cd $dir1; ls) <(cd $dir2; ls)




=================================================



find . -type f  -print0 | xargs -0 stat --printf='%s/%n\n' > /cygdrive/c/0/size.of.files.$(date +"__%Y.%m.%d_%H.%M.%S").tsv.txt



#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#@  
#@  
#@  
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@   2021-08-26[Aug-Thu]13-52PM 





#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#@  
#@  find size to tsv
#@  
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@   2021-05-26[May-Wed]10-52AM 


cd  //pmda-sgenas01/PMDA-SGE/image_data_2021

find  .  -type f  -print0 | xargs -0 stat --printf='%s/%n\n' > /cygdrive/c/0/size.of.files$(date +"__%Y.%m.%d_%H.%M.%S").tsv.txt


no..
find  .  -type f -iname "*.png" -print0 | xargs -0 stat --printf='%s/%n\n' > /cygdrive/c/0/size.of.files$(date +"__%Y.%m.%d_%H.%M.%S").tsv.txt

# replace tab with /

sed 's;\t;/;g' /cygdrive/c/0/size.of.files.tsv.txt >/cygdrive/c/0/size.of.files$(date +"__%Y.%m.%d_%H.%M.%S").tsv.txt


_____________


du . --max-depth=1  -cx  |tee  /cygdrive/c/0/size.of.files$(date +"__%Y.%m.%d_%H.%M.%S").tsv.txt

du . --max-depth=1  -cx     -h   | sort -h

_____________


cd /cygdrive/c/0x

# for folders do..
for f in *; do
    if [ -d "$f" ]; then
        # $f is a directory
		echo $f
		find  $f  -type f -print0 | xargs -0 stat --printf='%h\t%s\t%n\n' 
		#find  $f  -type f -print0 | xargs -0 stat --printf='%h\t%s\t%n\n' > /cygdrive/c/0/size.of.filesdate1=$(date +"__%Y.%m.%d_%H.%M.%S").tsv.txt

    fi
done




#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#@  
#@  move named outer
#@  
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@   2021-04-22[Apr-Thu]17-07PM 

# rsync files newer than.. with name contains..  
#      https://www.nicovs.be/rsync-files-younger-or-older-than/
#         --delete is not relevant since this copies one file at a time.
#      -mtime = days ,  -mmin = minutes
#  works..
#
sd01=~/tmp-2021-04-22d
dd01=~/tmp-2021-04-22-nameouter
#
tf01=/tmp/rsyncfiles422ne
#
cd "$sd01"
find . -type f  -iname '*outer*'  |sort   > ${tf01}
    rsync -av --files-from=$tf01  --remove-source-files  . $dd01
ls -la $dd01
cat $tf01
# remove empty folders.
find "${sd01}/"  -mindepth 1   -type d -empty -delete
 




#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#@  
#@  -iname
#@  
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@   2021-04-22[Apr-Thu]16-31PM 



cd /cygdrive/c/Users/dgleba/Dropbox (Stackpole)/DavidGleba-drpbx/Prolucid

# rsync files newer than.. with name contains..  
#      https://www.nicovs.be/rsync-files-younger-or-older-than/
#         --delete is not relevant since this copies one file at a time.
#      -mtime = days ,  -mmin = minutes
#  works..
#
sd01="//pmda-sgenas01/PMDA-SGE/training_library_SGE-Rotor6365"
dd01=~/tmp-2021-04-22e
#
tf01=/tmp/rsyncfiles422e
#
cd "$sd01"
find . -type f  -iname '*outer*'  |sort   > ${tf01}
    rsync -av --files-from=$tf01 . $dd01
ls -la $dd01
cat $tf01




#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#@  
#@  grep outer
#@  
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@   2021-04-22[Apr-Thu]16-31PM 



cd /cygdrive/c/Users/dgleba/Dropbox (Stackpole)/DavidGleba-drpbx/Prolucid

# rsync files newer than.. with name contains..  
#      https://www.nicovs.be/rsync-files-younger-or-older-than/
#         --delete is not relevant since this copies one file at a time.
#      -mtime = days ,  -mmin = minutes
#  works..
#
sd01="//pmda-sgenas01/PMDA-SGE/training_library_SGE-Rotor6365"
dd01=~/tmp-2021-04-22e
#
tf01=/tmp/rsyncfiles422e
#
cd "$sd01"
find . -type f   |grep -i 'outer' |sort   > ${tf01}
    rsync -av --files-from=$tf01 . $dd01
ls -la $dd01
cat $tf01



_____________

sd01="//pmda-sgenas01/PMDA-SGE/training_library_SGE-Rotor6365"
cd $sd01
find . |sort > ~/find.all.sge.rotor.library.images.2021-04-22b.txt


_____________

all training_library_SGE-Rotor6365


cd //pmda-sgenas01/PMDA-SGE/
cd //pmda-sgenas01/PMDA-SGE/training_library_SGE-Rotor6365

cd //pmda-sgenas01/PMDA-SGE/sge_c_back-up_march_16_2021



#   find  .  -type f -print0 | xargs -0 stat --printf='%.16y\t%s\t%n\n' > /cygdrive/c/0/sge-nas.92-prolu.jan21c.txt

_____________


grep s2 outer



C:\0\sge-nas.92-prolu.jan21c-all.library.2021-03-09.txt

cd /cygdrive/c/0
cat  sge-nas.92-prolu.jan21c-all.library.2021-03-09.txt  |grep s1_outer_surface_ >find.s1outer.2021-03-09.txt


_____________



#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#@  
#@  
#@  
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@   2021-03-08[Mar-Mon]20-04PM 




\\pmda-sgenas01\PMDA-SGE\training_library_SGE-Rotor6365

\\pmda-sgenas01\PMDA-SGE\from_prolucid\Prolucid Model Training Data Set Jan 2021

"//pmda-sgenas01/PMDA-SGE/from_prolucid/Prolucid Model Training Data Set Jan 2021"

_____________


eg.

newest.

  find  . -mtime -1121 -type f -print0 | xargs -0 stat --printf='%.16y %A %a %h %U %u\t %G %g\t %s\t %n\n'  | sort -n |  grep -v '.git/' | grep -v tmp/ |grep -v x/ |grep -v /datasys/ | tail -n1254

2020-11-02 00:53 -rw-r--r-- 644 1 root 1001      Domain Users 1049089    1006968         //pmda-sgenas01/PMDA-SGE/training_library_SGE-Rotor6365/2020November/S1 Inner Rim - Nov 2/20201102/s1_inner_rim_20201102T015305.png

_____________



#cd "//pmda-sgenas01/PMDA-SGE/from_prolucid/Prolucid Model Training Data Set Jan 2021"


_____________


find  .  -type f  > /cygdrive/c/0/find.sge-nas.092prolu.0302a.txt


cd /cygdrive/c/data/SGERotorVision/images2020-12-07/
cat  findall.sge-nas.092prolu.0302a.txt  |grep s1_outer_surface_ >find.s1outer.0304b.txt




_____________


cd /cygdrive/c/data/SGERotorVision/images2020-12-07/
find  .  -type f -print0 | xargs -0 stat --printf='%h\t%s\t%n\n' > /cygdrive/c/0/temp01.txt




#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#@  
#@  
#@  
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@   2021-03-22[Mar-Mon]12-15PM 

find duplicates


root@SICS-GZPJL13 /cygdrive/c/data/SGERotorVision 

cd /cygdrive/c/data/SGERotorVision
find . ! -empty -type f -exec md5sum {} + | sort | uniq -w32 -dD
b6d134872e71b5ae521a03c7c2226e6d *./images2020-12-07/1207-init-xml.txt
b6d134872e71b5ae521a03c7c2226e6d *./images2020-12-07/Initial Dataset relabeled/1207-init-xml.txt

hmm..
find -not -empty -type f -printf "%s\n" | sort -rn | uniq -d | xargs -I{} -n1 find -type f -size {}c -print0 | xargs -0 md5sum | sort | uniq -w32 --all-repeated=separate

no..
find . -type f -printf '%p/ %f\n' | sort -k2 | uniq -f1 --all-repeated=separate

# yes..
# https://stackoverflow.com/questions/16276595/how-to-find-duplicate-filenames-recursively-in-a-given-directory-bash
dirname=//pmda-sgenas01/PMDA-SGE/training_library_SGE-Rotor6365
dirname=.
find $dirname -type f | sed 's_.*/__' | sort|  uniq -d| 
while read fileName
do
find $dirname -type f | grep "$fileName"
done


root@SICS-GZPJL13 ~
dirname=//pmda-sgenas01/PMDA-SGE/training_library_SGE-Rotor6365
find $dirname -type f | sed 's_.*/__' | sort|  uniq -d| 
while read fileName
do
find $dirname -type f | grep "$fileName"
done
//pmda-sgenas01/PMDA-SGE/training_library_SGE-Rotor6365/2020November/S1 Top View - Nov 2/20201102/s1_top_view_20201102T030149.xml
//pmda-sgenas01/PMDA-SGE/training_library_SGE-Rotor6365/2020November/S1 Top View - Nov 2/s1_top_view_20201102T030149.xml
//pmda-sgenas01/PMDA-SGE/training_library_SGE-Rotor6365/2020November/processed_data/test_labels.csv
//pmda-sgenas01/PMDA-SGE/training_library_SGE-Rotor6365/processed_data/test_labels.csv
//pmda-sgenas01/PMDA-SGE/training_library_SGE-Rotor6365/2020November/processed_data/train_labels.csv
//pmda-sgenas01/PMDA-SGE/training_library_SGE-Rotor6365/processed_data/train_labels.csv
root@SICS-GZPJL13 ~


=================================================



