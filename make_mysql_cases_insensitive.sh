#!/bin/bash

MYSQL_CONFIG_FILE_PATH="/etc/mysql/mysql.conf.d/mysqld.cnf"

# Stop MySQL service
sudo service mysql stop

# Move the current MySQL data directory
mv /var/lib/mysql /tmp/mysql

# Create a new MySQL data directory
mkdir /var/lib/mysql
chown -R mysql:mysql /var/lib/mysql
chmod 750 /var/lib/mysql

# Modify the MySQL configuration file
sudo sed -i '15i\lower_case_table_names=1' "$MYSQL_CONFIG_FILE_PATH"
sudo sed -i '16i\sql-mode=""' "$MYSQL_CONFIG_FILE_PATH"
sudo sed -i '17i\max_allowed_packet=650M' "$MYSQL_CONFIG_FILE_PATH"

# Initialize MySQL data directory
sudo mysqld --initialize --user=mysql --datadir=/var/lib/mysql

# Correct ownership and permissions
chown -R mysql:mysql /var/lib/mysql
chmod 750 /var/lib/mysql

# Start MySQL service
sudo service mysql start

# Check the status of MySQL service
sudo systemctl status mysql.service

