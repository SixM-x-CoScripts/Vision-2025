ALTER TABLE `society` ADD `color` VARCHAR(10) NOT NULL DEFAULT '#00FF00' AFTER `inventory`;
ALTER TABLE `society` ADD `perm` TEXT NOT NULL DEFAULT '{\"recrute\":\1\,\"exclure\":\1\, \"editPerm\":\1\,\"editMembres\":\1\,\"sendDm\":\1\ }' AFTER `color`;
ALTER TABLE `society` ADD `devise` VARCHAR(255) NOT NULL DEFAULT 'empty devise' AFTER `perm`;