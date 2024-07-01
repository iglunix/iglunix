pkgname=go
pkgver=1.16

# TODO(Ella): should be loaded from `/etc/iglupkg.d/go.conf`
GOROOT_BOOTSTRAP=/usr/lib/go

fetch() {
	curl -L "https://golang.org/dl/go${pkgver/_/}.src.tar.gz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
	mv go go-$pkgver
}

build() {
	cd $pkgname-$pkgver
	cd src
	GOROOT_BOOTSTRAP=/usr/lib/go ./make.bash
}

package() {
	cd $pkgname-$pkgver
	install -d $pkgdir/usr/bin
	install -d $pkgdir/usr/lib/go
	cp -a bin pkg src lib misc api test $pkgdir/usr/lib/go

	ln -s ../../lib/go/bin/go $pkgdir/usr/bin/go
	ln -s ../../lib/go/bin/gofmt $pkgdir/usr/bin/gofmt
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
}
