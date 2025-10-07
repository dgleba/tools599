# Disk Space Manager

The Python script monitors disk space and periodically removes old files when available space falls below a defined threshold. The script prioritizes deleting the oldest 
files of specified types (configured in the .env file) and logs all operations to both a log file.

disk-space-actor-check-cross-platform.py: Checks if another instance is running, if so exit the code.
This also retains the Newest #N files (default to 5000 in script) and retains files from last #M hours (default to 24 hrs in script)

Setup
Install dependencies: pip install python-dotenv psutil
sudo mkdir -p /ap/script/diskactor; sudo chown -R 1000:1000 /ap;
Create a .env file with parameters like: FREESPACE_TARGET_MB, DELETE_AMOUNT_MB, DELETE_FOLDER, and DELETE_TYPES.
Run with: python disk_space_actor.py
setup a cron so it runs every hour. crontab -e to edit cron.

crontab -e
9 * * * * cd /ap/script/diskactor && /usr/bin/python3 /ap/script/diskactor/disk-space-actor.py


RETAIN_MIN_HOURS = 240000 # Don't delete files from last RETAIN_MIN_HOURS hours, Default 24 in the script if not set in .env
RETAIN_MIN_FILES = 10000 # Don't delete files Newest #RETAIN_MIN_FILES files in the folder, Default 5000 in the script if not set in .env

Run with: python disk_space_actor.py

# Warning Types

The script produces several types of warnings: 
1) configuration errors (invalid .env settings), 
2) insufficient space warnings (when free space is below target), 
3) delete limit warnings (when maximum delete amount is reached without meeting the target),and file access errors (permissions issues). 
4) Critical errors occur when the target free space cannot be achieved despite deleting files.

------------
