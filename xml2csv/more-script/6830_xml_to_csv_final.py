#--------------------------------------------------------------------------
# THIS IS THE IMPORT MODULE SECTION
import xml.etree.ElementTree as ET 
import csv
import os
import sys
import logging
import os.path
from pathlib import Path
import re
#----------------------------------------------------------------------------
# THIS IS THE SETTINGS SECTION
logger = logging.getLogger('')
logger.setLevel(logging.DEBUG)
fh = logging.FileHandler('xml_to_csv_logger.log')
sh = logging.StreamHandler(sys.stdout)
formatter = logging.Formatter('[%(asctime)s] %(levelname)s [%(filename)s,%(funcName)s:%(lineno)d] %(message)s', datefmt='%a, %d %b %Y %H:%M:%S')
fh.setFormatter(formatter)
sh.setFormatter(formatter)
logger.addHandler(fh)
logger.addHandler(sh)

def hello_logger():
    logger.debug("Debug means: Detailed information, typically of interest only when diagnosing problems.") #debug
    logger.info("Info means: Confirmation that things are working as expected.") #inbetween warning and debug, if you want more, use info
    logger.warning("Warning means: An indication that something unexpected happened, or indicative of some problem in the near future. Software working as expected.") #warning
    logging.error("Error means: Due to a more serious problem, the software has not been able to perform some function.")
    logger.critical("Critical means: A serious error, indicating that the program itself may be unable to continue running.") #always want to go to screen and log, errors (least amount shown)

if __name__ == "__main__":
    print(hello_logger())

#go to logger module docs

main_folder = r'D:\data\vision_6830\image_data'
extensions = ('.xml')

#open a file for writing
xml_data = open('defect_summary_results_with_scores.csv', 'w', newline='')

# In Python 2, open outfile with mode 'wb' instead of 'w'. 
# The csv.writer writes \r\n into the file directly. 
# If you don't open the file in binary mode, 
# it will write \r\r\n because on Windows text mode will translate each \n into \r\n.

# In Python 3 the required syntax changed (see documentation links below), 
# so open outfile with the additional parameter newline='' (empty string) instead.

#----------------------------------------------------------------------------
# THIS IS THE XML TO CSV CONVERTER CODE 

# create the csv writer object
csvwriter = csv.writer(xml_data)
header = []

count = 0
for subdirs, dirs, files in os.walk(main_folder):
    for filename in files:
        ext = os.path.splitext(filename)[-1].lower()

        if ext in extensions:
            current_file_path = (subdirs + '\\' + filename)
            # print(current_file_path)
            tree = ET.parse(current_file_path)
            root = tree.getroot()
            xml_file_name = []
            # count = count + 1
            # print(str(count) + current_file_path)
            # Up to this point, it is hitting every xml file ONCE

            for object_tag in root.findall('object'):
                #now it is printing file name for each defect it finds

    # this code creates the code for the first row on the first iteration of the for loop
    # after the header is created, the count = 1, and so 'if count ==0' gets bypassed, and each new row gets appended
                if count == 0:
                    Pathway = header.append('Path Way')
                    Filename = header.append('File Name')
                    Width = header.append('Width')
                    Height = header.append('Height')
                    Depth = header.append('Depth')
                    Defecttype = header.append('Defect Type')
                    Xmin = header.append('xmin')
                    Ymin = header.append('ymin')
                    Xmax = header.append('xmax')
                    Ymax = header.append('ymax')
                    Score = header.append('Score')

                    print(header)
                    csvwriter.writerow(header)
                    count = count + 1

            #Need to append filename in first column before variables from xml file are pulled
                xml_file_name.append(current_file_path)
                xml_file_name.append(filename)
                count = count + 1
                # print(str(count) + current_file_path, object_tag[0].text)

            # Size of defect?
                size = root.find('size')
                if size == None:
                    break
                # print(size)

                width = size[0].text
                xml_file_name.append(width)

                height = size[1].text
                xml_file_name.append(height)

                depth = size[2].text
                xml_file_name.append(depth)

            # Defect type
                defecttype = object_tag[0].text
                if defecttype == None:
                    break
                xml_file_name.append(defecttype)

                bndbox = object_tag[4]

                xmin = bndbox[0].text
                xml_file_name.append(xmin)

                ymin = bndbox[1].text
                xml_file_name.append(ymin)

                xmax = bndbox[2].text
                xml_file_name.append(xmax)

                ymax = bndbox[3].text
                xml_file_name.append(ymax)

                score = object_tag[3].text
                xml_file_name.append(score)

                try:
                    if xml_file_name[11] in xml_file_name:
                        del xml_file_name[0:11]
                        print(xml_file_name)

                except:
                    pass

                csvwriter.writerow(xml_file_name)

                x = re.search(filename, current_file_path)
            
                if x is True:
                    logger.debug("This file, " + filename + ", has already been logged.")
                    break
xml_data.close()

