CREATE TABLE `camera_recordings` (
  `id` varchar(8) NOT NULL,
  `groupId` int(11) NOT NULL,
  `stored` varchar(64) NOT NULL,
  `recordedAt` timestamp NOT NULL DEFAULT current_timestamp(),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;