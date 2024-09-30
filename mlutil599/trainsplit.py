
'''
trainsplit.py

David Gleba 2023-06-17 with help from chatgpt.
https://chat.openai.com/share/23c404c0-f290-4d48-9996-07d50fe1dcb2
also. see prompts at bottom.
Tested on some sample data. Seems to work ok.

 find example-ml-data-tree/ -type f |grep -E "(\.xml|png)">trainsplit-in.txt
 find split3/ -type f |grep -E "(\.xml|png)">trainsplit-out.txt
 
c:
cd \0
c:\prg\python\python trainsplit.py C:\0\example-ml-data-tree  C:\0\split3  0.8


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

    # Iterate over the folders in the source folder tree
    for root, dirs, files in os.walk(source_folder):
        # Skip the destination folder itself
        if root == destination_folder:
            continue
        
        # Determine the number of files to copy for this folder
        num_files = len(files)
        num_train_files = int(num_files * train_percentage)

        # Shuffle the files randomly
        random.shuffle(files)

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
                if os.path.exists(source_xml_path):
                    shutil.copy2(source_xml_path, destination_xml_path)
                else:
                    print(f"XML file not found: {source_xml_path}")

# Read command-line arguments
if len(sys.argv) != 4:
    print("Usage: python trainsplit.py <source_folder> <destination_folder> <train_percentage>")
    sys.exit(1)

source_folder = sys.argv[1]
destination_folder = sys.argv[2]
train_percentage = float(sys.argv[3])

copy_files(source_folder, destination_folder, train_percentage)




'''
------------
older
------------

=================================================
=================================================


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

    # Iterate over the folders in the source folder tree
    for root, dirs, files in os.walk(source_folder):
        # Skip the destination folder itself
        if root == destination_folder:
            continue
        
        # Determine the number of files to copy for this folder
        num_files = len(files)
        num_train_files = int(num_files * train_percentage)

        # Shuffle the files randomly
        random.shuffle(files)

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
                shutil.copy2(source_xml_path, destination_xml_path)

# Read command-line arguments
if len(sys.argv) != 4:
    print("Usage: python trainsplit.py <source_folder> <destination_folder> <train_percentage>")
    sys.exit(1)

source_folder = sys.argv[1]
destination_folder = sys.argv[2]
train_percentage = float(sys.argv[3])

copy_files(source_folder, destination_folder, train_percentage)




=================================================



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

    # Iterate over the folders in the source folder tree
    for root, dirs, files in os.walk(source_folder):
        # Skip the destination folder itself
        if root == destination_folder:
            continue
        
        # Determine the number of files to copy for this folder
        num_files = len(files)
        num_train_files = int(num_files * train_percentage)

        # Shuffle the files randomly
        random.shuffle(files)

        # Copy files to train and eval folders
        for i, file in enumerate(files):
            source_path = os.path.join(root, file)
            if i < num_train_files:
                destination_path = os.path.join(train_folder, file)
            else:
                destination_path = os.path.join(eval_folder, file)
            shutil.copy2(source_path, destination_path)

# Read command-line arguments
if len(sys.argv) != 4:
    print("Usage: python trainsplit.py <source_folder> <destination_folder> <train_percentage>")
    sys.exit(1)

source_folder = sys.argv[1]
destination_folder = sys.argv[2]
train_percentage = float(sys.argv[3])

copy_files(source_folder, destination_folder, train_percentage)

=================================================



Dave.Gleba@SICS-GZPJL13 /cygdrive/c/0
$ find example-ml-data-tree/
example-ml-data-tree/
example-ml-data-tree/2022-01-25-inner_bore_crop
example-ml-data-tree/2022-01-25-inner_bore_crop/inner_bore_220106T005310.png
example-ml-data-tree/2022-01-25-inner_bore_crop/inner_bore_220106T005310.xml
example-ml-data-tree/grp10_outer
example-ml-data-tree/grp10_outer/10a
example-ml-data-tree/grp10_outer/10a/chip
example-ml-data-tree/grp10_outer/10a/chip/outer_surface_210805T103923.png
example-ml-data-tree/grp10_outer/10a/chip/outer_surface_210805T103923.xml
example-ml-data-tree/grp10_outer/10a/chip/outer_surface_210805T103931.png
example-ml-data-tree/grp10_outer/10a/chip/outer_surface_210805T103931.xml
example-ml-data-tree/grp10_outer/10a/chip/outer_surface_210805T103940.png
example-ml-data-tree/grp10_outer/10a/chip/outer_surface_210805T103940.xml
example-ml-data-tree/grp10_outer/10a/chip/outer_surface_210805T103949.png
example-ml-data-tree/grp10_outer/10a/chip/outer_surface_210805T103949.xml
example-ml-data-tree/grp10_outer/10a/chip/outer_surface_210805T104018.png
example-ml-data-tree/grp10_outer/10a/chip/outer_surface_210805T104018.xml
example-ml-data-tree/grp10_outer/10a/chip/outer_surface_210805T104026.png
example-ml-data-tree/grp10_outer/10a/chip/outer_surface_210805T104026.xml
example-ml-data-tree/grp10_outer/10a/chip/outer_surface_210805T104234.png
example-ml-data-tree/grp10_outer/10a/chip/outer_surface_210805T104234.xml
example-ml-data-tree/grp10_outer/10a/chip/outer_surface_210805T104244.png
example-ml-data-tree/grp10_outer/10a/chip/outer_surface_210805T104244.xml
example-ml-data-tree/grp10_outer/10a/chip/outer_surface_210805T104252.png
example-ml-data-tree/grp10_outer/10a/chip/outer_surface_210805T104252.xml
example-ml-data-tree/grp10_outer/10a/crack
example-ml-data-tree/grp10_outer/10a/crack/outer_surface_210804T142654.png
example-ml-data-tree/grp10_outer/10a/crack/outer_surface_210804T142654.xml
example-ml-data-tree/grp10_outer/10a/crack/outer_surface_210804T142702.png
example-ml-data-tree/grp10_outer/10a/crack/outer_surface_210804T142702.xml
example-ml-data-tree/grp10_outer/10a/crack/outer_surface_210804T142909.png
example-ml-data-tree/grp10_outer/10a/crack/outer_surface_210804T142909.xml
example-ml-data-tree/grp10_outer/10a/crack/outer_surface_210804T142920.png
example-ml-data-tree/grp10_outer/10a/crack/outer_surface_210804T142920.xml
example-ml-data-tree/grp10_outer/10a/crack/outer_surface_210804T142928.png
example-ml-data-tree/grp10_outer/10a/crack/outer_surface_210804T142928.xml
example-ml-data-tree/grp10_outer/10a/crack/outer_surface_210804T142938.png
example-ml-data-tree/grp10_outer/10a/crack/outer_surface_210804T142938.xml
example-ml-data-tree/grp10_outer/10a/crack/outer_surface_210804T142946.png
example-ml-data-tree/grp10_outer/10a/crack/outer_surface_210804T142946.xml
example-ml-data-tree/grp10_outer/10a/crack/Thumbs.db
example-ml-data-tree/grp10_outer/10a/OK
example-ml-data-tree/grp10_outer/10a/OK/220324
example-ml-data-tree/grp10_outer/10a/OK/220324/flag
example-ml-data-tree/grp10_outer/10a/OK/220324/flag/outer_surface_220324T160315.png
example-ml-data-tree/grp10_outer/10a/OK/220324/flag/outer_surface_220324T160315.xml
example-ml-data-tree/grp10_outer/10a/OK/220324/flag/outer_surface_220324T163129.png
example-ml-data-tree/grp10_outer/10a/OK/220324/flag/outer_surface_220324T163129.xml
example-ml-data-tree/grp10_outer/10a/OK/220324/flag/outer_surface_220324T173218.png
example-ml-data-tree/grp10_outer/10a/OK/220324/flag/outer_surface_220324T173218.xml
example-ml-data-tree/grp10_outer/10a/OK/220324/outer_surface_220324T143242.png
example-ml-data-tree/grp10_outer/10a/OK/220324/outer_surface_220324T144718.png
example-ml-data-tree/grp10_outer/10a/OK/220324/outer_surface_220324T144805.png
example-ml-data-tree/grp10_outer/10a/OK/220324/outer_surface_220324T151233.png
example-ml-data-tree/grp10_outer/10a/OK/220324/outer_surface_220324T151850.png
example-ml-data-tree/grp10_outer/10a/OK/220324/outer_surface_220324T151855.png
example-ml-data-tree/grp10_outer/10a/OK/220324/outer_surface_220324T152651.png
example-ml-data-tree/grp10_outer/10a/OK/220324/outer_surface_220324T152656.png
example-ml-data-tree/grp10_outer/10a/OK/220324/outer_surface_220324T152737.png
example-ml-data-tree/grp10_outer/10a/OK/220324/outer_surface_220324T152742.png
example-ml-data-tree/grp10_outer/10a/OK/220324/outer_surface_220324T152824.png
example-ml-data-tree/grp10_outer/10a/OK/220324/outer_surface_220324T152829.png
example-ml-data-tree/grp10_outer/10a/OK/220324/outer_surface_220324T160842.png
example-ml-data-tree/grp10_outer/10a/OK/220324/outer_surface_220324T160858.png
example-ml-data-tree/grp10_outer/10a/OK/220324/outer_surface_220324T160909.png
example-ml-data-tree/grp10_outer/10a/OK/220324/outer_surface_220324T160915.png
example-ml-data-tree/grp10_outer/10a/OK/220324/outer_surface_220324T161920.png
example-ml-data-tree/grp10_outer/10a/OK/220324/outer_surface_220324T161936.png
example-ml-data-tree/grp10_outer/10a/OK/220324/outer_surface_220324T161943.png
example-ml-data-tree/grp10_outer/10a/OK/220324/outer_surface_220324T161950.png
example-ml-data-tree/grp10_outer/10a/OK/220324/outer_surface_220324T161957.png
example-ml-data-tree/grp10_outer/10a/OK/220324/outer_surface_220324T162004.png
example-ml-data-tree/grp10_outer/10a/OK/220324/outer_surface_220324T162408.png
example-ml-data-tree/grp10_outer/10a/_first-100boxes+1k-OK.txt
example-ml-data-tree/grp10_outer/grp10_outer-xml_to_csv_summary-2022-04-25-19-13-28.csv
example-ml-data-tree/grp10_outer/grp10_outer-xml_to_csv_summary-2022-04-25-19-13-28.xlsx
example-ml-data-tree/grp10_outer/ml-generation-iterative-process-instructions_outer-DV6_v01.pptx
example-ml-data-tree/grp9
example-ml-data-tree/grp9/rim_crack_100_box
example-ml-data-tree/grp9/rim_crack_100_box/top_surface_211028T145652.png
example-ml-data-tree/grp9/rim_crack_100_box/top_surface_211028T145652.xml
example-ml-data-tree/grp9/rim_crack_100_box/top_surface_211028T153922.png
example-ml-data-tree/grp9/rim_crack_100_box/top_surface_211028T153922.xml
example-ml-data-tree/grp9/rim_crack_100_box/top_surface_211102T084335.png
example-ml-data-tree/grp9/rim_crack_100_box/top_surface_211102T084335.xml
example-ml-data-tree/grp9/rim_crack_100_box/top_surface_211102T100331.png
example-ml-data-tree/grp9/rim_crack_100_box/top_surface_211102T100331.xml


=================================================



#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#@  
#@  chatgpt prompts:
#@  
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@   2023-06-17[Jun-Sat]09-45AM 


chatgpt prompts:

prompts:

write python to copy randomly 80% of files in each folder from source folder tree to a single destination folder called train.
The remaining files are copied to a folder called eval.

make it accept  cmd args of source folder dest folder and train_percentage

name the script trainsplit.py

only copy picture files. each picture file may have an .xml file with the same base name. copy the .xml file along with the picture file.

Traceback (most recent call last):
  File "C:\0\trainsplit.py", line 60, in <module>
    copy_files(source_folder, destination_folder, train_percentage)
  File "C:\0\trainsplit.py", line 49, in copy_files
    shutil.copy2(source_xml_path, destination_xml_path)
  File "c:\prg\python\Lib\shutil.py", line 436, in copy2
    copyfile(src, dst, follow_symlinks=follow_symlinks)
  File "c:\prg\python\Lib\shutil.py", line 256, in copyfile
    with open(src, 'rb') as fsrc:
         ^^^^^^^^^^^^^^^
FileNotFoundError: [Errno 2] No such file or directory: 'C:\\0\\example-ml-data-tree\\grp10_outer\\10a\\OK\\220324\\outer_surface_220324T152656.xml'


=================================================


'''
