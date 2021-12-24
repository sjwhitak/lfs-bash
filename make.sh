#!/bin/bash
export LFS=/mnt/lfs

echo "Creating user"
bash ./lfs-user.sh

echo "Mounting folders"
bash ./lfs-mount.sh

echo "Populating folders"
bash ./lfs-folder.sh

# Copy source tarball into $LFS/sources


# Go into the lfs environment
su - lfs

