--
-- Structure de la table `blips`
--

CREATE TABLE IF NOT EXISTS `blips` (
  `id` int NOT NULL AUTO_INCREMENT,
  `pos` text NOT NULL,
  `image` int NOT NULL,
  `color` int NOT NULL,
  `name` text NOT NULL,
  `props` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `blipscategories` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `blipscategories` (`id`, `name`) VALUES
(1, 'No distance shown in legend'),
(2, 'Distance shown in legend'),
(7, 'Other Players'),
(10, 'Property'),
(11, 'Owned Property');
