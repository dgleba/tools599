#!/usr/bin/env python3

"""

# usage:  albe@del-7410:/am/cruc4tb/koofry/apps/dev/far_mon_yard_dev2/djangosite$   prpy.py>../pr.py

# goal: print out all .py files recrusve from . with header showing file path with name, timestamp mod. sorted by path/name.

"""

import os
import datetime

def print_py_files(root="."):
    py_files = []

    # Collect all .py files
    for dirpath, _, filenames in os.walk(root):
        for fname in filenames:
            if fname.endswith(".py"):
                fpath = os.path.join(dirpath, fname)
                py_files.append((fpath, fname))

    # Sort by full path, then filename
    py_files.sort(key=lambda x: (x[0], x[1]))

    # Print each file with header
    for fpath, fname in py_files:
        try:
            stat = os.stat(fpath)
            mod_time = datetime.datetime.fromtimestamp(stat.st_mtime)
            header = (
                f"{'='*88}\n"
                f"###  file: {fpath} "
                # f"{fname} "
                f"  |  Mod: {mod_time.isoformat()}\n"
            )
            print(header)
            with open(fpath, "r", encoding="utf-8", errors="replace") as f:
                print(f.read())
                print("\n")  # spacing between files
        except Exception as e:
            print(f"Could not read {fpath}: {e}")

if __name__ == "__main__":
    print_py_files(".")
