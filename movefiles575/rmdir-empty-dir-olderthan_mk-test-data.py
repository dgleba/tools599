
'''
c:
cd \0
c:\prg\python\python rmdir-empty-dir-olderthan_mk-test-data.py


'''

import os
import time

def create_test_folders():
    # Create a base directory
    base_dir = "test_folders"
    os.makedirs(base_dir, exist_ok=True)

    # Get current time
    current_time = time.time()

    # Create 20 test folders with modification timestamps 7 days apart
    for i in range(1, 21):
        folder_name = f"test_folder_{i}"
        folder_path = os.path.join(base_dir, folder_name)
        os.makedirs(folder_path, exist_ok=True)


        # Create files in some folders
        if i % 5 == 0:
            for j in range(5):
                file_name = f"file_{j}.txt"
                file_path = os.path.join(folder_path, file_name)
                with open(file_path, "w") as file:
                    file.write("This is a test file.")

        # Set folder modification time
        folder_mtime = current_time - (i * 7 * 24 * 60 * 60)
        os.utime(folder_path, (folder_mtime, folder_mtime))

print("Test folders created successfully.")

if __name__ == "__main__":
    create_test_folders()
