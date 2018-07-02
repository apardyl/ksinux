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

install_kernel_headers () {
    if [ ! -d ./build/env/usr/include/linux ]; then
        prepare_kernel
        echo "Installing linux headers"
        ( cd ./build/linux-"$KERNEL_VERSION" && make headers_install )
        mkdir -p ./build/env/usr/
        cp -a ./build/linux-"$KERNEL_VERSION"/usr/include ./build/env/usr/
    fi
}

prepare_glibc () {
    if [ ! -d ./build/glibc-"$GLIBC_VERSION" ]; then
        install_kernel_headers
            if [ ! -f ./deps/glibc-"$GLIBC_VERSION".tar.xz ]; then
                    echo "Fetching glibc sources"
                    mkdir -p ./deps
                    wget "http://ftp.gnu.org/gnu/glibc/glibc-$GLIBC_VERSION.tar.xz" -O ./deps/glibc-"$GLIBC_VERSION".tar.xz
            fi
        echo "Unpacking glibc"
        mkdir -p ./build
        tar -xf ./deps/glibc-"$GLIBC_VERSION".tar.xz -C ./build

        DIR="$(pwd)"
        export CHOST="x86_64-pc-linux-gnu"
        export CFLAGS="-O2 -pipe"
        export CXXFLAGS="$CFLAGS"
        mkdir -p ./build/glibc-"$GLIBC_VERSION"/build
        ( cd ./build/glibc-"$GLIBC_VERSION"/build &&  ../configure \
            --prefix="/usr" \
            --build="x86_64-pc-linux-gnu" \
            --host="x86_64-pc-linux-gnu" \
            --target="x86_64-pc-linux-gnu" \
            --with-headers="$DIR/build/env/usr/include" \
            --with-bugurl="https://ksi.ii.uj.edu.pl/" \
            --enable-kernel="4.9.100" \
            --enable-static-pie \
            --enable-stackguard-randomization \
            --disable-profile \
            --disable-timezone-tools \
            --enable-stack-protector \
            --enable-bind-now \
            --disable-multi-arch \
            --disable-ss-crypt \
            --disable-obsolete-rpc \
            --disable-obsolete-nsl \
            --disable-werror \
            --disable-mathvec \
            --enable-tunables no \
            --disable-build-nscd \
            --disable-nscd
        )
    fi
}

build_glibc () {
    if [ ! -d ./build/glibc-"$GLIBC_VERSION"/build ]; then
        N_CPU=$(nproc)

        prepare_glibc

        echo "Building glibc"

        export CHOST="x86_64-pc-linux-gnu"
        export CFLAGS="-O2 -pipe"
        export CXXFLAGS="$CFLAGS"
        ( cd ./build/glibc-"$GLIBC_VERSION"/build && make -j "$N_CPU" )
        mkdir ./build/env
        DIR="$(pwd)"
        ( cd ./build/glibc-"$GLIBC_VERSION"/build && make install_root="$DIR/build/env" install -j "$N_CPU" )
    fi
}

install_libs () {
    build_glibc

    echo "Installing libs"

    FILES_TO_INSTALL=(
        "etc/ld.so.cache"
        "etc/rpc"
        "lib64/ld-2.27.so"
        "lib64/ld-linux-x86-64.so.2"
        "lib64/libc-2.27.so"
        "lib64/libc.so.6"
    )

    mkdir -p ./build/initramfs/{etc,lib64}

    for file in "${FILES_TO_INSTALL[@]}"; do
        cp -au ./build/env/"$file" ./build/initramfs/"$file"
    done
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

build_busybox () {
    N_CPU=$(nproc)

	prepare_busybox
	install_kernel_headers

	echo "Building busybox"
    ( cd ./build/busybox-"$BUSYBOX_VERSION" && make -j "$N_CPU" )
}

prepare_initramfs () {
    echo "Copying source files"
    mkdir -p ./build/initramfs
    cp -r ./initramfs ./build/
    echo "Creating directory tree"
    mkdir -p ./build/initramfs/{bin,dev,etc,lib,lib64,mnt/root,proc,root,sbin,sys,usr/bin,usr/sbin}
    echo "Creating devices (root required)"
    echo "sudo cp -au /dev/{null,zero,console,tty} ./build/initramfs/dev/"
    sudo cp -au /dev/{null,console,tty} ./build/initramfs/dev/

    echo "Installing libs"
    install_libs

    build_busybox
    echo "Installing busybox (root required)"
    cp ./build/busybox-"$BUSYBOX_VERSION"/busybox ./build/initramfs/bin/busybox
    echo "sudo chroot ./build/initramfs /bin/busybox sh"
    sudo chroot ./build/initramfs /bin/busybox sh << EOF
/bin/busybox --install
EOF
}

build_initramfs () {
    prepare_initramfs
    echo "Packing initramfs"
    ( cd ./build/initramfs/ && find . -print0 | cpio --null -ov --format=newc > ../initramfs.cpio )
}

build_kernel_image () {
	N_CPU=$(nproc)

	build_initramfs

	prepare_kernel

	echo "Building kernel image"

	( cd ./build/linux-"$KERNEL_VERSION" && make bzImage -j "$N_CPU" )

	cp -a ./build/linux-"$KERNEL_VERSION"/arch/x86/boot/bzImage ./vmlinuz-"$KERNEL_VERSION"-ksinux
}

build_kernel_modules () {
    N_CPU=$(nproc)
	prepare_kernel

	echo "Building kernel modules"

	( cd ./build/linux-"$KERNEL_VERSION" && make modules -j "$N_CPU" && make INSTALL_MOD_PATH=../env modules_install -j "$N_CPU")
}
