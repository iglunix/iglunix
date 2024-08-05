pkgname=raspberrypi-firmware
pkgver=20210805

fetch() {
	curl -L "https://github.com/raspberrypi/firmware/archive/refs/tags/1.$pkgver.tar.gz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
	mv firmware-1.$pkgver $pkgname-$pkgver
}

build() {
	cd $pkgname-$pkgver

}

package() {
	cd $pkgname-$pkgver
	install -d $pkgdir/boot
	cp ./boot/*.bin $pkgdir/boot	
	cp ./boot/*.dat $pkgdir/boot
	cp ./boot/*.elf $pkgdir/boot
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
#	cat COPYING
}
