#!/bin/bash
#title           :mount.sh
#description     :Bash script to mount ebs block volume.
#author		       :Elliott Ning
#date            :20171113
#version         :1.2

#==============================================================================

# get device name
fdisk -l
echo -e "Enter the EBS device name:"
read ebsdevice

# check variables
echo -e "EBS device name is $ebsdevice, type y to continue"
read input
if [ $input == 'y' ]
then

  # mount volume
  echo "Mount EBS block volume."
  mkfs -t ext4 $ebsdevice
  mkdir /ebsvolume
  mount $ebsdevice /ebsvolume
  
  # edit mount fstab
  file -s $ebsdevice
  echo -e "Enter the EBS UUID:"
  read ebsuuid
  echo "Mount EBS volume on every system reboot."
  sudo cp /etc/fstab /etc/fstab.orig
  echo -e "$ebsuuid  /ebsvolume  ext4  defaults,nofail  0  2" >> /etc/fstab
  echo "Mount directory is /ebsvolume."

else

  echo "Retry the script"

fi

#EOF
