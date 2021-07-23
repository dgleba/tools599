
#  python C:\data\script\tools599\ps1-yard\32.write.inifini.py

from datetime import datetime
import time

sttime = datetime.now().strftime('%Y%m%d_%H.%M.%S')
print (sttime)

myfile = open( ( "C:\data\cmm\results\write-infini_%s_py.chr.txt" % sttime ) , 'w')
# myfile = open( ( "C:\crib\c598\write-infini2__py.chr.txt"  ) , 'w')
# myfile = open( ( "C:\data\cmm\write-infini3__py.chr.txt"  ) , 'w')
# myfile = open( ( r"C:\data\cmm\results\write-infini__py.chr.txt"  ) , 'w')

while True:
    sttime = datetime.now().strftime('%Y%m%d_%H.%M.%S.%f')[:-3]
    myfile.write("%s\n" % sttime)
    time.sleep(0.1)

sttime = datetime.now().strftime('%Y%m%d_%H:%M:%S.%f')
print (sttime)

myfile.close()
