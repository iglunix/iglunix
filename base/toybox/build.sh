pkgver=0.8.7
pkgname=toybox
pkgrel=1
deps="musl"

fetch() {
	curl -O "https://landley.net/toybox/downloads/toybox-$pkgver.tar.gz"
	tar -xf $pkgname-$pkgver.tar.gz
	curl "https://pci-ids.ucw.cz/v2.2/pci.ids" -o pci.ids
	cd $pkgname-$pkgver
	patch -p1 < ../../ls-colour.patch
	patch -p1 < ../../mksh.patch
	patch -p1 < ../../xxd-i.patch
}

build() {
	cd $pkgname-$pkgver
	CPUS=1 bad --gmake gmake defconfig
	sed 's|# CONFIG_SH is not set|CONFIG_SH=y|' .config > /tmp/_
	mv /tmp/_ .config
	CPUS=1 bad --gmake gmake
}

backup() {
	return
}

package() {
	install -d $pkgdir/usr/share/misc
	install -Dm 644 pci.ids $pkgdir/usr/share/misc

	cd $pkgname-$pkgver
	bad --gmake gmake PREFIX=$pkgdir install

	# Provided by NetBSD Curses
	rm $pkgdir/usr/bin/clear
	rm $pkgdir/usr/bin/reset

	# LLVM Provides this
	rm $pkgdir/usr/bin/readelf
#	rm $pkgdir/usr/bin/tar

	# MKSH provides this
	rm $pkgdir/bin/sh
	rm $pkgdir/bin/bash
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
}
