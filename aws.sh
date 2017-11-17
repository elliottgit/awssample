#!/bin/bash
#title:         aws.sh
#description:   Bash script to complete AWS Work Sample.
#author:        Elliott Ning
#date:          20171117
#version:       1.4
#=======================================================

# ===get device name===
fdisk -l
echo -e "Enter the EBS device name for mounting:"
read ebsdevice

# ===set mount point===
echo -e "Enter the mount point for $ebsdevice, for example: /mnt/ebs"
read mountpoint

# ===mount EBS volume===
yes | mkfs.ext4 $ebsdevice
mkdir $mountpoint
mount $ebsdevice $mountpoint
chmod a+w $mountpoint
  
# ===get device uuid===
#file -s $ebsdevice
#echo -e "Enter the EBS UUID:"
#read ebsuuid
ebsuuid=UUID=`blkid -s UUID -o value $ebsdevice`

# ===update mount fstab for system reboot===
sudo cp /etc/fstab /etc/fstab.orig
echo -e "$ebsuuid  $mountpoint  ext4  defaults,nofail  0  2" >> /etc/fstab
#echo "Mount directory is $mountpoint."

# ===Get mount point directory===
#mkdir /mnt/ebs
#lsblk
#echo -e "Enter the EBS mount point:"
#read mountpoint
#$mountpoint

# ===download and install apache===
apt-get update
apt-get -y install apache2

# ===set firewall rules to allow ssh and apache===
ufw allow ssh
ufw allow 'Apache Full'
yes | ufw enable

# ===start and enable apache for startup===
systemctl start apache2
systemctl enable apache2

# ===sync folders if any conent in default apache directory===
rsync -av /var/www/html $mountpoint

# ===set apache config file to use new document root===
wget https://raw.githubusercontent.com/elliottgit/work/master/custom.conf -P $mountpoint
sed -i "s|root_directory_path_here|$mountpoint|g" $mountpoint/custom.conf
mv /etc/apache2/sites-enabled/000-default.conf /etc/apache2/sites-enabled/backup-default.conf
cp $mountpoint/custom.conf /etc/apache2/sites-enabled/000-default.conf
systemctl reload apache2

# ===get custom index page===
rm $mountpoint/html/index.html
wget https://objectstorage.us-phoenix-1.oraclecloud.com/p/cGDUptYdMuYizRCuGp3uFihqts4Xr7xuO0cF9KGNjbw/n/oraclemichaelme/b/image/o/home.jpg -P $mountpoint/html
wget https://raw.githubusercontent.com/elliottgit/work/master/index.html -P $mountpoint/html

# ===display url for web page===
echo "Enter the URL below in your browser to see the website:"
IP=`wget http://ipecho.net/plain -O - -q ; echo`
echo "http://$IP"

#EOF
