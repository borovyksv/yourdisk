CREATE TABLE `user_document` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `folder` tinyint(1) DEFAULT NULL,
  `name` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `type` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `glyphicon` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `content` longblob NOT NULL,
  `size` int(11) DEFAULT '0',
  `files_counter` int(11) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `document_user` (`user_id`),
  CONSTRAINT `document_user` FOREIGN KEY (`user_id`) REFERENCES `app_user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=96 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci
