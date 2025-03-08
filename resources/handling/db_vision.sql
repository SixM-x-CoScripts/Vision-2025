ALTER TABLE `vehicles`
	ADD COLUMN `handling` LONGTEXT NULL DEFAULT '[]';

CREATE TABLE `player_handlings` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`identifier` VARCHAR(80) NOT NULL COLLATE 'utf8_general_ci',
	`handlingData` LONGTEXT NOT NULL COLLATE 'utf8mb4_bin',
	`carName` VARCHAR(100) NULL DEFAULT '' COLLATE 'utf8_general_ci',
	`handlingName` VARCHAR(100) NULL DEFAULT '' COLLATE 'utf8_general_ci',
	`creator` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	PRIMARY KEY (`id`) USING BTREE,
	CONSTRAINT `handlingData` CHECK (json_valid(`handlingData`))
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB
AUTO_INCREMENT=10
;