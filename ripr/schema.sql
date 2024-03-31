-- Adminer 4.7.8 MySQL dump

SET NAMES utf8;
SET time_zone = '+00:00';
SET foreign_key_checks = 0;
SET sql_mode = 'NO_AUTO_VALUE_ON_ZERO';

DROP VIEW IF EXISTS `0_vw_ripr`;
CREATE TABLE `0_vw_ripr` (`id` int, `updated_at` datetime, `host` varchar(99), `ipaddr` varchar(99), `note` varchar(299), `macaddr` varchar(99), `iface` varchar(299), `touch` int, `created_at` datetime, `info` varchar(9999));


DROP VIEW IF EXISTS `0_vw_riprlog`;
CREATE TABLE `0_vw_riprlog` (`id` int, `updated_at` datetime, `host` varchar(99), `ipaddr` varchar(99), `note` varchar(299), `macaddr` varchar(99), `iface` varchar(299), `touch` int, `created_at` datetime, `info` varchar(9999));


DROP VIEW IF EXISTS `0_vw_riprlog_recent`;
CREATE TABLE `0_vw_riprlog_recent` (`id` int, `updated_at` datetime, `host` varchar(99), `ipaddr` varchar(99), `note` varchar(299), `macaddr` varchar(99), `iface` varchar(299), `touch` int, `created_at` datetime, `info` varchar(9999));


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
  `info` varchar(9999) DEFAULT NULL,
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
  `info` varchar(9999) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `host` (`host`),
  KEY `updated_at` (`updated_at`),
  KEY `updated_at_host` (`updated_at`,`host`)
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

SET NAMES utf8mb4;

DROP TABLE IF EXISTS `ripr_log_sum`;
CREATE TABLE `ripr_log_sum` (
  `id` int NOT NULL DEFAULT '0',
  `host` varchar(99) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `ipaddr` varchar(99) CHARACTER SET utf8 DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `note` varchar(299) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `iface` varchar(299) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `ripr_log_sum` (`id`, `host`, `ipaddr`, `updated_at`, `note`, `iface`) VALUES
(220,	'SICS-GZPJL13',	'10.5.252.197',	'2023-01-21 18:59:09',	NULL,	'Ethernet 2'),
(2228,	'leanai-aoi1',	'10.4.71.126',	'2023-01-31 09:50:24',	NULL,	'enp0s31f6'),
(2546,	'ghq4dd',	'10.4.110.227',	'2023-02-01 17:40:01',	NULL,	'enp0s25'),
(2547,	'pmda-dock-vi641',	'10.4.168.141',	'2023-02-01 17:45:02',	NULL,	'enp0s25');

DROP VIEW IF EXISTS `vw_last_seen`;
CREATE TABLE `vw_last_seen` (`id` int, `host` varchar(99), `ipaddr` varchar(99), `updated_at` datetime, `note` varchar(299), `iface` varchar(299), `info` varchar(9999));


DROP TABLE IF EXISTS `0_vw_ripr`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `0_vw_ripr` AS select `ripr`.`id` AS `id`,`ripr`.`updated_at` AS `updated_at`,`ripr`.`host` AS `host`,`ripr`.`ipaddr` AS `ipaddr`,`ripr`.`note` AS `note`,`ripr`.`macaddr` AS `macaddr`,`ripr`.`iface` AS `iface`,`ripr`.`touch` AS `touch`,`ripr`.`created_at` AS `created_at`,`ripr`.`info` AS `info` from `ripr` order by `ripr`.`host`;

DROP TABLE IF EXISTS `0_vw_riprlog`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `0_vw_riprlog` AS select `ripr_log`.`id` AS `id`,`ripr_log`.`updated_at` AS `updated_at`,`ripr_log`.`host` AS `host`,`ripr_log`.`ipaddr` AS `ipaddr`,`ripr_log`.`note` AS `note`,`ripr_log`.`macaddr` AS `macaddr`,`ripr_log`.`iface` AS `iface`,`ripr_log`.`touch` AS `touch`,`ripr_log`.`created_at` AS `created_at`,`ripr_log`.`info` AS `info` from `ripr_log` order by `ripr_log`.`id` desc;

DROP TABLE IF EXISTS `0_vw_riprlog_recent`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `0_vw_riprlog_recent` AS select `ripr_log`.`id` AS `id`,`ripr_log`.`updated_at` AS `updated_at`,`ripr_log`.`host` AS `host`,`ripr_log`.`ipaddr` AS `ipaddr`,`ripr_log`.`note` AS `note`,`ripr_log`.`macaddr` AS `macaddr`,`ripr_log`.`iface` AS `iface`,`ripr_log`.`touch` AS `touch`,`ripr_log`.`created_at` AS `created_at`,`ripr_log`.`info` AS `info` from `ripr_log` where (`ripr_log`.`updated_at` > (now() - interval 15 minute)) order by `ripr_log`.`id` desc;

DROP TABLE IF EXISTS `vw_last_seen`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vw_last_seen` AS select `r`.`id` AS `id`,`r`.`host` AS `host`,`r`.`ipaddr` AS `ipaddr`,`r`.`updated_at` AS `updated_at`,`r`.`note` AS `note`,`r`.`iface` AS `iface`,`r`.`info` AS `info` from `ripr_log` `r` where `r`.`updated_at` in (select max(`r2`.`updated_at`) from `ripr_log` `r2` where (`r2`.`host` = `r`.`host`)) order by `r`.`id`;

-- 2023-02-15 15:12:10