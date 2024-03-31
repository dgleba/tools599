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

s_xmax = '300'
s_ymax = '7990'

#----------------------------------------------------------------------------


def editdim():

    arga = sys.argv[1]
    print('file:',arga)
    tree = ET.parse(arga)
    root = tree.getroot()
    
    # print first level..
    # for e in root:
        # print(e.tag,e.text,e.attrib)

    for n in root.findall('.//name'):
        if n.text == 'GoodImage':
            print(n.text)
            # since this xml file has GoodImage in it, then simply brut force all dimensions to full image.
            for xmi in root.findall('.//xmin'): 
                xmi.text = "0"
            for ymi in root.findall('.//ymin'): 
                ymi.text = "0"
            for xmx in root.findall('.//xmax'): 
                #print(s_xmax)
                xmx.text = s_xmax
            for ymx in root.findall('.//ymax'): 
                ymx.text = s_ymax

            tree.write(arga, xml_declaration=True, method='xml', encoding="utf-8")
            # tree.write(arga)
            return
            
if __name__ == "__main__":
    editdim()

