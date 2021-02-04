pkgname=tiny-linux-bootloader
pkgver=master

fetch() {
	curl -L "https://github.com/owenson/tiny-linux-bootloader/archive/master.tar.gz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
	cd $pkgname-$pkgver
	patch build.sh /lazybox/patches/tiny-linux-bootloader-build 
}

package() {
	cd $pkgname-$pkgver
	mkdir /tiny-linux-bootloader
	CURR_DIR=$(pwd)
	cd /lazybox
	./geninitrd.sh
	
	cd $CURR_DIR
	./build.sh
	
	cd /lazybox
	./createimg.sh
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
}
