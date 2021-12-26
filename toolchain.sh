#!/bin/bash

export LFS=/mnt/lfs

cd $LFS/sources/
### Binutils Pass 1 -----------------------------
# Patch is not required until Pass 3.

# Only build if there's no binutils pass 1 created
if [[ ! -f $LFS/tools/bin/ld ]]; then

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

fi
### Binutils Pass 1 -----------------------------
### GCC Pass 1 ----------------------------------
if [[ ! -f $LFS/tools/bin/ld/x86_64-lfs-linux-gnu-gcc ]]; then

	echo "gcc"
	cd $LFS/sources/
	
	[[ -d gcc-11.2.0 ]] && rm -rf gcc-11.2.0
	
	tar -xf gcc-11.2.0.tar.xz
	cd gcc-11.2.0
	
	# Section 5.3.1: requires mpfr, gmp, mpc -- replace them
	tar -xf ../mpfr-4.1.0.tar.xz
	rm -rf mpfr && mv -f mpfr-4.1.0 mpfr
	tar -xf ../gmp-6.2.1.tar.xz
	rm -rf gmp && mv -f gmp-6.2.1 gmp
	tar -xf ../mpc-1.2.1.tar.gz
	rm -rf mpc && mv -f mpc-1.2.1 mpc
	
	# Modify the gcc file to set lib instead of lib64
	sed -e '/m64=/s/lib64/lib/' -i.orig gcc/config/i386/t-linux64
	
	mkdir build
	cd build
	
	# Configure
	../configure \
		--target=$LFS_TGT \
		--prefix=$LFS/tools \
		--with-glibc-version=2.11 \
		--with-sysroot=$LFS \
		--with-newlib \
		--without-headers \
		--enable-initfini-array \
		--disable-nls \
		--disable-shared \
		--disable-multilib \
		--disable-decimal-float \
		--disable-threads \
		--disable-libatomic \
		--disable-libgomp \
		--disable-libquadmath \
		--disable-libssp \
		--disable-libvtv \
		--disable-libstdcxx \
		--enable-languages=c,c++
	
	# Compile
	make
	
	# Install
	make install -j1
fi
### GCC Pass 1 ----------------------------------
