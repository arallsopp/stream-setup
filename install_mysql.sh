# Install MySQL
sudo apt install -y mysql-server

# Enable mysql to start on system boot
sudo systemctl enable mysql

# Set default password
read -p "Enter database passowrd [potato]: " DATABASE_PASSWORD
DATABASE_PASSWORD = ${DATABASE_PASSWORD:-potato}
echo "Using database password" $DATABASE_PASSWORD

# Create a temporary MySQL config file
# TEMP_MYSQL_CONF=$(mktemp)
# echo "[client]" > $TEMP_MYSQL_CONF
# echo "user=root" >> $TEMP_MYSQL_CONF
# echo "password=${DATABASE_PASSWORD}" >> $TEMP_MYSQL_CONF
# 
# # Update password
# mysql --defaults-extra-file=$TEMP_MYSQL_CONF <<EOF
# ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '${DATABASE_PASSWORD}';
# FLUSH PRIVILEGES;
# EOF


# Remove temporary MySQL config file
# rm $TEMP_MYSQL_CONF


# Set permissions
# sudo service mysql stop
# sudo mv /var/lib/mysql /tmp/mysql
# sudo mkdir /var/lib/mysql
# sudo chown -R mysql:mysql /var/lib/mysql
# sudo chmod 750 /var/lib/mysql
#
# update password
# mysql -u root -p
# ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'your_password_here';
# FLUSH PRIVILEGES;
# EXIT;

