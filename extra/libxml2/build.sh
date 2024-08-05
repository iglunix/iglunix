_pkgver=2.13
pkgver=$_pkgver.2
pkgname=libxml2
bad=""
ext="dev"

fetch() {
	curl -L "https://download.gnome.org/sources/libxml2/$_pkgver/libxml2-$pkgver.tar.xz" -o $pkgname-$pkgver.tar.gz
	tar -xf $pkgname-$pkgver.tar.gz
}

backup() {
    return
}

build() {
	cd $pkgname-$pkgver
	./configure --prefix=/usr --without-python
	bad --gmake gmake
}

package() {
    cd $pkgname-$pkgver
    bad --gmake gmake install DESTDIR=$pkgdir
}

package_dev() {
    cd $pkgname-$pkgver
    bad --gmake gmake install DESTDIR=$pkgdir
}

license() {
    cd $pkgname-$pkgver
    cat Copyright
}
