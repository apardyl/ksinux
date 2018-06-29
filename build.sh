#!/bin/bash

DIR=$(pwd)
NCPU=$(nproc)

mkdir -p ./deps
mkdir -p ./build

source ./configs/versions

if [ ! -d ./build/linux-"$KERNEL_VERSION" ]; then
	if [ ! -f ./deps/linux-"$KERNEL_VERSION".tar.xz ]; then
		echo "Fetching linux sources"
		wget "https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-$KERNEL_VERSION.tar.xz" -O ./deps/linux-"$KERNEL_VERSION".tar.xz
	fi
	echo "Unpacking linux"
	tar -xf ./deps/linux-"$KERNEL_VERSION".tar.xz -C ./build
	ln -s ../../configs/kernel build/linux-4.16.18/.config
fi

( cd ./build/linux-"$KERNEL_VERSION" && make -j "$NCPU" )
