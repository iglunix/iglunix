pkgname=limine
pkgver=2.55
mkdeps="nasm:llvm"

fetch() {
	curl -L "https://github.com/limine-bootloader/limine/releases/download/v$pkgver/limine-v$pkgver.tar.xz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
	mv $pkgname-v$pkgver $pkgname-$pkgver
}

build() {
	cd $pkgname-$pkgver
	gmake limine-bios bin/limine-install CC="clang" TOOLCHAIN="llvm" TOOLCHAIN_CC="clang" TOOLCHAIN_LD="ld.lld" -j1
}

package() {
	cd $pkgname-$pkgver
	mkdir -p $pkgdir/usr/sbin/
	install -m 755 ./bin/limine-install $pkgdir/usr/sbin/
	mkdir -p $pkgdir/usr/share/limine/
	install -m 644 ./bin/limine-cd.bin $pkgdir/usr/share/limine/
	install -m 644 ./bin/limine-hdd.bin $pkgdir/usr/share/limine/
	install -m 644 ./bin/limine-pxe.bin $pkgdir/usr/share/limine/
	install -m 644 ./bin/limine.sys $pkgdir/usr/share/limine/
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE.md
}
