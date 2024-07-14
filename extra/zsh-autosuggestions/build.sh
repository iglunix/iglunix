pkgname=zsh-autosuggestions
pkgver=0.6.4

iifetch() {
	curl -L "https://github.com/zsh-users/$pkgname/archive/v$pkgver.tar.gz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
	#mv zsh-users-$pkgname-* $pkgname-$pkgver
}

build() {
	cd $pkgname-$pkgver
	make
}

package() {
	cd $pkgname-$pkgver
	install -Dm644 ./$pkgname.zsh "$pkgdir/usr/share/zsh/plugins/$pkgname/"
	install -Dm644 ./$pkgname.plugin.zsh "$pkgdir/usr/share/zsh/plugins/$pkgname/"
	
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
}
