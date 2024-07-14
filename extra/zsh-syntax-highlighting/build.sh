pkgname=zsh-syntax-highlighting
pkgver=0.7.1

iifetch() {
	curl -L "https://github.com/zsh-users/$pkgname/tarball/$pkgver" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
	mv zsh-users-$pkgname-* $pkgname-$pkgver
}

build() {
	cd $pkgname-$pkgver
	make
}

package() {
	cd $pkgname-$pkgver
	make PREFIX="/usr" SHARE_DIR="$pkgdir/usr/share/zsh/plugins/$pkgname" DESTDIR="$pkgdir" install
}

license() {
	cd $pkgname-$pkgver
	cat COPYING.md
}
