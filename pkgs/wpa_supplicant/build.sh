pkgname=wpa_supplicant
pkgver=2.9

fetch() {
	curl "https://w1.fi/releases/wpa_supplicant-2.9.tar.gz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
	cp ../config .
}

build() {
	#############################################################################
	# This software is unlikely to be secure in the way that we are building it #
	#                                                                           #
	#                           USE AT YOUR OWN RISK!                           #
	#                                                                           #
	#############################################################################



	cd $pkgname-$pkgver
	cd $pkgname
	cp ../../config .config
	
	gmake
}

package() {
	cd $pkgname-$pkgver
	cd $pkgname
	gmake install DESTDIR=$pkgdir BINDIR=/usr/sbin
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
#	cat COPYING
}
