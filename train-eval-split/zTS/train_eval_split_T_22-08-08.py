#--------------------------------------------------------------------------
#IMPORT MODULES
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


#--------------------------Argparse Section----------------------------------


parser = argparse.ArgumentParser()
parser.add_argument('source', help = "Enter path of the source folder")
parser.add_argument('destination', help = "Enter path of the destination folder")

group = parser.add_mutually_exclusive_group()
group.add_argument("-tr", "--train", type=int, nargs='?', default=80, help = "Train refers to the training folders. Example Usage: --train 80. Eg: 10a, 10c")
group.add_argument("-t", "--test", type=int, nargs='?', default=0, help = "Folder to run an inference on. Example Usage: --test 0 Eg: 10b")
group.add_argument("-v", "--validate", type=int, nargs='?', default=0, help = "Set-up the validate folder. Example Usage: --validate 0")


parser.add_argument("--format", choices = ['train', 'allinone', 'final_test'], nargs='*', help = "choose the format you want to split the files into before copying")


#----------------------------------------------------------------------------


#------------------------Initialize------------------------------------------

args = parser.parse_args()
main = Path(args.source)
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
validate_files = []


#--------------------------------------------------------------------------


#--------------------------------------------------------------------------

if args.format == ['train']:
    train_dest = args.destination
    eval_dest = args.destination
    eval_dest = Path(eval_dest)
    train_dest = Path(train_dest)
    percent_split = args.train
    

if args.format == ['allinone']:
    test_dest = args.destination
    test_dest = Path(test_dest)
    test_destination = Path(os.path.join(test_dest, 'allinone'))
    

if args.format == ['final_test']:
    validate_dest = args.destination
    validate_dest = Path(validate_dest)

elif (args.test != int(0)) or (args.validate != int(0)):
    print("For test and validate, there is no split")
    sys.exit(1)
    
#----------------------------------------------------------------------------


#--------------------------------------------------------------------------
# THIS IS WHERE THE COPYING HAPPENS AFTER CONDITIONS ARE SET

if args.format == ['train']:
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

count = 0
counter = 0

for subdirs, dirs, files in os.walk(main):
    for d in dirs:
        directory_list.append(subdirs + '\\' + d)

for directory in directory_list:

    directory_path = Path(directory)
    files = os.listdir(directory_path)
    files_to_split = []
    files_without_xml = []
    for filename in files:
        filepath = (directory + '\\' + filename)
        if(filename.endswith('.png')):
            if args.format == ['allinone']:
                if not os.path.exists(test_destination):
                    os.makedirs(test_destination)
                try:
                    shutil.copy(filepath, test_destination)
                    print(filepath)
                except:
                    pass
                
            elif args.format == ['train']:
                if((os.path.basename(directory) == 'ok') or (os.path.basename(directory) == 'false_rejects')):
                    check_for_flag = (os.path.join(directory, 'flag'))
                    
                    count = count + 1
                    if(check_for_flag == directory_path):
                        files_without_xml.append(filepath)
                    files_without_xml.append(filepath)
                else:
                    counter = counter + 1
                    files_to_split.append(filepath)

            elif args.format == ['final_test']:
                if(os.path.basename(directory) == 'ok'):
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
                
    if args.format == ['final_test']:                    
        for i in validate_files:
            try:
                shutil.copy(i, validate_dest)
                print(i)
            except:
                pass

    if args.format == ['train']:
        shuffled_list = random.sample(files_to_split, k = len(files_to_split))
        shuffled_list2 = random.sample(files_without_xml, k = len(files_without_xml))
        train_list.append(shuffled_list[:((len(shuffled_list))*(percent_split)//100)])
        good_train_list.append(shuffled_list2[:((len(shuffled_list2))*(percent_split)//100)])
        
        eval_list.append(shuffled_list[((len(shuffled_list))*(percent_split)//100):])
        good_eval_list.append(shuffled_list2[((len(shuffled_list2))*(percent_split)//100):])


train_list = list(itertools.chain(*train_list))
eval_list = list(itertools.chain(*eval_list))


good_train_list = list(itertools.chain(*good_train_list))
good_eval_list = list(itertools.chain(*good_eval_list))


#--------------------------------------------------------------------------------


#--------------------------------------------------------------------------------
if args.format == ['train']:
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






if args.format == ['train']:
    print("copying to train and test folders")
#Copy files from lists that have xml files
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



#--------------------------------------------------------------------------------
print("Copying Completed")
















            
