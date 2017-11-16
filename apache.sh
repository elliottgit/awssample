#!/bin/bash
#title:         apache.sh
#description:   Bash script on Ubuntu to install and configure Apache.
#os:            Ubuntu 16.04
#author:        Elliott Ning
#date:          20171115
#version:       1.2
#====================================================

# create directory if doesnt exist - optional
#mkdir /mnt/ebs

# download and install apache
apt-get update
apt-get -y install apache2

# set firewall rules to allow ssh and apache
ufw allow ssh
ufw allow 'Apache Full'
yes | ufw enable

# start and enable apache for startup
systemctl start apache2
systemctl enable apache2

# sync folders if any conent in default apache directory
rsync -av /var/www/html /mnt/ebs

# set apache config file to use new document root
wget https://raw.githubusercontent.com/elliottgit/work/master/custom.conf -P /mnt/ebs
cp /mnt/ebs/custom.conf /etc/apache2/sites-enabled/000-default.conf
systemctl reload apache2

# change custom index page
mv /mnt/ebs/html/index.html /mnt/ebs/html/backupindex
wget https://raw.githubusercontent.com/elliottgit/demo/master/index.html -P /mnt/ebs/html

# get url for web page
echo "Enter the URL below in your browser to see the website:"
IP=`wget http://ipecho.net/plain -O - -q ; echo`
echo "http://$IP"

#EOF
