'''

# Prevent second instance of py script from running.

python3 /ap/script/tools599/py-yard/python.one.instance.py

There are errors in windows..
    python D:\n\sfile\script\python358\python358b\python.one.instance.py

'''

import os
import subprocess
import sys
import time

def is_running(script_name):
    current_pid = os.getpid()
    pids = subprocess.check_output(['pgrep', '-f', script_name]).decode('utf-8').splitlines()
    print(pids)
    for pid in pids:
        print(pid)
        if int(pid) != current_pid:
            return True
    return False

if is_running(os.path.basename(__file__)):
    print(os.path.basename(__file__))
    print("Another instance is already running.")
    sys.exit(1)

#
# Your main code here
#
print("Running the main script...")
time.sleep(99)

