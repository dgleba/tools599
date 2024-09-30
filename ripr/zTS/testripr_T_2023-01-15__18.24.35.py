'''
status: 

pip install SQLAlchemy pymysql psutil

'''
# =================================================
import pymysql
import datetime
from sqlalchemy import create_engine
import socket
import re, uuid
# =================================================


# settings:

engine = create_engine("mysql+pymysql://" + "a" + ":" + "a" + "@" + "10.4.71.231" + ":" + "7411" + "/" + "ripr684" + "?" + "charset=utf8mb4")
conn = engine.connect()


# =================================================

# get local pc info

## getting the hostname by socket.gethostname() method
hostname = socket.gethostname()
## getting the IP address using socket.gethostbyname() method
ip_address = socket.gethostbyname(hostname)
print(f"Hostname: {hostname}")
print(f"IP Address: {ip_address}")

# after each 2 digits, join elements of getnode().
# using regex expression
print ("The MAC address in expressed in formatted and less complex way : ", end="")
macad = (':'.join(re.findall('..', '%012x' % uuid.getnode())))
print(macad)






# =================================================

stmt =f"INSERT INTO `ripr` (`host`, `ipaddr`, `macaddr` ) VALUES ('{hostname}', '{ip_address}', '{macad}' );"
conn.execute(stmt)

# =================================================
'''
notes:

from sqlalchemy import create_engine
engine = create_engine('postgresql+psycopg2://user:password@hostname/database_name')

https://www.tutorialspoint.com/python-program-to-find-the-ip-address-of-the-client
https://www.tutorialspoint.com/extracting-mac-address-using-python

# conn.execute('ALTER TABLE name2 ADD PRIMARY KEY (id) ')
# conn.execute('INSERT INTO `ripr` (`host`, `macaddr`, `ipaddr`, `note`, `touch`, `updated_at`, `created_at`) VALUES ('a', NULL, NULL, NULL, NULL, NULL, NULL);  ')
# conn = engine.connect("INSERT INTO `ripr` (`host` ) VALUES (hostname ); ")
# conn.execute("INSERT INTO `ripr` (`host` ) VALUES (hostname ); ")


from sqlalchemy import text

# Make a dictionary of values to be inserted into the statement.
values = {'host': hostname}
# Make the statement text into a text instance, with a placeholder for the value.
stmt = text('DELETE FROM [dbo].table1 where dbo.table1.[Year Policy] = :year')
stmt = text("INSERT INTO `ripr` (`host` ) VALUES (hostname ); ")
# Execute the query.
result = connection.execute(stmt, values)


#   DEPRECATION: netifaces is being installed using the legacy 'setup.py install' method, because it does not have a 'pyproject.toml' and the 'wheel' package is not installed. pip 23.1 will enforce this behaviour change. A possible replacement is to enable the '--use-pep517' option. Discussion can be found at https://github.com/pypa/pip/issues/8559
#  Running setup.py install for netifaces ... error
#  error: subprocess-exited-with-error
  
from netifaces import interfaces, ifaddresses, AF_INET
iplist = [ifaddresses(face)[AF_INET][0]["addr"] for face in interfaces() if AF_INET in ifaddresses(face)]
print(iplist)
#['10.8.0.2', '192.168.1.10', '127.0.0.1']




'''
# =================================================
