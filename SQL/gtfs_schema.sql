-- phpMyAdmin SQL Dump
-- version 4.0.9
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Author: Mark Zammit	
-- Generation Time: May 06, 2014 at 05:48 AM
-- Server version: 5.5.34
-- PHP Version: 5.4.22

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `gtfs`
--
CREATE DATABASE IF NOT EXISTS `gtfs` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `gtfs`;

-- --------------------------------------------------------

--
-- Table structure for table `agency`
--
-- Creation: May 05, 2014 at 11:42 PM
--

DROP TABLE IF EXISTS `agency`;
CREATE TABLE IF NOT EXISTS `agency` (
  `agency_id` varchar(20) NOT NULL,
  `agency_name` varchar(45) NOT NULL,
  `agency_url` varchar(255) NOT NULL,
  `agency_timezone` varchar(45) NOT NULL,
  `agency_lang` varchar(45) NOT NULL,
  `agency_phone` char(12) NOT NULL,
  PRIMARY KEY (`agency_id`),
  KEY `agency_lang` (`agency_lang`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- RELATIONS FOR TABLE `agency`:
--   `agency_lang`
--       `ref_iso_639_1` -> `lang_id`
--

-- --------------------------------------------------------

--
-- Table structure for table `calendar`
--
-- Creation: May 05, 2014 at 11:42 PM
--

DROP TABLE IF EXISTS `calendar`;
CREATE TABLE IF NOT EXISTS `calendar` (
  `service_id` varchar(20) NOT NULL,
  `monday` bit(1) NOT NULL,
  `tuesday` bit(1) NOT NULL,
  `wednesday` bit(1) NOT NULL,
  `thursday` bit(1) NOT NULL,
  `friday` bit(1) NOT NULL,
  `saturday` bit(1) NOT NULL,
  `sunday` bit(1) NOT NULL,
  `start_date` char(8) NOT NULL COMMENT 'YYYYMMDD format',
  `end_date` char(8) NOT NULL COMMENT 'YYYYMMDD format',
  PRIMARY KEY (`service_id`),
  KEY `service_id` (`service_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `calendar_dates`
--
-- Creation: May 05, 2014 at 11:42 PM
--

DROP TABLE IF EXISTS `calendar_dates`;
CREATE TABLE IF NOT EXISTS `calendar_dates` (
  `service_id` varchar(20) NOT NULL,
  `date` char(8) NOT NULL COMMENT 'YYYYMMDD format',
  `exception_type` tinyint(4) NOT NULL COMMENT 'https://developers.google.com/transit/gtfs/reference?csw=1#calendar_dates_fields',
  PRIMARY KEY (`service_id`),
  KEY `service_id` (`service_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `fare_attributes`
--
-- Creation: May 05, 2014 at 11:42 PM
--

DROP TABLE IF EXISTS `fare_attributes`;
CREATE TABLE IF NOT EXISTS `fare_attributes` (
  `fare_id` varchar(20) NOT NULL,
  `price` double NOT NULL,
  `currency_type` char(3) NOT NULL,
  `payment_method` tinyint(1) NOT NULL COMMENT 'https://developers.google.com/transit/gtfs/reference?csw=1#fare_attributes_fields',
  `transfers` tinyint(1) NOT NULL COMMENT 'https://developers.google.com/transit/gtfs/reference?csw=1#fare_attributes_fields',
  `transfer_duration` int(11) DEFAULT NULL,
  PRIMARY KEY (`fare_id`),
  KEY `currency_type` (`currency_type`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- RELATIONS FOR TABLE `fare_attributes`:
--   `currency_type`
--       `ref_iso_4217` -> `currency_id`
--

-- --------------------------------------------------------

--
-- Table structure for table `fare_rules`
--
-- Creation: May 05, 2014 at 11:42 PM
--

DROP TABLE IF EXISTS `fare_rules`;
CREATE TABLE IF NOT EXISTS `fare_rules` (
  `fare_id` varchar(20) NOT NULL,
  `route_id` varchar(20) DEFAULT NULL,
  `origin_id` varchar(20) DEFAULT NULL,
  `destination_id` varchar(20) DEFAULT NULL,
  `contains_id` varchar(20) DEFAULT NULL,
  KEY `fare_id` (`fare_id`,`route_id`,`origin_id`,`destination_id`,`contains_id`),
  KEY `route_id` (`route_id`),
  KEY `origin_id` (`origin_id`),
  KEY `destination_id` (`destination_id`),
  KEY `contains_id` (`contains_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- RELATIONS FOR TABLE `fare_rules`:
--   `contains_id`
--       `stops` -> `stop_id`
--   `fare_id`
--       `fare_attributes` -> `fare_id`
--   `route_id`
--       `routes` -> `route_id`
--   `origin_id`
--       `stops` -> `stop_id`
--   `destination_id`
--       `stops` -> `stop_id`
--

-- --------------------------------------------------------

--
-- Table structure for table `feed_info`
--
-- Creation: May 06, 2014 at 12:43 AM
--

DROP TABLE IF EXISTS `feed_info`;
CREATE TABLE IF NOT EXISTS `feed_info` (
  `feed_publisher_name` varchar(20) NOT NULL,
  `feed_publisher_url` varchar(255) NOT NULL,
  `feed_lang` varchar(45) NOT NULL COMMENT 'IETF BCP 47 language code, see https://developers.google.com/transit/gtfs/reference?csw=1#feed_info_fields',
  `feed_start_date` char(8) NOT NULL COMMENT 'YYYYMMDD format',
  `feed_end_date` char(8) DEFAULT NULL COMMENT 'YYYYMMDD format',
  `feed_version` varchar(25) DEFAULT NULL,
  KEY `feed_publisher_name` (`feed_publisher_name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `frequencies`
--
-- Creation: May 06, 2014 at 12:38 AM
--

DROP TABLE IF EXISTS `frequencies`;
CREATE TABLE IF NOT EXISTS `frequencies` (
  `trip_id` varchar(20) NOT NULL,
  `start_time` char(8) NOT NULL COMMENT 'HH:MM:SS format, see https://developers.google.com/transit/gtfs/reference?csw=1#frequencies_fields',
  `end_time` char(8) NOT NULL COMMENT 'HH:MM:SS format, see https://developers.google.com/transit/gtfs/reference?csw=1#frequencies_fields',
  `headway_secs` int(11) NOT NULL DEFAULT '0',
  `exact_times` tinyint(1) DEFAULT '0' COMMENT 'https://developers.google.com/transit/gtfs/reference?csw=1#frequencies_fields',
  KEY `trip_id` (`trip_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- RELATIONS FOR TABLE `frequencies`:
--   `trip_id`
--       `trips` -> `trip_id`
--

-- --------------------------------------------------------

--
-- Table structure for table `ref_iso_639_1`
--
-- Creation: May 06, 2014 at 03:07 AM
--

DROP TABLE IF EXISTS `ref_iso_639_1`;
CREATE TABLE IF NOT EXISTS `ref_iso_639_1` (
  `lang_id` char(2) NOT NULL,
  PRIMARY KEY (`lang_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `ref_iso_639_3`
--
-- Creation: May 06, 2014 at 03:07 AM
--

DROP TABLE IF EXISTS `ref_iso_639_3`;
CREATE TABLE IF NOT EXISTS `ref_iso_639_3` (
  `lang_id` char(3) NOT NULL,
  PRIMARY KEY (`lang_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `ref_iso_4217`
--
-- Creation: May 06, 2014 at 01:11 AM
--

DROP TABLE IF EXISTS `ref_iso_4217`;
CREATE TABLE IF NOT EXISTS `ref_iso_4217` (
  `currency_id` char(3) NOT NULL,
  PRIMARY KEY (`currency_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `ref_timezones`
--
-- Creation: May 06, 2014 at 01:50 AM
--

DROP TABLE IF EXISTS `ref_timezones`;
CREATE TABLE IF NOT EXISTS `ref_timezones` (
  `timezone` varchar(45) NOT NULL,
  `country_code` varchar(2) DEFAULT NULL,
  `utc_offset` char(6) NOT NULL,
  `utc_dst_offset` char(6) DEFAULT NULL,
  UNIQUE KEY `timezone` (`timezone`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `routes`
--
-- Creation: May 05, 2014 at 11:42 PM
--

DROP TABLE IF EXISTS `routes`;
CREATE TABLE IF NOT EXISTS `routes` (
  `route_id` varchar(20) NOT NULL,
  `agency_id` varchar(20) NOT NULL,
  `route_short_name` varchar(20) NOT NULL,
  `route_long_name` varchar(50) NOT NULL,
  `route_desc` varchar(255) DEFAULT NULL,
  `route_type` tinyint(1) NOT NULL COMMENT 'https://developers.google.com/transit/gtfs/reference?csw=1#routes_fields',
  `route_url` varchar(255) DEFAULT NULL,
  `route_color` char(6) DEFAULT 'FFFFFF' COMMENT 'https://developers.google.com/transit/gtfs/reference?csw=1#routes_fields',
  `route_text_color` char(6) DEFAULT 'FFFFFF' COMMENT 'https://developers.google.com/transit/gtfs/reference?csw=1#routes_fields',
  PRIMARY KEY (`route_id`),
  KEY `agency_id` (`agency_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- RELATIONS FOR TABLE `routes`:
--   `agency_id`
--       `agency` -> `agency_id`
--

-- --------------------------------------------------------

--
-- Table structure for table `shapes`
--
-- Creation: May 05, 2014 at 11:42 PM
--

DROP TABLE IF EXISTS `shapes`;
CREATE TABLE IF NOT EXISTS `shapes` (
  `shape_id` varchar(20) NOT NULL,
  `shape_pt_lat` decimal(16,3) NOT NULL COMMENT 'WGS 84 latitude',
  `shape_pt_lon` decimal(16,3) NOT NULL COMMENT 'WGS 84 longitude',
  `shape_pt_sequence` int(10) unsigned NOT NULL,
  `shape_dist_traveled` double DEFAULT NULL,
  PRIMARY KEY (`shape_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `stops`
--
-- Creation: May 05, 2014 at 11:42 PM
--

DROP TABLE IF EXISTS `stops`;
CREATE TABLE IF NOT EXISTS `stops` (
  `stop_id` varchar(20) NOT NULL,
  `stop_code` varchar(20) DEFAULT NULL,
  `stop_name` varchar(45) NOT NULL,
  `stop_desc` varchar(255) DEFAULT NULL,
  `stop_lat` decimal(16,3) NOT NULL,
  `stop_lon` decimal(16,3) NOT NULL,
  `zone_id` varchar(20) DEFAULT NULL,
  `stop_url` varchar(255) DEFAULT NULL,
  `location_type` tinyint(1) DEFAULT '0' COMMENT 'https://developers.google.com/transit/gtfs/reference?csw=1#stops_fields',
  `parent_station` varchar(20) DEFAULT NULL COMMENT 'https://developers.google.com/transit/gtfs/reference?csw=1#stops_fields',
  `stop_timezone` varchar(45) DEFAULT NULL,
  `wheelchair_boarding` tinyint(1) DEFAULT '0' COMMENT 'https://developers.google.com/transit/gtfs/reference?csw=1#stops_fields',
  UNIQUE KEY `stop_id` (`stop_id`),
  KEY `stop_timezone` (`stop_timezone`),
  KEY `stop_timezone_2` (`stop_timezone`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- RELATIONS FOR TABLE `stops`:
--   `stop_timezone`
--       `ref_timezones` -> `timezone`
--

-- --------------------------------------------------------

--
-- Table structure for table `stop_times`
--
-- Creation: May 05, 2014 at 11:42 PM
--

DROP TABLE IF EXISTS `stop_times`;
CREATE TABLE IF NOT EXISTS `stop_times` (
  `trip_id` varchar(20) NOT NULL,
  `arrival_time` char(8) NOT NULL COMMENT 'HH:MM:SS format, see https://developers.google.com/transit/gtfs/reference?csw=1#stop_times_fields',
  `departure_time` char(8) NOT NULL COMMENT 'HH:MM:SS format, see https://developers.google.com/transit/gtfs/reference?csw=1#stop_times_fields',
  `stop_id` varchar(20) NOT NULL,
  `stop_sequence` smallint(6) NOT NULL,
  `stop_headsign` varchar(255) DEFAULT NULL,
  `pickup_type` tinyint(1) DEFAULT '0' COMMENT 'https://developers.google.com/transit/gtfs/reference?csw=1#stop_times_fields',
  `drop_off_type` tinyint(1) DEFAULT '0' COMMENT 'https://developers.google.com/transit/gtfs/reference?csw=1#stop_times_fields',
  `shape_dist_travelled` decimal(6,6) DEFAULT NULL,
  KEY `trip_id` (`trip_id`,`stop_id`),
  KEY `stop_id` (`stop_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- RELATIONS FOR TABLE `stop_times`:
--   `stop_id`
--       `stops` -> `stop_id`
--   `trip_id`
--       `trips` -> `trip_id`
--

-- --------------------------------------------------------

--
-- Table structure for table `transfers`
--
-- Creation: May 06, 2014 at 12:40 AM
--

DROP TABLE IF EXISTS `transfers`;
CREATE TABLE IF NOT EXISTS `transfers` (
  `from_stop_id` varchar(20) NOT NULL,
  `to_stop_id` varchar(20) NOT NULL,
  `transfer_type` tinyint(1) NOT NULL COMMENT 'https://developers.google.com/transit/gtfs/reference?csw=1#transfers_fields',
  `min_transfer_time` int(10) unsigned DEFAULT '0',
  KEY `from_stop_id` (`from_stop_id`,`to_stop_id`),
  KEY `to_stop_id` (`to_stop_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- RELATIONS FOR TABLE `transfers`:
--   `to_stop_id`
--       `stops` -> `stop_id`
--   `from_stop_id`
--       `stops` -> `stop_id`
--

-- --------------------------------------------------------

--
-- Table structure for table `trips`
--
-- Creation: May 05, 2014 at 11:42 PM
--

DROP TABLE IF EXISTS `trips`;
CREATE TABLE IF NOT EXISTS `trips` (
  `route_id` varchar(20) NOT NULL,
  `service_id` varchar(20) NOT NULL,
  `trip_id` varchar(20) NOT NULL,
  `trip_headsign` varchar(255) DEFAULT NULL,
  `trip_short_name` varchar(20) DEFAULT NULL,
  `direction_id` tinyint(1) DEFAULT NULL COMMENT 'https://developers.google.com/transit/gtfs/reference?csw=1#trips_fields',
  `block_id` varchar(20) DEFAULT NULL,
  `shape_id` varchar(20) DEFAULT NULL,
  `wheelchair_accessible` tinyint(1) DEFAULT '0' COMMENT 'https://developers.google.com/transit/gtfs/reference?csw=1#trips_fields',
  `bikes_allowed` tinyint(1) DEFAULT '0' COMMENT 'https://developers.google.com/transit/gtfs/reference?csw=1#trips_fields',
  PRIMARY KEY (`trip_id`),
  UNIQUE KEY `trip_short_name` (`trip_short_name`),
  KEY `route_id` (`route_id`,`service_id`),
  KEY `service_id` (`service_id`),
  KEY `shape_id` (`shape_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- RELATIONS FOR TABLE `trips`:
--   `service_id`
--       `calendar` -> `service_id`
--   `route_id`
--       `routes` -> `route_id`
--   `shape_id`
--       `shapes` -> `shape_id`
--

--
-- Constraints for dumped tables
--

--
-- Constraints for table `agency`
--
ALTER TABLE `agency`
  ADD CONSTRAINT `agency_ibfk_1` FOREIGN KEY (`agency_lang`) REFERENCES `ref_iso_639_1` (`lang_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `fare_attributes`
--
ALTER TABLE `fare_attributes`
  ADD CONSTRAINT `fare_attributes_ibfk_1` FOREIGN KEY (`currency_type`) REFERENCES `ref_iso_4217` (`currency_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `fare_rules`
--
ALTER TABLE `fare_rules`
  ADD CONSTRAINT `fare_rules_ibfk_5` FOREIGN KEY (`contains_id`) REFERENCES `stops` (`stop_id`) ON DELETE SET NULL ON UPDATE SET NULL,
  ADD CONSTRAINT `fare_rules_ibfk_1` FOREIGN KEY (`fare_id`) REFERENCES `fare_attributes` (`fare_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fare_rules_ibfk_2` FOREIGN KEY (`route_id`) REFERENCES `routes` (`route_id`) ON DELETE SET NULL ON UPDATE SET NULL,
  ADD CONSTRAINT `fare_rules_ibfk_3` FOREIGN KEY (`origin_id`) REFERENCES `stops` (`stop_id`) ON DELETE SET NULL ON UPDATE SET NULL,
  ADD CONSTRAINT `fare_rules_ibfk_4` FOREIGN KEY (`destination_id`) REFERENCES `stops` (`stop_id`) ON DELETE SET NULL ON UPDATE SET NULL;

--
-- Constraints for table `frequencies`
--
ALTER TABLE `frequencies`
  ADD CONSTRAINT `frequencies_ibfk_1` FOREIGN KEY (`trip_id`) REFERENCES `trips` (`trip_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `routes`
--
ALTER TABLE `routes`
  ADD CONSTRAINT `routes_ibfk_1` FOREIGN KEY (`agency_id`) REFERENCES `agency` (`agency_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `stops`
--
ALTER TABLE `stops`
  ADD CONSTRAINT `stops_ibfk_1` FOREIGN KEY (`stop_timezone`) REFERENCES `ref_timezones` (`timezone`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `stop_times`
--
ALTER TABLE `stop_times`
  ADD CONSTRAINT `stop_times_ibfk_2` FOREIGN KEY (`stop_id`) REFERENCES `stops` (`stop_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `stop_times_ibfk_1` FOREIGN KEY (`trip_id`) REFERENCES `trips` (`trip_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `transfers`
--
ALTER TABLE `transfers`
  ADD CONSTRAINT `transfers_ibfk_2` FOREIGN KEY (`to_stop_id`) REFERENCES `stops` (`stop_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `transfers_ibfk_1` FOREIGN KEY (`from_stop_id`) REFERENCES `stops` (`stop_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `trips`
--
ALTER TABLE `trips`
  ADD CONSTRAINT `trips_ibfk_4` FOREIGN KEY (`service_id`) REFERENCES `calendar_dates` (`service_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `trips_ibfk_1` FOREIGN KEY (`route_id`) REFERENCES `routes` (`route_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `trips_ibfk_2` FOREIGN KEY (`service_id`) REFERENCES `calendar` (`service_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `trips_ibfk_3` FOREIGN KEY (`shape_id`) REFERENCES `shapes` (`shape_id`) ON DELETE SET NULL ON UPDATE SET NULL;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
