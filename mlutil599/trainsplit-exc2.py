
'''
trainsplit-exc2.py - split ml data to train/eval ignoring some folders and xml files.

David Gleba 2023-06-20

Tested on some sample data. Seems to work ok.

cd /cygdrive/c/0
  find example-ml-data-tree5/ -type f |grep -E "(\.xml|png)">trainsplit-ex2-in5.txt
  find split5/ -type f >trainsplit-ex2-out5.txt

------------

usage:

c:
cd \0
c:\prg\python\python C:\data\script\tools599\mlutil599\trainsplit-exc2.py C:\0\example-ml-data-tree5  C:\0\split5  0.8


'''

import sys
import os
import random
import shutil

def copy_files(source_folder, destination_folder, train_percentage):
    # Create the train and eval folders if they don't exist
    train_folder = os.path.join(destination_folder, 'train')
    eval_folder = os.path.join(destination_folder, 'eval')
    os.makedirs(train_folder, exist_ok=True)
    os.makedirs(eval_folder, exist_ok=True)

    IGNORED_FOLDERS = ['ok','false_rejects', 'flag']

    # Iterate over the folders in the source folder tree
    for root, dirs, files in os.walk(source_folder):
        # print("root:", flush=True)
        # print(root, flush=True)
        # print(dirs, files, flush=True)
        # Skip the destination folder itself
        if root == destination_folder:
            continue

        # Check if the current folder should be excluded
        if any(exclude_folder in root for exclude_folder in ['exclude']):
            continue

        # Determine the number of files to copy for this folder
        num_files = len(files)
        num_train_files = int(num_files * train_percentage)

        # Shuffle the files randomly
        random.shuffle(files)

        # Check if the current folder should  ignore xml files..
        if any(igno_folder.lower() in root.lower() for igno_folder in IGNORED_FOLDERS):
            # Copy picture files ignoring corresponding XML files
            for i, file in enumerate(files):
                base_name, extension = os.path.splitext(file)
                if extension.lower() in ['.jpg', '.png', '.bmp']:
                    source_picture_path = os.path.join(root, file)
                    if i < num_train_files:
                        destination_picture_path = os.path.join(train_folder, file)
                    else:
                        destination_picture_path = os.path.join(eval_folder, file)
                    shutil.copy2(source_picture_path, destination_picture_path)
                    print(",", end="", flush=True)
        else:
            # Copy picture files and their corresponding XML files
            for i, file in enumerate(files):
                base_name, extension = os.path.splitext(file)
                if extension.lower() in ['.jpg', '.png', '.bmp']:
                    source_picture_path = os.path.join(root, file)
                    source_xml_path = os.path.join(root, base_name + '.xml')
                    if i < num_train_files:
                        destination_picture_path = os.path.join(train_folder, file)
                        destination_xml_path = os.path.join(train_folder, base_name + '.xml')
                    else:
                        destination_picture_path = os.path.join(eval_folder, file)
                        destination_xml_path = os.path.join(eval_folder, base_name + '.xml')
                    shutil.copy2(source_picture_path, destination_picture_path)
                    print(":", end="", flush=True)
                    if os.path.exists(source_xml_path):
                        shutil.copy2(source_xml_path, destination_xml_path)
                        print(".", end="", flush=True)
                    else:
                        print(f"Info: No matching XML file for: {source_xml_path}", flush=True)

# Read command-line arguments
if len(sys.argv) != 4:
    print("Usage: python trainsplit.py <source_folder> <destination_folder> <train_percentage>")
    sys.exit(1)

source_folder = sys.argv[1]
destination_folder = sys.argv[2]
train_percentage = float(sys.argv[3])

copy_files(source_folder, destination_folder, train_percentage)

