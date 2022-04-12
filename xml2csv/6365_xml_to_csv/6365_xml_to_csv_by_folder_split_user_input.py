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
import time
import datetime
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
    # print(hello_logger())
    print('')

#go to logger module docs

directory_input_from_user = input('List the directory you want to parse: ')
output_text_file = input('What would you like to call the .csv report that you are about to generate? Format does not include file extension, ex. type test_file, and it will generate test_file.csv: ')

main_folder_raw_input = directory_input_from_user
main_folder = Path(main_folder_raw_input)
extensions = ('.xml')

report_filename = Path(output_text_file + '.csv')
xml_data = open(report_filename, 'w', newline='')#open a file for writing
print('Generating report, please wait...')

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
                    Camera = header.append('Camera')
                    Datetime = header.append('Datetime')
                    Width = header.append('Width')
                    Height = header.append('Height')
                    Depth = header.append('Depth')
                    Defecttype = header.append('Defect Type')
                    Xmin = header.append('xmin')
                    Ymin = header.append('ymin')
                    Xmax = header.append('xmax')
                    Ymax = header.append('ymax')
                    csvwriter.writerow(header)
                    count = count + 1

            #Need to append filename in first column before variables from xml file are pulled
                xml_file_name.append(current_file_path)
                xml_file_name.append(filename)
                count = count + 1
                # print(str(count) + current_file_path, object_tag[0].text)
                        #iterate through filename string until we hit a number, then collect that information

                camera_name = filename[:-20]
                xml_file_name.append(camera_name)

                datetime_from_filename = filename[-19:-4]
                xml_file_name.append(datetime_from_filename)
                
                # datetime_stamp = []
                # for character in filename:
                #     if character.isnumeric():
                #         datetime_stamp.append(character)

                # year_month_day = str(''.join(datetime_stamp[1:9]))
                # hour_minute_second = str(''.join(datetime_stamp[9:]))

                # datetime_stamp_string = str(year_month_day + '  ' + hour_minute_second)
                
                # datetime_object = datetime.datetime.strptime(datetime_stamp_string, '%Y%m%d  %H%M%S')
                # datetime_object_string = str(datetime_object)

                # for character in datetime_object_string:
                #     if character == ' ':
                #         extra_space_in_datetime_string = datetime_object_string[0:11] + ' ' + datetime_object_string[11:]

                # xml_file_name.append(extra_space_in_datetime_string)

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

                try:
                    if xml_file_name[12] in xml_file_name:
                        del xml_file_name[0:12]
                        # print(xml_file_name)

                except:
                    pass

                csvwriter.writerow(xml_file_name)

                x = re.search(filename, current_file_path)
            
                if x is True:
                    logger.debug("This file, " + filename + ", has already been logged.")
                    break
xml_data.close()

print('Report has been generated.')
print('The report\'s filename is: ' + str(report_filename))