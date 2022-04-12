import os
import os.path
from os import path
from pathlib import Path
import shutil
import xml.etree.ElementTree as ET

source = input("Directory to remove empty xml files from: ")


try:
    os.makedirs(os.path.join(source, destination), exist_ok = True)
except OSError as error:
    print("Directory can not be created")

main = source
start = Path(main)
file_list = []

print("\nSource: " + source)
print("Destination: " + destination + "\n")


for subdirs, dirs, files in os.walk(start):
    for filename in files:
        if(filename.endswith('.xml')):
            filepath = (subdirs + '\\' + filename)
            child_list = []
        try:
            with open(filepath, encoding = "utf-8", errors = 'ignore') as file:
                contents = ET.parse(file)
                root = contents.getroot()
                for elem in root.iter():
                    child_list.append(elem.tag)
                if 'object' not in child_list:
                    file.close()
                    shutil.move(filepath, destination)
        except IndexError as err:
            print(err)

        else:
            pass

