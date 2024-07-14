pkgname=tiny-linux-bootloader
pkgver=master

ifetch() {
	curl -L "https://github.com/owenson/tiny-linux-bootloader/archive/master.tar.gz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
	cd $pkgname-$pkgver
	patch -p1 < ../../build.patch
        patch -p1 < ../../bsect.patch
        patch -p1 < ../../remove-dead.patch
}

package() {
	cd $pkgname-$pkgver

	rm -rf /tiny-linux-bootloader
	mkdir /tiny-linux-bootloader
	CURR_DIR=$(pwd)

	cd ./../../../../
	./geninitrd.sh

	cd $CURR_DIR
	./build.sh

	cd ./../../../../
	./createimg.sh
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
}
