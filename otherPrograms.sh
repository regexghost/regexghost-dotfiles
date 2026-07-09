#!/bin/sh

set -e

mkdir -p temp_programs
cd temp_programs

[ -d patches/ ] || git clone https://github.com/regexghost/patches

# dev tools
sudo apt install git make gcc automake unzip gettext autopoint pkg-config cmake libtool build-essential

jwm () {
	sudo apt install libxext-dev libxmu-dev libxinerama-dev libxpm-dev libjpeg-dev libpng-dev libpango1.0-dev
	git clone https://github.com/regexghost/jwm
	cd jwm
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
	url="$(github_latest_release "github" "mattn" "bsky")"
	wget --hsts-file="$XDG_STATE_HOME/wget-hsts" "$url"
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
	url="$(github_latest_release "codeberg" "forgejo-contrib" "forgejo-cli")"
	wget --hsts-file="$XDG_STATE_HOME/wget-hsts" "$url"
	unzip *.zip
	cd */
	cargo build --release
	cp target/release/fj ~/.local/bin/fj
	cd ..
	cd ..
}

aacgain () {
	mkdir aacgain
	cd aacgain
	url="$(github_latest_release "github" "dgilman" "aacgain")"
	wget --hsts-file="$XDG_STATE_HOME/wget-hsts" "$url"
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
	#wget --hsts-file="$XDG_STATE_HOME/wget-hsts" "https://greenwoodsoftware.com/less/less-${version}.zip"
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
	wget --hsts-file="$XDG_STATE_HOME/wget-hsts" "https://nano-editor.org/${version}"
	tar -xf *.xz
	cd */
	./configure --prefix="$HOME/.local"
	make
	make install
	cd ..
	cd ..
}

oksh () {
	mkdir oksh
	cd oksh
	url="$(github_latest_release "github" "ibara" "oksh")"
	wget --hsts-file="$XDG_STATE_HOME/wget-hsts" "$url"
	unzip *.zip
	cd */
	cp ../../patches/oksh-case-insensitive.diff .
	cp ../../patches/oksh-history.diff .
	patch < oksh-case-insensitive.diff
	patch < oksh-history.diff
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
	url="$(github_latest_release "github" "fmang" "opustags")"
	wget --hsts-file="$XDG_STATE_HOME/wget-hsts" "$url"
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
	url="$(github_latest_release "github" "complexlogic" "rsgain")"
	wget --hsts-file="$XDG_STATE_HOME/wget-hsts" "$url"
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
	git clone https://github.com/regexghost/st
	cd st
	make full
	sudo make install
	cd ..

}

dmenu () {
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
	url="$(github_latest_release "github" "pythops" "bluetui")"
	wget --hsts-file="$XDG_STATE_HOME/wget-hsts" "$url"
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
	url="$(github_latest_release "github" "trizen" "pipe-viewer")"
	wget --hsts-file="$XDG_STATE_HOME/wget-hsts" "$url"
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
}

sxiv () {
	git clone https://github.com/xyb3rt/sxiv
	cd sxiv
	make
	sudo make install
	cd ..
}

alpine () {
	mkdir alpine
	cd alpine
	url="$(curl "https://alpineapp.email/" | grep "HREF" | grep "tar.xz" | head -n 1 | cut -d "\"" -f 4)"
	wget --hsts-file="$XDG_STATE_HOME/wget-hsts" "$url"
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
	url="$(github_latest_release "sourcehut" '~mil' "mepo")"
	wget --hsts-file="$XDG_STATE_HOME/wget-hsts" "$url"
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
	url="$(github_latest_release "github" "fastfetch-cli" "fastfetch")"
	wget --hsts-file="$XDG_STATE_HOME/wget-hsts" "$url"
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
	build mepo
	build fastfetch
	build retroarch
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
elif [ "$1" = "alpine" ]; then
	alpine
else
	echo "Not found"
	echo "\"mine\" to install my programs/forks"
	echo "\"notmine\" to install other programs"
	exit
fi

cd ..
read -p "Delete temp folder (y/N)? " yesOrNo
if [ "$yesOrNo" = "y" ] || [ "$yesOrNo" = "Y" ]; then
	trash-put temp_programs/
fi
