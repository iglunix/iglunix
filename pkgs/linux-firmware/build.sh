pkgname=linux-firmware
pkgver=20210208

fetch() {
	curl "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/snapshot/linux-firmware-20210208.tar.gz" -o $pkgname-$pkgver.tar.gz
	tar -xf $pkgname-$pkgver.tar.gz
}

build() {
	echo "Nothing to do"
}

package() {
	cd $pkgname-$pkgver
	make install DESTDIR=$pkgdir FIRMWAREDIR="/lib/firmware"
}

license() {
	cd $pkgname-$pkgver
	cat LICENCE.*
}
