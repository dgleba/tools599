
'''
usage:

c:
cd \0
c:\prg\python\python count-files-by-type-csv.py .

c:\0

cd /media/albe/vi641-002/mcdata/mc_6670_vision/image_data
python /crib/tools599/movefiles575/count-files-by-type-csv.py .


'''

import os
import csv
import sys

def count_files_in_folder(folder_path):
    file_counts = {}
    for root, dirs, files in os.walk(folder_path):
        for file in files:
            file_type = os.path.splitext(file)[1]
            file_counts.setdefault(root, {}).setdefault(file_type, 0)
            file_counts[root][file_type] += 1
    return file_counts

def create_csv(file_counts):
    csv_file = "file_counts.csv"
    with open(csv_file, 'w', newline='') as f:
        fieldnames = ['Folder Path'] + sorted(set(file_type for folder in file_counts.values() for file_type in folder.keys()))
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        for folder, file_types in file_counts.items():
            row = {'Folder Path': folder}
            row.update(file_types)
            writer.writerow(row)
    print(f"CSV file '{csv_file}' has been created successfully.")

# Check if the folder path is provided as a command line argument
if len(sys.argv) != 2:
    print("Usage: python script.py <folder_path>")
    sys.exit(1)

# Get the folder path from the command line argument
folder_path = sys.argv[1]

# Verify that the folder path exists
if not os.path.isdir(folder_path):
    print("Invalid folder path.")
    sys.exit(1)

# Count files in folders
file_counts = count_files_in_folder(folder_path)

# Create CSV file
create_csv(file_counts)
