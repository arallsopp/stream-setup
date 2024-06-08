# Install MySQL
sudo apt install -y mysql-server

# Set permissions
sudo service mysql stop
sudo mv /var/lib/mysql /tmp/mysql
sudo mkdir /var/lib/mysql
sudo chown -R mysql:mysql /var/lib/mysql
sudo chmod 750 /var/lib/mysql