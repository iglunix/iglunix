# Iglunix
Unix like software distribution with no GNU components

All build scripts are 0BSD Licensed.


For the build system see https://github.com/iglunix/iglunix-autobuild

## Discord
[link](https://discord.gg/NKB9qD2bMx)

## TODO
 - WebKit - Need to port WebKit somehow since no browers will build for this
 - Wayland Compositors - No Wayland compositors currently work perfectly. I think this is because of the lack of udev or lack of logind
 - LLVM (Work out how to split packages)
 - FreeBSD Kernel (bootloader?, syslinux should support it)
 - FreeBSD libc? Standalone build how? (rly need LLVM libc)
 - Init system ( paralel shit and dependencies )
 - QEMU for multiarch
 - Lots of work on package manager still required
