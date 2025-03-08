CREATE TABLE IF NOT EXISTS `command_tablet` (
  `id` int NOT NULL,
  `crew_id` int NOT NULL,  
  `order` text NOT NULL,
  `time` varchar(5) NOT NULL,
  `date` varchar(30) NOT NULL,
  `total` int NOT NULL,  
  `typeObject` varchar(64) NOT NULL,
  `done` boolean NOT NULL,
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

ALTER TABLE `bank`
  ADD CONSTRAINT `crew_command_id` FOREIGN KEY (`crew_id`) REFERENCES `crew` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;