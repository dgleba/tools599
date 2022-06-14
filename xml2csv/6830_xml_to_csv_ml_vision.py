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
import datetime
import subprocess
import shutil
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
#D:\data\vision_6830\image_data\outer_surface\nok\211202\flag

#month subfolder 'YYMMDD' or ex. 211202 is December 2, 2021
# ----------------------------------------
#ASK USER FOR INPUT DIRECTORY AND DESIRED FILENAME

root_directory = r'D:\data\vision_6830\image_data'
current_working_directory = os.getcwd()
extensions = ('.xml')
report_destination_folder = r'D:\data\vision_6830\xml_to_csv_reports'
current_datetime = datetime.datetime.now()
yesterdays_datetime = current_datetime - datetime.timedelta(days=1)
yesterdays_datetime_string = str(yesterdays_datetime)
report_filename = '6830_xml_to_csv_report' + '--' + yesterdays_datetime_string[0:10] + '.csv'
print(report_filename)


generated_pathway = Path(current_working_directory + '\\' + report_filename)
destination_file_pathway = Path(report_destination_folder + '\\' + report_filename)


if destination_file_pathway.exists():
    # If 'exists()' means if the file is there
    # First, check if both files are already there. If they are, remove from generated folder.
    print('This report already ran and generated a summary from production yesterday.')
    print('The report\'s filename is: ' + report_filename)
    print('It is located at: ' + report_destination_folder)
    sys.exit()

elif generated_pathway.exists() and destination_file_pathway.exists() is False:
    # If 'exists() is False' means if the file is not there
    # Checking if the file was generated, but not moved to destination folder yet.
    print('Report has already been generated. Moving it to appropriate location.')
    print('The report\'s filename is: ' + report_filename)
    print('It is located at: ' + report_destination_folder)
    shutil.move(os.path.join(current_working_directory, report_filename), report_destination_folder)
    sys.exit()

xml_data = open(destination_file_pathway, 'w', newline='') #open a file for writing

print('Generating report, please wait...')

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

        current_datetime = datetime.datetime.now()
        yesterdays_datetime = current_datetime - datetime.timedelta(days=1)

        yesterdays_datetime_string = str(yesterdays_datetime)
        slice_yesterdays_datetime_string = yesterdays_datetime_string[2:10]

        removed_dashes = slice_yesterdays_datetime_string.replace('-', '')


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
                        Pathway = header.append('Full_Path_Way')
                        Basepath = header.append('Base_Path')
                        Filename = header.append('File_Name')
                        Camera = header.append('Camera')
                        Datetime = header.append('Datetime')
                        Dateonly = header.append('DateOnly')
                        Datetime_slice = header.append('ISO_8601')
                        #Width = header.append('Extension')
                        Width = header.append('Width')
                        Height = header.append('Height')
                        Depth = header.append('Depth')
                        Defecttype = header.append('Defect_Type')
                        Xmin = header.append('xmin')
                        Ymin = header.append('ymin')
                        Xmax = header.append('xmax')
                        Ymax = header.append('ymax')
                        xdelta = header.append('xdelta')
                        ydelta = header.append('ydelta')
                        Area = header.append('Area')
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


                ## Here we need to get the camera name, and append it, and datetime, and append that before we append anything else.
                #let's slice the filename BACK by outer_surface_211123T0 9 2 6 0 2 . x m l
                                            #                 123456789101112131415161718 --> there's 18 characters that make up the _ + date/time stamp + file extension
                    camera_name = filename[:-18]
                    xml_file_name.append(camera_name)

                    #iterate through filename string until we hit a number, then collect that information
                    datetime_stamp = []
                    for character in filename:
                        if character.isnumeric():
                            datetime_stamp.append(character)
                    year_month_day = str(''.join(datetime_stamp[0:6]))
                    hour_minute_second = str(''.join(datetime_stamp[6:]))

                    datetime_stamp_string = str(year_month_day + '  ' + hour_minute_second)

                    datetime_object = datetime.datetime.strptime(datetime_stamp_string, '%y%m%d %H%M%S')
                    datetime_object_string = str(datetime_object)
                    

                    for character in datetime_object_string:
                        if character == ' ':
                            extra_space_in_datetime_string = datetime_object_string[0:11] + ' ' + datetime_object_string[11:]
   

                    xml_file_name.append(extra_space_in_datetime_string)
                    xml_file_name.append(datetime_object_string[0:11])

                    datetime_from_filename = filename[-17:-4]
                    xml_file_name.append(datetime_from_filename)

                    #xml_file_name.append(ext)

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

                    deltax = int(xmax) - int(xmin)
                    xml_file_name.append(deltax)

                    deltay = int(ymax) - int(ymin)
                    xml_file_name.append(deltay)

                    box_area = int(deltax)*int(deltay)
                    xml_file_name.append(box_area)
                    

                    score = object_tag[3].text
                    xml_file_name.append(score)

                    try:
                        if xml_file_name[19] in xml_file_name:
                            del xml_file_name[0:19]
                            print(xml_file_name) #this prints whenever it finds more than one defect in a file

                    except:
                        pass
                    #print(xml_file_name)
                    csvwriter.writerow(xml_file_name)
                    x = re.search(filename, current_file_path)
                
                    if x is True:
                        logger.debug("This file, " + filename + ", has already been logged.")
                        break
xml_data.close()

print("Report Generated")

