pkgname=hack
pkgver=3.003                                                                                                         
                                                                                                                     
iifetch() {                                                                                                            
        mkdir $pkgname-$pkgver         
        cd $pkgname-$pkgver
	curl -L "https://github.com/source-foundry/Hack/releases/download/v$pkgver/Hack-v$pkgver-ttf.tar.xz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz                                                                              
                                                                                                                     
}                                                                                                                    
                                                                                                                     
build() {                                                                                                            
	cd $pkgname-$pkgver
}                                                                                                                    
                                                                                                                     
backup() {                                                                                                           
}                                                                                                                    
                                                                                                                     
package() {                                                                                                          
        cd $pkgname-$pkgver                                                                                          
        mkdir -p $pkgdir/usr/share/fonts                                                                                                         
        mv ./* $pkgdir/usr/share/fonts                                                                          
}                                                                                                                    
                                                                                                                     
license() {                                                                                                          
        cd $pkgname-$pkgver                                                                                          
#       cat LICENSE                                                                                                  
#       cat COPYING
	echo "MIT"                                                                                                  
}           
