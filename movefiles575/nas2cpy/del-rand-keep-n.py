
# purpose. delete all but n random files in each subfolder.

# todo. add filters to include only some folders strings. 

# settings: =================================================


# top folder to delete from..
# src=r"d:\copyof\corp-fs01\CORP-PM\x123123"
# src=r"d:\example-files\yr2021"
src=r"D:\Archive Record\images\year2021\Jun"

# number of files to keep in each folder
numtokeep = 9000

# list of strings to match in folder path..
lista = ['Good', 'Jul']


# end Settings. =================================================


import os, random


# get list of folders
def fast_scandir(dirname):
    subfolders= [f.path for f in os.scandir(dirname) if f.is_dir()]
    for dirname in list(subfolders):
        subfolders.extend(fast_scandir(dirname))
    return subfolders

folds=fast_scandir(src)
# print(folds)

# get folders matching string lista
for f in folds:
    for a in lista:
        # If folder name matches
        if a in f:
            print(f)
            lsdir=os.listdir(f)
            # print(lsdir)
            # caclulate number of iiles to delete. mininum 0.
            delnum = max(0,len(lsdir) - numtokeep)
            print(delnum)
            # create list of random file numbers to delete
            print(" deleting some files from this folder.. ")
            for num in random.sample(list(range(0,len(lsdir))), delnum):
                # print(num)
                os.remove(os.path.join(f, lsdir[num]))





"""

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

