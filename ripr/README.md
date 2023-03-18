
# ripr684

Short for report-ip-address - r.


Report current IP address and other facts to a mysql database.

This could be useful if the PC is using dns and pinging the hostname doesn't help. You can get the IP address from the database.

repo: 
https://github.com/dgleba/tools599/tree/main/ripr

git clone https://github.com/dgleba/tools599


# Install

```
pip install "SQLAlchemy<2" 
pip install  pymysql 
pip install  getmac 
pip install  psutil  
pip install  pandas 

- make mysql db `ripr684` 
- make tables using sql below
- set `username = a and password = a ` to the db [I am using it inside a local network]

Review the settings around line 30 in ripr684.py. I have the db on port 7411 using docker. Adjust things to match your setup.


```

## SQL

The schema for the database is in the file `schema.sql`


# Run it

```
python3 /ap/script/tools599/ripr/ripr684.py

python3 /home/albe/crib/script/tools599/ripr/ripr684.py

python c:\data\script\tools599\ripr\ripr684.py


```


# Web page

Visit the url: http://10.4.71.231:7412/?server=dbm&username=a&db=ripr684&select=ripr

There is an adminer page there where you can see the data.
 

# Optional: scheduler

Use a cron or windows task scheduler entry to run it periodically.

Edit the username and paths to suit your setup.

```
sudo crontab -u albe -l | grep -v 'tools599/ripr/ripr684.py'  | sudo crontab -u albe - #remove
sudo crontab -u albe -l | { cat; echo "*/15 * * * 0-6 "python3 /ap/script/tools599/ripr/ripr684.py" "; } | sudo crontab -u albe -  #add

sudo crontab -u albe -l  # list

```

or

```
sudo crontab -u albe -l | grep -v 'tools599/ripr/ripr684.py'  | sudo crontab -u albe - #remove
sudo crontab -u albe -l | { cat; echo "*/15 * * * 0-6 "python3 /home/albe/crib/script/tools599/ripr/ripr684.py" "; } | sudo crontab -u albe -  #add

sudo crontab -u albe -l  # list

```

## for windows task scheduler

import the task from  0_ripr684_ipaddress_reporter _invis.xml


# todo

1.
Use https://github.com/mevdschee/php-crud-api to add an api to the db so it can be access with http calls using curl, or many other tools.

2.
add info column and put things like running OS




