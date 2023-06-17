
"""
purpose: copy 100 files randomly from each subfolder containing good in the path name


python /crib/tools599/mlutil599/copysome-by-folder.py \
  /media/albe/vi641-002/mcdata/mc_6670_vision/image_data/vision-1/images/year2023 /home/albe/tmp/y23m


"""

import os
import sys
import random
import shutil

def copy_files(source_folder, destination_folder):
    for root, dirs, files in os.walk(source_folder):
        for dir_name in dirs:
            if 'good' in dir_name.lower():
                source_path = os.path.join(root, dir_name)
                destination_path = os.path.join(destination_folder, dir_name)

                if not os.path.exists(destination_path):
                    os.makedirs(destination_path)

                file_list = os.listdir(source_path)
                random.shuffle(file_list)  # Randomize the file list

                file_count = 0
                for file_name in file_list:
                    if file_count >= 100:
                        break

                    source_file = os.path.join(source_path, file_name)
                    destination_file = os.path.join(destination_path, file_name)

                    if os.path.exists(destination_file):
                        base_name, extension = os.path.splitext(file_name)
                        count = 1
                        while True:
                            new_file_name = f"{base_name}~{count}{extension}"
                            new_destination_file = os.path.join(destination_path, new_file_name)
                            if not os.path.exists(new_destination_file):
                                destination_file = new_destination_file
                                break
                            count += 1

                    shutil.copy2(source_file, destination_file)
                    file_count += 1

if __name__ == '__main__':
    if len(sys.argv) != 3:
        print("Usage: python script.py source_folder destination_folder")
        sys.exit(1)

    source_folder = sys.argv[1]
    destination_folder = sys.argv[2]

    copy_files(source_folder, destination_folder)



'''

works, but not random..


import os
import sys
import shutil

def copy_files(source_folder, destination_folder):
    for root, dirs, files in os.walk(source_folder):
        for dir_name in dirs:
            if 'good' in dir_name.lower():
                source_path = os.path.join(root, dir_name)
                destination_path = os.path.join(destination_folder, dir_name)

                if not os.path.exists(destination_path):
                    os.makedirs(destination_path)

                file_count = 0
                for file_name in os.listdir(source_path):
                    if file_count >= 100:
                        break

                    source_file = os.path.join(source_path, file_name)
                    destination_file = os.path.join(destination_path, file_name)
                    if os.path.exists(destination_file):
                        base_name, extension = os.path.splitext(file_name)
                        count = 1
                        while True:
                            new_file_name = f"{base_name}~{count}{extension}"
                            new_destination_file = os.path.join(destination_path, new_file_name)
                            if not os.path.exists(new_destination_file):
                                destination_file = new_destination_file
                                break
                            count += 1
                    shutil.copy2(source_file, destination_file)
                    file_count += 1

if __name__ == '__main__':
    if len(sys.argv) != 3:
        print("Usage: python script.py source_folder destination_folder")
        sys.exit(1)

    source_folder = sys.argv[1]
    destination_folder = sys.argv[2]

    copy_files(source_folder, destination_folder)

'''


'''
import os
import sys
import shutil

def copy_files(source_folder, destination_folder):
    for root, dirs, files in os.walk(source_folder):
        for dir_name in dirs:
            if 'good' in dir_name.lower():
                source_path = os.path.join(root, dir_name)
                destination_path = os.path.join(destination_folder, dir_name)

                if not os.path.exists(destination_path):
                    os.makedirs(destination_path)

                file_count = {}
                for file_name in os.listdir(source_path):
                    source_file = os.path.join(source_path, file_name)
                    destination_file = os.path.join(destination_path, file_name)

                    if file_name in file_count:
                        file_count[file_name] += 1
                        file_base, file_ext = os.path.splitext(file_name)
                        new_file_name = f"{file_base}~{file_count[file_name]}{file_ext}"
                        destination_file = os.path.join(destination_path, new_file_name)
                    else:
                        file_count[file_name] = 0

                    shutil.copy2(source_file, destination_file)

if __name__ == '__main__':
    if len(sys.argv) != 3:
        print("Usage: python script.py source_folder destination_folder")
        sys.exit(1)

    source_folder = sys.argv[1]
    destination_folder = sys.argv[2]

    copy_files(source_folder, destination_folder)

'''




'''
works.

import os
import sys
import shutil

def copy_files(source_folder, destination_folder):
    for root, dirs, files in os.walk(source_folder):
        for dir_name in dirs:
            if 'good' in dir_name.lower():
                source_path = os.path.join(root, dir_name)
                destination_path = os.path.join(destination_folder, dir_name)

                if not os.path.exists(destination_path):
                    os.makedirs(destination_path)

                file_count = 0
                for file_name in os.listdir(source_path):
                    if file_count >= 100:
                        break

                    source_file = os.path.join(source_path, file_name)
                    destination_file = os.path.join(destination_path, file_name)
                    shutil.copy2(source_file, destination_file)
                    file_count += 1

if __name__ == '__main__':
    if len(sys.argv) != 3:
        print("Usage: python script.py source_folder destination_folder")
        sys.exit(1)

    source_folder = sys.argv[1]
    destination_folder = sys.argv[2]

    copy_files(source_folder, destination_folder)

'''


'''
import os
import sys
import shutil

def copy_files_from_subfolders(source_dir, destination_dir, keyword, num_files):
    for root, dirs, files in os.walk(source_dir):
        if keyword in root:
            file_counter = 0
            for file in files:
                if file_counter >= num_files:
                    break
                source_path = os.path.join(root, file)
                destination_path = os.path.join(destination_dir, file)
                
                # Check if the destination file already exists
                if os.path.exists(destination_path):
                    filename, extension = os.path.splitext(file)
                    counter = 1
                    while os.path.exists(destination_path):
                        new_filename = f"{filename}_{counter}{extension}"
                        destination_path = os.path.join(destination_dir, new_filename)
                        counter += 1
                
                shutil.copy2(source_path, destination_path)
                file_counter += 1

# Check if the correct number of command-line arguments is provided
if len(sys.argv) != 5:
    print("Usage: python script.py source_dir destination_dir keyword num_files")
    sys.exit(1)

source_directory = sys.argv[1]
destination_directory = sys.argv[2]
keyword = sys.argv[3]
num_files_to_copy = int(sys.argv[4])

copy_files_from_subfolders(source_directory, destination_directory, keyword, num_files_to_copy)

'''



'''

import os
import shutil
import sys

def copy_files(source_folder, destination_folder):
    count = 1
    for root, dirs, files in os.walk(source_folder):
        for directory in dirs:
            if "good" in os.path.join(root, directory):
                source_path = os.path.join(root, directory)
                for filename in os.listdir(source_path):
                    source_file = os.path.join(source_path, filename)
                    destination_file = os.path.join(destination_folder, filename)
                    # Check if the destination file already exists
                    while os.path.exists(destination_file):
                        # If the file already exists, add an underscore and a number
                        filename, extension = os.path.splitext(filename)
                        filename = f"{filename}_{count}{extension}"
                        destination_file = os.path.join(destination_folder, filename)
                        count += 1
                    # Copy the file to the destination folder
                    shutil.copy2(source_file, destination_file)

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python script.py <source_folder> <destination_folder>")
    else:
        source_folder = sys.argv[1]
        destination_folder = sys.argv[2]
        copy_files(source_folder, destination_folder)

'''

'''
import os
import shutil
import sys

def copy_files(source_folder, destination_folder):
    for root, dirs, files in os.walk(source_folder):
        for directory in dirs:
            if "good" in os.path.join(root, directory):
                source_path = os.path.join(root, directory)
                for filename in os.listdir(source_path):
                    source_file = os.path.join(source_path, filename)
                    destination_file = os.path.join(destination_folder, filename)
                    # Check if the destination file already exists
                    while os.path.exists(destination_file):
                        # If the file already exists, modify the filename with the path
                        filename, extension = os.path.splitext(filename)
                        path_as_filename = source_path.replace("/", "_")
                        filename = f"{path_as_filename}_{filename}{extension}"
                        destination_file = os.path.join(destination_folder, filename)
                    # Copy the file to the destination folder
                    shutil.copy2(source_file, destination_file)

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python script.py <source_folder> <destination_folder>")
    else:
        source_folder = sys.argv[1]
        destination_folder = sys.argv[2]
        copy_files(source_folder, destination_folder)

'''

"""

preserves tree in destination

import os
import sys
import shutil

def copy_files(source_folder, destination_folder):
    for root, dirs, files in os.walk(source_folder):
        for dir_name in dirs:
            if 'good' in dir_name.lower():
                source_path = os.path.join(root, dir_name)
                relative_path = os.path.relpath(source_path, source_folder)
                destination_path = os.path.join(destination_folder, relative_path)

                if not os.path.exists(destination_path):
                    os.makedirs(destination_path)

                file_count = 0
                for file_name in os.listdir(source_path):
                    if file_count >= 100:
                        break

                    source_file = os.path.join(source_path, file_name)
                    destination_file = os.path.join(destination_path, file_name)
                    shutil.copy2(source_file, destination_file)
                    file_count += 1

if __name__ == '__main__':
    if len(sys.argv) != 3:
        print("Usage: python script.py source_folder destination_folder")
        sys.exit(1)

    source_folder = sys.argv[1]
    destination_folder = sys.argv[2]

    copy_files(source_folder, destination_folder)
    
"""



