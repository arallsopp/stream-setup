# Update package list
sudo apt update -y
sudo apt upgrade -y

# install PHP 7.4
sudo apt install -y software-properties-common
sudo add-apt-repository -y ppa:ondrej/php

# Install PHP basic modules
sudo apt install -y php7.4 php7.4-cli php7.4-common php7.4-fpm php7.4-mysql

# Setup Apache's PHP
sudo a2enmod php7.4
sudo apt install -y libapache2-mod-php7.4

sudo systemctl restart apache2