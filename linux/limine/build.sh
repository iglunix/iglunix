pkgname=limine
pkgver=4.0
mkdeps="nasm:llvm"
auto_cross

fetch() {
	curl -L "https://github.com/limine-bootloader/limine/releases/download/v$pkgver/limine-$pkgver.tar.xz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
}

build() {
	cd $pkgname-$pkgver
	export LIMINE_CC=clang
	bad --gmake ./configure \
		--build=$HOST_TRIPLE \
		--host=$TRIPLE \
		--prefix=/usr \
		--enable-bios \
		--enable-efi-x86_64 \
		--enable-limine-deploy
	bad --gmake gmake
}

package() {
	cd $pkgname-$pkgver
	bad --gmake gmake install DESTDIR=$pkgdir
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE.md
}

backup() {
	return
}
