"""
# purpose: zip folders matching names from list. 

uses: 
-6670 vision good image folders. combines lots of files into one for faster archiving to NAS.

example usage: 

python D:\data\script\tools599\movefiles575\zip-lrg-folders.py


Also refer to: 
D:\data\script\tools599\movefiles575\del-rand-keep-n.py

"""

# settings: =================================================

# top folder to delete from..
# src=r"d:\copyof\corp-fs01\CORP-PM_xx"
# src=r"d:\example-files\yr2021"
src=r"D:\Archive Record\images\year2021\Jun"
src=r"d:\0\Jun"


# list of strings to match in folder path..
# lista = ['Good', '0755']
lista = ['Good', 'Bad']

# end Settings. =================================================

import os, sys, random, shutil, time, glob, subprocess
import logging
logging.basicConfig(level=0)

start_time = time.time()
print("--- %s seconds ---" % (time.time() - start_time))

# get list of folders
def fast_scandir(dirname):
    subfolders= [f.path for f in os.scandir(dirname) if f.is_dir()]
    for dirname in list(subfolders):
        subfolders.extend(fast_scandir(dirname))
    return subfolders

folds=fast_scandir(src)
print("--- %s seconds ---" % (time.time() - start_time))
# print(folds)

# get folders matching string lista
for f in folds:
    # check if the folder still exists. it may have been zipped and deleted by another match.
    if os.path.isdir(f):
        for a in lista:
            # If folder name matches
            if a in f:
                print("f:",f)
                # rt = shutil.make_archive(f, 'zip', f, )
                # rt = shutil.make_archive(f, 'zip', f, logger=logging)
                # use 7z no compression. may be faster than make_archive.
                lastpathname = os.path.basename(os.path.normpath(f))
                zipfn = f"{os.path.split(f)[0]}\{lastpathname}.7z"
                # print(os.path.split(f)[0])
                print(zipfn)
                call00 = "C:\\prg\\7-Zip\\7z.exe"
                ret00 = subprocess.check_output([call00, 'a', "-m0=Copy", zipfn, f])
                # print(ret00)
                print("zipedfilename:  ",zipfn)
                #get modified.timestamp of a file and set zip file mtime to that.
                afile = os.path.join(f, os.listdir(f)[0])
                # print(afile)
                mtime0 = os.path.getmtime(afile)
                # print(mtime0)
                os.utime(zipfn,(mtime0,mtime0))
                # print(fn01)
                # remove files after archiving them.
                shutil.rmtree(f)
                print("--- %s seconds ---" % (time.time() - start_time))
                sys.stdout.flush()
print("--- REACHED--END. %s sec. %s hours ---" % (time.time() - start_time, (time.time() - start_time)/3600 ))



"""
Notes:

                # ret00 = subprocess.check_output(["C:\\prg\\7-Zip\\7z.exe", "a", "-m0=Copy", "d:\0\a.7z", "d:\0\a"])

                print("npth:",os.path.normpath(zipfn))


command02 = r'C:\Program Files\7-Zip\7z.exe ...'
subprocess.call(command02)

C:\prg\7-Zip\7z.exe a -m0=Copy tmp7.7z D:\0\Jun\6670\6670_good_bad

ret01 = subprocess.check_output([path_7zip, "a", "-tzip", outfile_name, "*.txt", "*.py", "-pSECRET"])

f"Hello, {name}. You are {age}."
zipfn = 
f"C:\prg\7-Zip\7z.exe a -m0=Copy tmp7.7z {f}\. {f}"



            # lsdir=os.listdir(f)
            # print(lsdir)
            # # caclulate number of iiles to delete. mininum 0.
            # delnum = max(0,len(lsdir) - numtokeep)
            # print(delnum)
            # # create list of random file numbers to delete
            # for num in random.sample(list(range(0,len(lsdir))), delnum):
                # print(num)
                # os.remove(os.path.join(f, lsdir[num]))


# how to delete n number of files in directory using python
dogs_dir=os.listdir('dogs')
for num in random.sample(len(dogs_dir), 8000):
    os.remove(os.path.join('dogs', dogs_dir[num]))
    


https://stackoverflow.com/questions/973473/getting-a-list-of-all-subdirectories-in-the-current-directory


from pathlib import Path

# replace text using find 
p = Path('in')
for i in p.glob('**/*.xml'):
    print(i.name)


# yes:
url_string = '1.pdf2'
url_string = '1.xls2'
extensionsToCheck = ['.pdf', '.doc', '.xls']
for extension in extensionsToCheck:
    if extension in url_string:
        print(url_string)



list_to_match = ['ok', 'OK']
string_to_match = '\ok'
string_to_match = '\\220127'

# for root, subdirs, filename in os.walk(r"d:\copyof\corp-fs01\CORP-PM"):
    # if  string_to_match in root:
        # # shutil.copy(filename, destination_dir)
        # # print(root, " sd: ", subdirs," fn: ", filename)
        # print(root, " sd: ", subdirs,)
        

# #no:
# for root, subdirs, filename in os.walk(r"d:\copyof\corp-fs01\CORP-PM"):
    # if root in list_to_match:
        # # shutil.copy(filename, destination_dir)
        # # print(root, " sd: ", subdirs," fn: ", filename)
        # print(root, " sd: ", subdirs,)


# #list all:
# for root, subdirs, filename in os.walk(r"d:\copyof\corp-fs01\CORP-PM"):
        # #shutil.copy(filename, destination_dir)
        # print(" ~~ rt: ", root, " sd: ", subdirs," fn: ", filename)

"""

