# Update package list
sudo apt update -y
sudo apt upgrade -y

# Install Apache
sudo apt install -y apache2

# add Apache mdule
sudo a2enmod expires
 systemctl restart apache2
