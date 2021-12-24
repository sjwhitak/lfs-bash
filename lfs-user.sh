#!/bin/bash

# Add LFS group and user
[[ ! $(getent group lfs) ]] && groupadd lfs
if ! id -u "lfs" &>/dev/null; then
	useradd -s /bin/bash -g lfs -m -k /dev/null lfs
fi

# Make $LFS under lfs
chown -R lfs:lfs $LFS

# Set up the user
cp lfs.bashrc /home/lfs/.bashrc
cp lfs.bashprofile /home/lfs/.bash_profile

# Ubuntu has a default .bashrc
[ ! -e /etc/bash.bashrc ] || mv /etc/bash.bashrc /etc/bash.bashrc.NOUSE
