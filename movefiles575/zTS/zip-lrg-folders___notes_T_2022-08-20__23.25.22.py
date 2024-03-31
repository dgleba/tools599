
# purpose. zip folders and remove the source files. 

# uses: 6670 vision `good` image folders.

"""

This works on 6670 because Good folder is the deepest and only  folder 
called good.
If good were not the deepest, then it would error because it would try to 
zip a non-existent folder in the list.



"""

# also refer to: D:\data\script\tools599\movefiles575\del-rand-keep-n.py


# settings: =================================================



# top folder to delete from..
# src=r"d:\0\Jun"
src=r"D:\Archive Record\images\year2021\Jul"


# list of strings to match in folder path..
# lista = ['Good', 'xx0755']
lista = ['Good']

# end Settings. =================================================

import logging
logging.basicConfig(level=0)
import os, random
import shutil
import time

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
    for a in lista:
        # If folder name matches
        if a in f:
            print(f)
            rt = shutil.make_archive(f, 'zip', f, )
            # rt = shutil.make_archive(f, 'zip', f, logger=logging)
            print("zipedfilename:  ",rt)
            shutil.rmtree(f)
            print("--- %s seconds ---" % (time.time() - start_time))
            





"""


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

