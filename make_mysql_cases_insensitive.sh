MYSQL_CONFIG_FILE_PATH="/etc/mysql/mysql.conf.d/mysqld.cnf"

## Insert each line separately at line 15
sudo sed -i '15i\lower_case_table_names=1' "$MYSQL_CONFIG_FILE_PATH"
sudo sed -i '16i\sql-mode=""' "$MYSQL_CONFIG_FILE_PATH"
sudo sed -i '17i\max_allowed_packet=650M' "$MYSQL_CONFIG_FILE_PATH"

# Initialize MySQL with the specified configuration
sudo mysqld --defaults-file=/etc/mysql/my.cnf --initialize --user=mysql --console

## Set appropriate permissions
sudo chown -R mysql:mysql /var/lib/mysql
sudo chmod 750 /var/lib/mysql

sudo mysql -u root <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED WITH 'mysql_native_password' BY 'potato';
FLUSH PRIVILEGES;
EXIT;
EOF

## Start MySQL service
sudo service mysql start
