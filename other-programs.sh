#!/bin/sh

root="$(pwd)"

export PATH="/usr/bin:$PATH"

cleanup () {
	cd "$root"
	read -p "Delete temp folder (y/N)? " yesOrNo
	if [ "$yesOrNo" = "y" ] || [ "$yesOrNo" = "Y" ]; then
		[ -d temp_programs/ ] && trash-put temp_programs/
	fi
}

trap 'cleanup' EXIT

set -e

mkdir -p temp_programs
cd temp_programs

# dev tools
sudo apt install git make gcc automake cmake meson unzip gettext autopoint pkg-config libtool build-essential

[ -d patches/ ] || git clone https://github.com/regexghost/patches

jwm () {
	sudo apt install libxext-dev libxmu-dev libxinerama-dev libxpm-dev libjpeg-dev libpng-dev libpango1.0-dev
	git clone https://github.com/joewing/jwm

	cd jwm

	cp ../patches/jwm-desktop-change.diff .
	cp ../patches/jwm-border-flicker.diff .
	cp ../patches/jwm-caps-lock.diff .
	cp ../patches/jwm-move-unmap.diff .
	cp ../patches/jwm-centered.diff .

	patch -p 1 < jwm-desktop-change.diff
	patch -p 1 < jwm-border-flicker.diff
	patch -p 1 < jwm-caps-lock.diff
	patch -p 1 < jwm-move-unmap.diff
	patch -p 1 < jwm-centered.diff

	./autogen.sh
	gettextize -f
	./configure
	make
	sudo make install
	cd ..
}

bsky () {
	sudo apt install golang
	mkdir bsky
	cd bsky
	url="$(github-latest-release "github" "mattn" "bsky")"
	wget "$url"
	unzip *.zip
	cd */
	make
	cp bsky ~/.local/bin/bsky
	cd ..
	cd ..
}

forgejo () {
	sudo apt install rustup libssl-dev
	rustup default stable
	mkdir forgejo
	cd forgejo
	url="$(github-latest-release "codeberg" "forgejo-contrib" "forgejo-cli")"
	wget "$url"
	unzip *.zip
	cd */
	cargo build --release
	cp target/release/fj ~/.local/bin/fj
	cd ..
	cd ..
}

bat () {
	git clone https://github.com/sharkdp/bat
	cd bat
	cargo build --release
	cp target/release/bat ~/.local/bin/bat
	cd ..
}

gozer () {
	sudo apt install golang
	git clone https://github.com/regexghost/gozer
	cd gozer
	go build
	cp gozer ~/.local/bin
	cd ..
}

less () {
	sudo apt install libncurses-dev
	#mkdir less
	#cd less
	#version="$(curl https://www.greenwoodsoftware.com/less/download.html | grep RECOMMENDED | tail -n 1 | sed -nE 's/.*version ([0-9]*).*/\1/p')"
	#echo $version
	#wget "https://greenwoodsoftware.com/less/less-${version}.zip"
	#unzip *.zip
	#cd */
	git clone https://github.com/gwsw/less
	cd less
	cp ../patches/less-bsu-esu.diff .
	patch < less-bsu-esu.diff
	make -f Makefile.aut distfiles
	./configure --prefix="$HOME/.local"
	make
	make install
	cd ..
	#cd ..
}

nano () {
	mkdir nano
	cd nano
	version="$(curl "https://www.nano-editor.org/download.php" | grep "dist/" | head -n 1 | cut -d "\"" -f 2)"
	wget "https://nano-editor.org/${version}"
	tar -xf *.xz
	cd */
	./configure --prefix="$HOME/.local"

	cp ../../patches/nano-copy-system.diff .
	patch -p 1 < nano-copy-system.diff

	make
	make install
	cd ..
	cd ..
}

oksh () {
	mkdir oksh
	cd oksh
	url="$(github-latest-release "github" "ibara" "oksh")"
	wget "$url"
	unzip *.zip
	cd */
	cp ../../patches/oksh-case-insensitive.diff .
	cp ../../patches/oksh-history.diff .
	cp ../../patches/oksh-ctrl-backspace-delete.diff .
	patch < oksh-case-insensitive.diff
	patch < oksh-history.diff
	patch < oksh-ctrl-backspace-delete.diff
	./configure
	make
	sudo make install
	cd ..
	cd ..
}

opustags () {
	sudo apt install libogg-dev
	mkdir opustags
	cd opustags
	url="$(github-latest-release "github" "fmang" "opustags")"
	wget "$url"
	unzip *.zip
	cd */
	mkdir build
	cd build
	cmake -DCMAKE_INSTALL_PREFIX="$HOME/.local" ..
	make
	make install
	cd ..
	cd ..
	cd ..
}

rsgain () {
	sudo apt install libavcodec-dev libavformat-dev libtag-dev libebur128-dev libinih-dev libfmt-dev
	mkdir rsgain
	cd rsgain
	url="$(github-latest-release "github" "complexlogic" "rsgain")"
	wget "$url"
	unzip *.zip
	cd */
	mkdir build
	cd build
	cmake -DCMAKE_INSTALL_PREFIX="$HOME/.local" ..
	make
	make install
	cd ..
	cd ..
	cd ..
}

newsraft () {
	sudo apt install libcurl4-openssl-dev libsqlite3-dev libgumbo-dev
	git clone https://codeberg.org/newsraft/newsraft
	cd newsraft
	make PREFIX="$HOME/.local"
	make install PREFIX="$HOME/.local"
	cd ..
}

aacgain () {
	git clone --recursive https://github.com/dgilman/aacgain
	cd aacgain
	mkdir build
	cd build
	cmake -DCMAKE_INSTALL_PREFIX="$HOME/.local" ..
	make
	make install
	cd ..
	cd ..
}

bug () {
	git clone https://github.com/regexghost/bug-fork
	cd bug-fork
	make install
	cd ..
}

st () {
	sudo apt install libgd-dev papirus-icon-theme libxft-dev

	git clone https://github.com/regexghost/st
	cd st
	make full
	sudo make install
	cd ..

}

dmenu () {
	sudo apt install libxinerama-dev

	git clone https://github.com/regexghost/dmenu
	cd dmenu
	make full
	sudo make install
	cd ..

}

slock () {
	sudo apt install libxrandr-dev libimlib2-dev
	git clone https://github.com/regexghost/slock
	cd slock
	make full
	sudo make install
	cd ..
}

bluetui () {
	mkdir bluetui
	cd bluetui
	url="$(github-latest-release "github" "pythops" "bluetui")"
	wget "$url"
	unzip *.zip
	cd */
	cargo build --release
	cp target/release/bluetui ~/.local/bin/bluetui
	cd ..
	cd ..
}

retroarch () {
	cp -r ../retroarch-setup .
	cd retroarch-setup
	./retroarch-setup.sh
	cd ..
}

lemonbar () {
	sudo apt install libxcb-randr0-dev libx11-xcb-dev libxcb-xinerama0-dev
	git clone https://github.com/silentz/lemonbar-xft
	cd lemonbar-xft
	cp ../patches/lemonbar-xft-font-offset.diff .
	patch < lemonbar-xft-font-offset.diff
	make
	sudo make install
	cd ..
}

pipeviewer () {
	sudo apt install libmodule-build-perl libwww-curl-perl libjson-perl libterm-readline-gnu-perl libdata-dump-perl liblwp-protocol-https-perl libunicode-linebreak-perl
	mkdir pipeviewer
	cd pipeviewer
	url="$(github-latest-release "github" "trizen" "pipe-viewer")"
	wget "$url"
	unzip *.zip
	cd */
	cp ../../patches/pipe-viewer-copy.diff .
	cd bin
	patch < ../pipe-viewer-copy.diff
	cd ..
	perl Build.PL
	sudo ./Build installdeps
	sudo ./Build install
	cd ..
	cd ..
}

sbase () {
	sudo apt install yacc
	git clone https://git.suckless.org/sbase
	cd sbase
	make
	sudo make install
	cd ..

	read -p "Add \"/usr/bin\" to start of secure_path (enter to continue):" thing
	sudo visudo
}

sxiv () {
	sudo apt install libexif-dev

	git clone https://github.com/xyb3rt/sxiv
	cd sxiv

	cp ../patches/sxiv-print-index.diff .
	patch < sxiv-print-index.diff

	make
	sudo make install
	cd ..
}

openssh () {
	mkdir openssh
	cd openssh
	url="$(curl "https://www.openssh.org/openbsd.html" | grep "ftp" | head -n 2 | tail -n 1 | cut -d "\"" -f 2)"
	wget "$url"
	tar -xf *.tar.gz/
}

cava () {
	sudo apt install libfftw3-dev libasound2-dev libpulse-dev libtool libiniparser-dev libsdl2-2.0-0 libsdl2-dev libjack-jackd2-dev

	mkdir cava
	cd cava
	url="$(github-latest-release "github" "karlstav" "cava")"
	wget "$url"
	unzip *.zip
	cd */

	./autogen.sh
	./configure --prefix="$HOME/.local"
	make
	make install

	cd ..
	cd ..
}

alpine () {
	mkdir alpine
	cd alpine
	url="$(curl "https://alpineapp.email/" | grep "HREF" | grep "tar.xz" | head -n 1 | cut -d "\"" -f 4)"
	wget "https://alpineapp.email/${url}"
	tar -xf *.xz
	cd */
	./configure
	make
	sudo make install
	cd ..
	cd ..
}

dotacat () {
	git clone https://gitlab.scd31.com/sophie/dotacat.git
	cd dotacat
	cargo build --release
	cp target/release/dotacat ~/.local/bin/dotacat
	cd ..
}

mepo () {
	sudo apt install libsdl2-gfx-1.0-0 libsdl2-dev libsdl2-image-2.0-0 libsdl2-image-dev libsdl2-ttf-2.0-0 libsdl2-ttf-dev

	mkdir mepo
	cd mepo
	url="$(github-latest-release "sourcehut" '~mil' "mepo")"
	wget "$url"
	unzip *.zip
	cd */

	trim () {
		sed -ne '/---/,$ p' | sed 's/\r//g'
	}

	curl "https://lists.sr.ht/~mil/mepo-devel/%3C20250821020031.28035-1-lauren@selfisekai.rocks%3E/raw" | trim > 15-part1.diff
	curl "https://lists.sr.ht/~mil/mepo-devel/%3C20250910145816.10962-1-lauren@selfisekai.rocks%3E/raw" | trim > 15-part2.diff
	curl "https://lists.sr.ht/~mil/mepo-devel/%3C20250821020031.28035-3-lauren@selfisekai.rocks%3E/raw" | trim > 15-part3.diff
	curl "https://lists.sr.ht/~mil/mepo-devel/%3C20250821020031.28035-4-lauren@selfisekai.rocks%3E/raw" | trim > 15-part4.diff
	curl "https://lists.sr.ht/~mil/mepo-devel/%3C20250821020031.28035-5-lauren@selfisekai.rocks%3E/raw" | trim > 15-part5.diff
	curl "https://lists.sr.ht/~mil/mepo-devel/%3C20250821020031.28035-6-lauren@selfisekai.rocks%3E/raw" | trim > 15-part6.diff
	curl "https://lists.sr.ht/~mil/mepo-devel/%3C20250821020031.28035-7-lauren@selfisekai.rocks%3E/raw" | trim > 15-part7.diff
	curl "https://lists.sr.ht/~mil/mepo-devel/%3C20250821020031.28035-8-lauren@selfisekai.rocks%3E/raw" | trim > 15-part8.diff
	curl "https://lists.sr.ht/~mil/mepo-devel/%3C20250821020031.28035-9-lauren@selfisekai.rocks%3E/raw" | trim > 15-part9.diff
	curl "https://lists.sr.ht/~mil/mepo-devel/%3C20250821020031.28035-10-lauren@selfisekai.rocks%3E/raw" | trim > 15-part10.diff
	curl "https://lists.sr.ht/~mil/mepo-devel/%3C20250821020031.28035-11-lauren@selfisekai.rocks%3E/raw" | trim > 15-part11.diff

	curl "https://lists.sr.ht/~mil/mepo-devel/%3C20260421135005.20761-1-lauren@selfisekai.rocks%3E/raw" | trim > 16-part1.diff
	curl "https://lists.sr.ht/~mil/mepo-devel/%3C20260421135005.20761-2-lauren@selfisekai.rocks%3E/raw" | trim | sed 's/15/14/g' > 16-part2.diff
	curl "https://lists.sr.ht/~mil/mepo-devel/%3C20260421135005.20761-3-lauren@selfisekai.rocks%3E/raw" | trim > 16-part3.diff
	curl "https://lists.sr.ht/~mil/mepo-devel/%3C20260421135005.20761-4-lauren@selfisekai.rocks%3E/raw" | trim > 16-part4.diff
	curl "https://lists.sr.ht/~mil/mepo-devel/%3C20260421135005.20761-5-lauren@selfisekai.rocks%3E/raw" | trim > 16-part5.diff
	curl "https://lists.sr.ht/~mil/mepo-devel/%3C20260421135005.20761-6-lauren@selfisekai.rocks%3E/raw" | trim > 16-part6.diff
	curl "https://lists.sr.ht/~mil/mepo-devel/%3C20260421135005.20761-7-lauren@selfisekai.rocks%3E/raw" | trim > 16-part7.diff

	patch -p 1 < 15-part1.diff
	patch -p 1 < 15-part2.diff
#	patch -p 1 < 15-part3.diff
	patch -p 1 < 15-part4.diff
	patch -p 1 < 15-part5.diff
	patch -p 1 < 15-part6.diff
	patch -p 1 < 15-part7.diff
	patch -p 1 < 15-part8.diff
	patch -p 1 < 15-part9.diff
	patch -p 1 < 15-part10.diff
	patch -p 1 < 15-part11.diff
	patch -p 1 < 16-part1.diff
	patch -p 1 < 16-part2.diff
	patch -p 1 < 16-part3.diff
	patch -p 1 < 16-part4.diff
	patch -p 1 < 16-part5.diff
	patch -p 1 < 16-part6.diff
	patch -p 1 < 16-part7.diff

	zig build

	cp zig-out/bin/* ~/.local/bin/
	[ -d ~/.local/share/applications ] || mkdir ~/.local/share/applications
	cp zig-out/share/applications/mepo.desktop ~/.local/share/applications/mepo.desktop
	[ -d ~/.local/share/icons ] || mkdir ~/.local/share/icons
	cp -r zig-out/share/icons/* ~/.local/share/icons
	[ -d ~/.local/share/pixmaps ] || mkdir ~/.local/share/pixmaps
	cp zig-out/share/pixmaps/mepo.png ~/.local/share/pixmaps/mepo.png

	cd ..
	cd ..
}

fastfetch () {
	mkdir fastfetch
	cd fastfetch
	url="$(github-latest-release "github" "fastfetch-cli" "fastfetch")"
	wget "$url"
	unzip *.zip
	cd */
	mkdir build
	cd build
	cmake -DCMAKE_INSTALL_PREFIX="$HOME/.local" ..
	make
	make install

	cd ..
	cd ..
	cd ..
}

dragon () {
	sudo apt install libgtk-3-dev
	git clone https://github.com/mwh/dragon
	cd dragon
	make
	cp dragon ~/.local/bin/dragon
	cd ..
}

cal () {
	mkdir util-linux
	cd util-linux
	ver="$(curl "https://www.kernel.org/pub/linux/utils/util-linux/" | grep "v2." | tail -n 1 | cut -d "\"" -f 2 | tr -d "/" | tr -d "v")"
	wget "https://www.kernel.org/pub/linux/utils/util-linux/v${ver}/util-linux-${ver}.tar.xz"
	tar -xf *.xz
	cd */
	./configure --disable-all-programs --enable-cal
	make
	cp cal ~/.local/bin/cal

	cd ..
	cd ..
}

mercusys () {
	sudo apt install dkms linux-headers-amd64

	git clone https://github.com/ProgrammingRainbow/mercusys-ma530-dkms

	sed 's/kernel=.*/kernel="$\{1%%-*\}"\nkernel="$\{kernel%%+*\}"/g' mercusys-ma530-dkms/pre_build.sh > /tmp/pre_build.sh
	mv /tmp/pre_build.sh mercusys-ma530-dkms/pre_build.sh
	chmod +x mercusys-ma530-dkms/pre_build.sh

	sudo dkms remove mercusys-ma530-dkms/1.0 --all || echo "Not installed"
	sudo dkms add ./mercusys-ma530-dkms
	sudo dkms install mercusys-ma530-dkms/1.0
}

zathura () {
	sudo apt install libxxhash-dev libmagic-dev libgtk-4-dev xorg-dev libxcursor-dev libxrandr-dev libxinerama-dev mesa-common-dev libgl1-mesa-dev libglu1-mesa-dev freeglut3-dev

	git clone https://github.com/ArtifexSoftware/mupdf
	cd mupdf
	git checkout 205b8cf
	git submodule update --init
	make shared=yes build=release XCFLAGS="-fPIC" XCXXFLAGS="-fPIC" USE_SYSTEM_FREETYPE=yes USE_SYSTEM_GUMBO=yes USE_SYSTEM_HARFBUZZ=yes USE_SYSTEM_JBIG2DEC=yes USE_SYSTEM_LIBJPEG=yes USE_SYSTEM_OPENJPEG=no USE_SYSTEM_ZLIB=yes USE_SYSTEM_GLUT=yes USE_SYSTEM_CURL=yes USE_SYSTEM_LEPTONICA=yes USE_SYSTEM_TESSERACT=yes USE_SYSTEM_ZXINGCPP=yes USE_SYSTEM_BROTLI=yes
	sudo make shared=yes build=release XCFLAGS="-fPIC" XCXXFLAGS="-fPIC" USE_SYSTEM_FREETYPE=yes USE_SYSTEM_GUMBO=yes USE_SYSTEM_HARFBUZZ=yes USE_SYSTEM_JBIG2DEC=yes USE_SYSTEM_LIBJPEG=yes USE_SYSTEM_OPENJPEG=no USE_SYSTEM_ZLIB=yes USE_SYSTEM_GLUT=yes USE_SYSTEM_CURL=yes USE_SYSTEM_LEPTONICA=yes USE_SYSTEM_TESSERACT=yes USE_SYSTEM_ZXINGCPP=yes USE_SYSTEM_BROTLI=yes install
	cd ..

	mkdir girara
	cd girara
	tag="$(curl "https://github.com/pwmt/girara/tags" | grep "releases/tag" | head -n 3 | tail -n 1 | cut -d "\"" -f 6 | cut -d "/" -f 6)"
	wget "https://github.com/pwmt/girara/archive/refs/tags/${tag}.zip"
	unzip *.zip
	cd */
	meson build
	cd build
	ninja
	sudo ninja install
	cd ..
	cd ..
	cd ..

	mkdir zathura
	cd zathura
	tag="$(curl "https://github.com/pwmt/zathura/tags" | grep "releases/tag" | head -n 3 | tail -n 1 | cut -d "\"" -f 6 | cut -d "/" -f 6)"
	wget "https://github.com/pwmt/zathura/archive/refs/tags/${tag}.zip"
	unzip *.zip
	cd */
	sed 's/test-wayland features<\/issue>/test-wayland features<\/p>/g' data/org.pwmt.zathura.metainfo.xml.in > /tmp/out
	mv /tmp/out data/org.pwmt.zathura.metainfo.xml.in
	meson build
	cd build
	ninja
	sudo ninja install
	cd ..
	cd ..
	cd ..

	mkdir zathura-mupdf
	cd zathura-mupdf
	tag="$(curl "https://github.com/pwmt/zathura-pdf-mupdf/tags" | grep "releases/tag" | head -n 3 | tail -n 1 | cut -d "\"" -f 6 | cut -d "/" -f 6)"
	wget "https://github.com/pwmt/zathura-pdf-mupdf/archive/refs/tags/${tag}.zip"
	unzip *.zip
	cd */
	meson build
	cd build
	ninja
	sudo ninja install
	cd ..
	cd ..
	cd ..
}

zigitself () {
	mkdir zig
	cd zig
	url="$(curl "https://ziglang.org/download/" | pup 'table:nth-of-type(2)' | grep "zig-x86_64-linux" | head -n 1 | cut -d "\"" -f 2)"
	wget "$url"
	unxz *.xz
	tar -xf *.tar
	cd */
	cp -r doc/* ~/.local/share/doc/
	cp -r lib/ ~/.local/bin/
	cp zig ~/.local/bin/
	cd ..
	cd ..
}

onetrueawk () {
	sudo apt install bison

	git clone "https://github.com/onetrueawk/awk"
	cd awk/

	make
	sudo cp a.out /usr/local/bin/awk
	sudo cp awk.1 /usr/local/man/man1/awk.1

	cd ..
}

ueberzugpp () {
	sudo apt install libssl-dev libvips-dev libsixel-dev libchafa-dev libtbb-dev libxcb-image0-dev libxcb-res0 libxcb-res0-dev libopencv-dev

	mkdir ueberzugpp
	cd ueberzugpp
	url="$(github-latest-release "github" "jstkdng" "ueberzugpp")"
	wget "$url"
	unzip *.zip
	cd */

	mkdir build
	cd build
	cmake -DCMAKE_BUILD_TYPE=Release ..
	cmake --build .
	cd ..
	sudo cmake --install build

	cd ..
	cd ..
}

doggo () {
	mkdir doggo
	cd doggo
	url="$(github-latest-release "github" "mr-karan" "doggo")"
	wget "$url"
	unzip *.zip
	cd */
	make
	cp bin/doggo.bin ~/.local/bin/doggo

	cd ..
	cd ..
}


build () {
	read -p "q to quit, s to skip (next: $1)" qToQuit
	[ "$qToQuit" = "q" ] && exit
	[ "$qToQuit" = "s" ] || "$1"
}

if [ "$1" = "mine" ]; then
	build bug
	build st
	build dmenu
	build slock
	build jwm
	build gozer
	echo "done"
elif [ "$1" = "notmine" ]; then
	build bsky
	build forgejo
	build bat
	build less
	build nano
	build oksh
	build opustags
	build rsgain
	build newsraft
	build aacgain
	build bluetui
	build lemonbar
	build pipeviewer
	build sbase
	build sxiv
	build alpine
	build dotacat
	build fastfetch
	build dragon
	build cal
	build mercusys
	build zathura
	build ueberzugpp
	build openssh
	build zigitself
	build mepo
	build cava
	build onetrueawk
	build doggo
	build retroarch
	echo "done"
elif [ "$1" = "needed" ]; then
	build bug
	build st
	build dmenu
	build slock
	build jwm
	build bat
	build less
	build nano
	build oksh
	build bluetui
	build lemonbar
	build sbase
	build sxiv
	build dotacat
	build dragon
	build cal
	build mercusys
	echo "done"
elif [ "$1" = "jwm" ]; then
	jwm
elif [ "$1" = "bsky" ]; then
	bsky
elif [ "$1" = "forgejo" ]; then
	forgejo
elif [ "$1" = "bat" ]; then
	bat
elif [ "$1" = "gozer" ]; then
	gozer
elif [ "$1" = "less" ]; then
	less
elif [ "$1" = "nano" ]; then
	nano
elif [ "$1" = "oksh" ]; then
	oksh
elif [ "$1" = "opustags" ]; then
	opustags
elif [ "$1" = "rsgain" ]; then
	rsgain
elif [ "$1" = "newsraft" ]; then
	newsraft
elif [ "$1" = "aacgain" ]; then
	aacgain
elif [ "$1" = "bug" ]; then
	bug
elif [ "$1" = "st" ]; then
	st
elif [ "$1" = "dmenu" ]; then
	dmenu
elif [ "$1" = "slock" ]; then
	slock
elif [ "$1" = "bluetui" ]; then
	bluetui
elif [ "$1" = "retroarch" ]; then
	retroarch
elif [ "$1" = "lemonbar" ]; then
	lemonbar
elif [ "$1" = "pipe-viewer" ]; then
	pipeviewer
elif [ "$1" = "sbase" ]; then
	sbase
elif [ "$1" = "sxiv" ]; then
	sxiv
elif [ "$1" = "dotacat" ]; then
	dotacat
elif [ "$1" = "mepo" ]; then
	mepo
elif [ "$1" = "fastfetch" ]; then
	fastfetch
elif [ "$1" = "dragon" ]; then
	dragon
elif [ "$1" = "cal" ]; then
	cal
elif [ "$1" = "mercusys" ]; then
	mercusys
elif [ "$1" = "zathura" ]; then
	zathura
elif [ "$1" = "ueberzugpp" ]; then
	ueberzugpp
elif [ "$1" = "openssh" ]; then
	openssh
elif [ "$1" = "zig" ]; then
	zigitself
elif [ "$1" = "cava" ]; then
	cava
elif [ "$1" = "onetrueawk" ]; then
	onetrueawk
elif [ "$1" = "doggo" ]; then
	doggo
elif [ "$1" = "alpine" ]; then
	alpine
else
	echo "Not found"
	echo "\"mine\" to install my programs/forks"
	echo "\"notmine\" to install other programs"
	exit
fi
