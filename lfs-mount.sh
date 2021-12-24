#!/bin/bash
# Mounts the proper drives set up where
# /dev/sda2 = /boot
# /dev/sda3 = /
# /dev/sda4 = /home
#
# and
# $LFS = /mnt/lfs
#
# Note there is NO swap partition since I'm on MBR/DOS, there 
# are only 4 partitions available!
# TODO: You need to remember to add a swapfile.

[[ ! -d "$LFS" ]] && mkdir $LFS
[[ ! $(findmnt -M "$LFS") ]] && mount /dev/sda3 $LFS

[[ ! -d "$LFS/home" ]] && mkdir $LFS/home
[[ ! $(findmnt -M "$LFS/home") ]] && mount /dev/sda4 $LFS/home

[[ ! -d "$LFS/boot" ]] && mkdir $LFS/boot
[[ ! $(findmnt -M "$LFS/boot") ]] && mount /dev/sda2 $LFS/boot
