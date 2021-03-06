-- phpMyAdmin SQL Dump
-- version 2.11.5.1
-- http://www.phpmyadmin.net
--
-- Host: stul14.ac.bankit.it
-- Generato il: 29 Ott, 2008 at 09:38 AM
-- Versione MySQL: 5.0.22
-- Versione PHP: 5.1.6

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";

--
-- Database: `bitslinked`
--

-- --------------------------------------------------------

--
-- Struttura della tabella `data`
--

DROP TABLE IF EXISTS `data`;
CREATE TABLE IF NOT EXISTS `data` (
  `ID` int(11) unsigned NOT NULL,
  `VID` int(11) unsigned NOT NULL,
  `SEQ` int(11) unsigned NOT NULL,
  `VALUE` double default NULL,
  PRIMARY KEY  (`ID`,`VID`,`SEQ`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struttura della tabella `info`
--

DROP TABLE IF EXISTS `info`;
CREATE TABLE IF NOT EXISTS `info` (
  `OID` int(11) NOT NULL, 
  `KWORD` char(255) NOT NULL,
  `T` int(11) NOT NULL,
  `VD` double default NULL,
  `VS` char(255) default NULL,
  UNIQUE KEY `OID` (`OID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO info VALUES(1,'VERSION',0,1.0,NULL);
-- --------------------------------------------------------

--
-- Struttura della tabella `meta`
--

DROP TABLE IF EXISTS `meta`;
CREATE TABLE IF NOT EXISTS `meta` (
  `XID` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `ID` int(11) unsigned NOT NULL,
  `VID` int(11) unsigned NOT NULL,
  `MID` int(11) unsigned NOT NULL,
  PRIMARY KEY  (`XID`),
  KEY `ID` (`ID`,`VID`,`MID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struttura della tabella `metaname`
--

DROP TABLE IF EXISTS `metaname`;
CREATE TABLE IF NOT EXISTS `metaname` (
  `MID` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `TID` int(11) NOT NULL,
  `Name` char(255) default NULL,
  PRIMARY KEY  (`MID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struttura della tabella `metanum`
--

DROP TABLE IF EXISTS `metanum`;
CREATE TABLE IF NOT EXISTS `metanum` (
  `XID` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `VALUE` double default NULL,
  PRIMARY KEY  (`XID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struttura della tabella `metastr`
--

DROP TABLE IF EXISTS `metastr`;
CREATE TABLE IF NOT EXISTS `metastr` (
  `XID` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `VALUE` varchar(1024) default NULL,
  PRIMARY KEY  (`XID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struttura della tabella `series`
--

DROP TABLE IF EXISTS `series`;
CREATE TABLE IF NOT EXISTS `series` (
  `ID` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `Name` char(255) NOT NULL UNIQUE,
  `Freq` int(11) NOT NULL,
  PRIMARY KEY  (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struttura della tabella `version`
--

DROP TABLE IF EXISTS `version`;
CREATE TABLE IF NOT EXISTS `version` (
  `VID` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `ID` int(11) unsigned NOT NULL,
  `Rel` int(11) NOT NULL,
  `Start_year` int(11) NOT NULL,
  `Start_period` int(11) NOT NULL,
  `Version` int(11) default NULL,
  `Resolution` int(11) default NULL,
  PRIMARY KEY  (`VID`,`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

