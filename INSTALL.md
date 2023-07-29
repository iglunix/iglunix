# Iglunix Installation Guide

## Getting an installation image
There are two ways of getting hold of an install image: From the releases tab on
GitHub and with [iglunix-autobuild](https://github.com/iglunix/iglunix-autobuild).

### Using Autobuild
```
git clone https://github.com/iglunix/iglunix-autobuild
cd iglunix-autobuild
./autobuild.sh
./chroot.sh
./img.sh
```

### Writing the image
Write the image to a USB to boot on the target computer.
Make sure to triple check which disk you're writing to.
```
dd if=build/iglunix.img of=/dev/sdX bs=64M
```

## Disk Partitioning
Iglunix recommends a two partition layout with an MBR partition table, a FAT
formatted boot partition and an EXT4 formatted root partition. The following
is a guide on how to do it where `/dev/disk` is the target install disk.
```
fdisk /dev/disk
>o
>n
>p
>1
>2048
>+512M
>t
>ef
>n
>p
>2
>
>
>w

mkfs.vfat -n BOOT /dev/disk1
mkfs.ext4 -L ROOT /dev/disk2
mkdir /install_root
mount /dev/disk2 /install_root
mkdir /install_root/boot
mount /dev/disk1 /install_root/boot
```

## Extracting Packages
For any packages you want to install
```
tar -I zstd -xf /mnt/<pkgname>.<pkgver>.tar.zst -C /install_root
```

## The init system
Use https://github.com/iglunix/iglunix/tree/main/init not https://github.com/iglunix/init

## Installing Bootloaders

```
limine-deploy /dev/disk
cp /usr/share/limine/limine.sys /install_root/boot
# If the oslo package wasn't installed earlier and you want UEFI support
cp /usr/share/limine/BOOTX64.EFI /install_root/boot/efi/boot/bootx64.efi
```
Edit `/install_root/boot/efi/oslo/entries.ini` and `/install_root/boot/limine.cfg`
accordingly


## Further reading

https://docs.kernel.org/admin-guide/initrd.html#obsolete-root-change-mechanism
https://man7.org/linux/man-pages/man2/pivot_root.2.html
