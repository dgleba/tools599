# goodimg651b



#  python goodimg651b.py  D:\code\xmled651\xml\outer_surface_211208T073242.xml



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

def editdim():

    print('file:',sys.argv[1])
    tree = ET.parse(sys.argv[1])
    root = tree.getroot()
    
    # print first level..
    # for e in root:
        # print(e.tag,e.text,e.attrib)

    for n in root.findall('.//name'):
        if n.text == 'GoodImage':
            print(n.text)
            for xmi in root.findall('.//xmin'): 
                xmi.text = "0"
            # tree.write(sys.argv[1], xml_declaration=True, method='xml', encoding="utf-8")
            tree.write(sys.argv[1])
            return
            
if __name__ == "__main__":
    # get_filelist_summary()
    # zip_back_up_of_xml_files()
    # get_defectype_list()
    # editing_tags()
    editdim()
