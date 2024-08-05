pkgver=0.8.11
pkgname=toybox
pkgrel=1
mkdeps="bad:gmake"
deps="musl"
desc="all-in-one Linux command line."

fetch() {
	curl -O "https://landley.net/toybox/downloads/toybox-$pkgver.tar.gz"
	tar -xf $pkgname-$pkgver.tar.gz
	cd $pkgname-$pkgver
	patch -p1 < ../../ls-colour.patch
	patch -p1 < ../../mksh.patch
	patch -p1 < ../../mksh2.patch
	patch -p1 < ../../xxd-i.patch

	sed -i 's|/usr/share/misc|/usr/share/hwdata|' toys/other/lsusb.c
}

build() {
	cd $pkgname-$pkgver
	CPUS=1 bad --gmake gmake defconfig
	# sed 's|# CONFIG_SH is not set|CONFIG_SH=y|' .config > /tmp/_
	# mv /tmp/_ .config
	CPUS=1 bad --gmake gmake
}

backup() {
	return
}

package() {
	cd $pkgname-$pkgver
	bad --gmake gmake PREFIX=$pkgdir install

	# Provided by NetBSD Curses
	rm $pkgdir/usr/bin/clear
	rm $pkgdir/usr/bin/reset

	# LLVM Provides this
	rm $pkgdir/usr/bin/readelf
#	rm $pkgdir/usr/bin/tar

	# MKSH provides this
	#rm $pkgdir/bin/sh
	#rm $pkgdir/bin/bash
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
}
