#!/usr/bin/env python3
"""
Disk Space Management Script

This script removes files from a designated folder when available disk space is below a defined threshold.
It prioritizes removing the oldest files of specified types and logs each operation.
"""

import os
import sys
import time
import logging
import shutil
import psutil
from datetime import datetime
from typing import List, Dict
import sqlite3
import socket
from dotenv import load_dotenv
from pathlib import Path

# Create log directory if it doesn't exist
log_dir = os.path.join(os.path.dirname(os.path.abspath(__file__)), "logs")
os.makedirs(log_dir, exist_ok=True)
log_file = os.path.join(log_dir, "diskspace_actor.log")

# Setup logging
logging.basicConfig(
    filename='./logs/diskspace_actor.log',
    level=logging.INFO,
    format='%(asctime)s\t%(levelname)s\t%(message)s\t%(hostname)s',
)

# Add hostname to log records
old_factory = logging.getLogRecordFactory()

def record_factory(*args, **kwargs):
    record = old_factory(*args, **kwargs)
    record.hostname = socket.gethostname()
    return record

logging.setLogRecordFactory(record_factory)

logger = logging.getLogger(__name__)

# PID file management
PID_FILE = os.path.join(os.path.dirname(os.path.abspath(__file__)), "diskspace_actor.pid")

def is_process_running(pid):
    """Check if a process with the given PID is running."""
    try:
        return psutil.pid_exists(pid) and psutil.Process(pid).status() != psutil.STATUS_ZOMBIE
    except (psutil.NoSuchProcess, psutil.AccessDenied):
        return False

def is_already_running():
    """Check if another instance of the script is already running."""
    if os.path.exists(PID_FILE):
        try:
            with open(PID_FILE, "r") as f:
                pid = int(f.read().strip())
            if is_process_running(pid):
                logger.warning(f"Script is already running with PID {pid}")
                return True
        except Exception as e:
            logger.error(f"Error reading PID file: {e}")
    return False

def create_pid_file():
    """Create PID file with current process ID."""
    with open(PID_FILE, "w") as f:
        f.write(str(os.getpid()))
    logger.info(f"Created PID file with PID {os.getpid()}")

def remove_pid_file():
    """Remove PID file."""
    if os.path.exists(PID_FILE):
        os.remove(PID_FILE)
        logger.info("Removed PID file")


class DiskSpaceManager:
    def __init__(self):
        """Initialize the disk space manager by loading configuration."""
        self.load_configuration()
        
    def load_configuration(self) -> None:
        """Load all required configuration values from .env file."""
        logger.info("Loading configuration from .env file")
        
        # Load .env file
        load_dotenv()
        
        try:
            # Load required values
            self.freespace_target_mb = int(os.getenv('FREESPACE_TARGET_MB'))
            self.delete_amount_mb = int(os.getenv('DELETE_AMOUNT_MB'))
            self.delete_folder = os.getenv('DELETE_FOLDER')
            
            # Load file types to delete - convert string to list
            delete_types_str = os.getenv('DELETE_TYPES')
            self.delete_types = [ext.strip().lower() for ext in delete_types_str.strip('[]').replace('"', '').split(',')]
            
            # Database configuration
            # self.db_host = os.getenv('DB_HOST')
            # self.db_port = os.getenv('DB_PORT')
            # self.db_user = os.getenv('DB_USER')
            # self.db_password = os.getenv('DB_PASSWORD')
            # self.db_name = os.getenv('DB_NAME')
            # self.db_table = os.getenv('DB_TABLE')
            
            logger.info(f"Configuration loaded successfully: target={self.freespace_target_mb}MB, "
                        f"delete_amount={self.delete_amount_mb}MB, folder={self.delete_folder}")
            
        except (TypeError, ValueError) as e:
            logger.critical(f"Configuration error: {str(e)}")
            sys.exit(1)
    
    def check_folder_exists(self) -> bool:
        """Verify the existence of delete_folder."""
        if not os.path.exists(self.delete_folder) or not os.path.isdir(self.delete_folder):
            logger.warning(f"Delete folder does not exist or is not a directory: {self.delete_folder}")
            return False
        return True
    
    def get_disk_free_space(self) -> int:
        """Calculate current free disk space in MB on the drive where delete_folder is located."""
        disk_usage = shutil.disk_usage(self.delete_folder)
        free_space_mb = disk_usage.free // (1024 * 1024)  # Convert bytes to MB
        total_space_mb = disk_usage.total // (1024 * 1024)
        used_space_mb = disk_usage.used // (1024 * 1024)
        
        logger.info(f"Disk space: total={total_space_mb}MB, used={used_space_mb}MB, free={free_space_mb}MB")
        return free_space_mb
    
    # def log_to_database(self, message: str, level: str, deleted_bytes: int = 0) -> None:
    #     """Log events to the database."""
    #     try:
    #         # For simplicity, using SQLite. In production, use appropriate DB based on configuration
    #         conn = sqlite3.connect('/tmp/diskspace_actor.db')  # Placeholder
    #         cursor = conn.cursor()
            
    #         # Create table if it doesn't exist
    #         cursor.execute('''
    #         CREATE TABLE IF NOT EXISTS disk_space_logs (
    #             id INTEGER PRIMARY KEY AUTOINCREMENT,
    #             timestamp TEXT,
    #             level TEXT,
    #             message TEXT,
    #             hostname TEXT,
    #             deleted_bytes INTEGER
    #         )
    #         ''')
            
    #         # Insert log entry
    #         cursor.execute(
    #             "INSERT INTO disk_space_logs (timestamp, level, message, hostname, deleted_bytes) VALUES (?, ?, ?, ?, ?)",
    #             (datetime.now().isoformat(), level, message, socket.gethostname(), deleted_bytes)
    #         )
            
    #         conn.commit()
    #         conn.close()
    #     except Exception as e:
    #         logger.error(f"Failed to log to database: {str(e)}")
    
    def scan_for_files(self) -> List[Dict]:
        """Recursively search delete_folder for files matching the extensions."""
        matched_files = []
        
        logger.info(f"Scanning for files with extensions: {self.delete_types}")
        
        for root, _, files in os.walk(self.delete_folder):
            for file in files:
                file_path = os.path.join(root, file)
                file_ext = os.path.splitext(file)[1].lower().lstrip('.')
                
                if file_ext in self.delete_types:
                    file_size = os.path.getsize(file_path)
                    file_mtime = os.path.getmtime(file_path)
                    
                    matched_files.append({
                        'path': file_path,
                        'size': file_size,
                        'mtime': file_mtime
                    })
        
        logger.info(f"Found {len(matched_files)} matching files")
        return matched_files
    
    def delete_files(self, files: List[Dict], free_space_mb: int) -> bool:
        """Delete files until target free space is reached or delete amount is exhausted."""
        # Sort files by modification time (oldest first)
        sorted_files = sorted(files, key=lambda x: x['mtime'])
        
        total_bytes_to_delete = (self.freespace_target_mb - free_space_mb) * 1024 * 1024
        max_bytes_to_delete = self.delete_amount_mb * 1024 * 1024
        
        if total_bytes_to_delete > max_bytes_to_delete:
            logger.warning(f"Required space ({total_bytes_to_delete//(1024*1024)}MB) exceeds "
                          f"maximum allowed deletion ({self.delete_amount_mb}MB)")
        
        bytes_deleted = 0
        files_deleted = 0
        
        for file in sorted_files:
            try:
                # Check if we've deleted enough
                if free_space_mb >= self.freespace_target_mb:
                    logger.info(f"Target free space reached after deleting {files_deleted} files "
                               f"({bytes_deleted//(1024*1024)}MB)")
                    return True
                
                # Check if we've hit the delete amount limit
                if bytes_deleted >= max_bytes_to_delete:
                    logger.warning(f"Delete amount limit reached ({self.delete_amount_mb}MB). "
                                  f"Deleted {files_deleted} files.")
                    return False
                
                # Delete the file
                file_size = file['size']
                os.remove(file['path'])
                
                bytes_deleted += file_size
                files_deleted += 1
                
                # Log the deletion
                log_message = f"Deleted file: {file['path']} ({file_size//(1024*1024)}MB)"
                logger.info(log_message)
                # self.log_to_database(log_message, "INFO", file_size)
                
                # Recalculate free space
                free_space_mb = self.get_disk_free_space()
                
            except Exception as e:
                logger.error(f"Failed to delete file {file['path']}: {str(e)}")
        
        # Check if we met the target after deleting all eligible files
        if free_space_mb >= self.freespace_target_mb:
            logger.info(f"Target free space reached after deleting all eligible files")
            return True
            
        logger.critical(f"Failed to free up enough space. Current: {free_space_mb}MB, "
                       f"Target: {self.freespace_target_mb}MB")
        return False
    
    def run(self) -> int:
        """Execute the main workflow."""
        logger.info("Starting disk space management")
        
        # Check if folder exists
        if not self.check_folder_exists():
            return 1
        
        # Check current disk space
        free_space_mb = self.get_disk_free_space()
        
        # Evaluate if action is needed
        if free_space_mb >= self.freespace_target_mb:
            logger.info(f"Sufficient free space available: {free_space_mb}MB (target: {self.freespace_target_mb}MB)")
            return 0
        
        logger.warning(f"Insufficient free space: {free_space_mb}MB (target: {self.freespace_target_mb}MB)")
        
        # Scan for files to delete
        files = self.scan_for_files()
        
        if not files:
            logger.warning("No eligible files found to delete")
            return 1
        
        # Delete files until target is reached or limit is hit
        success = self.delete_files(files, free_space_mb)
        
        # Final check
        final_free_space = self.get_disk_free_space()
        if final_free_space >= self.freespace_target_mb:
            logger.info(f"Success: Free space target met. Current: {final_free_space}MB")
            return 0
        else:
            logger.critical(f"Failed: Free space target not met. Current: {final_free_space}MB")
            return 1


# start here:
#
#   configuration is loaded from .env file in folder with this script.
#
#

if __name__ == "__main__":
    try:
        # Check if another instance is already running
        if is_already_running():
            print("Another instance of the script is already running.")
            sys.exit(2)  # Exit code 2 indicates another instance is running
        
        # Create PID file
        create_pid_file()
        
        # Run the main script logic
        logger.info("Starting disk space management")
        manager = DiskSpaceManager()
        exit_code = manager.run()
        
        logger.info("Process completed successfully")

        sys.exit(exit_code)
        
    except Exception as e:
        logger.critical(f"Unhandled exception: {str(e)}")
        sys.exit(1)
    finally:
        # Always remove PID file
        remove_pid_file()