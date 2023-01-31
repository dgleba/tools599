
# ripr684

Short for report-ip-address - r.


Report current IP address and other facts to a mysql database.

This could be useful if the PC is using dns and pinging the hostname doesn't help. You can get the IP address from the database.

repo: 
https://github.com/dgleba/tools599/tree/main/ripr


# Install

```
pip install "SQLAlchemy<2" 
pip install  pymysql getmac psutil pandas 

- make mysql db `ripr684` 
- make tables using sql below
- set `username = a and password = a ` to the db [I am using it inside a local network]

Review the settings around line 30 in ripr684.py. I have the db on port 7411 using docker. Adjust things to match your setup.


```

## SQL

```sql
DROP TABLE IF EXISTS `ripr`;
CREATE TABLE `ripr` (
  `id` int NOT NULL AUTO_INCREMENT,
  `updated_at` datetime DEFAULT NULL,
  `host` varchar(99) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `ipaddr` varchar(99) DEFAULT NULL,
  `note` varchar(299) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `macaddr` varchar(99) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `iface` varchar(299) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `touch` int DEFAULT '1',
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
DELIMITER ;;
CREATE TRIGGER `00_notes_trigger_created` BEFORE INSERT ON `ripr` FOR EACH ROW
BEGIN 
      SET new.created_at := now();  
      SET new.updated_at := now(); 
      END;;
CREATE TRIGGER `00_notes_trigger_updated` BEFORE UPDATE ON `ripr` FOR EACH ROW
BEGIN 
      SET new.updated_at := now();  
      END;;
DELIMITER ;

```

```sql
DROP TABLE IF EXISTS `ripr_log`;
CREATE TABLE `ripr_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `updated_at` datetime DEFAULT NULL,
  `host` varchar(99) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `ipaddr` varchar(99) DEFAULT NULL,
  `note` varchar(299) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `macaddr` varchar(99) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `iface` varchar(299) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `touch` int DEFAULT '1',
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
DELIMITER ;;
CREATE TRIGGER `riperlog_trigger_created` BEFORE INSERT ON `ripr_log` FOR EACH ROW
BEGIN 
      SET new.created_at := now();  
      SET new.updated_at := now(); 
      END;;
CREATE TRIGGER `riperlog_trigger_updated` BEFORE UPDATE ON `ripr_log` FOR EACH ROW
BEGIN 
      SET new.updated_at := now();  
      END;;
DELIMITER ;

```


# Run it

```
python3 /ap/script/tools599/ripr/ripr684.py

python3 /home/albe/crib/script/tools599/ripr/ripr684.py

```

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


# todo

Use https://github.com/mevdschee/php-crud-api to add an api to the db so it can be access with http calls using curl, or many other tools.




