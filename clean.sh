#!/bin/bash

export LFS=/mnt/lfs

echo "WARNING WARNING WARNING"
read -p "This will delete everything. Proceed? [y/N] " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
	echo "Nothing has been changed."
	exit 1
fi

if [[ -d $LFS ]]
then
	[[ -d $LFS/boot ]] && echo "Deleting $LFS/boot"; rm -rf $LFS/boot/*; umount $LFS/boot
	[[ -d $LFS/home ]] && echo "Deleting $LFS/home"; rm -rf $LFS/home/*; umount $LFS/home
	
	echo "Deleting $LFS"; rm -rf $LFS/*; umount $LFS
	rmdir $LFS
else
	echo "$LFS is already cleaned."
fi

echo "Deleting lfs user and group"
if id -u "lfs" &>/dev/null; then deluser --remove-home lfs; fi


