# lazybox
Unix like software distribution with no GNU components

All build scripts are 0BSD Licensed.


## TODO
 - Switch to different file system layout (follow standard)
 - Switch to making single utilities with busybox and toybox
 - LLVM (Work out how to split packages)
 - LLVM Sort out the symlinking madness
 - Linux kernel (no perl patch, byacc patch)
 - FreeBSD Kernel (bootloader?, syslinux should support it)
 - FreeBSD libc? Standalone build how? (rly need LLVM libc)
 - Init system ( paralel shit and dependencies )
 - QEMU for multiarch

## New File System Layout
__**NO LIB64 or LIB32**__
```
/bin
/boot
/dev
/etc
/home
/lib
/mnt
/opt
/proc
/root
/run
/sbin
/srv
/sys
/tmp
/usr
 |--/bin
 |--/include
 |--/lib
 |--<arch>-linux-musl => .
 |--aarch64-linux-musl
 
/var
```
