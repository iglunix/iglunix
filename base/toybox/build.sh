pkgver=0.8.6
pkgname=toybox
pkgrel=1
deps="musl"

fetch() {
	curl "http://www.landley.net/toybox/downloads/$pkgname-$pkgver.tar.gz" -o $pkgname-$pkgver.tar.gz
	tar -xf $pkgname-$pkgver.tar.gz
	curl "https://pci-ids.ucw.cz/v2.2/pci.ids" -o pci.ids
	cd $pkgname-$pkgver
	patch -p1 < ../../ls-colour.patch
	patch -p1 < ../../mksh-make.patch
	patch -p1 < ../../xxd-i.patch
}

build() {
	cd $pkgname-$pkgver
	CPUS=1 bad --gmake gmake defconfig
	CPUS=1 bad --gmake gmake
}

backup() {
	return
}

package() {
	install -d $pkgdir/usr/share/misc
	install -Dm 644 pci.ids $pkgdir/usr/share/misc

	cd $pkgname-$pkgver
#	install -d $pkgdir/bin
#	install -Dm755 ./toybox $pkgdir/bin/
#	ln -sr $pkgdir/bin/toybox $pkgdir/bin/ln
#	ln -sr $pkgdir/bin/toybox $pkgdir/bin/uname
#	install -d $pkgdir/usr/bin
#	ln -sr $pkgdir/bin/toybox $pkgdir/usr/bin/install
#	ln -sr $pkgdir/bin/toybox $pkgdir/usr/bin/lspci
	bad --gmake gmake PREFIX=$pkgdir install

	# Provided by NetBSD Curses
	rm $pkgdir/usr/bin/clear
	rm $pkgdir/usr/bin/reset

	# LLVM Provides this
	rm $pkgdir/usr/bin/readelf
#	rm $pkgdir/usr/bin/tar
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
}
