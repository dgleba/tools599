#--------------------------------------------------------------------------
# THIS IS THE IMPORT MODULE SECTION 
import csv
import os
import sys
import os.path
from pathlib import Path
import re
import subprocess
import shutil
import random
import argparse
import itertools
#----------------------------------------------------------------------------

source = sys.argv[1]
main = Path(source)
files_to_split = []
train_list = []
eval_list = []
extensions = ['.png','.xml']
directory_list = []
files_without_xml = []
complete_directory_list = []
good_train_list = []
good_eval_list = []
filelist = []
complete_train_list = []
complete_eval_list = []

#--------------------------------------------------------------------------
while True:
    choice = input("Type either train, test or bad: ")
    if choice == "train":
        train_dest = sys.argv[2]
        eval_dest = sys.argv[2]
        eval_dest = Path(eval_dest)
        train_dest = Path(train_dest)
        try:
            percent_split = input("Enter an Integer from 0:100 for the train and eval file split ratio: ")
            if percent_split == int:
                pass
            else:
                print("Not an Integer")
                sys.exit(1)
        except:
            print("Incorrect input value")
            sys.exit(1)
        copy_xml = 1
        break

    elif choice == "test":
        test_dest = sys.argv[2]
        test_destination = Path(os.path.join(test_dest, 'allinone')
        copy_xml = 0
        break

    elif choice == "bad":
        validate_dest = sys.argv[2]
        copy_xml = 2
        break
    
    else:
        choice = input("Type either train, test or bad: ")

#----------------------------------------------------------------------------


#--------------------------------------------------------------------------
# THIS IS WHERE THE COPYING HAPPENS AFTER CONDITIONS ARE SET

if copy_xml == 1:
    if(str(os.path.basename(train_dest)) != "train"):
        try:
            train_dest = os.path.join(train_dest, 'train')
            if not os.path.isdir(train_dest):
                os.makedirs(train_dest)
            else:
                pass
        except:
            pass
    else:
        pass

    if(str(os.path.basename(eval_dest)) != "eval"):
        try:
            eval_dest = os.path.join(eval_dest, 'eval')
            if not os.path.isdir(eval_dest):
                os.makedirs(eval_dest)
            else:
                pass
        except:
            pass
    else:
        pass

print("starting to copy and/or copying validate/test files")


for subdirs, dirs, files in os.walk(main):
    for d in dirs:
        directory_list.append(subdirs + '\\' + d)
for directory in directory_list:
    directory_path = Path(directory)
    files_to_copy = []
    files_without_xml = []
    validate_files = []
    files = os.listdir(directory_path)
    for filename in files:
        directory_path = (directory + '\\' + filename)
        if(directory_path.endswith('.png')):
            if copy_xml == 0:
                if not os.path.exists(test_destination):
                    os.makedirs(test_destination)                   
                shutil.copy(filepath, test_destination)
            elif copy_xml == 1:
                if((os.path.basename(directory) == 'ok') or (os.path.basename(directory) == 'false_rejects')):
                    check_for_flag = (os.path.join(directory, 'flag'))
                    if(check_for_flag == directory_path):
                        files_without_xml.append(directory_path)
                    files_without_xml.append(directory_path)
                else:
                    files_to_split.append(directory_path)

            elif copy_xml == 2:
                if((os.path.basename(directory) == 'ok'):
                    check_for_flag = (os.path.join(directory, 'flag'))
                    if(check_for_flag == directory_path):
                        validate_files.append(filepath)
                    validate_files.append(filepath)
                else:  
                    f = os.path.splitext(filepath)
                    for ext in extensions:
                        name = str(f[0]) + str(ext)
                        if os.path.exists(name):
                            validate_files.append(name)
                        
                validate_destination = Path(os.path.join(validate_dest, os.path.basename(directory)))
                if not os.path.exists(validate_destination):
                    os.makedirs(validate_destination)
                    
    if copy_xml == 2:                
        for i in validate_files:
            try:
                shutil.copy(i, validate_destination)
            except:
                pass
    if copy_xml == 1:
        shuffled_list = random.sample(files_to_split, k = len(files_to_split))
        shuffled_list2 = random.sample(files_without_xml, k = len(files_without_xml))

    #   append list from folders that have xml files
        train_list.append(shuffled_list[:(len(shuffled_list)//10)*8])
        eval_list.append(shuffled_list[(len(shuffled_list)//10)*8:])
        
    #   list of from ok folders and false reject folders where xml files are not necessary.
        good_train_list.append(shuffled_list2[:(len(shuffled_list2)//10)*8])
        good_eval_list.append(shuffled_list2[(len(shuffled_list2)//10)*8:])

train_list = list(itertools.chain(*train_list))
eval_list = list(itertools.chain(*eval_list))

good_train_list = list(itertools.chain(*good_train_list))
good_eval_list = list(itertools.chain(*good_eval_list))
          
print("copying to train and test folders")

if copy_xml == 2: 

    for i in train_list:
        f = os.path.splitext(i)
        for ext in extensions:
            name = str(f[0]) + str(ext)
            if os.path.exists(name):
                complete_train_list.append(name)
    for i in eval_list:
        f = os.path.splitext(i)
        for ext in extensions:
            name = str(f[0]) + str(ext)
            if os.path.exists(name):
                complete_eval_list.append(name)




    for files in complete_train_list:
        try:
            shutil.copy(files, train_dest)
            print(files)
        except:
            pass
    for files in complete_eval_list:
        try:
            shutil.copy(files, eval_dest)
            print(files)
        except:
            pass

    #Copy files from lists that dont have xml files
    for j in good_train_list:
        try:
            shutil.copy(j, train_dest)
            print(j)
        except:
            pass
    for k in good_eval_list:
        try:
            shutil.copy(k, eval_dest)
            print(k)
        except:
            pass




















            
