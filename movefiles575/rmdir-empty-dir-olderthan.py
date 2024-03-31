
'''

usage:

c:
cd \temp
# c:\prg\python\python rmdir-empty-dir-olderthan.py c:\0\test_folders

c:\prg\python\python C:\data\script\tools599\movefiles575\rmdir-empty-dir-olderthan.py "D:\Archive Record\images"

note:
# D:\Archive Record\images\year2022\Jan


'''
# rm empty folders older than daysold
daysold=19

import os
import shutil
import time
import sys

def list_files_in_tree(path, count):
    file_list = []
    for root, dirs, files in os.walk(path):
        for file in files:
            file_path = os.path.join(root, file)
            file_list.append(file_path)
            if len(file_list) >= count:
                return file_list
    return file_list

def remove_empty_folders(path):
    # files_list = list_files_in_tree(path, 101)
    # only remove folders if there are some files present in the tree. This may prevent removing too many folders.
    if len(files_list) > 99:
        for root, dirs, files in os.walk(path, topdown=False):
            for folder in dirs:
                folder_path = os.path.join(root, folder)
                if not os.listdir(folder_path):
                    folder_mtime = os.path.getmtime(folder_path)
                    current_time = time.time()
                    if current_time - folder_mtime > daysold * 24 * 60 * 60:
                        print(f"Removing empty folder: {folder_path}")
                        shutil.rmtree(folder_path)


# if __name__ == "__main__":
    # current_directory = os.getcwd()
    # remove_empty_folders(current_directory)


if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Please provide the path of the folder to delete empty folders from.")
        sys.exit(1)

    folder_path = sys.argv[1]
    if not os.path.isdir(folder_path):
        print("The provided path is not a directory.")
        sys.exit(1)


    files_list = list_files_in_tree(folder_path, 101)
    if len(files_list) > 99:
        print("List of the first 100 files:")
        for file_path in files_list:
            print(file_path)
        print("\n We found more than 100 files, so we will remove empty folders older than the value of daysold variable...")
        print("\n Other programs may expect some folders present. This may help keep a few folders to avoid errors.")
        remove_empty_folders(folder_path)
    else:
        print("\n Less than 100 files in the tree, so we won't remove empty folders. stopping.")
    

