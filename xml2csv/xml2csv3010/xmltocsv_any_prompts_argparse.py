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
import yaml
import shutil
import argparse
import itertools
#----------------------------------------------------------------------------

#--------------------------Notes---------------------------------------
# Will have to ADD new path for each part's directory to get correct contents for the xml files. eg: 10R80 rotors on 6365 = 10r_directory = r'D:\path\to\images


#--------------------------Information for User---------------------------------------
# Currently assuming the datetime format used to name files will remain same for each machine.
# Assume for future machines and parts the datetime format will be one of the following 220524T084835 or 20220524T084835
# ENTER FULL PATH as arguments on command prompt. The script WILL NOT work otherwise.
# Due to naming convention the csv reports will not have copies but instead a new one will be generated excluding csv reports for the machines.


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

# ----------------------------------------
#ASK USER FOR INPUT DIRECTORY AND DESIRED FILENAME

parser = argparse.ArgumentParser()
parser.add_argument('source', help = "Enter path of the source folder")
parser.add_argument('destination', help = "Enter path of the destination folder")
parser.add_argument('config', help = "Enter path of the config file")

parser.add_argument('--yesterday', action='store_true', default=False, help="Enter this optional argument to run a report for yesterdays date, otherwise do not enter")


args = parser.parse_args()
main_folder_raw_input = args.source
report_destination_folder = args.destination
main_folder = Path(main_folder_raw_input)
report_destination = Path(report_destination_folder)
current_working_directory = os.getcwd()
extensions = ('.xml')
datetime_now = datetime.datetime.now()
datetime_now_format = datetime_now.strftime('%Y-%m-%d-%H-%M-%S')
yesterdays_datetime = datetime_now - datetime.timedelta(days=1)
yesterdays_datetime_string = str(yesterdays_datetime)
current_file_path_list = []

date_ext_stamp = []
print('Generating report, please wait... \n')

#----------------------------------------------------------------------------
#---------------------- Functions Area --------------------------------------

def loadYaml(filepath):
    with open(filepath, "r") as fileDescriptor:
        yamlFileContents = yaml.load(fileDescriptor, Loader=yaml.FullLoader)
    return yamlFileContents


##THIS SECTION EXTRACTS THE RIGHT DATE FOLDERS, converts to datetime object. Today's datetime - 1 day = folder we want to access
def get_yesterdays_folder_pathways():
    for subdirs, dirs, files in os.walk(main_folder):
        current_datetime = datetime.datetime.now()
        yesterdays_datetime = current_datetime - datetime.timedelta(days=1)
        yesterdays_datetime_string = str(yesterdays_datetime)
                    
        cell_2_format_datetime = yesterdays_datetime_string[2:10].replace('-', '')
        cell_1_format_datetime = yesterdays_datetime_string[:10].replace('-','')
            
        for folders in dirs:
            if (cell_2_format_datetime == folders):
                current_file_path = subdirs + '\\' + cell_2_format_datetime
                current_file_path_list.append(current_file_path)
            if(cell_1_format_datetime == folders):
                current_file_path = subdirs + '\\' + cell_1_format_datetime
                current_file_path_list.append(current_file_path)
    return(current_file_path_list)

def get_all_folder_pathways():
    for subdirs, dirs, files in os.walk(main_folder):
        for folders in dirs:
            folderpath = os.path.join(main_folder, folders)
            if os.path.exists(folderpath):
                current_file_path = subdirs + '\\' + folders
                current_file_path_list.append(current_file_path)
    if current_file_path_list == []:
        current_file_path_list.append(main_folder)
    return(current_file_path_list)


if args.yesterday is True:
    get_yesterdays_folder_pathways()
    filepath = Path(args.config)
    yamlFileContents = loadYaml(filepath)
    partNumber = str(yamlFileContents.get('productNumber'))
    machineNumber = str(yamlFileContents.get('machineNumber'))
    report_filename = partNumber + '--' + 'xml_to_csv_report' + '--' + yesterdays_datetime_string[2:10] + '.csv'
    
    
if args.yesterday is False:
    current_file_path_list = get_all_folder_pathways()
    filepath = Path(args.config)
    yamlFileContents = loadYaml(filepath)
    partNumber = str(yamlFileContents.get('productNumber'))
    machineNumber = str(yamlFileContents.get('machineNumber'))
    report_filename = str(os.path.basename(main_folder_raw_input)) + '-xml_to_csv_summary-' + str(datetime_now_format) + '.csv'

print(report_filename + '\n')



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
   

xml_data = open(report_filename, 'w', newline='') #open a file for writing




##----------------------------------------------------------------------------

##----------------------------------------------------------------------------
##THIS IS THE XML TO CSV CONVERTER CODE
##Assuming the xml files have a ISO_8601 format for the date and timestamp.

##create the csv writer object
csvwriter = csv.writer(xml_data)
header = []

count = 0
for file_pathways in current_file_path_list:
    for subdirs, dirs, files in os.walk(Path(file_pathways)):
        for filename in files:
            ext = os.path.splitext(filename)[-1].lower()

            if ext in extensions:
                current_file_path = (subdirs + '\\' + filename)
                tree = ET.parse(current_file_path)
                root = tree.getroot()
                xml_file_name = []
                # Up to this point, it is hitting every xml file ONCE
                date_ext_stamp = []
                for i in reversed(filename):
                    if(i != "_"):
                        date_ext_stamp.append(i)
                    elif(i == "_"):
                        break;
                if(os.path.basename(filepath) == "config.yaml"):
                    if(len(date_ext_stamp) == 17):
                        partNumber = str(yamlFileContents.get('productNumber'))
                        machineNumber = str(yamlFileContents.get('machineNumber'))
                    elif(len(date_ext_stamp) != 17):
                        partNumber = str(yamlFileContents.get('productNumber1'))
                        machineNumber = str(yamlFileContents.get('machineNumber1'))


                for object_tag in root.findall('object'):
                    #now it is printing file name for each defect it finds

        # this code creates the code for the first row on the first iteration of the for loop
        # after the header is created, the count = 1, and so 'if count == 0' gets bypassed, and each new row gets appended
                    if count == 0:
                        Machine_Number = header.append('Machine Number')
                        Part_Number = header.append('Part Number')
                        Pathway = header.append('Full_Path_Way')
                        Basepath = header.append('Base_Path')
                        Filename = header.append('File_Name')
                        Camera = header.append('Camera')
                        Datetime = header.append('Datetime')
                        Dateonly = header.append('DateOnly')
                        Datetime_slice = header.append('ISO_8601')
                        extension = header.append('Extension')
                        Width = header.append('Width')
                        Height = header.append('Height')
                        Depth = header.append('Depth')
                        Defecttype = header.append('Defect Type')
                        Xmin = header.append('xmin')
                        Ymin = header.append('ymin')
                        Xmax = header.append('xmax')
                        Ymax = header.append('ymax')
                        xdelta = header.append('xdelta')
                        ydelta = header.append('ydelta')
                        Area = header.append('Area')
                        Score = header.append('Score')
                        
                        csvwriter.writerow(header)
                        count = count + 1
                            

                #Need to append filename in first column before variables from xml file are pulled
                    xml_file_name.append(machineNumber)
                    xml_file_name.append(partNumber)
                    xml_file_name.append(current_file_path)
                    xml_file_name.append(subdirs)
                    xml_file_name.append(filename)
                    count = count + 1


                ## Here we need to get the camera name, and append it, and datetime, and append that before we append anything else.
                #let's slice the filename BACK by outer_surface_211123T0 9 2 6 0 2 . x m l
                #                 123456789101112131415161718 --> there's 18 characters that make up the _ + date/time stamp + file extension
                    if(len(date_ext_stamp) != 17):
                        camera = filename[:-20]
                    elif(len(date_ext_stamp) == 17):
                        camera = filename[:-18]

                    xml_file_name.append(camera)

                    #iterate through filename string until we hit a number, then collect that information
                    if(len(date_ext_stamp) == 17):
                        datetime_stamp = []
                        for character in reversed(date_ext_stamp):
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

                        datetime_from_filename = filename[-17:-4]
                        
                        xml_file_name.append(datetime_object_string[0:11])
                        xml_file_name.append(datetime_from_filename)
                        xml_file_name.append(ext)
                        
                    if(len(date_ext_stamp) != 17):
                        datetime_stamp = []
                        for character in reversed(date_ext_stamp):
                            if character.isnumeric():
                                datetime_stamp.append(character)
                        
                        year_month_day = str(''.join(datetime_stamp[0:8]))
                        hour_minute_second = str(''.join(datetime_stamp[8:]))

                        datetime_stamp_string = str(year_month_day + '  ' + hour_minute_second)
                        
                        datetime_object = datetime.datetime.strptime(datetime_stamp_string, '%Y%m%d %H%M%S')
                        datetime_object_string = str(datetime_object)

                        for character in datetime_object_string:
                            if character == ' ':
                                extra_space_in_datetime_string = datetime_object_string[0:11] + ' ' + datetime_object_string[11:]

                        xml_file_name.append(extra_space_in_datetime_string)

                        datetime_from_filename = filename[-19:-4]
                        
                        xml_file_name.append(datetime_object_string[0:11])
                        xml_file_name.append(datetime_from_filename)
                        xml_file_name.append(ext)
                        

                # Size of image?
                    size = root.find('size')
                    if size == None:
                        width = ''
                        xml_file_name.append(width)
                        height = ''
                        xml_file_name.append(height)
                        depth = ''
                        xml_file_name.append(depth)
                        
                    else: 
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
                    if(len(date_ext_stamp) == 17):
                        bndbox = object_tag.find('bndbox')

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
                        
                    elif(len(date_ext_stamp) != 17):
                        bndbox = object_tag.find('bndbox')

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
                    
                    scores = object_tag.find('score')
                    if scores == None:
                        xml_file_name.append("Manual")
                    else:
                        xml_file_name.append(scores.text)

                    try:
                        if xml_file_name[22] in xml_file_name:
                            del xml_file_name[0:22]
                    except:
                        pass

                    csvwriter.writerow(xml_file_name)
                    x = re.search(filename, current_file_path)
                    
                    if x is True:
                        logger.debug("This file, " + filename + ", has already been logged.")
                        break
xml_data.close()
try:
    shutil.move(os.path.join(current_working_directory, report_filename), report_destination_folder)
except:
    pass
print('Report has been generated.')


