
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#@  
#@  how to use
#@  
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@   2023-01-15[Jan-Sun]13-59PM 

-  

#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#@  
#@  
#@  
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@   2023-01-15[Jan-Sun]13-59PM 


how to install

- make mysql db using sql below
- set username = a and password = a to db
- test script using:   c:\prg\python\python C:\data\script\tools599\ripr\testripr.py




#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#@  
#@  
#@  
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@   2023-01-13[Jan-Fri]21-06PM 


ripr

sftp://10.4.71.231/ap/620dkrcollection/web618_a_yard/618phphtml/html/ripr


mysql create table as select.
MySQL Create Table as SELECT - database


windowing function.
https://stackoverflow.com/questions/1313120/retrieving-the-last-record-in-each-group-mysql?page=1&tab=scoredesc#tab-top

MySQL 8.0 now supports windowing functions, like almost all popular SQL implementations. With this standard syntax, we can write greatest-n-per-group queries:


mysql scheduler
https://www.mysqltutorial.org/mysql-triggers/working-mysql-scheduled-event/

_____________

get ip. python.
https://stackoverflow.com/a/28950776/2744870


_____________

post - requests.

https://linuxhint.com/python-requests-post-form-data/

https://stackoverflow.com/questions/12385179/how-to-send-a-multipart-form-data-with-requests-in-python


=================================================



ip route get 8.8.8.8 | sed -n '/src/{s/.*src *\([^ ]*\).*/\1/p;q}'
ip route get 127.0.0.1 | sed -n '/src/{s/.*src *\([^ ]*\).*/\1/p;q}'
ip route get 10.4.1.200 | sed -n '/src/{s/.*src *\([^ ]*\).*/\1/p;q}'

https://unix.stackexchange.com/questions/8518/how-to-get-my-own-ip-address-and-save-it-to-a-variable-in-a-shell-script
ip route | grep src | awk '{print $NF; exit}'

=================================================


#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#@  
#@  
#@  
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@   2023-01-15[Jan-Sun]13-29PM 

db: ripr684

tbl:ripr

-- Adminer 4.7.8 MySQL dump
SET NAMES utf8;
SET sql_mode = 'NO_AUTO_VALUE_ON_ZERO';
DROP TABLE IF EXISTS `ripr`;
CREATE TABLE `ripr` (
  `id` int NOT NULL AUTO_INCREMENT,
  `host` varchar(99) DEFAULT NULL,
  `macaddr` varchar(99) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `ipaddr` varchar(99) DEFAULT NULL,
  `note` varchar(299) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `touch` int DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- INSERT INTO `ripr` (`id`, `host`, `macaddr`, `ipaddr`, `note`, `touch`, `updated_at`, `created_at`) VALUES
-- (1,	'a',	NULL,	NULL,	NULL,	NULL,	'2023-01-15 13:34:17',	'2023-01-15 13:34:17');

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
-- 2023-01-15 18:35:32

=================================================
ripr_log:

-- Adminer 4.7.8 MySQL dump
SET NAMES utf8;
SET sql_mode = 'NO_AUTO_VALUE_ON_ZERO';

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

-- INSERT INTO `ripr_log` (`id`, `host`, `macaddr`, `ipaddr`, `note`, `touch`, `updated_at`, `created_at`) VALUES
-- (1,	'a',	NULL,	NULL,	NULL,	NULL,	'2020-01-15 13:34:17',	'2020-01-15 13:34:17');
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
-- 2023-01-15 18:35:32



=================================================



user a password a

=================================================


C:\data\script\tools599\ripr\testripr.py:46: 
RemovedIn20Warning: ←[31mDeprecated API features detected! 
These feature(s) are not compatible with SQLAlchemy 2.0.
 ←[32mTo prevent incompatible upgrades prior to updating applications,
 ensure requirements files are pinned to "sqlalchemy<2.0". 
 ←[36mSet environment variable SQLALCHEMY_WARN_20=1 to show all deprecation warnings.  
 Set environment variable SQLALCHEMY_SILENCE_UBER_WARNING=1 to silence this message.←[0m (Background on SQLAlchemy 2.0 at: https://sqlalche.me/e/b8d9)
  conn.execute("INSERT INTO `ripr_log` (`host` ) VALUES ('b'); ")
  

#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#@  
#@  
#@  
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@   2023-01-15[Jan-Sun]16-51PM 


https://towardsdatascience.com/sqlalchemy-python-tutorial-79a577141a91


=================================================


  

