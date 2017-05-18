-- ---
-- Globals
-- ---

-- SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
-- SET FOREIGN_KEY_CHECKS=0;

-- ---
-- Table 'users'
-- 
-- ---

DROP TABLE IF EXISTS `users`;
		
CREATE TABLE `users` (
  `id` INTEGER NULL NOT NULL PRIMARY KEY,
  `first_name` VARCHAR(30) NOT NULL,
  `last_name` VARCHAR(30) NOT NULL
) charset utf8;

-- ---
-- Table 'relations'
-- 
-- ---

DROP TABLE IF EXISTS `relations`;

CREATE TABLE `relations` (
  `id` INTEGER NOT NULL,
  `friend_id` INTEGER NOT NULL,
  `uniq_id` INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,
  INDEX `id` (`id`)
);

-- ---
-- Test Data
-- ---

-- INSERT INTO `users` (`id`,`first_name`,`last_name`) VALUES
-- ('','','');
-- INSERT INTO `relations` (`id`,`id_users`,`friend_id`) VALUES
-- ('','','');
