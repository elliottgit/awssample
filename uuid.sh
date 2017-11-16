#!/bin/bash

fdisk -l
echo -e "Enter the EBS device name:"
read ebsdevice

ebsuuid=uuid=`blkid -s UUID -o value $ebsdevice`
file -s $ebsdevice
echo "$ebsuuid"
