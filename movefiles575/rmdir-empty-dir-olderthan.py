
'''
c:
cd \temp
c:\prg\python\python C:\data\script\tools599\movefiles575\rmdir-empty-dir-olderthan.py "D:\Archive Record\images"


'''

# rm empty folders older than daysold
daysold=19

import os
import shutil
import time
import sys

def remove_empty_folders(path):
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

    remove_empty_folders(folder_path)
 
