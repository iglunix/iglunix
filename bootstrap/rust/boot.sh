#!/bin/sh

ARCH=aarch64
CHAN=beta
LIBUNWIND=/usr/lib/libunwind.so.1

mkdir -p build

echo 'Downloading rust tar'
stat build/rust.tar > /dev/null 2> /dev/null \
|| curl "https://static.rust-lang.org/dist/rust-$CHAN-$ARCH-unknown-linux-musl.tar.gz" -o build/rust.tar

echo 'Extracting rust tar'
stat build/rust-$CHAN-$ARCH-unknown-linux-musl > /dev/null 2> /dev/null \
|| tar -xf build/rust.tar -C build

echo 'Building libgcc_s.so'
stat build/libgcc_s.so > /dev/null 2> /dev/null \
|| clang -shared -o build/libgcc_s.so \
-Wl,--allow-multiple-definition -Wl,--whole-archive \
$(clang -print-libgcc-file-name)

mkdir -p build/rust-root

echo 'Installing rust to rust-root'

stat build/rust-root/lib/rustlib/uninstall.sh > /dev/null 2> /dev/null \
|| ./build/rust-$CHAN-$ARCH-unknown-linux-musl/install.sh \
--disable-ldconfig \
--destdir=$(pwd)/build/rust-root \
--prefix=/

# Can't just symlink here 'cause rustc needs __clear_cache which isn't exposed
# by libunwind
echo 'Copying libgcc_s shim'
stat $(pwd)/build/rust-root/lib/libgcc_s.so.1 > /dev/null 2> /dev/null \
|| cp $(pwd)/build/libgcc_s.so $(pwd)/build/rust-root/lib/libgcc_s.so.1

# Symlink libunwind for dynamic builds to link to
echo 'Symlinking libunwind'
stat $(pwd)/build/rust-root/lib/rustlib/aarch64-unknown-linux-musl/lib/libgcc_s.so > /dev/null 2> /dev/null \
|| ln -sr $LIBUNWIND $(pwd)/build/rust-root/lib/rustlib/aarch64-unknown-linux-musl/lib/libgcc_s.so

export RUSTC=$(pwd)/build/rust-root/bin/rustc

echo "Checking Sanity"

$RUSTC sanity.rs -C target-feature=-crt-static -o build/sanity
./build/sanity
