<<<<<<< HEAD
import csv
import os
import sys
import logging
import os.path
from pathlib import Path
import argparse


#parser = argparse.ArgumentParser()
#parser.add_argument('source', help = "Enter path of the source folder")

#args = parser.parse_args()
#main_folder_raw_input = args.source
main_folder_raw_input = "/dsk1/downloads/6365-report/vis2_sge_inner"
main_folder = Path(main_folder_raw_input)
current_working_directory = os.getcwd()
extensions = ('.png')
current_file_path_list = []
files = []

for subdirs, dirs, files in os.walk(main_folder):
    for folders in dirs:
        if(folders =='nok'):
            current_file_path = os.path.join(subdirs,"nok")
            current_file_path_list.append(current_file_path)


with open('vis2_sge_inner_filelist.txt', 'w') as f:
    for folder_path in current_file_path_list:
        print(folder_path)
        for file_path in os.listdir(folder_path):
            print(file_path)
            if os.path.isfile(os.path.join(folder_path, file_path)):
                f.write(f"{file_path}\n")
=======
import csv
import os
import sys
import logging
import os.path
from pathlib import Path
import argparse


#parser = argparse.ArgumentParser()
#parser.add_argument('source', help = "Enter path of the source folder")

#args = parser.parse_args()
#main_folder_raw_input = args.source
main_folder_raw_input = "/dsk1/downloads/6365-report/vis2_sge_inner"
main_folder = Path(main_folder_raw_input)
current_working_directory = os.getcwd()
extensions = ('.png')
current_file_path_list = []
files = []

for subdirs, dirs, files in os.walk(main_folder):
    for folders in dirs:
        if(folders =='nok'):
            current_file_path = os.path.join(subdirs,"nok")
            current_file_path_list.append(current_file_path)


with open('vis2_sge_inner_filelist.txt', 'w') as f:
    for folder_path in current_file_path_list:
        print(folder_path)
        for file_path in os.listdir(folder_path):
            print(file_path)
            if os.path.isfile(os.path.join(folder_path, file_path)):
                f.write(f"{file_path}\n")
>>>>>>> 1f8feda2a95c0760c351fc5fcd5d2508de3b2b1f
