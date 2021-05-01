# [Iglunix](https://iglunix.xyz/)
Unix like software distribution with no GNU components

All build scripts are 0BSD Licensed.


To create an ISO from a non-iglunix OS please see https://github.com/iglunix/iglunix-autobuild

## Discord
Join us at [link](https://discord.gg/NKB9qD2bMx)

## Status of Other Kernels

### FreeBSD
FreeBSD has solid upstream LLVM support which would make it ideal for iglunix.
However, I haven't been successful at building the required parts of the base
system.

### OpenBSD
OpenBSD's build system is much easier to work with that FreeBSD's (we can just
cd to the required directories, run make and install required files). However,
I wasn't successful on getting upstream clang to build working binaries so
the system can't be self hosting at the moment.

### Darwin
I have found no easy way of building libc on Darwin platforms as on yet.
Because of this I haven't got far at all porting Iglunix to Darwin
based systems such as MacOS and PureDarwin.

## TODO
 - WebKit - Need to port WebKit somehow since no browers will build for this
 - Wayland Compositors - No Wayland compositors currently work perfectly. I think this is because of the lack of udev or lack of logind
 - LLVM (Work out how to split packages)
 - Init system (parallel stuff and dependencies)
 - QEMU for multiarch
 - Lots of work on package manager still required
