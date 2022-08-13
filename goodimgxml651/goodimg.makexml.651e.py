
# Assumptions
#
# argument is a folder
#
# this will copy the set xml file for each file in the folder.
#


#  example usage:  python D:\data\script\tools599\goodimgxml651\goodimg.makexml.651e.py  D:\dataset\ir7\holdout-test

#  example usage:  python D:\data\script\tools599\goodimgxml651\goodimg.makexml.651e.py  D:\copyof\corp-fs01\CORP-PM\data_eng\ml_lib\ml_lib_6830\grp12_inner-rim\12a\inner-rim_ml_gen\ok
#  example usage:  python D:\data\script\tools599\goodimgxml651\goodimg.makexml.651e.py  D:\copyof\corp-fs01\CORP-PM\data_eng\ml_lib\ml_lib_6830\grp12_inner-rim\12d\clean
#  example usage:  python D:\data\script\tools599\goodimgxml651\goodimg.makexml.651e.py  D:\copyof\corp-fs01\CORP-PM\data_eng\ml_lib\ml_lib_6830\grp12_inner-rim\12e\ok




#--------------------------------------------------------------------------
# THIS IS THE IMPORT MODULE SECTION
import xml.etree.ElementTree as ET
import shutil, os, sys, csv, logging, glob, re, time, errno, zipfile
import os.path
from pathlib import Path
# from os.path import basename 
# from datetime import datetime
# from zipfile import ZipFile

#----------------------------------------------------------------------------
# THIS IS THE SETTINGS SECTION



#----------------------------------------------------------------------------

def funca():

    # path to work on..
    arga = sys.argv[1]
    print('dir:',arga)

    xfile_path = curr_dir.joinpath('goodimage.template.xml')
    print("tmplate xml:",xfile_path )

    files = Path(arga).glob('*.png')
    for file in files:
        # potential xml file to create if not exists
        nxml = os.path.join(arga,Path(file).stem + ".xml")
        if not os.path.exists(nxml):
            print("f: ",file, "newxml: ", nxml)
            shutil.copyfile(xfile_path, nxml)
    return



if __name__ == "__main__":

    # get directory of .py file running..
    curr_dir = Path(__file__).parent
    print(curr_dir)

    funca()

