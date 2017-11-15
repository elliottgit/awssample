#!/bin/bash
#title           :mount.sh
#description     :Bash script to mount ebs block volume.
#author		       :Elliott Ning
#date            :20171113
#version         :1.2

#==============================================================================

# set variables
export ebsdevice=
# export ebsuuid=

#==============================================================================

# display variables
echo "EBS Device name is $ebsdevice."
# echo "EBS Device uuid is $ebsuuid."

# check variables
echo -e "Check the EBS volume variables and type y to start the script:"
read input
if [ $input == 'y' ]
then

  # mount volume
  echo "Mount EBS block volume."
  mkfs -t ext4 $ebsdevice
  mkdir /ebsvolume
  mount $ebsdevice /ebsvolume
  
  # edit mount fstab
  echo "Mount EBS volume on every system reboot."
  sudo cp /etc/fstab /etc/fstab.orig
  echo -e "$ebsdevice /ebsvolume next4 defaults,nofail 0 2" >> /etc/fstab
  echo "Mount directory is /ebsvolume."
  
else

  echo "Edit the variables and try again"

fi

#EOF
