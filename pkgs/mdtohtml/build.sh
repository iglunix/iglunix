pkgname=mdtohtml
pkgver=master

fetch() {
	curl -L "https://github.com/gomarkdown/mdtohtml/archive/refs/heads/master.tar.gz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
	cp ../go.mod .
	cp ../go.sum .
	cp ../exts.patch .
	cd $pkgname-$pkgver
	patch -p1 < ../exts.patch
}

build() {
	cd $pkgname-$pkgver
	mkdir build
	cp ../go.mod .
	cp ../go.sum .
	go build -o build
}

package() {
	cd $pkgname-$pkgver
	install -Dm755 build/$pkgname $pkgdir/usr/bin/$pkgname
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
#	cat COPYING
}
