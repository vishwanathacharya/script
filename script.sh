#!/bin/bash
set -x
username=$(ls /home/);
echo $username
cd /home/$username/ && mkdir -p www/html && chown -R $username:Wuser www/
cd www/html
document_root=$(pwd);
apt update -y
apt install -y apache2
sed -i "s|/var/www/html|$document_root|g" /etc/apache2/sites-available/000-default.conf 
sed -i "s|/var/www|/home/$username/www|g" /etc/apache2/apache2.conf
sed -i -e "172s/None/All/" /etc/apache2/apache2.conf
sed -i -e "16s|www-data|$username|" /etc/apache2/envvars
a2enmod rewrite && /etc/init.d/apache2 restart
directory="/home/vishwa/www/html"
filename="index.html"
filepath="$directory/$filename"
if [ ! -d "$directory" ]; then
  mkdir -p "$directory"
fi
if [ ! -f "$filepath" ]; then
  touch "$filepath"
fi
echo "<!DOCTYPE html>
<html>
<head>
  <title>nikal lawde</title>
</head>
<body>
  <h1>Bhag, Bhosdi chai hamesha riste banaye!</h1>
  <p>This is your new index.html page.</p>
</body>
</html>" > "$filepath"
echo "index.html created successfully at $filepath"
