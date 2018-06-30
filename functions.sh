#!/bin/bash

source ./versions.sh

prepare_kernel () {
    if [ ! -d ./build/linux-"$KERNEL_VERSION" ]; then
        if [ ! -f ./deps/linux-"$KERNEL_VERSION".tar.xz ]; then
            echo "Fetching linux sources"
            mkdir -p ./deps
            wget "https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-$KERNEL_VERSION.tar.xz" -O ./deps/linux-"$KERNEL_VERSION".tar.xz
        fi
        echo "Unpacking linux"
        mkdir -p ./build
        tar -xf ./deps/linux-"$KERNEL_VERSION".tar.xz -C ./build
        cp ./configs/kernel ./build/linux-"$KERNEL_VERSION"/.config
    fi
}

prepare_busybox () {
    if [ ! -d ./build/busybox-"$BUSYBOX_VERSION" ]; then
            if [ ! -f ./deps/busybox-"$BUSYBOX_VERSION".tar.bz2 ]; then
                    echo "Fetching busybox sources"
                    mkdir -p ./deps
                    wget "http://busybox.net/downloads/busybox-$BUSYBOX_VERSION.tar.bz2" -O ./deps/busybox-"$BUSYBOX_VERSION".tar.bz2
            fi
        echo "Unpacking busybox"
        mkdir -p ./build
        tar -xf ./deps/busybox-"$BUSYBOX_VERSION".tar.bz2 -C ./build
        cp ./configs/busybox ./build/busybox-"$BUSYBOX_VERSION"/.config
    fi
}
