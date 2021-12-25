#!/bin/bash

export LFS=/mnt/lfs

# Binutils Pass 1
# Patch is not required until Pass 3.
cd $LFS/sources/

tar -xf binutils-2.37.tar.xz
[[ ! -d binutils-2.37/build ]] && mkdir binutils-2.37/build
cd binutils-2.37/build

# Configure compilation
../configure --prefix=$LFS/tools \
	--with-sysroot=$LFS \
	--target=$LFS_TGT \
	--disable-nls \
	--disable-werror

# Compile
make

# Install
make install -j1
