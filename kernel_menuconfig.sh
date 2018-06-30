#!/bin/bash

set -e

source ./functions.sh
source ./versions.sh

prepare_kernel

( cd ./build/linux-"$KERNEL_VERSION" && make menuconfig )

cp ./build/linux-"$KERNEL_VERSION"/.config ./configs/kernel
