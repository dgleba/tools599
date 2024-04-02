
'''
compare files in two folders recursively ignoring dos vs unix line endings

https://chat.openai.com/c/fbac4daf-4066-4fb7-a240-0f3af949440c

python cmp.fold.py /crib/tools599 /ap/script/tools599 10.4.64.7 22 albe 1325

python  ./_this_copying/cmp.fold.py   /crib/tools599  /ap/script/tools599    10.4.64.7 albe 1325

python ./_this_copying/cmp.fold.py . /crib/tmp/tools599 

'''



# works on local folders.

import os
import difflib
import argparse

# ANSI escape codes for text colorization
COLOR_RED = '\033[91m'
COLOR_YELLOW = '\033[93m'
COLOR_END = '\033[0m'

def compare_folders(local_dir1, local_dir2, ignore_folders=[]):
    for root, dirs, files in os.walk(local_dir1, topdown=True):
        dirs[:] = [d for d in dirs if d not in ignore_folders]
        for file in files:
            file1 = os.path.join(root, file)
            file2 = os.path.join(local_dir2, os.path.relpath(file1, local_dir1))
            if os.path.exists(file2):
                try:
                    differences = get_differences(file1, file2)
                    if differences:
                        print(f"{COLOR_RED}Differences found in file: {os.path.relpath(file1, local_dir1)}{COLOR_END}")
                        for line in differences:
                            print(line)
                except UnicodeDecodeError:
                    print(f"{COLOR_RED}UnicodeDecodeError occurred while processing file: {os.path.relpath(file1, local_dir1)}{COLOR_END}")
            else:
                print(f"{COLOR_YELLOW}File {os.path.relpath(file1, local_dir1)} exists only in the first directory{COLOR_END}")

def get_differences(file1, file2):
    with open(file1, 'r', errors='ignore', newline='') as f1, open(file2, 'r', errors='ignore', newline='') as f2:
        lines1 = normalize_line_endings(f1.readlines())
        lines2 = normalize_line_endings(f2.readlines())

        # Create diff object
        diff = difflib.ndiff(lines1, lines2)

        # Get lines with differences
        differences = [line for line in diff if line.startswith(('+', '-'))]
        return differences

def normalize_line_endings(lines):
    return [line.rstrip('\r\n') for line in lines]

def main(local_folder1, local_folder2):
    if not os.path.isdir(local_folder1):
        print(f"Directory '{local_folder1}' does not exist.")
        return
    if not os.path.isdir(local_folder2):
        print(f"Directory '{local_folder2}' does not exist.")
        return

    compare_folders(local_folder1, local_folder2, ignore_folders=[".git", "zTS"])

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Compare files in two local folders.")
    parser.add_argument("local_folder1", help="Path to the first local folder.")
    parser.add_argument("local_folder2", help="Path to the second local folder.")
    args = parser.parse_args()

    main(args.local_folder1, args.local_folder2)







#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#@  
#@  
#@  
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@   2024-03-31[Mar-Sun]22-46PM 


# result.. all files are only local.. doesn't work..
#   File util/tee.exe exists only in the local directory


'''
# python script.py /path/to/local/folder /path/to/remote/folder ssh.example.com username password
import os
import difflib
import argparse
import paramiko

# ANSI escape codes for text colorization
COLOR_RED = '\033[91m'
COLOR_YELLOW = '\033[93m'
COLOR_END = '\033[0m'

def compare_folders(local_dir, remote_dir, ssh_host, ssh_username, ssh_password, ignore_folders=[]):
    for root, dirs, files in os.walk(local_dir, topdown=True):
        dirs[:] = [d for d in dirs if d not in ignore_folders]
        for file in files:
            local_file = os.path.join(root, file)
            remote_file = os.path.join(remote_dir, os.path.relpath(local_file, local_dir))

            if os.path.exists(remote_file):
                try:
                    differences = get_differences(local_file, remote_file)
                    if differences:
                        print(f"{COLOR_RED}Differences found in file: {os.path.relpath(local_file, local_dir)}{COLOR_END}")
                        for line in differences:
                            print(line)
                except UnicodeDecodeError:
                    print(f"{COLOR_RED}UnicodeDecodeError occurred while processing file: {os.path.relpath(local_file, local_dir)}{COLOR_END}")
            else:
                print(f"{COLOR_YELLOW}File {os.path.relpath(local_file, local_dir)} exists only in the local directory{COLOR_END}")

def get_differences(local_file, remote_file):
    with open(local_file, 'r', errors='ignore', newline='') as f1, open(remote_file, 'r', errors='ignore', newline='') as f2:
        lines1 = normalize_line_endings(f1.readlines())
        lines2 = normalize_line_endings(f2.readlines())

        # Create diff object
        diff = difflib.ndiff(lines1, lines2)

        # Get lines with differences
        differences = [line for line in diff if line.startswith(('+', '-'))]
        return differences

def normalize_line_endings(lines):
    return [line.rstrip('\r\n') for line in lines]

def main(local_folder, remote_folder, ssh_host, ssh_username, ssh_password):
    if not os.path.isdir(local_folder):
        print(f"Local directory '{local_folder}' does not exist.")
        return

    compare_folders(local_folder, remote_folder, ssh_host, ssh_username, ssh_password, ignore_folders=[".git", "zTS"])

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Compare files in a local folder with a remote folder over SSH.")
    parser.add_argument("local_folder", help="Path to the local folder.")
    parser.add_argument("remote_folder", help="Path to the remote folder.")
    parser.add_argument("ssh_host", help="SSH server address.")
    parser.add_argument("ssh_username", help="SSH username.")
    parser.add_argument("ssh_password", help="SSH password.")
    args = parser.parse_args()

    main(args.local_folder, args.remote_folder, args.ssh_host, args.ssh_username, args.ssh_password)
'''





#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#@  
#@  
#@  
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@   2024-03-31[Mar-Sun]22-32PM 

#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#@  
#@  
#@  
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@   2024-03-31[Mar-Sun]22-02PM 





'''
import os
import difflib
import argparse

def compare_folders(local_dir1, local_dir2, ignore_folders=[]):
    for root, dirs, files in os.walk(local_dir1, topdown=True):
        dirs[:] = [d for d in dirs if d not in ignore_folders]
        for file in files:
            file1 = os.path.join(root, file)
            file2 = os.path.join(local_dir2, os.path.relpath(file1, local_dir1))
            if os.path.exists(file2):
                try:
                    differences = get_differences(file1, file2)
                    if differences:
                        print(f"Differences found in file: {os.path.relpath(file1, local_dir1)}")
                        for line in differences:
                            print(line)
                except UnicodeDecodeError:
                    print(f"UnicodeDecodeError occurred while processing file: {os.path.relpath(file1, local_dir1)}")
            else:
                print(f"File {os.path.relpath(file1, local_dir1)} exists only in the first directory")

def get_differences(file1, file2):
    with open(file1, 'r', errors='ignore', newline='') as f1, open(file2, 'r', errors='ignore', newline='') as f2:
        lines1 = normalize_line_endings(f1.readlines())
        lines2 = normalize_line_endings(f2.readlines())

        # Create diff object
        diff = difflib.ndiff(lines1, lines2)

        # Get lines with differences
        differences = [line for line in diff if line.startswith(('+', '-'))]
        return differences

def normalize_line_endings(lines):
    return [line.rstrip('\r\n') for line in lines]

def main(local_folder1, local_folder2):
    if not os.path.isdir(local_folder1):
        print(f"Directory '{local_folder1}' does not exist.")
        return
    if not os.path.isdir(local_folder2):
        print(f"Directory '{local_folder2}' does not exist.")
        return

    compare_folders(local_folder1, local_folder2, ignore_folders=[".git", "zTS"])

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Compare files in two local folders.")
    parser.add_argument("local_folder1", help="Path to the first local folder.")
    parser.add_argument("local_folder2", help="Path to the second local folder.")
    args = parser.parse_args()

    main(args.local_folder1, args.local_folder2)


'''



#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#@  
#@  
#@  
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@   2024-03-31[Mar-Sun]21-56PM 





'''

import os
import difflib
import argparse

def compare_folders(local_dir1, local_dir2, ignore_folders=[]):
    for root, dirs, files in os.walk(local_dir1, topdown=True):
        dirs[:] = [d for d in dirs if d not in ignore_folders]
        for file in files:
            file1 = os.path.join(root, file)
            file2 = os.path.join(local_dir2, os.path.relpath(file1, local_dir1))
            if os.path.exists(file2):
                try:
                    if are_files_different(file1, file2):
                        print(f"Differences found in file: {os.path.relpath(file1, local_dir1)}")
                except UnicodeDecodeError:
                    print(f"UnicodeDecodeError occurred while processing file: {os.path.relpath(file1, local_dir1)}")
            else:
                print(f"File {os.path.relpath(file1, local_dir1)} exists only in the first directory")

def are_files_different(file1, file2):
    with open(file1, 'r', errors='ignore', newline='') as f1, open(file2, 'r', errors='ignore', newline='') as f2:
        lines1 = normalize_line_endings(f1.readlines())
        lines2 = normalize_line_endings(f2.readlines())

        # Create diff object
        diff = difflib.ndiff(lines1, lines2)

        # Check for differences ignoring line endings
        for line in diff:
            if not line.startswith(' '):
                return True
        return False

def normalize_line_endings(lines):
    return [line.rstrip('\r\n') for line in lines]

def main(local_folder1, local_folder2):
    if not os.path.isdir(local_folder1):
        print(f"Directory '{local_folder1}' does not exist.")
        return
    if not os.path.isdir(local_folder2):
        print(f"Directory '{local_folder2}' does not exist.")
        return

    compare_folders(local_folder1, local_folder2, ignore_folders=[".git", "zTS"])

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Compare files in two local folders.")
    parser.add_argument("local_folder1", help="Path to the first local folder.")
    parser.add_argument("local_folder2", help="Path to the second local folder.")
    args = parser.parse_args()

    main(args.local_folder1, args.local_folder2)


'''


#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#@  
#@  
#@  
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@   2024-03-31[Mar-Sun]21-52PM 


'''

import os
import difflib
import argparse

def compare_folders(local_dir1, local_dir2, ignore_folders=[]):
    for root, dirs, files in os.walk(local_dir1, topdown=True):
        dirs[:] = [d for d in dirs if d not in ignore_folders]
        for file in files:
            file1 = os.path.join(root, file)
            file2 = os.path.join(local_dir2, os.path.relpath(file1, local_dir1))
            if os.path.exists(file2):
                try:
                    if are_files_different(file1, file2):
                        print(f"Differences found in file: {os.path.relpath(file1, local_dir1)}")
                except UnicodeDecodeError:
                    print(f"UnicodeDecodeError occurred while processing file: {os.path.relpath(file1, local_dir1)}")
            else:
                print(f"File {os.path.relpath(file1, local_dir1)} exists only in the first directory")

def are_files_different(file1, file2):
    with open(file1, 'r', errors='ignore', newline='') as f1, open(file2, 'r', errors='ignore', newline='') as f2:
        lines1 = f1.readlines()
        lines2 = f2.readlines()

        # Create diff object
        diff = difflib.ndiff(lines1, lines2)

        # Check for differences ignoring line endings
        for line in diff:
            if not line.startswith(' '):
                return True
        return False

def main(local_folder1, local_folder2):
    if not os.path.isdir(local_folder1):
        print(f"Directory '{local_folder1}' does not exist.")
        return
    if not os.path.isdir(local_folder2):
        print(f"Directory '{local_folder2}' does not exist.")
        return

    compare_folders(local_folder1, local_folder2, ignore_folders=[".git", "zTS"])

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Compare files in two local folders.")
    parser.add_argument("local_folder1", help="Path to the first local folder.")
    parser.add_argument("local_folder2", help="Path to the second local folder.")
    args = parser.parse_args()

    main(args.local_folder1, args.local_folder2)
'''


#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#@  
#@  
#@  
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@   2024-03-31[Mar-Sun]21-47PM 

'''

import os
import difflib
import argparse

def compare_folders(local_dir1, local_dir2, ignore_folders=[]):
    for root, dirs, files in os.walk(local_dir1, topdown=True):
        dirs[:] = [d for d in dirs if d not in ignore_folders]
        for file in files:
            file1 = os.path.join(root, file)
            file2 = os.path.join(local_dir2, os.path.relpath(file1, local_dir1))
            if os.path.exists(file2):
                if are_files_different(file1, file2):
                    print(f"Differences found in file: {os.path.relpath(file1, local_dir1)}")
            else:
                print(f"File {os.path.relpath(file1, local_dir1)} exists only in the first directory")

def are_files_different(file1, file2):
    with open(file1, 'r', newline='') as f1, open(file2, 'r', newline='') as f2:
        lines1 = f1.readlines()
        lines2 = f2.readlines()

        # Create diff object
        diff = difflib.ndiff(lines1, lines2)

        # Check for differences ignoring line endings
        for line in diff:
            if not line.startswith(' '):
                return True
        return False

def main(local_folder1, local_folder2):
    if not os.path.isdir(local_folder1):
        print(f"Directory '{local_folder1}' does not exist.")
        return
    if not os.path.isdir(local_folder2):
        print(f"Directory '{local_folder2}' does not exist.")
        return

    compare_folders(local_folder1, local_folder2, ignore_folders=[".git", "zTS"])

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Compare files in two local folders.")
    parser.add_argument("local_folder1", help="Path to the first local folder.")
    parser.add_argument("local_folder2", help="Path to the second local folder.")
    args = parser.parse_args()

    main(args.local_folder1, args.local_folder2)

'''

#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#@  
#@  
#@  
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@   2024-03-31[Mar-Sun]21-46PM 


'''

import os
import filecmp
import argparse

def compare_folders(local_dir1, local_dir2, ignore_folders=[]):
    for root, dirs, files in os.walk(local_dir1, topdown=True):
        dirs[:] = [d for d in dirs if d not in ignore_folders]
        for file in files:
            file1 = os.path.join(root, file)
            file2 = os.path.join(local_dir2, os.path.relpath(file1, local_dir1))
            if os.path.exists(file2):
                if are_files_different(file1, file2):
                    print(f"Differences found in file: {os.path.relpath(file1, local_dir1)}")
            else:
                print(f"File {os.path.relpath(file1, local_dir1)} exists only in the first directory")

def are_files_different(file1, file2):
    with open(file1, 'r', newline='') as f1, open(file2, 'r', newline='') as f2:
        lines1 = f1.readlines()
        lines2 = f2.readlines()

        # Normalize line endings
        lines1 = [line.rstrip('\r\n') for line in lines1]
        lines2 = [line.rstrip('\r\n') for line in lines2]

        return lines1 != lines2

def main(local_folder1, local_folder2):
    if not os.path.isdir(local_folder1):
        print(f"Directory '{local_folder1}' does not exist.")
        return
    if not os.path.isdir(local_folder2):
        print(f"Directory '{local_folder2}' does not exist.")
        return

    compare_folders(local_folder1, local_folder2, ignore_folders=[".git", "zTS"])

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Compare files in two local folders.")
    parser.add_argument("local_folder1", help="Path to the first local folder.")
    parser.add_argument("local_folder2", help="Path to the second local folder.")
    args = parser.parse_args()

    main(args.local_folder1, args.local_folder2)

'''


#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#@  
#@  
#@  
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@   2024-03-31[Mar-Sun]21-21PM 


'''

import os
import filecmp
import paramiko
import shutil
import argparse

def compare_folders(local_dir, remote_dir, ignore_folders=[]):
    for root, dirs, files in os.walk(local_dir, topdown=True):
        dirs[:] = [d for d in dirs if d not in ignore_folders]
        for file in files:
            local_file = os.path.join(root, file)
            remote_file = os.path.join(remote_dir, os.path.relpath(local_file, local_dir))
            if os.path.exists(remote_file):
                if are_files_different(local_file, remote_file):
                    print(f"Differences found in file: {os.path.relpath(local_file, local_dir)}")
            else:
                print(f"File {os.path.relpath(local_file, local_dir)} exists only locally")

def are_files_different(file1, file2):
    return filecmp.cmp(file1, file2) is False

def download_remote_folder(remote_dir, local_dir, ssh_client):
    sftp_client = ssh_client.open_sftp()
    try:
        sftp_client.get(remote_dir, local_dir)
    finally:
        sftp_client.close()

def main(remote_folder, local_folder, ssh_host, ssh_port, ssh_username, ssh_password):
    ssh_client = paramiko.SSHClient()
    ssh_client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    try:
        ssh_client.connect(hostname=ssh_host, port=ssh_port, username=ssh_username, password=ssh_password)
        temp_local_folder = os.path.join(os.path.dirname(os.path.abspath(__file__)), "temp_folder")
        
        # Check if the remote folder exists
        sftp_client = ssh_client.open_sftp()
        try:
            sftp_client.stat(remote_folder)
        except FileNotFoundError:
            print(f"Remote folder '{remote_folder}' not found.")
            return
        finally:
            sftp_client.close()

        download_remote_folder(remote_folder, temp_local_folder, ssh_client)
        compare_folders(temp_local_folder, local_folder, ignore_folders=[".git", "zTS"])
    except Exception as e:
        print(f"An error occurred: {e}")
    finally:
        ssh_client.close()
        shutil.rmtree(temp_local_folder, ignore_errors=True)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Compare files in local and remote folders over SSH.")
    parser.add_argument("remote_folder", help="Path to the remote folder.")
    parser.add_argument("local_folder", help="Path to the local folder.")
    parser.add_argument("ssh_host", help="SSH hostname or IP address.")
    parser.add_argument("ssh_port", type=int, help="SSH port number.")
    parser.add_argument("ssh_username", help="SSH username.")
    parser.add_argument("ssh_password", help="SSH password.")
    args = parser.parse_args()

    main( args.local_folder, args.remote_folder, args.ssh_host, args.ssh_port, args.ssh_username, args.ssh_password)



'''

#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#@  
#@  
#@  
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@   2024-03-31[Mar-Sun]20-52PM 





"""

import os
import filecmp
import paramiko
import argparse

def compare_folders(local_dir, remote_dir, ssh_client):
    local_files = os.listdir(local_dir)
    remote_files = list_remote_files(remote_dir, ssh_client)
    
    # Compare files in both directories
    for file in local_files:
        local_file_path = os.path.join(local_dir, file)
        remote_file_path = os.path.join(remote_dir, file)
        print(remote_file_path)
        
        # Skip if the file is a directory
        if os.path.isdir(local_file_path):
            print(f"Skipping directory: {local_file_path}")
            continue
        
        if file in remote_files:
            local_file_path_temp = local_file_path + "_temp"
            download_file(remote_file_path, local_file_path_temp, ssh_client)
            
            if are_files_different(local_file_path, local_file_path_temp):
                print(f"Differences found in file: {file}")
                
            os.remove(local_file_path_temp)
        else:
            print(f"File {file} exists only locally")

    # Recursively compare subdirectories
    for sub_dir in local_files:
        local_sub_dir = os.path.join(local_dir, sub_dir)
        remote_sub_dir = os.path.join(remote_dir, sub_dir)
        if os.path.isdir(local_sub_dir):
            compare_folders(local_sub_dir, remote_sub_dir, ssh_client)

def are_files_different(file1, file2):
    with open(file1, 'r', newline='') as f1, open(file2, 'r', newline='') as f2:
        for line1, line2 in zip(f1, f2):
            if line1.rstrip('\r\n') != line2.rstrip('\r\n'):
                return True
        return False



def list_remote_files(remote_dir, ssh_client):
    _, stdout, _ = ssh_client.exec_command(f"ls -p {remote_dir}")
    try:
        return [filename.strip() for filename in stdout.read().decode('utf-8').split("\n") if filename.strip() and not filename.endswith('/')]
    except UnicodeDecodeError:
        _, stdout, _ = ssh_client.exec_command(f"ls -p {remote_dir}")
        return [filename.strip() for filename in stdout.read().decode(errors='ignore').split("\n") if filename.strip() and not filename.endswith('/')]

'''
def list_remote_files(remote_dir, ssh_client):
    _, stdout, _ = ssh_client.exec_command(f"ls -p {remote_dir}")
    return [filename.strip() for filename in stdout.read().decode('utf-8').split("\n") if filename.strip() and not filename.endswith('/')]
'''

'''
def list_remote_files(remote_dir, ssh_client):
    sftp_client = ssh_client.open_sftp()
    file_list = []
    try:
        for item in sftp_client.listdir(remote_dir):
            if not sftp_client.stat(os.path.join(remote_dir, item)).st_mode & 0o170000 == 0o040000:
                file_list.append(item)
    finally:
        sftp_client.close()
    return file_list
'''

def download_file(remote_file, local_file, ssh_client):
    try:
        ftp_client = ssh_client.open_sftp()
        ftp_client.get(remote_file, local_file)
    except Exception as e:
        print(f"Failed to download file: {remote_file}")
        print(f"Error: {e}")
    finally:
        ftp_client.close()

def main(local_folder, remote_folder, ssh_host, ssh_port, ssh_username, ssh_password):
    ssh_client = paramiko.SSHClient()
    ssh_client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    try:
        ssh_client.connect(hostname=ssh_host, port=ssh_port, username=ssh_username, password=ssh_password)
        compare_folders(local_folder, remote_folder, ssh_client)
    except Exception as e:
        print(f"SSH connection failed: {e}")
    finally:
        ssh_client.close()

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Compare files in local and remote folders over SSH.")
    parser.add_argument("local_folder", help="Path to the local folder.")
    parser.add_argument("remote_folder", help="Path to the remote folder.")
    parser.add_argument("ssh_host", help="SSH hostname or IP address.")
    parser.add_argument("ssh_port", type=int, help="SSH port number.")
    parser.add_argument("ssh_username", help="SSH username.")
    parser.add_argument("ssh_password", help="SSH password.")
    args = parser.parse_args()

    main(args.local_folder, args.remote_folder, args.ssh_host, args.ssh_port, args.ssh_username, args.ssh_password)




"""



#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#@  
#@  
#@  
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@   2024-03-31[Mar-Sun]20-32PM 




"""


import os
import filecmp
import paramiko
import argparse

def compare_folders(local_dir, remote_dir, ssh_client):
    local_files = os.listdir(local_dir)
    remote_files = list_remote_files(remote_dir, ssh_client)
    
    # Compare files in both directories
    for file in local_files:
        local_file_path = os.path.join(local_dir, file)
        remote_file_path = os.path.join(remote_dir, file)
        
        # Skip if the file is a directory
        if os.path.isdir(local_file_path):
            print(f"Skipping directory: {local_file_path}")
            continue
        
        if file in remote_files:
            local_file_path_temp = local_file_path + "_temp"
            download_file(remote_file_path, local_file_path_temp, ssh_client)
            
            if are_files_different(local_file_path, local_file_path_temp):
                print(f"Differences found in file: {file}")
                
            os.remove(local_file_path_temp)
        else:
            print(f"File {file} exists only locally")

    # Recursively compare subdirectories
    for sub_dir in local_files:
        local_sub_dir = os.path.join(local_dir, sub_dir)
        remote_sub_dir = os.path.join(remote_dir, sub_dir)
        if os.path.isdir(local_sub_dir):
            compare_folders(local_sub_dir, remote_sub_dir, ssh_client)

def are_files_different(file1, file2):
    with open(file1, 'r', newline='') as f1, open(file2, 'r', newline='') as f2:
        for line1, line2 in zip(f1, f2):
            if line1.rstrip('\r\n') != line2.rstrip('\r\n'):
                return True
        return False


def list_remote_files(remote_dir, ssh_client):
    sftp_client = ssh_client.open_sftp()
    file_list = []
    try:
        for item in sftp_client.listdir_attr(remote_dir):
            if not stat.S_ISDIR(item.st_mode):
                file_list.append(item.filename)
    finally:
        sftp_client.close()
    return file_list


'''
def list_remote_files(remote_dir, ssh_client):
    _, stdout, _ = ssh_client.exec_command(f"ls -b -p {remote_dir}")
    return [f.encode('utf-8').decode('utf-8', 'ignore') for f in stdout.read().decode('utf-8', 'ignore').split() if not f.endswith('/')]
'''

'''
def list_remote_files(remote_dir, ssh_client):
    _, stdout, _ = ssh_client.exec_command(f"ls -p {remote_dir}")
    return [f.encode('utf-8').decode('utf-8', 'ignore') for f in stdout.read().decode('utf-8', 'ignore').split() if not f.endswith('/')]
'''
'''
def list_remote_files(remote_dir, ssh_client):
    _, stdout, _ = ssh_client.exec_command(f"ls -p {remote_dir}")
    return [f for f in stdout.read().decode().split() if not f.endswith('/')]
'''

def download_file(remote_file, local_file, ssh_client):
    try:
        ftp_client = ssh_client.open_sftp()
        ftp_client.get(remote_file, local_file)
    except Exception as e:
        print(f"Failed to download file: {remote_file}")
        print(f"Error: {e}")
    finally:
        ftp_client.close()

def main(local_folder, remote_folder, ssh_host, ssh_port, ssh_username, ssh_password):
    ssh_client = paramiko.SSHClient()
    ssh_client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    try:
        ssh_client.connect(hostname=ssh_host, port=ssh_port, username=ssh_username, password=ssh_password)
        compare_folders(local_folder, remote_folder, ssh_client)
    except Exception as e:
        print(f"SSH connection failed: {e}")
    finally:
        ssh_client.close()

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Compare files in local and remote folders over SSH.")
    parser.add_argument("local_folder", help="Path to the local folder.")
    parser.add_argument("remote_folder", help="Path to the remote folder.")
    parser.add_argument("ssh_host", help="SSH hostname or IP address.")
    parser.add_argument("ssh_port", type=int, help="SSH port number.")
    parser.add_argument("ssh_username", help="SSH username.")
    parser.add_argument("ssh_password", help="SSH password.")
    args = parser.parse_args()

    main(args.local_folder, args.remote_folder, args.ssh_host, args.ssh_port, args.ssh_username, args.ssh_password)
"""