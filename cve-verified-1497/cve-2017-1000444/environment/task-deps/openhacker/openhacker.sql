-- MySQL dump 10.13  Distrib 5.6.37, for Linux (x86_64)
--
-- Host: 127.0.0.1    Database: openhacker
-- ------------------------------------------------------
-- Server version	5.6.37-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `accounts`
--

DROP TABLE IF EXISTS `accounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `accounts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` varchar(255) NOT NULL DEFAULT 'user',
  `email` varchar(255) NOT NULL,
  `regip` varchar(255) NOT NULL,
  `experience` int(255) DEFAULT '0',
  `level` int(11) DEFAULT '0',
  `rank` int(11) DEFAULT '0',
  `lastip` varchar(255) DEFAULT NULL,
  `deleted` int(11) NOT NULL DEFAULT '0',
  `banned` int(11) NOT NULL DEFAULT '0',
  `regdate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `lastlogindate` datetime DEFAULT CURRENT_TIMESTAMP,
  `emailenabled` int(11) NOT NULL DEFAULT '1',
  `lastseen` datetime DEFAULT NULL,
  `reghash` varchar(32) NOT NULL,
  `active` int(11) NOT NULL DEFAULT '0',
  `hp` int(11) DEFAULT '2',
  `modnotes` longtext NOT NULL,
  `bio` longtext,
  `smallhackcd` datetime NOT NULL,
  `ethic` int(11) DEFAULT NULL,
  `clan` text,
  `prevclan` text,
  `smalljobsuccess` int(11) NOT NULL DEFAULT '0',
  `smalljobcount` int(11) NOT NULL DEFAULT '0',
  `timesjailed` int(11) DEFAULT '0',
  `fbidbpass` varchar(8) NOT NULL,
  `injail` tinyint(1) NOT NULL DEFAULT '0',
  `inprison` tinyint(1) NOT NULL DEFAULT '0',
  `onfbilist` tinyint(1) NOT NULL DEFAULT '0',
  `jailcd` datetime NOT NULL,
  `banreason` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  UNIQUE KEY `username_UNIQUE` (`username`),
  UNIQUE KEY `email_UNIQUE` (`email`),
  KEY `totalbanned_idx` (`banned`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `accounts`
--

LOCK TABLES `accounts` WRITE;
/*!40000 ALTER TABLE `accounts` DISABLE KEYS */;
INSERT INTO `accounts` VALUES (1,'Admin','$6$rounds=10000$FV0so8tUC4G36xI6$CzBX8JAhXLHpjMtMS0xXK/1F/wykmc6Rj4XJf6Br3OkjMAW6KpE1LYu8vUXVZinbO9.OzWbofVNw9K9Y2IhXM0','admin','root@localhost','0.0.0.0',0,0,0,'0.0.0.0',0,0,'2017-02-13 01:25:54','2017-09-18 14:02:53',1,'2017-09-18 15:30:19','',1,2,'','','0000-00-00 00:00:00',NULL,'0',NULL,0,0,0,'',0,0,0,'0000-00-00 00:00:00',NULL),(2,'SYSTEM','','system','system@localhost','127.0.0.1',0,0,0,'0.0.0.0',0,0,'2017-02-01 00:00:00','2017-02-01 00:00:00',1,'2999-12-31 23:59:59','',1,0,'','I can see everything...','0000-00-00 00:00:00',NULL,'1',NULL,0,0,0,'',0,0,0,'0000-00-00 00:00:00',NULL);
/*!40000 ALTER TABLE `accounts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bank_transactions`
--

DROP TABLE IF EXISTS `bank_transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `bank_transactions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userid` int(11) NOT NULL COMMENT 'User linked ID to Bank ID',
  `recvid` int(11) NOT NULL COMMENT 'Player ID who received payment',
  `timestamp` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `details` text NOT NULL COMMENT 'Summary of transaction',
  `amount` decimal(10,2) NOT NULL COMMENT 'Value credited/debited from the user''s account',
  `watchdog_approve` varchar(45) NOT NULL DEFAULT '0',
  `linked_transid` int(11) DEFAULT NULL,
  `wd_scanned` varchar(45) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bank_transactions`
--

LOCK TABLES `bank_transactions` WRITE;
/*!40000 ALTER TABLE `bank_transactions` DISABLE KEYS */;
/*!40000 ALTER TABLE `bank_transactions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `claneconomy`
--

DROP TABLE IF EXISTS `claneconomy`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `claneconomy` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `clanid` int(11) NOT NULL,
  `cash` float NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `claneconomy`
--

LOCK TABLES `claneconomy` WRITE;
/*!40000 ALTER TABLE `claneconomy` DISABLE KEYS */;
/*!40000 ALTER TABLE `claneconomy` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `clans`
--

DROP TABLE IF EXISTS `clans`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `clans` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `clanname` varchar(45) DEFAULT NULL,
  `bankbal` varchar(45) DEFAULT NULL,
  `clanowner` varchar(45) DEFAULT NULL,
  `clanbio` varchar(45) DEFAULT NULL,
  `gateway` varchar(45) DEFAULT NULL,
  `bankpassword` varchar(255) DEFAULT NULL,
  `formationdate` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clans`
--

LOCK TABLES `clans` WRITE;
/*!40000 ALTER TABLE `clans` DISABLE KEYS */;
/*!40000 ALTER TABLE `clans` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cryptocurrency_list`
--

DROP TABLE IF EXISTS `cryptocurrency_list`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cryptocurrency_list` (
  `id` int(11) NOT NULL,
  `currencyname` varchar(256) NOT NULL,
  `currencytype` varchar(256) NOT NULL,
  `ico` float NOT NULL,
  `circulatingsupply` int(11) NOT NULL,
  `maxcoins` int(11) NOT NULL,
  `value` float NOT NULL,
  `percentchange` decimal(10,0) NOT NULL,
  `currencyfounder` varchar(256) NOT NULL,
  `marketcap` float NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cryptocurrency_list`
--

LOCK TABLES `cryptocurrency_list` WRITE;
/*!40000 ALTER TABLE `cryptocurrency_list` DISABLE KEYS */;
INSERT INTO `cryptocurrency_list` VALUES (1,'Bitcoin','SHA256',0.00154722,0,21000000,0.00154722,0,'9',0);
/*!40000 ALTER TABLE `cryptocurrency_list` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `economy`
--

DROP TABLE IF EXISTS `economy`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `economy` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userid` int(11) NOT NULL COMMENT 'Link bank to user''s ID',
  `cash` float NOT NULL DEFAULT '0' COMMENT 'Total cash ',
  PRIMARY KEY (`id`),
  KEY `userid` (`userid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `economy`
--

LOCK TABLES `economy` WRITE;
/*!40000 ALTER TABLE `economy` DISABLE KEYS */;
/*!40000 ALTER TABLE `economy` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `emails`
--

DROP TABLE IF EXISTS `emails`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `emails` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `timesent` datetime DEFAULT NULL,
  `senderid` int(11) NOT NULL,
  `recieverid` int(11) NOT NULL,
  `subject` varchar(45) DEFAULT NULL,
  `body` varchar(255) NOT NULL,
  `viewed` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `emails`
--

LOCK TABLES `emails` WRITE;
/*!40000 ALTER TABLE `emails` DISABLE KEYS */;
/*!40000 ALTER TABLE `emails` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gamelogs`
--

DROP TABLE IF EXISTS `gamelogs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `gamelogs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userid` int(11) NOT NULL,
  `username` varchar(45) NOT NULL,
  `alerttime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `type` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gamelogs`
--

LOCK TABLES `gamelogs` WRITE;
/*!40000 ALTER TABLE `gamelogs` DISABLE KEYS */;
/*!40000 ALTER TABLE `gamelogs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `jail`
--

DROP TABLE IF EXISTS `jail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `jail` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userid` int(11) DEFAULT NULL,
  `bail` decimal(10,2) DEFAULT NULL,
  `jailreason` longtext,
  `jailrelease` datetime DEFAULT NULL,
  `adminjailed` int(11) DEFAULT NULL,
  `active` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `jail`
--

LOCK TABLES `jail` WRITE;
/*!40000 ALTER TABLE `jail` DISABLE KEYS */;
/*!40000 ALTER TABLE `jail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `jobs`
--

DROP TABLE IF EXISTS `jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `jobs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `job` text NOT NULL,
  `type` text NOT NULL,
  `basesuccess` float NOT NULL,
  `minpayout` float NOT NULL,
  `maxpayout` float NOT NULL,
  `experiencepayout` int(11) NOT NULL,
  `islocked` int(11) NOT NULL DEFAULT '0',
  `failmessage` text NOT NULL,
  `successmessage` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `jobs`
--

LOCK TABLES `jobs` WRITE;
/*!40000 ALTER TABLE `jobs` DISABLE KEYS */;
INSERT INTO `jobs` VALUES (1,'Steal someones password by looking over their shoulder','small',80,100,400,10,0,'You attempted to look over a user\'s shoulder but the user used a password manager to manage passwords. ',''),(2,'Install a keylogger on a computer','small',76,300,500,20,0,'You attempted to install the keylogger but the system\'s antivirus deleted it before you could start it.',''),(3,'Sniff Open Wireless Traffic','small',72,500,1000,50,0,'You attempted to sniff for open wireless networks but came up empty.',''),(4,'Crack a WEP-Secured Wireless Network','small',68,2000,5000,20,0,'You attempted to crack the password but the owner shut off the network before you were able to extract the password.',''),(5,'Decrypt a Windows 10 Password','small',65,8000,10000,20,0,'The tools you were using to crack the password erased the stored value before you could break it.',''),(6,'Take down ISIS twitter accounts','small',62,5000,10000,20,0,'You accidentally delete your own account in the process.',''),(7,'DDoS A Government Website Offline','small',60,300,500,20,0,'Your attack was mitigated by the mighty Cloudflare network! The other hacker was not impressed.',''),(8,'Break into the NSA to find proof of illegal spying','small',23,100000,100000,40,0,'You were locked out before you could find anything useful...','');
/*!40000 ALTER TABLE `jobs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `queuesystem`
--

DROP TABLE IF EXISTS `queuesystem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `queuesystem` (
  `id` int(11) NOT NULL,
  `task` longtext NOT NULL,
  `description` longtext NOT NULL,
  `runas` int(11) NOT NULL,
  `timetoexecute` datetime NOT NULL,
  `executed` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `queuesystem`
--

LOCK TABLES `queuesystem` WRITE;
/*!40000 ALTER TABLE `queuesystem` DISABLE KEYS */;
/*!40000 ALTER TABLE `queuesystem` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `servers`
--

DROP TABLE IF EXISTS `servers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `servers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `serverid` int(11) NOT NULL COMMENT 'Global server IDs',
  `color` varchar(40) NOT NULL DEFAULT '#000' COMMENT 'Faction color that appears on the Internet page',
  `owner` int(11) DEFAULT NULL COMMENT 'User ID who owns the server',
  `price` decimal(10,0) NOT NULL DEFAULT '20000' COMMENT 'Cost to own',
  `dailycost` decimal(10,0) NOT NULL DEFAULT '5000' COMMENT 'Daily costs to maintain',
  `location` longtext COMMENT 'Server location',
  `status` varchar(32) NOT NULL DEFAULT 'Offline' COMMENT 'Current status of Server',
  `software` varchar(80) NOT NULL DEFAULT 'Nothing',
  `os` varchar(60) NOT NULL DEFAULT 'Nothing',
  `firewall` varchar(256) NOT NULL DEFAULT 'Not Installed',
  `securitypack` varchar(256) NOT NULL DEFAULT 'Not Installed',
  `firewallver` varchar(12) NOT NULL DEFAULT 'N/A',
  `securitypackver` varchar(12) NOT NULL DEFAULT 'N/A',
  `ipv4` varchar(256) DEFAULT 'Unallocated',
  `ipv6` varchar(256) NOT NULL DEFAULT 'Unallocated',
  `serverpassword` longtext,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=551 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `servers`
--

LOCK TABLES `servers` WRITE;
/*!40000 ALTER TABLE `servers` DISABLE KEYS */;
INSERT INTO `servers` VALUES (1,1,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(2,2,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(3,3,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(4,4,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(5,5,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(6,6,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(7,7,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(8,8,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(9,9,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(10,10,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(11,11,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(12,12,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(13,13,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(14,14,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(15,15,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(16,16,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(17,17,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(18,18,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(19,19,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(20,20,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(21,21,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(22,22,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(23,23,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(24,24,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(25,25,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(26,26,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(27,27,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(28,28,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(29,29,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(30,30,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(31,31,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(32,32,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(33,33,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(34,34,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(35,35,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(36,36,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(37,37,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(38,38,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(39,39,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(40,40,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(41,41,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(42,42,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(43,43,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(44,44,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(45,45,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(46,46,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(47,47,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(48,48,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(49,49,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(50,50,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(51,51,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(52,52,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(53,53,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(54,54,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(55,55,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(56,56,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(57,57,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(58,58,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(59,59,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(60,60,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(61,61,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(62,62,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(63,63,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(64,64,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(65,65,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(66,66,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(67,67,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(68,68,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(69,69,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(70,70,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(71,71,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(72,72,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(73,73,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(74,74,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(75,75,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(76,76,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(77,77,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(78,78,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(79,79,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(80,80,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(81,81,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(82,82,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(83,83,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(84,84,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(85,85,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(86,86,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(87,87,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(88,88,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(89,89,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(90,90,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(91,91,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(92,92,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(93,93,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(94,94,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(95,95,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(96,96,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(97,97,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(98,98,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(99,99,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(100,100,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(101,101,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(102,102,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(103,103,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(104,104,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(105,105,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(106,106,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(107,107,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(108,108,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(109,109,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(110,110,'#000',NULL,20000,5000,'New York City','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(111,1,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(112,2,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(113,3,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(114,4,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(115,5,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(116,6,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(117,7,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(118,8,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(119,9,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(120,10,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(121,11,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(122,12,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(123,13,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(124,14,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(125,15,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(126,16,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(127,17,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(128,18,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(129,19,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(130,20,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(131,21,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(132,22,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(133,23,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(134,24,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(135,25,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(136,26,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(137,27,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(138,28,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(139,29,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(140,30,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(141,31,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(142,32,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(143,33,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(144,34,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(145,35,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(146,36,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(147,37,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(148,38,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(149,39,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(150,40,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(151,41,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(152,42,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(153,43,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(154,44,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(155,45,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(156,46,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(157,47,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(158,48,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(159,49,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(160,50,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(161,51,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(162,52,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(163,53,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(164,54,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(165,55,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(166,56,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(167,57,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(168,58,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(169,59,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(170,60,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(171,61,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(172,62,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(173,63,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(174,64,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(175,65,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(176,66,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(177,67,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(178,68,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(179,69,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(180,70,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(181,71,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(182,72,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(183,73,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(184,74,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(185,75,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(186,76,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(187,77,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(188,78,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(189,79,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(190,80,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(191,81,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(192,82,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(193,83,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(194,84,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(195,85,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(196,86,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(197,87,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(198,88,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(199,89,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(200,90,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(201,91,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(202,92,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(203,93,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(204,94,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(205,95,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(206,96,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(207,97,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(208,98,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(209,99,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(210,100,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(211,101,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(212,102,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(213,103,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(214,104,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(215,105,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(216,106,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(217,107,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(218,108,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(219,109,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(220,110,'#000',NULL,20000,5000,'Montreal','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(221,1,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(222,2,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(223,3,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(224,4,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(225,5,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(226,6,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(227,7,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(228,8,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(229,9,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(230,10,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(231,11,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(232,12,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(233,13,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(234,14,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(235,15,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(236,16,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(237,17,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(238,18,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(239,19,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(240,20,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(241,21,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(242,22,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(243,23,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(244,24,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(245,25,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(246,26,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(247,27,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(248,28,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(249,29,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(250,30,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(251,31,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(252,32,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(253,33,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(254,34,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(255,35,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(256,36,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(257,37,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(258,38,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(259,39,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(260,40,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(261,41,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(262,42,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(263,43,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(264,44,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(265,45,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(266,46,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(267,47,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(268,48,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(269,49,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(270,50,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(271,51,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(272,52,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(273,53,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(274,54,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(275,55,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(276,56,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(277,57,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(278,58,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(279,59,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(280,60,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(281,61,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(282,62,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(283,63,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(284,64,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(285,65,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(286,66,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(287,67,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(288,68,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(289,69,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(290,70,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(291,71,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(292,72,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(293,73,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(294,74,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(295,75,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(296,76,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(297,77,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(298,78,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(299,79,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(300,80,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(301,81,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(302,82,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(303,83,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(304,84,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(305,85,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(306,86,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(307,87,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(308,88,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(309,89,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(310,90,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(311,91,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(312,92,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(313,93,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(314,94,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(315,95,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(316,96,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(317,97,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(318,98,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(319,99,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(320,100,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(321,101,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(322,102,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(323,103,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(324,104,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(325,105,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(326,106,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(327,107,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(328,108,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(329,109,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(330,110,'#000',NULL,20000,5000,'Fremont','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(331,1,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(332,2,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(333,3,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(334,4,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(335,5,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(336,6,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(337,7,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(338,8,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(339,9,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(340,10,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(341,11,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(342,12,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(343,13,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(344,14,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(345,15,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(346,16,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(347,17,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(348,18,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(349,19,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(350,20,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(351,21,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(352,22,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(353,23,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(354,24,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(355,25,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(356,26,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(357,27,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(358,28,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(359,29,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(360,30,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(361,31,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(362,32,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(363,33,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(364,34,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(365,35,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(366,36,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(367,37,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(368,38,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(369,39,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(370,40,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(371,41,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(372,42,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(373,43,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(374,44,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(375,45,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(376,46,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(377,47,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(378,48,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(379,49,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(380,50,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(381,51,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(382,52,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(383,53,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(384,54,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(385,55,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(386,56,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(387,57,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(388,58,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(389,59,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(390,60,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(391,61,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(392,62,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(393,63,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(394,64,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(395,65,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(396,66,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(397,67,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(398,68,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(399,69,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(400,70,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(401,71,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(402,72,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(403,73,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(404,74,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(405,75,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(406,76,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(407,77,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(408,78,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(409,79,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(410,80,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(411,81,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(412,82,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(413,83,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(414,84,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(415,85,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(416,86,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(417,87,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(418,88,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(419,89,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(420,90,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(421,91,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(422,92,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(423,93,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(424,94,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(425,95,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(426,96,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(427,97,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(428,98,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(429,99,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(430,100,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(431,101,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(432,102,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(433,103,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(434,104,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(435,105,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(436,106,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(437,107,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(438,108,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(439,109,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(440,110,'#000',NULL,20000,5000,'Austin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(441,1,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(442,2,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(443,3,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(444,4,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(445,5,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(446,6,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(447,7,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(448,8,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(449,9,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(450,10,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(451,11,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(452,12,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(453,13,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(454,14,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(455,15,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(456,16,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(457,17,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(458,18,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(459,19,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(460,20,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(461,21,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(462,22,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(463,23,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(464,24,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(465,25,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(466,26,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(467,27,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(468,28,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(469,29,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(470,30,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(471,31,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(472,32,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(473,33,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(474,34,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(475,35,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(476,36,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(477,37,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(478,38,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(479,39,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(480,40,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(481,41,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(482,42,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(483,43,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(484,44,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(485,45,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(486,46,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(487,47,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(488,48,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(489,49,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(490,50,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(491,51,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(492,52,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(493,53,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(494,54,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(495,55,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(496,56,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(497,57,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(498,58,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(499,59,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(500,60,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(501,61,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(502,62,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(503,63,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(504,64,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(505,65,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(506,66,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(507,67,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(508,68,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(509,69,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(510,70,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(511,71,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(512,72,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(513,73,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(514,74,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(515,75,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(516,76,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(517,77,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(518,78,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(519,79,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(520,80,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(521,81,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(522,82,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(523,83,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(524,84,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(525,85,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(526,86,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(527,87,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(528,88,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(529,89,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(530,90,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(531,91,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(532,92,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(533,93,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(534,94,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(535,95,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(536,96,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(537,97,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(538,98,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(539,99,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(540,100,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(541,101,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(542,102,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(543,103,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(544,104,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(545,105,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(546,106,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(547,107,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(548,108,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(549,109,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL),(550,110,'#000',NULL,20000,5000,'Admin','Offline','Nothing','Nothing','Not Installed','Not Installed','N/A','N/A','Unallocated','Unallocated',NULL);
/*!40000 ALTER TABLE `servers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ticketcomments`
--

DROP TABLE IF EXISTS `ticketcomments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ticketcomments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userid` int(11) NOT NULL,
  `ticketid` int(11) NOT NULL,
  `posttime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `rep` int(11) NOT NULL,
  `body` longtext NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ticketcomments`
--

LOCK TABLES `ticketcomments` WRITE;
/*!40000 ALTER TABLE `ticketcomments` DISABLE KEYS */;
/*!40000 ALTER TABLE `ticketcomments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tickets`
--

DROP TABLE IF EXISTS `tickets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tickets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ticketname` varchar(45) NOT NULL,
  `ticketcreation` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `body` longtext NOT NULL,
  `assignment` int(45) DEFAULT '9' COMMENT 'Matched to accounts userid',
  `status` varchar(45) NOT NULL DEFAULT 'Open',
  `userid` int(45) NOT NULL COMMENT 'User ID from accounts',
  `type` varchar(45) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tickets`
--

LOCK TABLES `tickets` WRITE;
/*!40000 ALTER TABLE `tickets` DISABLE KEYS */;
/*!40000 ALTER TABLE `tickets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usersystems`
--

DROP TABLE IF EXISTS `usersystems`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `usersystems` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userid` int(11) NOT NULL,
  `cpu` varchar(30) NOT NULL DEFAULT '486',
  `motherboard` varchar(30) NOT NULL DEFAULT 'Simple Motherboard',
  `ram` varchar(30) NOT NULL DEFAULT '256MB',
  `os` varchar(30) NOT NULL DEFAULT 'DOS',
  `hddtype` varchar(30) NOT NULL DEFAULT '10GB',
  `hddhealth` int(30) NOT NULL DEFAULT '100',
  `size` varchar(30) NOT NULL DEFAULT '10GB',
  `spaceused` double NOT NULL DEFAULT '0',
  `spacefree` double NOT NULL DEFAULT '10',
  `logs` varchar(30) NOT NULL DEFAULT 'Not Installed',
  `serversniffer` varchar(45) NOT NULL DEFAULT 'Not Installed',
  `securitypack` varchar(30) NOT NULL DEFAULT 'Not Installed',
  `firewall` varchar(30) NOT NULL DEFAULT 'Not Installed',
  `sphealth` int(30) NOT NULL DEFAULT '0',
  `firewallhealth` int(30) NOT NULL DEFAULT '0',
  `connectedto` varchar(30) NOT NULL DEFAULT 'n00bnet',
  `connectiontype` varchar(30) NOT NULL DEFAULT 'Loopback',
  `ipaddress` varchar(30) NOT NULL DEFAULT '127.0.0.1',
  `ipv6address` varchar(45) NOT NULL DEFAULT '::1',
  `gatewayip` varchar(30) NOT NULL,
  `gatewaystatus` varchar(30) NOT NULL DEFAULT 'Offline',
  `systemstatus` varchar(30) NOT NULL DEFAULT 'online',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usersystems`
--

LOCK TABLES `usersystems` WRITE;
/*!40000 ALTER TABLE `usersystems` DISABLE KEYS */;
INSERT INTO `usersystems` VALUES (1,1,'486','Simple Motherboard','256MB','DOS','10GB',100,'10GB',0,10,'Not Installed','Not Installed','Not Installed','Not Installed',0,0,'n00bnet','Loopback','127.0.0.1','::1','','offline','online');
/*!40000 ALTER TABLE `usersystems` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2017-09-18 16:10:03
