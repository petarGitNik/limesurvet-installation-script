#!/bin/bash

# Variables:
# $CUSER -> desired owner of the installation
# $DBUSER -> root user of the mysql db
# $DBPASSWORD -> password of the root user for mysql database
# $NEWUSER -> new db user
# $NEWPASSWORD -> password for new db user
# $SNAME -> server name (apache configuration)
# $SALIAS -> server alias (apache configuration)
# $SADMIN -> server admin (apache configuration)

# LimeSurvey Installation script for Ubuntu 16.04
# LAMP stack implied
curl -L https://www.limesurvey.org/stable-release?download=2317:limesurvey353%20180316targz --output lime.tar.gz
tar xvzf lime.tar.gz

sudo apt-get update
sudo apt-get install apache2 mysql-client mysql-server php7.1 php7.1-common php7.1-cli libapache2-mod-php7.1

# Optional but not so optional PHP extensions
# Zlib missing here (?)
sudo apt-get install php7.1-mysql php7.1-ldap php7.1-zip php7.1-mbstring php7.1-gd php7.1-imap php7.1-xml
sudo service apache2 restart

sudo mkdir /var/www/limesurvey
sudo chown $CUSER:www-data /var/www/limesurvey
sudo cp -ra limesurvey/. /var/www/limesurvey

# Ownership and permissions
sudo find /var/www/limesurvey/ -type d -exec chown $CUSER:www-data {} \;
sudo find /var/www/limesurvey/ -type f -exec chown $CUSER:www-data {} \;

sudo find /var/www/limesurvey/ -type d -exec chmod 755 {} \;

sudo find /var/www/limesurvey/tmp/ -type d -exec chmod 775 {} \;
sudo find /var/www/limesurvey/upload/ -type d -exec chmod 775 {} \;

sudo find /var/www/limesurvey/tmp/ -type f -exec chmod 775 {} \;
sudo find /var/www/limesurvey/upload/ -type f -exec chmod 775 {} \;

sudo chmod 775 /var/www/limesurvey/application/config/

# Create a database
mysql --user="$DBUSER" --password="$DBPASSWORD" --execute="CREATE DATABASE limesurvey;"
mysql --user="$DBUSER" --password="$DBPASSWORD" --execute="CREATE USER '$NEWUSER'@'localhost' IDENTIFIED BY '$NEWPASSWORD';"
mysql --user="$DBUSER" --password="$DBPASSWORD" --execute="GRANT ALL PRIVILEGES ON limesurvey.* TO '$NEWUSER'@'localhost' IDENTIFIED BY '$NEWPASSWORD';"


# Apache configuration
sudo touch /etc/apache2/sites-available/limesurvey.conf

echo "<VirtualHost *:80>
  ServerName $SNAME
  ServerAlias $SALIAS
  ServerAdmin $SADMIN
  DocumentRoot /var/www/limesurvey

  LogLevel warn
  ErrorLog /var/log/apache2/lime_error.log
  CustomLog /var/log/apache2/lime_access.log combined

  <Directory /var/www/limesurvey>
    Require all granted
    Options -MultiViews
  </Directory>
</VirtualHost>" | sudo tee -a /etc/apache2/sites-available/limesurvey.conf

sudo a2ensite limesurvey
sudo service apache2 reload
