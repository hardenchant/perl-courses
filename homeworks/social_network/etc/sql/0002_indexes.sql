-- ---
-- Foreign and Primary Keys 
-- ---

ALTER TABLE `users` ADD PRIMARY KEY (`id`);
ALTER TABLE `relations` ADD PRIMARY KEY (`id`);

ALTER TABLE `relations` ADD FOREIGN KEY (id_users) REFERENCES `users` (`id`);

