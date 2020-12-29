pkgver=0.0.0
pkgname=kati
pkgrel=1

fetch() {
	git clone --depth=1 "https://github.com/google/kati"
}

build() {
	cd $pkgname
	ckati
}

package() {
	cd $pkgname
	install -d $pkgdir/bin
	install -Dm755 ./ckati $pkgdir/bin/
}

license() {
	cd $pkgname
	cat LICENSE
}
