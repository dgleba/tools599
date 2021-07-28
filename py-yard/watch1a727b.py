
# https://dev.to/stokry/monitor-files-for-changes-with-python-1npj

import time
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler

from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler, PatternMatchingEventHandler
import os
import time
from pathlib import Path


class  MyHandler(FileSystemEventHandler):
    def  on_modified(self,  event):
         print(f'event type: {event.event_type} path : {event.src_path}')
    def  on_created(self,  event):
         print(f'event type: {event.event_type} path : {event.src_path}')
    def  on_deleted(self,  event):
         print(f'event type: {event.event_type} path : {event.src_path}')

if __name__ ==  "__main__":
    event_handler = MyHandler()
    observer = Observer()
    observer.schedule(event_handler,  path='C:\\Users\\Stokry\Desktop\\test',  recursive=False)
    observer.start()

    try:
        while  True:
            time.sleep(3)
    except  KeyboardInterrupt:
        observer.stop()
        observer.join()
