# Lazybox Linux


## Building
Inorder to build from source you need a complete LLVM/Musl toolchain.
I have provided one on the releases page on this repo.

```sh
tar -xf llvm...tar.xz -C $LBROOT

```

Next one must install musl from source
```sh
./configure --prefix=/usr --enable-wrapper=no
make
make install DESTDIR=$LBROOT
```
Next one must grab the binary releases of busybox and toybox from
their respective websites and place them in `$LBROOT/bin`


Next one needs to chroot into `$LBROOT`
```sh
doas chroot $LBROOT /bin/busybox --install -s
doas chroot $LBROOT /bin/sh
```
One may need to adjust their `$PATH`.

One needs to cross compile GNU Make and place it in `/usr/bin/gmake`

From here one needs to build the first package, `mksh` which will
allow one to rebuild `toybox` and `busybox`.

Clone this git repo into `$LBROOT/root/lazybox` and then chroot to `$LBROOT`
```sh
cd /root/lazybox

cd pkgs/mksh
../../lazypkg.sh
tar -xf out/mksh*.tar.xz -C /

cd ../..

cd pkgs/bmake
../../lazypkg.sh
tar -xf out/bmake*.tar.xz -C /

cd ../..

cd pkgs/gmake
../../lazypkg.sh
tar-xf out/gmake*.tar.xz -C /

cd ../../
```
Build packages like above. There is a problem with building CMake as it needs LibreSSL but LibreSSL needs CMake to build.
To get around this one will need to manually build LibreSSL with `./configure` first, then build CMake then rebuild
LibreSSL.
