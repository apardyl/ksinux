#!/bin/bash

MENUCONFIG_TYPE=menuconfig

set -e

source ./functions.sh
source ./versions.sh

prepare_kernel

( cd ./build/linux-"$KERNEL_VERSION" && make "$MENUCONFIG_TYPE" )

cp ./build/linux-"$KERNEL_VERSION"/.config ./configs/kernel
