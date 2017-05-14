CREATE TABLE `newsv2` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `id_unique` int(10) unsigned NOT NULL DEFAULT '0',
  `source` varchar(20) NOT NULL DEFAULT '',
  `subsource` varchar(20) NOT NULL DEFAULT '',
  `categorie` int(10) unsigned NOT NULL DEFAULT '0',
  `titre` varchar(255) NOT NULL,
  `extra` varchar(128) NOT NULL DEFAULT '',
  `url` varchar(512) NOT NULL,
  `date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `dateinsert` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `description` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `date` (`date`),
  KEY `dateinsert` (`dateinsert`),
  KEY `categorie` (`categorie`),
  KEY `url` (`url`),
  KEY `id_unique` (`id_unique`),
  KEY `source_subsource` (`source`,`subsource`),
  KEY `titre_dateinsert` (`titre`,`dateinsert`)
) ENGINE=MyISAM AUTO_INCREMENT=2516511 DEFAULT CHARSET=latin1;


CREATE TABLE `uniquenewsv2` (
  `id_unique` int(10) unsigned NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id_unique`)
) ENGINE=MyISAM AUTO_INCREMENT=1428519 DEFAULT CHARSET=latin1;

