#!/bin/bash

df -h

mkdir disco_diretorio

dd if=/dev/zero of=disco_virtual.img bs=1M count=100
mkfs.ext4 -F disco_virtual.img

mount -o loop disco_virtual.img disco_diretorio
cp /etc/passwd /etc/group disco_diretorio
sudo umount disco_diretorio
