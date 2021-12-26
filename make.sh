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

# Globals
export LFS=/mnt/lfs

### Set up partitions -----------------------------
echo "Setting up partitions"

[[ ! -d "$LFS" ]] && mkdir $LFS
[[ ! $(findmnt -M "$LFS") ]] && mount /dev/sda3 $LFS

[[ ! -d "$LFS/home" ]] && mkdir $LFS/home
[[ ! $(findmnt -M "$LFS/home") ]] && mount /dev/sda4 $LFS/home

[[ ! -d "$LFS/boot" ]] && mkdir $LFS/boot
[[ ! $(findmnt -M "$LFS/boot") ]] && mount /dev/sda2 $LFS/boot

### Set up partitions -----------------------------
### File structure --------------------------------
echo "Setting up file structure"

source_folders=("etc" "var" "usr/bin" \
	"usr/lib" "usr/sbin" "tools" "sources")
for i in "${source_folders[@]}"
do
	[[ ! -d $LFS/$i ]] && mkdir -p $LFS/$i
done

for i in bin lib sbin
do
	[[ ! -L $LFS/$i ]] && ln -s usr/$i $LFS/$i
done

# Make lib64 if 64-bit
if [[ "$(uname -m)" == "x86_64" ]]
then
	[[ ! -d $LFS/lib64 ]] && mkdir $LFS/lib64
fi

### File structure --------------------------------
### Set up user -----------------------------------
echo "Setting up lfs user"

# Add LFS group and user
[[ ! $(getent group lfs) ]] && groupadd lfs
if ! id -u "lfs" &>/dev/null; then
	useradd -s /bin/bash -g lfs -m -k /dev/null lfs
fi

# Copy scripts that are run under lfs
cp toolchain.sh $LFS

# Make $LFS under lfs
chown -R lfs:lfs $LFS # TODO: This causes a slow down with untar-d files

# Set up the user
cp lfs.bashrc /home/lfs/.bashrc
cp lfs.bashprofile /home/lfs/.bash_profile


# Ubuntu has a default .bashrc
[ ! -e /etc/bash.bashrc ] || mv /etc/bash.bashrc /etc/bash.bashrc.NOUSE

### Set up user -----------------------------------
### Unpack files ----------------------------------
if [ -z "$(ls -A $LFS/sources)" ]; then
	echo "Extracting source files"
	tar -xf *.tar -C $LFS/sources
	mv $LFS/sources/*/* $LFS/sources/
	new_files=1
else
	new_files=0
fi
# Only verify if setting "verify" or you've just extracted
# the files.
# Check files -- go into directory, then come back out
if [[ "$@" == *"verify"* || $new_files -eq 1 ]] ; then
	echo "Verifying source checksums"
	cur_dir=${pwd}
	cd $LFS/sources
	md5sum -c --quiet md5sums
	cd $cur_dir
	unset cur_dir
fi

### Unpack files ----------------------------------

### Compile toolchain -----------------------------
[[ "$@" == *"compile"* ]] && sudo -u lfs bash $LFS/toolchain.sh
