pkgname=tiny-linux-bootloader
pkgver=master

fetch() {
	curl -L "https://github.com/owenson/tiny-linux-bootloader/archive/master.tar.gz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
	cd $pkgname-$pkgver
	patch -p1 < ../../build.patch
        patch -p1 < ../../bsect.patch
}

package() {
	cd $pkgname-$pkgver
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
