bash ./clone_project.sh    

# Update package list
sudo apt update -y
sudo apt upgrade -y

# Install Apache
sudo apt install -y apache2

# Install PHP 7.4
sudo apt install -y software-properties-common
sudo add-apt-repository -y ppa:ondrej/php
sudo apt update -y

# Install PHP basic modules
sudo apt install -y php7.4 php7.4-cli php7.4-common php7.4-fpm php7.4-mysql

# Setup Apache's PHP
sudo a2enmod php7.4
sudo apt install -y libapache2-mod-php7.4
sudo systemctl restart apache2

# Install MySQL
sudo apt install -y mysql-server

## Make table names case insensitive
sudo service mysql stop
sudo mv /var/lib/mysql /tmp/mysql
sudo mkdir /var/lib/mysql
sudo chown -R mysql:mysql /var/lib/mysql
sudo chmod 750 /var/lib/mysql

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

# Clone the application repository
ssh-keyscan -t rsa bitbucket.org >> ~/.ssh/known_hosts
git clone git@bitbucket.org:arallsopp/stream.git ~/stream 

# Variables
APP_NAME="stream"
APP_PATH="$HOME/$APP_NAME"
WEB_DIR="/var/www/html"
APACHE_CONFIG_FILE="/etc/apache2/sites-available/000-default.conf"
SERVER_NAME="159.223.28.188"

# Move the application to the web directory
if [ -d "$APP_PATH" ]; then
    sudo mv "$APP_PATH" "$WEB_DIR/$APP_NAME"
else
    echo "Application directory $APP_PATH does not exist."
    exit 1
fi

# Set permissions
sudo chown -R www-data:www-data "$WEB_DIR/$APP_NAME"
sudo find "$WEB_DIR/$APP_NAME" -type d -exec chmod 755 {} \;
sudo find "$WEB_DIR/$APP_NAME" -type f -exec chmod 644 {} \;

# Create Apache Virtual Host configuration
sudo bash -c "cat > $APACHE_CONFIG_FILE <<EOL
<VirtualHost *:80>
    ServerAdmin webmaster@localhost
    ServerName $SERVER_NAME
    DocumentRoot $WEB_DIR/$APP_NAME

    <Directory $WEB_DIR/$APP_NAME>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog \${APACHE_LOG_DIR}/error.log
    CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOL"

# Enable necessary Apache modules
sudo a2enmod rewrite

# Restart Apache to apply changes
sudo systemctl restart apache2

# Check Apache error log for troubleshooting
echo "Checking Apache error log for recent errors..."
sudo tail -n 10 /var/log/apache2/error.log

# Test setup
echo "Your application should be available at http://$SERVER_NAME"

# Print a reminder to check the logs if there is an error
echo "If you encounter an error, check the Apache error log for more details: /var/log/apache2/error.log"

### create db config folder

# Define the target directory and file
TARGET_DIR="/var/www/html/config"
TARGET_FILE="$TARGET_DIR/dbconfig.php"

# Create the directory if it doesn't exist
if [ ! -d "$TARGET_DIR" ]; then
    sudo mkdir -p "$TARGET_DIR"
    echo "Directory $TARGET_DIR created."
else
    echo "Directory $TARGET_DIR already exists."
fi

# Define the content of the configuration file
CONFIG_CONTENT="<?php
\$db_config = array(
    'host' => 'localhost',        // Use 'localhost' if MySQL is on the same server
    'user' => 'root',             // Your MySQL username
    'password' => 'MyNewPa$$w0rd',     // Your MySQL password
    'contentschema' => 'content_schema', // Your content schema database name
    'customerschema' => 'customer_schema' // Your customer schema database name
);
?>"

# Create the configuration file with the specified content
echo "$CONFIG_CONTENT" | sudo tee "$TARGET_FILE" > /dev/null

# Set appropriate permissions
sudo chown www-data:www-data "$TARGET_FILE"
sudo chmod 644 "$TARGET_FILE"

echo "Configuration file $TARGET_FILE created with the specified content."
asddas

#!/bin/bash

# Stop MySQL service
sudo systemctl stop mysql

# Uninstall MySQL completely if previously installed
sudo apt-get purge -y mysql-server mysql-client mysql-common mysql-server-core-* mysql-client-core-*
sudo rm -rf /etc/mysql /var/lib/mysql /var/log/mysql /var/log/mysql.* /var/run/mysqld
sudo apt-get autoremove -y
sudo apt-get autoclean -y

# Update package information
sudo apt-get update

# Install MySQL server
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-server

# Ensure the required directory exists and has correct permissions
sudo mkdir -p /var/run/mysqld
sudo chown mysql:mysql /var/run/mysqld

# Start MySQL in safe mode
sudo mysqld_safe --skip-grant-tables --skip-networking &
sleep 5

# Login to MySQL and change root password
mysql -u root <<EOF
USE mysql;
UPDATE user SET authentication_string=PASSWORD('potato') WHERE User='root' AND Host='localhost';
FLUSH PRIVILEGES;
EXIT;
EOF

# Stop MySQL safe mode
sudo killall -u mysql
sleep 5

# Start MySQL service normally
sudo systemctl start mysql

# Enable MySQL service to start on boot
sudo systemctl enable mysql

# Add Bitbucket's SSH key to known hosts
ssh-keyscan -t rsa bitbucket.org >> ~/.ssh/known_hosts

# Clone the repository
git clone git@bitbucket.org:arallsopp/stream.git ~/stream

echo "MySQL installation is complete. The root password is set to 'potato'. Repository cloned."



asddas
sudo a2enmod expires
sudo systemctl restart apache2
