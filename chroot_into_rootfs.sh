#!/bin/bash

source functions

echo "You probably should not use this - update the build configuration instead."

sudo bash -c "source functions; setup_chroot; chroot build/rootfs /bin/bash; teardown_chroot"
