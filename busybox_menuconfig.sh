#!/bin/bash

set -e

source ./functions.sh
source ./versions.sh

prepare_busybox

( cd ./build/busybox-"$BUSYBOX_VERSION" && make menuconfig )

cp ./build/busybox-"$BUSYBOX_VERSION"/.config ./configs/busybox
