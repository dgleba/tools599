#--------------------------------------------------------------------------
# THIS IS THE IMPORT MODULE SECTION
import xml.etree.ElementTree as ET 
import csv
import os
import sys
import logging
import os.path
from pathlib import Path
import time
import datetime
import shutil
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

#go to logger module docs

root_directory = r'C:\Users\pmdacameras\Documents\LabVIEW Data\SGE Rotor Vision'
current_working_directory = os.getcwd()
extensions = ('.xml')
report_destination_folder = r'D:\data\xml_to_csv_reports'
current_datetime = datetime.datetime.now()
yesterdays_datetime = current_datetime - datetime.timedelta(days=1)
yesterdays_datetime_string = str(yesterdays_datetime)
report_filename = '6365_xml_to_csv_report' + '--' + yesterdays_datetime_string[0:10] + '.csv'

xml_data = open(report_filename, 'w', newline='') #open a file for writing

current_file_path_list = []
#----------------------------------------------------------------------------
# THIS SECTION EXTRACTS THE RIGHT DATE FOLDERS, converts to datetime object. Today's datetime - 1 day = folder we want to access
def get_yesterdays_folder_pathways():
    for subdirs, dirs, files in os.walk(root_directory):
        # print(subdirs, len(subdirs))
        root_dir_sliced = subdirs[31:]
        folder_datestamp = []
        for character in root_dir_sliced:
            if character.isnumeric():
                folder_datestamp.append(character)
        # print(folder_datestamp)

        year_month_day = str(''.join(folder_datestamp[0:6]))
        # print(year_month_day)

        current_datetime = datetime.datetime.now()
        yesterdays_datetime = current_datetime - datetime.timedelta(days=1)
        # print(current_datetime, yesterdays_datetime)
        yesterdays_datetime_string = str(yesterdays_datetime)
        slice_yesterdays_datetime_string = yesterdays_datetime_string[2:10]

        removed_dashes = slice_yesterdays_datetime_string.replace('-', '')
        # print(removed_dashes)

        for folders in dirs:
            if removed_dashes == folders:
                current_file_path = subdirs + '\\' + removed_dashes
                current_file_path_list.append(current_file_path)
    return (current_file_path_list)

get_yesterdays_folder_pathways()
#----------------------------------------------------------------------------
# THIS IS THE XML TO CSV CONVERTER CODE 

# create the csv writer object
csvwriter = csv.writer(xml_data)
header = []

count = 0
for file_pathways in current_file_path_list:
    for subdirs, dirs, files in os.walk(Path(file_pathways)):
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
                        Width = header.append('Width') # Does not exist in 6365 prod. files
                        Height = header.append('Height') # Does not exist in 6365 prod. files
                        Depth = header.append('Depth') # Does not exist in 6365 prod. files
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
                    xml_file_name.append(filename)
                    count = count + 1

                    xml_file_name.append(filename[:-18])

                        #iterate through filename string until we hit a number, then collect that information
                    datetime_stamp = []
                    for character in filename:
                        if character.isnumeric():
                            datetime_stamp.append(character)
                    
                    year_month_day = str(''.join(datetime_stamp[0:6]))
                    hour_minute_second = str(''.join(datetime_stamp[7:]))

                    datetime_stamp_string = str(year_month_day + '  ' + hour_minute_second)
                    
                    datetime_object = datetime.datetime.strptime(datetime_stamp_string, '%y%m%d %H%M%S')
                    datetime_object_string = str(datetime_object)

                    for character in datetime_object_string:
                        if character == ' ':
                            extra_space_in_datetime_string = datetime_object_string[0:11] + ' ' + datetime_object_string[11:]

                    xml_file_name.append(extra_space_in_datetime_string)


                    width = ''
                    xml_file_name.append(width)

                    height = ''
                    xml_file_name.append(height)

                    depth =  ''
                    xml_file_name.append(depth)

                # Defect type
                    defecttype = object_tag[0].text
                    if defecttype == None:
                        break
                    xml_file_name.append(defecttype)

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
                        if xml_file_name[13] in xml_file_name:
                            del xml_file_name[0:13]
                            # print(xml_file_name)

                    except:
                        pass

                    csvwriter.writerow(xml_file_name)

                    x = re.search(filename, current_file_path)
                
                    if x is True:
                        logger.debug("This file, " + filename + ", has already been logged.")
                        break
xml_data.close()

joined_path = current_working_directory + '\\' + report_filename

if os.stat(joined_path) is False:
    print('This pathway does not exist')
    shutil.move(os.path.join(current_working_directory, report_filename), report_destination_folder)
    print('Report has been generated.')
else:
    print('This report already ran and generated a summary from production yesterday.')
    print('The report\'s filename is: ' + report_filename)
    print('It is located at: ' + report_destination_folder)