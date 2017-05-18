LOAD DATA INFILE '/var/lib/mysql-files/user' INTO TABLE users
FIELDS TERMINATED BY ' '
LINES TERMINATED BY '\n';
LOAD DATA INFILE '/var/lib/mysql-files/user_relation' INTO TABLE relations
FIELDS TERMINATED BY ' '
LINES TERMINATED BY '\n';
