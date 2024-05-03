
'''
Purpose: copy a sampling of images from each cam/trigger.

We are given a folder with thousands of files named like C8_T16B_20221125_125909_ 1_160.bmp.  C8 is the camera number, T16B is the trigger number,  2022-11-15 is the date. Copy randomly 10 of each  unique camera,  and trigger . So randomly 10 of each unique string before the second underscore.

---

notes:

run it:

cd "/media/albe/vi641-003/mcdata/mc_6820_vision/Archive Record/Images"
python /ap/script/tools599/mlutil599/cp43_triggers_sampling.py  ./year2022/Nov/day25/Shift1/DV6.2/good/ /acrib/dg/6820a


python /ap/script/tools599/mlutil599/cp43_triggers_sampling.py  /acrib/dg/6820-good-10-each /acrib/dg/6820-good5


test:
cd /acrib/dg/
python /ap/script/tools599/mlutil599/cp43_triggers_sampling.py  ./6820in/ /acrib/dg/6820a



'''

import os
import random
import shutil
import argparse

def get_unique_combinations(files):
    unique_combinations = set()
    for file_name in files:
        parts = file_name.split('_')
        if len(parts) >= 2:  # Ensure at least two elements in parts list
            unique_combinations.add((parts[0], parts[1]))
        else:
            print(f"Skipping file {file_name}: Not in expected format")
    return list(unique_combinations)

def copy_files_randomly(files, unique_combinations, source_folder, destination_folder):
    for camera, trigger in unique_combinations:
        filtered_files = [file for file in files if file.startswith(camera + '_' + trigger)]
        # set # of images to copy here..
        selected_files = random.sample(filtered_files, min(5, len(filtered_files)))
        for file_name in selected_files:
            source_path = os.path.join(source_folder, file_name)
            destination_path = os.path.join(destination_folder, file_name)
            os.makedirs(os.path.dirname(destination_path), exist_ok=True)  # Ensure destination folder exists
            shutil.copyfile(source_path, destination_path)
            print(f"Copying {file_name} to {destination_path}")

def main():
    parser = argparse.ArgumentParser(description="Randomly copy files for each unique camera and trigger combination")
    parser.add_argument("source_folder", help="Path to the source folder containing files")
    parser.add_argument("destination_folder", help="Path to the destination folder where files will be copied")
    args = parser.parse_args()

    source_folder = args.source_folder
    destination_folder = args.destination_folder

    all_files = os.listdir(source_folder)
    unique_combinations = get_unique_combinations(all_files)
    copy_files_randomly(all_files, unique_combinations, source_folder, destination_folder)

if __name__ == "__main__":
    main()
