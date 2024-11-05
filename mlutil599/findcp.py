
'''

python that calls bash find to look for filenames containing string in the filename and copy the files to output path without subfolders. if duplicate filename is found, then add _# to the name.

'''

import os
import shutil
import subprocess
import shlex

def find_and_copy_files(search_configs, output_path):
    # Ensure output_path exists
    if not os.path.exists(output_path):
        os.makedirs(output_path)

    total_files_found = 0
    global_count = 1

    for config in search_configs:
        input_path = config['input_path']
        search_string = config['search_string']

        # Create the find command
        command = f"find {shlex.quote(input_path)} -type f -name '*{shlex.quote(search_string)}*'"

        # Run the find command
        result = subprocess.run(command, shell=True, capture_output=True, text=True)
        if result.returncode != 0:
            print(f"Error while running find command for search_string '{search_string}' in '{input_path}':", result.stderr)
            continue

        files = result.stdout.splitlines()

        # Show the number of files found for the current search string
        num_files_found = len(files)
        total_files_found += num_files_found
        print(f"Number of files found for search_string '{search_string}' in '{input_path}': {num_files_found}")

        # Copy files to output_path while appending __count to the filenames
        for file_path in files:
            file_name = os.path.basename(file_path)
            base_name, extension = os.path.splitext(file_name)
            new_file_name = f"{base_name}__{global_count}{extension}"
            global_count += 1

            # Copy the file to the output directory
            dest_path = os.path.join(output_path, new_file_name)
            shutil.copy(file_path, dest_path)
            print(f"Copied {file_path} to {dest_path}")

    print(f"Total number of files found: {total_files_found}")


# Example usage:
search_configs = [
    {"input_path": "./", "search_string": "242011110824049691"},
    {"input_path": "./", "search_string": "242011110824049691"},
]
output_path = "/home/qualisense/tmp/out/1105h"
find_and_copy_files(search_configs, output_path)

#   python3  ~/tmp/findcp.py 

# test find . -type f -name "*242011110824049691*"

