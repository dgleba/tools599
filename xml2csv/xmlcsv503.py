<<<<<<< HEAD
'''
####################################   2024-05-03[May-Fri]09-06AM 

gpt created pascal voc xml to csv .py


'''

import os
import xml.etree.ElementTree as ET
import csv

def xml_to_csv(xml_folder, csv_file):
    xml_list = []
    for xml_file in os.listdir(xml_folder):
        if xml_file.endswith('.xml'):
            tree = ET.parse(os.path.join(xml_folder, xml_file))
            root = tree.getroot()
            filename = root.find('filename').text
            size = root.find('size')
            width = int(size.find('width').text)
            height = int(size.find('height').text)
            for member in root.findall('object'):
                try:
                    class_name = member.find('name').text
                    bbox = member.find('bndbox')
                    xmin = float(bbox.find('xmin').text)
                    ymin = float(bbox.find('ymin').text)
                    xmax = float(bbox.find('xmax').text)
                    ymax = float(bbox.find('ymax').text)
                    xml_list.append([filename, width, height, class_name, xmin, ymin, xmax, ymax])
                except Exception as e:
                    print(f"Error processing file {xml_file}: {e}")

    with open(csv_file, 'w', newline='') as f:
        writer = csv.writer(f)
        writer.writerow(['filename', 'width', 'height', 'class', 'xmin', 'ymin', 'xmax', 'ymax'])
        writer.writerows(xml_list)


# Usage example
xml_folder = '.'
csv_file = 'output-xml2csvgen-4.csv'
xml_to_csv(xml_folder, csv_file)


=======
'''
####################################   2024-05-03[May-Fri]09-06AM 

gpt created pascal voc xml to csv .py


'''

import os
import xml.etree.ElementTree as ET
import csv

def xml_to_csv(xml_folder, csv_file):
    xml_list = []
    for xml_file in os.listdir(xml_folder):
        if xml_file.endswith('.xml'):
            tree = ET.parse(os.path.join(xml_folder, xml_file))
            root = tree.getroot()
            filename = root.find('filename').text
            size = root.find('size')
            width = int(size.find('width').text)
            height = int(size.find('height').text)
            for member in root.findall('object'):
                try:
                    class_name = member.find('name').text
                    bbox = member.find('bndbox')
                    xmin = float(bbox.find('xmin').text)
                    ymin = float(bbox.find('ymin').text)
                    xmax = float(bbox.find('xmax').text)
                    ymax = float(bbox.find('ymax').text)
                    xml_list.append([filename, width, height, class_name, xmin, ymin, xmax, ymax])
                except Exception as e:
                    print(f"Error processing file {xml_file}: {e}")

    with open(csv_file, 'w', newline='') as f:
        writer = csv.writer(f)
        writer.writerow(['filename', 'width', 'height', 'class', 'xmin', 'ymin', 'xmax', 'ymax'])
        writer.writerows(xml_list)


# Usage example
xml_folder = '.'
csv_file = 'output-xml2csvgen-4.csv'
xml_to_csv(xml_folder, csv_file)


>>>>>>> 7fec4860c461f21c29b361e4435dd9251bcf6b07
