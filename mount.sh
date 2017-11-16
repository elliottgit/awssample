#!/bin/bash
#title:         mount.sh
#description:   Bash script to mount ebs block volume.
#author:        Elliott Ning
#date:          20171114
#version:       1.3
#====================================================

# get device name
fdisk -l
echo -e "Enter the EBS device name for mounting:"
read ebsdevice

# set mount point
echo -e "Enter the mount point directory for the EBS volume $ebsdevice, for example: /mnt/ebs"
read mountpoint

# mount volume
echo "Mount EBS block volume."
yes | mkfs.ext4 $ebsdevice
mkdir $mountpoint
mount $ebsdevice $mountpoint
chmod a+w $mountpoint
  
# get device uuid
file -s $ebsdevice
echo -e "Enter the EBS UUID:"
read ebsuuid
#ebsuuid=uuid=`blkid -s UUID -o value $ebsdevice`
#file -s $ebsdevice
#echo "$ebsuuid"

# update mount fstab
echo "Mount EBS volume on every system reboot."
sudo cp /etc/fstab /etc/fstab.orig
echo -e "$ebsuuid  $mountpoint  ext4  defaults,nofail  0  2" >> /etc/fstab
echo "Mount directory is $mountpoint."

#EOF
