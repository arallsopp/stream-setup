# Set default password
DATABASE_PASSWORD="potato"

# Create a temporary MySQL config file
TEMP_MYSQL_CONF=$(mktemp)
echo "[client]" > $TEMP_MYSQL_CONF
echo "user=root" >> $TEMP_MYSQL_CONF
echo "password=${DATABASE_PASSWORD}" >> $TEMP_MYSQL_CONF

# Update password
mysql --defaults-extra-file=$TEMP_MYSQL_CONF <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '${DATABASE_PASSWORD}';
FLUSH PRIVILEGES;
EOF


# Remove temporary MySQL config file
rm $TEMP_MYSQL_CONF
