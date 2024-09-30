#--------------------------------------------------------------------------
# THIS IS THE IMPORT MODULE SECTION
import xml.etree.ElementTree as ET 
import csv
import os
import sys
import logging
import os.path
from pathlib import Path
import datetime
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
    print('')
    # print(hello_logger())

#go to logger module docs

main_folder = r'E:\projects\vision_systems\6830_dv6_rotor\6830_dv6.2_trial_images\6830_dv6.2_scanning_trial_nov_3_2021\6830_dv6.2_scanning_trial_nov_22_2021\inner_bore_crack\top_surface'
extensions = ('.xml')

#open a file for writing
xml_data = open('inner_bore_crack-top_surface_camera_view.csv', 'w', newline='')

# In Python 2, open outfile with mode 'wb' instead of 'w'. 
# The csv.writer writes \r\n into the file directly. 
# If you don't open the file in binary mode, 
# it will write \r\r\n because on Windows text mode will translate each \n into \r\n.

# In Python 3 the required syntax changed (see documentation links below), 
# so open outfile with the additional parameter newline='' (empty string) instead.

#----------------------------------------------------------------------------
# THIS IS THE XML TO CSV CONVERTER CODE 


#ASK USER FOR INPUT DIRECTORY AND DESIRED FILENAME
directory_input_from_user = input('List the directory you want to parse in the format: ')
main_folder_raw_input = directory_input_from_user
main_folder = Path(main_folder_raw_input)

datetime_now = datetime.datetime.now()
datetime_now_format = datetime_now.strftime('%Y-%m-%d-%H-%M-%S')
destination_file_name = str(main_folder) + '-xml_to_csv_summary-' + str(datetime_now_format)

text_file_name_string = Path(destination_file_name + '.csv')
xml_data = open(text_file_name_string, 'w', newline='') #open a file for writing

# create the csv writer object
csvwriter = csv.writer(xml_data)
header = []

print('Generating report, please wait...')

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
                    Pathway = header.append('Full_Path_Way')
                    Basepath = header.append('Base_Path')
                    Filename = header.append('File_Name')
                    Camera = header.append('Camera')
                    Datetime = header.append('Datetime')

                    Datetime_slice = header.append('Datetime_Slice')
                    Width = header.append('Extension')

                    Width = header.append('Width')
                    Height = header.append('Height')
                    Depth = header.append('Depth')
                    Defecttype = header.append('Defect Type')
                    Xmin = header.append('xmin')
                    Ymin = header.append('ymin')
                    Xmax = header.append('xmax')
                    Ymax = header.append('ymax')
                    Score = header.append('Score')
                    # print(header)
                    csvwriter.writerow(header)
                    count = count + 1

            #Need to append filename in first column before variables from xml file are pulled
                xml_file_name.append(current_file_path)
                xml_file_name.append(subdirs)
                xml_file_name.append(filename)
                count = count + 1

                # print(str(count) + current_file_path, object_tag[0].text)
                #Camera name
                camera = filename[:-20]
                xml_file_name.append(camera)

                # datetime_stamp = []
                # for character in filename:
                #     if character.isnumeric():
                #         datetime_stamp.append(character)
                
                year_month_day = str(''.join(filename[-19:-11]))
                # print(year_month_day)
                hour_minute_second = str(''.join(filename[-10:-4]))
                # print(hour_minute_second)
                datetime_stamp_string = str(year_month_day + '  ' + hour_minute_second)

                # format_date_time = datetime_stamp_string.strfttime('%Y%m%d %H%M%S')
                datetime_object = datetime.datetime.strptime(datetime_stamp_string, '%Y%m%d %H%M%S')
                datetime_object_string = str(datetime_object)
                for character in datetime_object_string:
                    if character == ' ':
                        extra_space_in_datetime_string = datetime_object_string[0:11] + ' ' + datetime_object_string[11:]

                xml_file_name.append(extra_space_in_datetime_string)
                datetime_from_filename = filename[-19:-4]
                xml_file_name.append(datetime_from_filename)

                xml_file_name.append(ext)
                # print(ext)

            # Size of defect?
                # size = root.find('size')
                # if size == None:
                #     break
                # print(size)

                # width = size[0].text
                width = ''
                xml_file_name.append(width)

                # height = size[1].text
                height = ''
                xml_file_name.append(height)

                # depth = size[2].text
                depth = ''
                xml_file_name.append(depth)

            # Defect type
                defecttype = object_tag[0].text
                if defecttype == None:
                    break
                xml_file_name.append(defecttype)
                # print(defecttype)

                bndbox = object_tag[2]

                xmin = bndbox[0].text
                xml_file_name.append(xmin)

                ymin = bndbox[1].text
                xml_file_name.append(ymin)

                xmax = bndbox[2].text
                xml_file_name.append(xmax)

                ymax = bndbox[3].text
                xml_file_name.append(ymax)

                score = object_tag[1].text
                xml_file_name.append(score)

                try:
                    if xml_file_name[16] in xml_file_name:
                        del xml_file_name[0:16]
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
