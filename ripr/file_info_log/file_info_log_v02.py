import os
import pwd
import grp
import stat
import time
import socket
import logging
import pymysql
from configparser import ConfigParser
from datetime import datetime
from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()

# Load settings from ini file
config = ConfigParser()
config.read('settings.ini')

# Configure logging
log_file = config['one']['log_file']
logging.basicConfig(filename=log_file, level=logging.INFO, format='%(levelname)s\\t%(asctime)s\\t%(message)s')

# File path and database connection details from ini file and environment variables
file_path = config['one']['file_path']
db_host = config['one']['db_host']
db_port = int(config['one']['db_port'])
db_user = os.getenv('DB_USER')
db_password = os.getenv('DB_PASSWORD')
db_name = config['one']['db_name']

# Function to get file information
def get_file_info(file_path):
    file_stat = os.stat(file_path)
    owner = pwd.getpwuid(file_stat.st_uid).pw_name  
    group = grp.getgrgid(file_stat.st_gid).gr_name 
    perms = stat.filemode(file_stat.st_mode)       
    modified_time = time.strftime('%Y-%m-%d %H:%M:%S', time.localtime(file_stat.st_mtime))
    return owner, group, perms, modified_time

# Function to log information to database
def log_to_database(data):
    try:
        connection = pymysql.connect(host=db_host, port=db_port, user=db_user, password=db_password, db=db_name)
        try:
            with connection.cursor() as cursor:
                create_table_query = """
                    CREATE TABLE IF NOT EXISTS file_perms_log (
                        id INT AUTO_INCREMENT PRIMARY KEY,
                        `current_timestamp` DATETIME,
                        owner VARCHAR(50),
                        `group` VARCHAR(50),
                        perms VARCHAR(10),
                        fpath VARCHAR(255),
                        file_modified_timestamp DATETIME,
                        hostname VARCHAR(255)
                    )
                """
                cursor.execute(create_table_query)
                insert_query = """
                    INSERT INTO file_perms_log (`current_timestamp`, owner, `group`, perms, fpath, file_modified_timestamp, hostname)
                    VALUES (%s, %s, %s, %s, %s, %s, %s)
                """
                cursor.execute(insert_query, data)
            connection.commit()
        finally:
            connection.close()
    except pymysql.MySQLError as e:
        logging.error(f"Database error: {e}")

# Main function to gather and log file information
def main():
    owner, group, perms, modified_time = get_file_info(file_path)
    hostname = socket.gethostname()
    current_time = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    log_data = (current_time, owner, group, perms, file_path, modified_time, hostname)
    
    # Log to the database
    log_to_database(log_data)

    # Log to the log file in CSV format and include logging level
    log_line = '\\t'.join(log_data)
    logging.info(log_line)

# Run the main function once
if __name__ == '__main__':
    main()
