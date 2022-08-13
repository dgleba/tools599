# based on https://github.com/datitran/raccoon_dataset/blob/master/xml_to_csv.py


# python D:\dataset\ir7\xml_2_csv.py

# this seems to need to be placed in D:/dataset if inputfolder = "D:/dataset/ir7/"

# David Gleba change filename source to file from OS rather than xml filename


# settings:

# see:   edit-these-marker



# edit-these-marker
inputfolder = "D:/dataset/ir7/"

import os
import glob
import pandas as pd
import xml.etree.ElementTree as ET


def xml_to_csv(path):
    xml_list = []
    for xml_file in glob.glob(path + '/*.xml'):
        tree = ET.parse(xml_file)
        root = tree.getroot()
        for member in root.findall('object'):
            value = (path + xml_file,
                     int(root.find('size')[0].text),
                     int(root.find('size')[1].text),
                     member[0].text,
                     int(member[4][0].text),
                     int(member[4][1].text),
                     int(member[4][2].text),
                     int(member[4][3].text)
                     )
            xml_list.append(value)
    column_name = ['filename', 'width', 'height', 'class', 'xmin', 'ymin', 'xmax', 'ymax']
    xml_df = pd.DataFrame(xml_list, columns=column_name)
    return xml_df


def main():
    # edit-these-marker
    for folder in ['train', 'eval', 'holdout-test']:
        image_path = os.path.join(os.getcwd(), (inputfolder + folder))
        xml_df = xml_to_csv(image_path)
        xml_df.to_csv((inputfolder  + folder +'_labels.csv'), index=None)
    print('convert xml to csv reached end. Check the result.')


main()
