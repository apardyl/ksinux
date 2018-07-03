#!/bin/bash

set -e

source functions
source versions

prepare_busybox

( cd ./build/busybox-"$BUSYBOX_VERSION" && make menuconfig )

cp ./build/busybox-"$BUSYBOX_VERSION"/.config ./configs/busybox
