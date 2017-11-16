#!/bin/bash
#title:         mount.sh
#description:   Bash script to mount ebs block volume.
#author:        Elliott Ning
#date:          20171114
#version:       1.3
#====================================================

# get device name
fdisk -l
echo -e "Enter the EBS device name:"
read ebsdevice

# mount volume
echo "Mount EBS block volume."
yes | mkfs.ext4 $ebsdevice
mkdir /mnt/ebs
mount $ebsdevice /mnt/ebs
chmod a+w /mnt/ebs
  
# get device uuid
file -s $ebsdevice
echo -e "Enter the EBS UUID:"
read ebsuuid

# update mount fstab
echo "Mount EBS volume on every system reboot."
sudo cp /etc/fstab /etc/fstab.orig
echo -e "$ebsuuid  /mnt/ebs  ext4  defaults,nofail  0  2" >> /etc/fstab
echo "Mount directory is /mnt/ebs."

#EOF
