#!/bin/bash
#title:         ubuntu.sh
#description:   Bash script to complete work sample.
#author:        Elliott Ning
#date:          20171115
#version:       1.0
#====================================================
mkdir /mnt/ebs

apt-get update
apt-get -y install apache2

ufw disable

systemctl start apache2
systemctl enable apache2

rsync -av /var/www/html /mnt/ebs

cd /mnt/ebs
wget https://raw.githubusercontent.com/elliottgit/work/master/custom.conf
cp custom.conf /etc/apache2/sites-enabled/000-default.conf
systemctl reload apache2

cd /mnt/ebs/html
mv index.html indexbackup
wget https://raw.githubusercontent.com/elliottgit/demo/master/index.html

#EOF
