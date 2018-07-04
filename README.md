# ksinux
Debian based Linux distribution for diskless workstations

## Configuration
* NFS server and path: ./initramfs/init
* packages list and versions: ./packages, ./versions

## Building
* run ./build.sh and make yourself a sandwich
* place rootfs.squash on NFS server
* install vmlinuz-* on TFTP boot server (or test with `qemu-system-x86_64 -kernel <vmlinuz file> 
-m 4096 <network and vga configuration>`)
