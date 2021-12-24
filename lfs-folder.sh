#!/bin/bash
# Create the linux folder structure
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
