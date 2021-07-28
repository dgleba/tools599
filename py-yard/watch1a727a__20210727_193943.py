

# https://stackoverflow.com/questions/64086350/filenotfounderror-winerror-3-the-system-cannot-find-the-path-specified-windo


from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler, PatternMatchingEventHandler
import os
import time
from pathlib import Path


folder_to_track = '/0/1'
folder_destination = '/0/2'



def on_modified(event):
    for filename in os.listdir(folder_to_track):
        print('Checking file {}....'.format(filename))
        chk_name = folder_to_track + "/" + filename
        if os.path.isfile(folder_destination + "/" + filename):
            print('The file {} exists'.format(filename))
        else:
            newfile = os.path.join(folder_destination, os.path.basename(filename))
            print (chk_name)
            print (newfile)
            Path(chk_name).rename(newfile)
            print('File {} moved'.format(filename))

if __name__ == "__main__":
    patterns = "*"
    ignore_patterns = ""
    ignore_directories = False
    case_sensitive = True
    my_event_handler = PatternMatchingEventHandler(patterns, ignore_patterns, ignore_directories, case_sensitive)

my_event_handler.on_modified = on_modified
go_recursively = True
observer = Observer()
observer.schedule(my_event_handler, folder_to_track, recursive=go_recursively)
observer.start()

try:
    while True:
        time.sleep(5)
except KeyboardInterrupt:
    observer.stop()
    observer.join()
    
    