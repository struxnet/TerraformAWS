#!/bin/bash
# Update system
apt-get update -y
apt-get upgrade -y

# Install Apache2
apt-get install -y apache2 unzip wget

# Enable Apache2 to start on boot
systemctl enable apache2
systemctl start apache2

# Move to Apache web root
cd /var/www/html

# Clean default index.html
rm -f index.html

# Download a sample template from Tooplate (e.g., template 2129)
wget https://www.tooplate.com/zip-templates/2139_neural_portfolio.zip -O template.zip

# Unzip and move files
unzip template.zip
template_dir=$(ls -d */ | head -n 1)
cp -r ${template_dir}* /var/www/html/

# Fix permissions
chown -R www-data:www-data /var/www/html

# Restart Apache
systemctl restart apache2