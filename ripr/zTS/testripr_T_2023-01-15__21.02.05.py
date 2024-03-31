'''
status: 

pip install SQLAlchemy pymysql getmac psutil

'''
# =================================================
import pymysql, datetime, socket, psutil, re, uuid
from sqlalchemy import create_engine
from getmac import get_mac_address as getmaca
# =================================================


# settings:

engine = create_engine("mysql+pymysql://" + "a" + ":" + "a" + "@" + "10.4.71.231" + ":" + "7411" + "/" + "ripr684" + "?" + "charset=utf8mb4")
conn = engine.connect()


# =================================================

# get local pc info

## getting the hostname by socket.gethostname() method
hostname = socket.gethostname()
print(f"Hostname: {hostname}")

# https://stackoverflow.com/a/43478599/2744870
for interface, snics in psutil.net_if_addrs().items():
    for snic in snics:
        if snic.family == socket.AF_INET:
            print (interface, snic.address)
            # Look for ip address starting 10.4 or 10.5 - these are the stackpole range.
            x = re.search("10\.(4|5)\.", snic.address)
            if x:
              print("YES! We have a match!")
              ip_address = ( snic.address)
              viface = (interface)
            else:
              print("No match")

viface2 = f"interface=\"{viface}\""
viface3 = viface2[1:-1]
macad = getmaca(viface2)
win_mac = getmaca(interface="Ethernet 2")
win_mac = getmaca(interface="eth0")
print(viface2, viface3, macad, win_mac)


# =================================================

stmt = f"INSERT INTO `ripr` (`host`, `ipaddr`, `macaddr`, `iface` ) VALUES ('{hostname}', '{ip_address}', 'notworkingyet', '{viface}' );"
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

  
https://stackoverflow.com/a/43478599/2744870
def get_ip_addresses(family):
    for interface, snics in psutil.net_if_addrs().items():
        for snic in snics:
            if snic.family == family:
                yield (interface, snic.address)

ipv4s = list(get_ip_addresses(socket.AF_INET))
print(ipv4s)



# only 127...
addrs = socket.getaddrinfo(socket.gethostname(), None)
for addr in addrs:
  print (addr[4][0])


# cant install on windows.
from netifaces import interfaces, ifaddresses, AF_INET
iplist = [ifaddresses(face)[AF_INET][0]["addr"] for face in interfaces() if AF_INET in ifaddresses(face)]
print(iplist)
#['10.8.0.2', '192.168.1.10', '127.0.0.1']


#error
import fcntl
import struct
def get_ip_address(ifname):
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    return socket.inet_ntoa(fcntl.ioctl(
        s.fileno(),
        0x8915,  # SIOCGIFADDR
        struct.pack('256s', ifname[:15])
    )[20:24])
ip2 = get_ip_address('eth0')  # '192.168.0.110'
print(ip2)

## getting the IP address using socket.gethostbyname() method
ip_address = socket.gethostbyname(hostname)
print(f"IP Address: {ip_address}")

# after each 2 digits, join elements of getnode().
# using regex expression
print ("The MAC address in expressed in formatted and less complex way : ", end="")
macad = (':'.join(re.findall('..', '%012x' % uuid.getnode())))
print(macad)



'''
# =================================================
