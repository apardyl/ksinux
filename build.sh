#!/bin/bash

set -e

DIR=$(pwd)
N_CPU=$(nproc)

mkdir -p ./build

source versions.sh
source ./functions.sh

prepare_kernel

( cd ./build/linux-"$KERNEL_VERSION" && make -j "$N_CPU" )

prepare_busybox

( cd ./build/busybox-"$BUSYBOX_VERSION" && make -j "$N_CPU" )
