#!/bin/bash
set -x

# Get the username of the home directory
username=$(ls /home/)
echo "Username: $username"

# Create necessary directories and set ownership
cd /home/$username/ && mkdir -p www/html && chown -R $username:$username www/
cd www/html
document_root=$(pwd)
echo "Document Root: $document_root"

# Update and install Apache2
apt update -y
apt install -y apache2 git

# Pull code from GitHub repository
git clone https://github.com/vishwanathacharya/file.git /home/$username/www/html/

# Configure Apache2 virtual host
sed -i "s|/var/www/html|$document_root|g" /etc/apache2/sites-available/000-default.conf
sed -i "s|/var/www|/home/$username/www|g" /etc/apache2/apache2.conf
sed -i -e "172s/None/All/" /etc/apache2/apache2.conf
sed -i -e "16s|www-data|$username|" /etc/apache2/envvars

# Enable mod_rewrite and restart Apache
a2enmod rewrite && /etc/init.d/apache2 restart
