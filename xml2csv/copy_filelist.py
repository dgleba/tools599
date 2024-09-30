import sys
import os
import os.path
from os import path
from pathlib import Path
import shutil
import glob

file_list_to_copy = input("Enter 'txt' file of the filelist you want to copy: ")
destFolder = input("Enter the directory where the files be copied: ")
extensions = {".xml", ".png"}


try:
        destFolder = os.path.join(destFolder, 'copied_files')
        os.makedirs(destFolder)
        print("destination path created")
except FileExistsError as err:
        print("Destination Path is already exists")
        sys.exit()
destFolder = os.path.abspath(destFolder)
                   

file_list = []
with open(file_list_to_copy, "r") as fl:
        for f in fl:
                filename = f.strip()
                filename = os.path.splitext(filename)
                for ext in extensions:
                        name = str(filename[0]) + str(ext)
                        print(name)
                        if os.path.exists(name):
                                file_list.append(name)

                        
fl.close()





for files in file_list:
        
        source = (os.path.splitdrive(files))
        
        base = os.path.split(source[1])
        base0 = base[0].lstrip("\\")
        
        destination = os.path.join(destFolder, base0)
        
        if not os.path.exists(destination):
                os.makedirs(destination)
                 
        shutil.copy(files, destination)      

print("copy completed")
