#!/bin/bash

# remount root rw
mount -o remount,rw /

# prapare target paths
mkdir -p /chroot
mkdir -p /chroot/{bin,boot,dev,etc,home,lib,opt,proc,root,run,sbin,sys,tmp,usr,var}

# mount special filesystems
mount -t proc proc /chroot/proc
mount --rbind /sys /chroot/sys
mount --rbind /dev /chroot/dev

# bind rw directories
for f in {etc,var}; do mount --rbind /${f}_org /chroot/$f; done
