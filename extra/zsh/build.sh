pkgname=zsh
pkgver=5.9
ext=doc

fetch() {
	curl "https://www.zsh.org/pub/zsh-$pkgver.tar.xz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
	cp ../zprofile.zsh .
}

build() {
	cd $pkgname-$pkgver
	./configure \
		--prefix=/usr \
		--build=$TRIPLE \
		--host=$TRIPLE

	#make || echo "first make failed"
	bad --gmake gmake
}

backup() {
}

package() {
	cd $pkgname-$pkgver
	make install DESTDIR=$pkgdir
	install -d /etc
	install -Dm644 ../zprofile.zsh $pkgdir/etc/zprofile
	rm -rf $pkgdir/usr/share/man
}

package_doc() {
	cd $pkgname-$pkgver
	make install.man DESTDIR=$pkgdir
}

license() {
	cd $pkgname-$pkgver
	cat LICENCE
#	cat COPYING
}
