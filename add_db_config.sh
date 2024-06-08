# Define the target directory and file
TARGET_DIR="/var/www/html/config"
TARGET_FILE="$TARGET_DIR/dbconfig.php"

# Set the database password
DATABASE_PASSWORD="potato"

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
    'password' => '$DATABASE_PASSWORD',     // Your MySQL password
    'contentschema' => 'content_schema', // Your content schema database name
    'customerschema' => 'customer_schema' // Your customer schema database name
);
?>"

# Create the configuration file with the specified content
echo "$CONFIG_CONTENT" | sudo tee "$TARGET_FILE" > /dev/null

# Set appropriate permissions
sudo chown www-data:www-data "$TARGET_FILE"
sudo chmod 644 "$TARGET_FILE"
