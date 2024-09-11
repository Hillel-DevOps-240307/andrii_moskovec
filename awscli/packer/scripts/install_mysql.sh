#!/bin/sh

export FLASK_CONFIG=mysql

#### Installation MYSQL:
MYSQL_USER="admin"
MYSQL_PASSWORD="Pa55WD"
MYSQL_DB="flask_db"
MYSQL_HOST="127.0.0.1"


#### Create Mysql user and database
sudo mysql -e " CREATE USER IF NOT EXISTS 'admin'@'%' IDENTIFIED BY 'Pa55WD';
SELECT user FROM mysql.user;
create database flask_db;
grant ALL on flask_db.* to  'admin'@'%';
SHOW DATABASES;"
