'''
# Usage:   
            /ap/script/pyenv/venv0/bin/python  /ap/script/tools599/ripr/df_log.py  >> /ap/log/df_log_02.log 2>&1


Version info: 
                see below

Cron:

add a cron entry to run this hourly

    mkdir -p /ap/script/pyenv
    cd       /ap/script/pyenv
    python -m venv venv0
    # install packages in the env..
    chmod +x venv0/bin/activate;
    source venv0/bin/activate;
    # cygwin
    #source venv0/Scripts/activate;
    #::# windows..
    #.\venv0\Scripts\activate;
    pip install python-dotenv pandas pymysql psutil


  crontab -l | grep -v 'df_log.py'  | crontab - #remove
  # add
  crontab -l | { cat; echo "21 * * * 1-7 /ap/script/pyenv/venv0/bin/python /ap/script/tools599/ripr/df_log.py >> /ap/log/df_log_02.log 2>&1"; } | crontab -
  crontab -l # list


Purpose/specs:
    get disk space and mounted disk info. write to db on server so it can be on dashboard in metabase with email alerts from metabase.


------------

To just run it manually..

mkdir -p /ap/script
cd /ap/script
git clone https://github.com/dgleba/tools599.git
cd /ap/script/tools599/ripr/
pip list
pip install python-dotenv pandas pymysql psutil


'''


import os
import csv
import socket
import subprocess
import pandas as pd
import pymysql
from dotenv import load_dotenv
import psutil
from datetime import datetime

# Get the current time
current_time = datetime.now()
# Format the time
formatted_time = current_time.strftime("%Y-%m-%d %I:%M:%S %p")
print(formatted_time)

# Load environment variables from .env file
load_dotenv()

# Execute df -h command and get the output
def get_df_output():
    result = subprocess.run(['df', '-h'], stdout=subprocess.PIPE)
    output = result.stdout.decode('utf-8')
    return output

# Check if a specific mount point exists using psutil
def check_mount_point(search_term):
    for partition in psutil.disk_partitions(all=True):
        if partition.mountpoint == search_term:
            partition_usage = psutil.disk_usage(partition.mountpoint)
            return True, partition_usage.percent / 100  # Convert to fraction
    return False, None

# Get root partition usage using psutil
def get_root_partition_usage():
    partition_usage = psutil.disk_usage('/')
    return partition_usage.percent / 100  # Convert to fraction

# Write result to a CSV file
def write_to_csv(rows, filename):
    with open(filename, mode='w', newline='') as file:
        writer = csv.writer(file)
        writer.writerow(['hostname', 'body', 'usage'])
        for row in rows:
            writer.writerow(row)

# Create df_log table if it doesn't exist
def create_table_if_not_exists(conn, db_table):
    cursor = conn.cursor()
    create_table_query = f"""
    CREATE TABLE IF NOT EXISTS `{db_table}` (
        id INT AUTO_INCREMENT PRIMARY KEY,
        hostname VARCHAR(255) NOT NULL,
        body TEXT NOT NULL,
        `usage` FLOAT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );
    """
    cursor.execute(create_table_query)
    cursor.close()

# Insert CSV data into MySQL table
def insert_csv_to_mysql(rows, db_settings):
    conn = pymysql.connect(
        host=db_settings['DB_HOST'],
        port=int(db_settings['DB_PORT']),
        user=db_settings['DB_USER'],
        password=db_settings['DB_PASSWORD'],
        database=db_settings['DB_NAME']
    )
    
    # Create table if it doesn't exist
    create_table_if_not_exists(conn, db_settings['DB_TABLE'])

    cursor = conn.cursor()

    sql = f"""INSERT INTO {db_settings['DB_TABLE']} (hostname, body, `usage`)
              VALUES (%s, %s, %s)"""
    cursor.executemany(sql, rows)

    conn.commit()
    cursor.close()
    conn.close()

def main():
    # Get environment variables
    DB_HOST = os.getenv('DB_HOST')
    DB_PORT = os.getenv('DB_PORT')
    DB_USER = os.getenv('DB_USER')
    DB_PASSWORD = os.getenv('DB_PASSWORD')
    DB_NAME = os.getenv('DB_NAME')
    DB_TABLE = os.getenv('DB_TABLE')
    OUTPUTCSV = os.getenv('OUTPUTCSV')
    SEARCH_TERM_641 = os.getenv('SEARCH_TERM_641')

    # Check if VARIABLES are loaded successfully
    if not all([DB_HOST, DB_PORT, DB_USER, DB_PASSWORD, DB_NAME, DB_TABLE, OUTPUTCSV, SEARCH_TERM_641]):
        print("One or more environment variables are missing. Please check the .env file.")
        return
    
    # Get df -h output
    df_output = get_df_output()

    # Get the root partition usage
    root_usage_fraction = get_root_partition_usage()
    root_line = "/ (root partition)"
    root_usage = root_usage_fraction
    print(f"Root partition usage: {root_usage}")

    # Check if the specific mount point exists
    is_mounted, disk_usage_641 = check_mount_point(SEARCH_TERM_641)
    if is_mounted:
        result_line = f"{SEARCH_TERM_641} (mounted)"
        disk_usage_641_fraction = disk_usage_641
        print(f"Found search term: {SEARCH_TERM_641}")
        print(f"Disk usage of search term: {disk_usage_641_fraction}")
    else:
        result_line = f"{SEARCH_TERM_641} is not-mounted"
        disk_usage_641_fraction = None
        print(result_line)

    # Get the hostname
    hostname = socket.gethostname()

    # Prepare rows for CSV and MySQL insertion
    rows = [
        (hostname, root_line, root_usage),
        (hostname, result_line, disk_usage_641_fraction)
    ]

    # Write the result to a CSV file
    write_to_csv(rows, OUTPUTCSV)

    # Insert the CSV data into MySQL table
    insert_csv_to_mysql(rows, {
        'DB_HOST': DB_HOST,
        'DB_PORT': DB_PORT,
        'DB_USER': DB_USER,
        'DB_PASSWORD': DB_PASSWORD,
        'DB_NAME': DB_NAME,
        'DB_TABLE': DB_TABLE
    })

    print("Data has been inserted successfully.")

if __name__ == '__main__':
    main()
    
    
'''
Version info:

v15 2024-10-08_Tue_22.26-PM - add env to be used in cron.


'''