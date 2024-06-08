# Variables
APP_PATH="$HOME/stream"
WEB_DIR="/var/www/html"
APACHE_CONFIG_FILE="/etc/apache2/sites-available/000-default.conf"

# Move the application to the web directory
if [ -d "$APP_PATH" ]; then
    sudo mv "$APP_PATH" "$WEB_DIR/stream"
else
    echo "Application directory $APP_PATH does not exist."
    exit 1
fi

# Set permissions
sudo chown -R www-data:www-data "$WEB_DIR/stream"
sudo find "$WEB_DIR/stream" -type d -exec chmod 755 {} \;
sudo find "$WEB_DIR/stream" -type f -exec chmod 644 {} \;

# Create Apache Virtual Host configuration
sudo bash -c "cat > $APACHE_CONFIG_FILE <<'EOL'
<VirtualHost *:80>
    ServerAdmin webmaster@localhost
    DocumentRoot $WEB_DIR/stream

    <Directory $WEB_DIR/stream>
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