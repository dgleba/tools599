
1.
both robocopy and rsync overwrite newer destination data with older source data unless /xo or -u are used.

2.
for rsync cd into source and copy . folder to avoid creating source folder path inside destination.
or
use trailing slash on source dir
also
consider -R relative option.


#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#@  
#@  rsync & robocopy example
#@  
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@   2022-02-05[Feb-Sat]09-51AM 

create data.....



cd /cygdrive/d/0

mkdir -p a
mkdir -p b
rm -r a/*; rm -r b/*

echo 'cc'> a/1.txt
echo 'ee'> b/e.txt
sleep 1


# 1.

# this creates a inside folder b ...   rsync -a --itemize-changes -R ./a ./b
# cd in to the source to avoid this.


# 2.

## this overwrites the newer b

# this overwrites the newer b so it is like a  -- it makes b exactly reflect a  -  even though there are newer data in b. 

# make b newer than a
echo 'dd'> b/1.txt
cat b/1.txt
cd a
rsync -a --itemize-changes  . ../b
cd ..
cat b/1.txt


output:
		$ rsync -a --itemize-changes  . ../b
		.d..t...... ./
		>f..t...... 1.txt



# 2b.

# robocopy - this overwrites the newer b 
# this overwrites the newer b so it is like a  -- it makes b exactly reflect a  -  even though there are newer data in b. 

# make b newer than a
echo 'dd'> b/1.txt
cat b/1.txt
robocopy /e a b
cat b/1.txt


# 2c.

# b retains newer data it contains
# this copies only newer files from a.  b retains newer data it contains.

echo '33'> a/2.txt
# make b newer than a
echo 'dd'> b/1.txt
cat a/1.txt
robocopy /e /xo a b
cat b/1.txt





# 3.

# b retains newer data it contains
# this -u copies only newer files from a.  b retains newer data it contains.

echo '33'> a/2.txt
# make b newer than a
echo 'ee'> b/1.txt
cd a
rsync -a -u --itemize-changes  . ../b
cd ..
cat b/1.txt
cat b/2.txt


output..
		$ rsync -a -u --itemize-changes  . ../b
		.d..t...... ./
		>f+++++++++ 2.txt


or


rsync -a  --itemize-changes  a/ b


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~




# Trailing slash behavior on source folder.

# 4. 
# this trailing slash on a/ avoids creating a folder in c/.
echo 'cc'> a/1.txt
rsync -a -u --itemize-changes  a/ c
cat c/1.txt

# 5.
# this is the same as above, this trailing slash on a/ avoids creating a folder in c/.
echo 'cc'> a/1.txt
rsync -a -u --itemize-changes  a/ c/
cat c/1.txt


# 6
# this creates  folder a/ in c/.
echo 'cc'> a/1.txt
rsync -a -u --itemize-changes  a c/
cat c/1.txt

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

rclone config touch
 
#rclone takes along time to load on xps. why? sophos? 
echo %date% %time% 
# make b newer than a
echo 'ff'> d/1.txt
cat d/1.txt
rclone -u -vv copy a d
cat d/1.txt
echo %date% %time% 



# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~




