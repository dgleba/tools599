##Features:
# User input for directory of interest
# Lists the tags available
# Asks which tag you'd like to change
# Asks if you want to replace with another tag, or delete
# Keep log of changes

# ADD FEATURES------------VVV
# Zip .xml file back-ups with timestamp
# Provide full listing of all of the files to go along with the back-up in a text file inside the zip
# Output differences, verify that it did what you wanted it to (different code, compare xml back-up folder to final result)

### LESSONS LEARNED FROM WRITING THIS SCRIPT-------------------------------
## Note about replacing tags with empty string - this breaks the .xml file. Anything after the broken tag will not be read. 
# It changes the <name>DEFECT</name> into '<name />' which stops the code from reading the file, and any defects that appear after this broken tag will not be read.
# Noticed this on outer_surface_211208T0723723.xml - Misload appeared at the very end of the script. It was not included after replacing
#  a different defect tag in the document, ex. Debris
# Because 'Debris' tags appeared in the document first, the first instance of '<name />' meant anything after it would not get read.
# Therefore, have to remove entire section of <object></object>, not just tag.text

#--------------------------------------------------------------------------
# THIS IS THE IMPORT MODULE SECTION
import xml.etree.ElementTree as ET
import shutil
import os
import sys
import csv 
import logging
import os.path
from os.path import basename 
from pathlib import Path
import re
from datetime import datetime
import time
import errno
import zipfile
from zipfile import ZipFile
#----------------------------------------------------------------------------
# THIS IS THE SETTINGS SECTION
logger = logging.getLogger('')
logger.setLevel(logging.DEBUG)
fh = logging.FileHandler('xml_tag_editor_logger.log')
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

# ----------------------------------------
#ASK USER FOR INPUT DIRECTORY 
welcome_message = print('Hi there, I\'m Tag Bot :)! If at any point you want to exit this script, simply press Ctrl + C.')
directory_input_from_user = input('To start, list the directory that has the .xml files you want to parse: ' + '\n')

main_folder_raw_input = directory_input_from_user
main_folder = Path(main_folder_raw_input)
extensions = ('.xml')
extentions_for_csv = ('.xml', '.png')
defecttype_list = []
filename_list = []
kick_out_list = []

#----------------------------------------------------------------------------
# THIS IS THE FUNCTIONS SECTION
while True:
    datetime_now = datetime.now()
    datetime_now_format = datetime_now.strftime('%Y-%m-%d-%H-%M-%S')
    csv_file_name = Path(str(main_folder) + '-file_list_summary-' + str(datetime_now_format) + '.csv')
    
    def get_filelist_summary():
        kick_out_list = []
        print('Creating a .csv summary report of folder contents...Please wait.')
        
        filename_data = open(csv_file_name, 'w', newline='') #open a file for writing
        csvwriter = csv.writer(filename_data)
        header = []
        count = 0
        for subdirs, dirs, files in os.walk(main_folder):
            for filename in files:
                ext = os.path.splitext(filename)[-1].lower()

                #Only want .xml files physically copied
                #Want a record of both .png and .xml
                if ext in extentions_for_csv:
                    file_name_list = []
                    current_file_path = (subdirs + '\\' + filename)
                    try:
                        if count == 0:
                            Pathway = header.append('Full_Path_Way')
                            Basepath = header.append('Base_Path')
                            Filename = header.append('File_Name')
                            Camera = header.append('Camera')
                            Datetime = header.append('Datetime')
                            Datetime_slice = header.append('Datetime_Slice')
                            Extension = header.append('Extension')

                            # print(header)
                            csvwriter.writerow(header)
                            count = count + 1

                    #Need to append filename in first column before variables from xml file are pulled
                        file_name_list.append(current_file_path)
                        file_name_list.append(subdirs)
                        file_name_list.append(filename)
                        count = count + 1
                        # print(str(count) + current_file_path, object_tag[0].text)


                    ## Here we need to get the camera name, and append it, and datetime, and append that before we append anything else.
                    #let's slice the filename BACK by outer_surface_211123T0 9 2 6 0 2 . x m l
                                                #                 123456789101112131415161718 --> there's 18 characters that make up the _ + date/time stamp + file extension
                        file_name_list.append(filename[:-18])

                        #iterate through filename string until we hit a number, then collect that information

                        datetime_stamp = []
                        for character in filename:
                            if character.isnumeric():
                                datetime_stamp.append(character)
                        
                        year_month_day = str(''.join(datetime_stamp[0:6]))
                        hour_minute_second = str(''.join(datetime_stamp[7:]))

                        datetime_stamp_string = str(year_month_day + '  ' + hour_minute_second)

                        datetime_object = datetime.strptime(datetime_stamp_string, '%y%m%d %H%M%S')
                        datetime_object_string = str(datetime_object)

                        for character in datetime_object_string:
                            if character == ' ':
                                extra_space_in_datetime_string = datetime_object_string[0:11] + ' ' + datetime_object_string[11:]

                        file_name_list.append(extra_space_in_datetime_string)
                        datetime_from_filename = filename[-17:-4]
                        file_name_list.append(datetime_from_filename)
                        file_name_list.append(ext)

                        csvwriter.writerow(file_name_list)
                        x = re.search(filename, current_file_path)
                    
                        if x is True:
                            logger.debug("This file, " + filename + ", has already been logged.")
                            break

                    except:
                        kick_out_list.append(current_file_path)
                        return(kick_out_list)
        
            filename_data.close()

    def zip_back_up_of_xml_files():
        try:        
            zip_folder_name = str(main_folder) + '-xml_back-up-' + str(datetime_now_format) + '.zip'

            print('Creating a back-up zip file of all .xml files in directory specified...Please wait.')
            myzip = ZipFile(zip_folder_name, 'w')

            for subdirs, dirs, files in os.walk(main_folder):
                for filename in files:
                    ext = os.path.splitext(filename)[-1].lower()
                    current_file_path = (subdirs + '\\' + filename)

                    replace_slashes = current_file_path.replace('\\','/')

                    abs_src = os.path.abspath(main_folder)
                    arcname = replace_slashes[len(abs_src) + 1:] 

                    if ext == extensions and str(current_file_path) not in kick_out_list:
                        myzip.write(filename=replace_slashes, arcname=arcname)
        except:
            pass

        replace_slashes_csv_filepath = str(csv_file_name).replace('\\','/')
        abs_src = os.path.abspath(main_folder)
        arcname = replace_slashes_csv_filepath[len(abs_src) + 1:] 
        myzip.write(filename=replace_slashes_csv_filepath, arcname=arcname)

        time.sleep(2)
        os.remove(csv_file_name)
        myzip.close()

        print('Back-up zip file has been generated and can be found at, \'' + str(zip_folder_name) + '\'. \n')

    def get_defectype_list():
        defecttype_list.clear()
        for subdirs, dirs, files in os.walk(main_folder):
            for filename in files:
                ext = os.path.splitext(filename)[-1].lower()

                if filename.endswith(ext):
                    current_file_path = (subdirs + '\\' + filename)
                    
                    try:
                        tree = ET.parse(current_file_path)
                        root = tree.getroot()

                        for object_tag in root.findall('object'):
                            defecttype = object_tag[0].text
                            if defecttype == None:
                                break
                            elif defecttype not in defecttype_list:
                                defecttype_list.append(defecttype)
                    except:
                        pass
                else:
                    pass
        return(defecttype_list)

    def editing_tags():
        defecttype_of_interest = input('Here\'s the list of tags found: ' + str(defecttype_list) + '\n' + 'Which defect tag would you like to edit?: ')

        for element in defecttype_list:
            if defecttype_of_interest not in defecttype_list:
                defecttype_of_interest = input('Sorry, I couldn\'t find that tag from the list. Could you try typing it in again? Characters must match exactly: ')

        replace_or_delete = input('Would you like to replace or delete a tag? To replace with another tag, type \'r\', and to delete type \'d\': ')

        if replace_or_delete == 'r':
            desired_defecttype = input('What tag would you like to replace \'' + defecttype_of_interest + '\' with?: ')
            confirmation_input = input('The options you have selected are to replace \'' + defecttype_of_interest + '\' with \'' + desired_defecttype + '\'. Is this correct? (y/n): ')

            if confirmation_input == 'n':
                print('Returning to defect tag selection.')
                time.sleep(2)
                return

            if confirmation_input == 'y':
                    print('Replacing tags...please wait.')
                    for subdirs, dirs, files in os.walk(main_folder):
                        for filename in files:
                            ext = os.path.splitext(filename)[-1].lower()

                            if ext in extensions:
                                current_file_path = (subdirs + '\\' + filename)
                                tree = ET.parse(current_file_path)
                                defecttype_of_interest_string = str(defecttype_of_interest)
                                desired_defecttype_string = str(desired_defecttype)
                                root = tree.getroot()

                                with open(current_file_path, encoding="utf-8") as f:
                                    tree = ET.parse(f)
                                    root = tree.getroot()

                                    for elem in root.getiterator():
                                        if elem.text == defecttype_of_interest_string:
                                            filename_list.append(filename)

                                        try:
                                            elem.text = elem.text.replace(defecttype_of_interest_string, desired_defecttype_string)
                                        except AttributeError:
                                            pass

                                tree.write(current_file_path, xml_declaration=True, method='xml', encoding="utf-8")
                    confirmation_of_replaced_text = 'Confirmed. All instances of \'' + defecttype_of_interest + '\' have been replaced with \'' + desired_defecttype + '\'.'
                    logging.debug(confirmation_of_replaced_text)
                    print('Returning to defect tag selection.')
                    time.sleep(2)
                    return
        
        if replace_or_delete == 'd':
            confirmation_input = input('The options you have selected are to delete all \'' + defecttype_of_interest + '\' tags. WARNING: Once the tags have been deleted, they cannot be recovered.' + '\n' + 'Do you want to proceed? (y/n): ')
            empty_string = ''

            if confirmation_input == 'n':
                print('Returning to defect tag selection.')
                time.sleep(2)
                return

            if confirmation_input == 'y':
                    print('Deleting tags...please wait.')
                    for subdirs, dirs, files in os.walk(main_folder):
                        for filename in files:
                            ext = os.path.splitext(filename)[-1].lower()

                            if ext in extensions:
                                current_file_path = (subdirs + '\\' + filename)
                                tree = ET.parse(current_file_path)
                                defecttype_of_interest_string = str(defecttype_of_interest)
                                root = tree.getroot()

                                with open(current_file_path, encoding="utf-8") as f:
                                    for object_tag in root.findall('object'):
                                        defect_tag = object_tag.find('name').text
                                        if defect_tag == defecttype_of_interest_string:
                                            try:
                                                root.remove(object_tag)
                                            except AttributeError:
                                                pass

                                    for elem in root.getiterator():
                                        if elem.text == defecttype_of_interest_string:
                                            filename_list.append(filename)

                                tree.write(current_file_path, xml_declaration=True, method='xml', encoding="utf-8")
                    confirmation_of_removed_text = 'Confirmed. All instances of \'' + defecttype_of_interest_string + '\' have been replaced with \'' + empty_string + ' \'.'
                    logging.debug(confirmation_of_removed_text)
                    print('Returning to defect tag selection.')
                    time.sleep(2)
                    return

    # editing_tags()
    if __name__ == "__main__":
        get_filelist_summary()
        zip_back_up_of_xml_files()
        get_defectype_list()
        editing_tags()