
'''

python that calls bash find to look for filenames containing string in the filename and copy the files to output path without subfolders. if duplicate filename is found, then add _# to the name.

'''


import os
import shutil
import subprocess
import shlex

def find_and_copy_files(search_string, output_path):
    # Ensure output_path exists
    if not os.path.exists(output_path):
        os.makedirs(output_path)

    # Create the find command
    command = f"find . -type f -name '*{shlex.quote(search_string)}*'"

    # Run the find command
    result = subprocess.run(command, shell=True, capture_output=True, text=True)
    if result.returncode != 0:
        print("Error while running find command:", result.stderr)
        return

    files = result.stdout.splitlines()

    # Show the number of files found
    num_files_found = len(files)
    print(f"Number of files found: {num_files_found}")

    # Copy files to output_path while handling potential duplicates
    counts = {}
    for file_path in files:
        file_name = os.path.basename(file_path)
        base_name, extension = os.path.splitext(file_name)
        if file_name not in counts:
            counts[file_name] = 1
        else:
            counts[file_name] += 1
            file_name = f"{base_name}_{counts[file_name]}{extension}"

        # Copy the file to the output directory
        dest_path = os.path.join(output_path, file_name)
        shutil.copy(file_path, dest_path)
        print(f"Copied {file_path} to {dest_path}")


# Example usage:
search_string = "242011110824049691"
output_path = "/home/qualisense/tmp/out/1105f"
find_and_copy_files(search_string, output_path)

#   python3  ~/tmp/findcp.py 

# test find . -type f -name "*242011110824049691*"

