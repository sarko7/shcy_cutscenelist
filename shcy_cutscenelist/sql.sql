CREATE TABLE IF NOT EXISTS `cutscenes_fav` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `license` varchar(255) COLLATE utf8_danish_ci NOT NULL,
  `cLabel` varchar(255) COLLATE utf8_danish_ci NOT NULL,
  `cName` varchar(255) COLLATE utf8_danish_ci NOT NULL,
  `x` int(11) NOT NULL DEFAULT 0,
  `y` int(11) NOT NULL DEFAULT 0,
  `z` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
);