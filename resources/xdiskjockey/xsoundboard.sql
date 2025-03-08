CREATE TABLE `xsoundboard` (
 `id` int(11) NOT NULL AUTO_INCREMENT,
 `name` varchar(32) DEFAULT NULL,
 `url` varchar(256) DEFAULT NULL,
 `identifier` varchar(64) DEFAULT NULL,
 `steamid` varchar(64) DEFAULT NULL,
 `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
 PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8