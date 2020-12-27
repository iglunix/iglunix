fetch() {
	# in ./src
	# for fetching and patching source files
}

build() {
	# in ./src
	# configure and build
	./configure --prefix=/
	# make is bmake
	make
}

package() {
	# in ./src
	# make is bmake
	make install DESTDIR=$pkgdir
	# samurai is the default ninja implementation
	DESTDIR=$pkgdir samu install
	# for rust programs we just do this
	install -Dm755 target/release/$pkgname $pkgdir/bin
}
