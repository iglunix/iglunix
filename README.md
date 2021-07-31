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
Iglunix has been tested to work on OpenBSD. (don't forget to symlink `libc.so`
otherwise the toolchain breaks).

### Darwin
I have found no easy way of building libc on Darwin platforms as on yet.
Because of this I haven't got far at all porting Iglunix to Darwin
based systems such as MacOS and PureDarwin.

## Web Browsers
Iglunix doesn't currently have any working web browsers yet however we do have
a WIP WebKit port (WPM or WebKit Platform for Minimal systems). Currently
WebKit builds with all our work and we're currently working on exposing an API
to use it. JavaScriptCore API works perfectly and example programs run with no
issue.

## TODO (lots more TODO items in the Discord)
 - LLVM (Work out how to split packages)
 - QEMU for multiarch (need lots of work on glibr to get this to build)
