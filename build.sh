#!/bin/bash

echo "Install Development tools"
toolbox run sudo dnf -y groupinstall "Development Tools"

echo "Install kernel, kernel-modules, kernel-devel"
toolbox run sudo dnf -y install kernel kernel-modules kernel-devel --best

echo "make ashmem_linux"
toolbox run make clean -C ashmem/
toolbox run make -C ashmem/

echo "insmod ashmen_linux"
if [ -n "$TOOLBOX_PATH"  ]
then
     echo "try unloading old ashmem_linux kernel module"
     flatpak-spawn --host sudo -S rmmod ashmem_linux || true

     echo "try loading new ashmem_linux kernel module"
     flatpak-spawn --host sudo -S insmod ./ashmem/ashmem_linux.ko
else
     echo "try unloading old ashmem_linux kernel module"
     sudo rmmod ashmem_linux || true

     echo "try loading new ashmem_linux kernel module"
     sudo insmod ./ashmem/ashmem_linux.ko
fi
