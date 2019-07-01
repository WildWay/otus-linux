CREATE DATABASE Syslog;
USE Syslog;
-- MySQL dump 10.14  Distrib 5.5.60-MariaDB, for Linux (x86_64)
--
-- Host: localhost    Database: Syslog
-- ------------------------------------------------------
-- Server version	5.5.60-MariaDB

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
-- Table structure for table `SystemEvents`
--

DROP TABLE IF EXISTS `SystemEvents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SystemEvents` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `CustomerID` bigint(20) DEFAULT NULL,
  `ReceivedAt` datetime DEFAULT NULL,
  `DeviceReportedTime` datetime DEFAULT NULL,
  `Facility` smallint(6) DEFAULT NULL,
  `Priority` smallint(6) DEFAULT NULL,
  `FromHost` varchar(60) DEFAULT NULL,
  `Message` text,
  `NTSeverity` int(11) DEFAULT NULL,
  `Importance` int(11) DEFAULT NULL,
  `EventSource` varchar(60) DEFAULT NULL,
  `EventUser` varchar(60) DEFAULT NULL,
  `EventCategory` int(11) DEFAULT NULL,
  `EventID` int(11) DEFAULT NULL,
  `EventBinaryData` text,
  `MaxAvailable` int(11) DEFAULT NULL,
  `CurrUsage` int(11) DEFAULT NULL,
  `MinUsage` int(11) DEFAULT NULL,
  `MaxUsage` int(11) DEFAULT NULL,
  `InfoUnitID` int(11) DEFAULT NULL,
  `SysLogTag` varchar(60) DEFAULT NULL,
  `EventLogType` varchar(60) DEFAULT NULL,
  `GenericFileName` varchar(60) DEFAULT NULL,
  `SystemID` int(11) DEFAULT NULL,
  `processid` varchar(60) NOT NULL DEFAULT '',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SystemEvents`
--

LOCK TABLES `SystemEvents` WRITE;
/*!40000 ALTER TABLE `SystemEvents` DISABLE KEYS */;
/*!40000 ALTER TABLE `SystemEvents` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SystemEventsProperties`
--

DROP TABLE IF EXISTS `SystemEventsProperties`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SystemEventsProperties` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `SystemEventID` int(11) DEFAULT NULL,
  `ParamName` varchar(255) DEFAULT NULL,
  `ParamValue` text,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SystemEventsProperties`
--

LOCK TABLES `SystemEventsProperties` WRITE;
/*!40000 ALTER TABLE `SystemEventsProperties` DISABLE KEYS */;
/*!40000 ALTER TABLE `SystemEventsProperties` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `elk-master_charts`
--

DROP TABLE IF EXISTS `elk-master_charts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `elk-master_charts` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `DisplayName` varchar(255) NOT NULL,
  `chart_enabled` tinyint(1) NOT NULL DEFAULT '1',
  `chart_type` int(11) NOT NULL,
  `chart_width` int(11) NOT NULL,
  `chart_field` varchar(255) NOT NULL,
  `chart_defaultfilter` varchar(1024) NOT NULL,
  `maxrecords` int(11) NOT NULL,
  `showpercent` tinyint(1) NOT NULL,
  `userid` int(11) DEFAULT NULL,
  `groupid` int(11) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=latin1 COMMENT='This table contains all configured charts';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `elk-master_charts`
--

LOCK TABLES `elk-master_charts` WRITE;
/*!40000 ALTER TABLE `elk-master_charts` DISABLE KEYS */;
INSERT INTO `elk-master_charts` VALUES (1,'Top Hosts',1,3,400,'FROMHOST','',10,0,NULL,NULL),(2,'SyslogTags',1,1,400,'syslogtag','',10,0,NULL,NULL),(3,'Severity Occurences',1,2,400,'syslogseverity','',10,1,NULL,NULL),(4,'Usage by Day',1,1,400,'timereported','',10,1,NULL,NULL);
/*!40000 ALTER TABLE `elk-master_charts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `elk-master_config`
--

DROP TABLE IF EXISTS `elk-master_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `elk-master_config` (
  `propname` varchar(32) NOT NULL,
  `propvalue` varchar(255) DEFAULT NULL,
  `propvalue_text` text,
  `is_global` tinyint(1) NOT NULL,
  `userid` int(11) DEFAULT NULL,
  `groupid` int(11) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='Table to store global and user specific configurations';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `elk-master_config`
--

LOCK TABLES `elk-master_config` WRITE;
/*!40000 ALTER TABLE `elk-master_config` DISABLE KEYS */;
INSERT INTO `elk-master_config` VALUES ('database_installedversion','10',NULL,1,NULL,NULL),('ViewDefaultLanguage','en',NULL,1,NULL,NULL),('ViewDefaultTheme','default',NULL,1,NULL,NULL),('ViewUseTodayYesterday','1',NULL,1,NULL,NULL),('ViewEnableDetailPopups','1',NULL,1,NULL,NULL),('EnableContextLinks','1',NULL,1,NULL,NULL),('EnableIPAddressResolve','1',NULL,1,NULL,NULL),('MiscShowDebugMsg','0',NULL,1,NULL,NULL),('MiscShowDebugGridCounter','0',NULL,1,NULL,NULL),('MiscShowPageRenderStats','1',NULL,1,NULL,NULL),('MiscEnableGzipCompression','1',NULL,1,NULL,NULL),('SuppressDuplicatedMessages','0',NULL,1,NULL,NULL),('TreatNotFoundFiltersAsTrue','0',NULL,1,NULL,NULL),('InlineOnlineSearchIcons','1',NULL,1,NULL,NULL),('ViewMessageCharacterLimit','80',NULL,1,NULL,NULL),('ViewStringCharacterLimit','30',NULL,1,NULL,NULL),('ViewEntriesPerPage','50',NULL,1,NULL,NULL),('ViewEnableAutoReloadSeconds','5',NULL,1,NULL,NULL),('AdminChangeWaitTime','',NULL,1,NULL,NULL),('PopupMenuTimeout','3000',NULL,1,NULL,NULL),('PrependTitle','',NULL,1,NULL,NULL),('SearchCustomButtonCaption','I\'d like to feel sad',NULL,1,NULL,NULL),('SearchCustomButtonSearch','error',NULL,1,NULL,NULL),('DefaultViewsID','',NULL,1,NULL,NULL),('DefaultSourceID','1',NULL,1,NULL,NULL),('DefaultFont','Arial',NULL,1,NULL,NULL),('DefaultFontSize','100',NULL,1,NULL,NULL),('DebugUserLogin','0',NULL,1,NULL,NULL),('MiscDebugToSyslog','0',NULL,1,NULL,NULL),('MiscMaxExecutionTime','30',NULL,1,NULL,NULL),('UseProxyServerForRemoteQueries','',NULL,1,NULL,NULL),('HeaderDefaultEncoding','ISO-8859-1',NULL,1,NULL,NULL),('DisableAdminUsers','',NULL,1,NULL,NULL),('InjectHtmlHeader','',NULL,1,NULL,NULL),('InjectBodyHeader','',NULL,1,NULL,NULL),('InjectBodyFooter','',NULL,1,NULL,NULL),('PhplogconLogoUrl','',NULL,1,NULL,NULL);
/*!40000 ALTER TABLE `elk-master_config` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `elk-master_dbmappings`
--

DROP TABLE IF EXISTS `elk-master_dbmappings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `elk-master_dbmappings` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `DisplayName` varchar(64) NOT NULL,
  `Mappings` varchar(1024) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `elk-master_dbmappings`
--

LOCK TABLES `elk-master_dbmappings` WRITE;
/*!40000 ALTER TABLE `elk-master_dbmappings` DISABLE KEYS */;
/*!40000 ALTER TABLE `elk-master_dbmappings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `elk-master_fields`
--

DROP TABLE IF EXISTS `elk-master_fields`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `elk-master_fields` (
  `FieldID` varchar(64) NOT NULL,
  `FieldDefine` varchar(64) NOT NULL,
  `FieldCaption` varchar(255) NOT NULL,
  `FieldType` int(11) NOT NULL,
  `Sortable` tinyint(1) NOT NULL,
  `DefaultWidth` int(11) NOT NULL,
  `FieldAlign` varchar(32) NOT NULL,
  `SearchField` varchar(64) NOT NULL,
  `SearchOnline` tinyint(1) NOT NULL,
  `Trunscate` int(11) NOT NULL,
  PRIMARY KEY (`FieldID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='This table stores custom fields';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `elk-master_fields`
--

LOCK TABLES `elk-master_fields` WRITE;
/*!40000 ALTER TABLE `elk-master_fields` DISABLE KEYS */;
/*!40000 ALTER TABLE `elk-master_fields` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `elk-master_groupmembers`
--

DROP TABLE IF EXISTS `elk-master_groupmembers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `elk-master_groupmembers` (
  `userid` int(11) NOT NULL,
  `groupid` int(11) NOT NULL,
  `is_member` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='Helpertable to store which users are in which group';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `elk-master_groupmembers`
--

LOCK TABLES `elk-master_groupmembers` WRITE;
/*!40000 ALTER TABLE `elk-master_groupmembers` DISABLE KEYS */;
/*!40000 ALTER TABLE `elk-master_groupmembers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `elk-master_groups`
--

DROP TABLE IF EXISTS `elk-master_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `elk-master_groups` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `groupname` varchar(32) NOT NULL,
  `groupdescription` varchar(255) NOT NULL,
  `grouptype` int(11) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='Table for phplogcon groups';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `elk-master_groups`
--

LOCK TABLES `elk-master_groups` WRITE;
/*!40000 ALTER TABLE `elk-master_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `elk-master_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `elk-master_savedreports`
--

DROP TABLE IF EXISTS `elk-master_savedreports`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `elk-master_savedreports` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `reportid` varchar(255) NOT NULL,
  `sourceid` int(11) NOT NULL,
  `customTitle` varchar(255) NOT NULL,
  `customComment` text NOT NULL,
  `filterString` text NOT NULL,
  `customFilters` text NOT NULL,
  `outputFormat` varchar(64) NOT NULL,
  `outputTarget` varchar(64) NOT NULL,
  `outputTargetDetails` text NOT NULL,
  `scheduleSettings` text NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='Table to store saved reports';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `elk-master_savedreports`
--

LOCK TABLES `elk-master_savedreports` WRITE;
/*!40000 ALTER TABLE `elk-master_savedreports` DISABLE KEYS */;
/*!40000 ALTER TABLE `elk-master_savedreports` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `elk-master_searches`
--

DROP TABLE IF EXISTS `elk-master_searches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `elk-master_searches` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `DisplayName` varchar(255) NOT NULL,
  `SearchQuery` varchar(1024) NOT NULL,
  `userid` int(11) DEFAULT NULL,
  `groupid` int(11) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM AUTO_INCREMENT=8 DEFAULT CHARSET=latin1 COMMENT='Stores custom user searches';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `elk-master_searches`
--

LOCK TABLES `elk-master_searches` WRITE;
/*!40000 ALTER TABLE `elk-master_searches` DISABLE KEYS */;
INSERT INTO `elk-master_searches` VALUES (1,'Syslog Warnings and Errors','filter=severity%3A0%2C1%2C2%2C3%2C4&search=Search',NULL,NULL),(2,'Syslog Errors','filter=severity%3A0%2C1%2C2%2C3&search=Search',NULL,NULL),(3,'All messages from the last hour','filter=datelastx%3A1&search=Search',NULL,NULL),(4,'All messages from last 12 hours','filter=datelastx%3A2&search=Search',NULL,NULL),(5,'All messages from last 24 hours','filter=datelastx%3A3&search=Search',NULL,NULL),(6,'All messages from last 7 days','filter=datelastx%3A4&search=Search',NULL,NULL),(7,'All messages from last 31 days','filter=datelastx%3A5&search=Search',NULL,NULL);
/*!40000 ALTER TABLE `elk-master_searches` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `elk-master_sources`
--

DROP TABLE IF EXISTS `elk-master_sources`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `elk-master_sources` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(255) NOT NULL,
  `Description` text NOT NULL,
  `SourceType` tinyint(4) NOT NULL,
  `MsgParserList` varchar(255) NOT NULL,
  `MsgNormalize` tinyint(1) NOT NULL DEFAULT '0',
  `MsgSkipUnparseable` tinyint(1) NOT NULL DEFAULT '0',
  `ViewID` varchar(64) NOT NULL,
  `LogLineType` varchar(64) DEFAULT NULL,
  `DiskFile` varchar(255) DEFAULT NULL,
  `DBTableType` varchar(64) DEFAULT NULL,
  `DBType` tinyint(4) DEFAULT NULL,
  `DBServer` varchar(255) DEFAULT NULL,
  `DBName` varchar(64) DEFAULT NULL,
  `DBUser` varchar(64) DEFAULT NULL,
  `DBPassword` varchar(255) DEFAULT NULL,
  `DBTableName` varchar(64) DEFAULT NULL,
  `DBEnableRowCounting` tinyint(1) DEFAULT NULL,
  `DBRecordsPerQuery` int(11) NOT NULL DEFAULT '100',
  `defaultfilter` varchar(1024) NOT NULL,
  `userid` int(11) DEFAULT NULL,
  `groupid` int(11) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=latin1 COMMENT='Table to store datasources in phplogcon';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `elk-master_sources`
--

LOCK TABLES `elk-master_sources` WRITE;
/*!40000 ALTER TABLE `elk-master_sources` DISABLE KEYS */;
INSERT INTO `elk-master_sources` VALUES (1,'My Syslog Source','',2,'',0,0,'SYSLOG',NULL,NULL,'monitorware',0,'localhost','Syslog','rsyslog','Password','SystemEvents',1,100,'',NULL,NULL);
/*!40000 ALTER TABLE `elk-master_sources` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `elk-master_users`
--

DROP TABLE IF EXISTS `elk-master_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `elk-master_users` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(32) NOT NULL,
  `password` varchar(32) NOT NULL,
  `is_admin` tinyint(1) NOT NULL DEFAULT '0',
  `is_readonly` tinyint(1) NOT NULL DEFAULT '0',
  `last_login` int(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=latin1 COMMENT='Table for the phplogcon users';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `elk-master_users`
--

LOCK TABLES `elk-master_users` WRITE;
/*!40000 ALTER TABLE `elk-master_users` DISABLE KEYS */;
INSERT INTO `elk-master_users` VALUES (1,'admin','dc647eb65e6711e155375218212b3964',1,0,0);
/*!40000 ALTER TABLE `elk-master_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `elk-master_views`
--

DROP TABLE IF EXISTS `elk-master_views`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `elk-master_views` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `DisplayName` varchar(255) NOT NULL,
  `Columns` text NOT NULL,
  `userid` int(11) DEFAULT NULL,
  `groupid` int(11) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='Stores custom defined user views.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `elk-master_views`
--

LOCK TABLES `elk-master_views` WRITE;
/*!40000 ALTER TABLE `elk-master_views` DISABLE KEYS */;
/*!40000 ALTER TABLE `elk-master_views` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-06-21 11:35:21
GRANT ALL ON Syslog.* TO 'rsyslog'@'localhost' IDENTIFIED BY 'Password';
