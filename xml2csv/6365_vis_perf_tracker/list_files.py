#THIS CODE PRINTS ALL THE FILES THAT ARE XML TYPE IN A DIRECTORY AND ITS SUBDIRECTORIES

import os, shutil, glob
import os.path
# from xml_extension import xml_file
#from xml_extension.py import xml_file the class

main_folder = r'C:\Users\pmdacameras\Documents\LabVIEW Data\SGE Rotor Vision'
extensions = ('.xml', '.png')

#file_name_list_main_folder = os.listdir(main_folder)
# print(file_name_list_main_folder)
for subdirs, dirs, files in os.walk(main_folder):
    for filename in files:
        ext = os.path.splitext(filename)[-1].lower()
        if ext in extensions:
            current_file_path = (subdirs + '\\' + filename)
            print(filename)
            file = open("files_summary.txt", "a")
            file.write(filename + "\n")
            file.close()

#We want to list a file in a directory 