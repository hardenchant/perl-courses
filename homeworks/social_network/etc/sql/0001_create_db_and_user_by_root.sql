CREATE DATABASE social_network CHARSET utf8;
CREATE USER sn IDENTIFIED BY 'socnet';
GRANT ALL ON social_network.* TO sn;
