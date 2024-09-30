'''

# usage:   
            python3  /ap/script/tools599/ripr/qslog01.py

add a cron entry to run this hourly

  crontab -l | grep -v 'qslog01.py'  | crontab - #remove
  crontab -l | { cat; echo "01 * * * 1-7 "python3  /ap/script/tools599/ripr/qslog01.py" "; } | crontab - # add
  crontab -l # list


specs:
    python script to search in /home/qualisense/leanai_aoi/output/logs/server.log (set as variable) for "nspection timeout". 
    write csv with hostname and body(which is the search result). 
    Search only the previous hour. 
    Write the csv to the mysql table qs_server_log. server=10.4.71.231:7411&username=a&db=ripr684. password=a

    log format:
    ERROR    2024-09-26 08:59:11,480 : PLC: Setting fail on inspection flags.  [root - standard_plc.py:237]
    INFO     2024-09-26 08:59:11,487 : PLC: Write - PLC: Write - Change Sys State: Vision2.FROM_Q.SYSTEM_READY set to 3: Vision2.FROM_Q.SYSTEM_READY set to 3  [root - standard_plc.py:82]

------------

pip install mysql-connector-python

------------

mkdir -p /ap/script
cd /ap/script
git clone https://github.com/dgleba/tools599.git
cd /ap/script/tools599/ripr/
pip list
pip install mysql-connector-python


'''



import csv
import datetime
import re
import mysql.connector
import os
import logging

# Configuration

searchfor = re.compile(r'ERROR.*nspection timeout')

logfile_path = "/home/qualisense/leanai_aoi/output/logs/server.log"

# number of hours to look back in the logs.
numhours = 1

hostname = os.uname().nodename

csv_filepath = "/var/tmp/qslogs_tmpcsvfile.csv"  # Updated CSV file path
db_config = {
    'host': '10.4.71.231',
    'port': 7411,
    'user': 'a',
    'password': 'a',
    'database': 'ripr684'
}

table_name = 'qs_server_log'


# Setup logging
logging.basicConfig(level=logging.DEBUG)


# ------------


# Get the current time and previous n hour time for testing (use appropriate test duration)
current_time = datetime.datetime.now()
previous_hour_time = current_time - datetime.timedelta(hours=numhours)

# Debugging current time and previous hour time
logging.debug(f"Current time: {current_time}")
logging.debug(f"Previous hour time: {previous_hour_time}")

# Function to check if a log entry's timestamp is within the previous 8 hours range
def is_within_previous_hour(log_time_str):
    try:
        log_time = datetime.datetime.strptime(log_time_str, '%Y-%m-%d %H:%M:%S,%f')
        return previous_hour_time <= log_time <= current_time
    except ValueError as ve:
        logging.debug(f"Timestamp parsing error: {ve} for {log_time_str}")
        return False

# List to store the filtered log entries
filtered_logs = []

# Read the log file and filter the entries
with open(logfile_path, 'r') as logfile:
    for line in logfile:
        if searchfor.search(line):
            parts = line.split()
            try:
                timestamp_str = f"{parts[1]} {parts[2]}"
                logging.debug(f"Processing line with timestamp: {timestamp_str} - Line: {line.strip()}")
                
                if is_within_previous_hour(timestamp_str):
                    logging.debug(f"Adding line: {line.strip()}")
                    filtered_logs.append((hostname, line.strip()))
            except IndexError as ie:
                logging.debug(f"Error parsing line (index error): {ie} - {line.strip()}")

# Write the filtered logs to a CSV file
with open(csv_filepath, 'w', newline='') as csvfile:
    writer = csv.writer(csvfile)
    writer.writerow(['hostname', 'body'])
    writer.writerows(filtered_logs)

# Insert data from CSV into MySQL table
connection = mysql.connector.connect(**db_config)
cursor = connection.cursor()

# Create table if it doesn't exist
create_table_query = f"""
    CREATE TABLE IF NOT EXISTS {table_name} (
        id INT AUTO_INCREMENT PRIMARY KEY,
        hostname VARCHAR(255),
        body TEXT,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    )
"""
cursor.execute(create_table_query)

# Insert CSV data into the table
with open(csv_filepath, 'r') as csvfile:
    reader = csv.reader(csvfile)
    next(reader)  # Skip header row
    for row in reader:
        cursor.execute(f"INSERT INTO {table_name} (hostname, body) VALUES (%s, %s)", row)

# Commit and close
connection.commit()
cursor.close()
connection.close()

print("matching Log entries have been written to the database.")

