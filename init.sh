#!/bin/sh

# Exit on fail
set -e

# Have to load all the variables
. dotfiles/.profile

[ -d "$XDG_CACHE_HOME" ] || mkdir -p "$XDG_CACHE_HOME"
[ -d "$XDG_DATA_HOME" ] || mkdir -p "$XDG_DATA_HOME"
[ -d "$XDG_CONFIG_HOME" ] || mkdir -p "$XDG_CONFIG_HOME"
[ -d "$XDG_STATE_HOME" ] || mkdir -p "$XDG_STATE_HOME"

# Install programs
if uname -a | grep -q Debian; then
	./apt-install.sh
fi

# Make substitution program before running setup.sh
cd helpers/subgo; make full; cd ../..

cd helpers/colours; ./make.sh DoomOne; cd ../..

./setup.sh make dotfiles

# Install dotfile scripts
cd panel-scripts/; make; cd ../
cd terminal-scripts/; make; cd ../
cd other/; make; cd ../
cd wm-scripts/; make; cd ../

# Compile programs
./otherPrograms.sh mine
./otherPrograms.sh notmine

# Shell stuff
if ! grep -q "/usr/local/bin/oksh" /etc/shells; then
	cp /etc/shells ~/Downloads/shells_backup
	echo "/usr/local/bin/oksh" | sudo tee -a /etc/shells
fi
chsh

# Random setup
mkdir ~/.cache/panel_volume
echo "50" > ~/.cache/panel_volume/volume
echo "no" > ~/.cache/panel_volume/muted
echo "default" > ~/.cache/panel_volume/sink
mkdir -p ~/.config/aspell/
mkdir -p ~/.local/share/aspell/
sudo systemctl enable --now bluetooth
systemctl --user restart pulseaudio

# Make dirs
mkdir -p ~/Videos
mkdir -p ~/Videos/Podcasts
mkdir -p ~/Videos/YouTube
mkdir -p ~/Videos/YouTube/Videos
mkdir -p ~/Videos/YouTube/Shorts
mkdir -p ~/Videos/YouTube/toDownload
touch ~/Videos/Podcasts/toDownload.txt
mkdir -p ~/.local/state/mpd
mkdir -p ~/.cache/mpd

# Python3 venv
cd ~/.local/share/regexghost
python3 -m venv .venv
~/.local/share/regexghost/.venv/bin/pip install music-tag pillow requests beautifulsoup4 howlongtobeatpy

# nnn preview
mkdir -p ~/.config/nnn/plugins
curl "https://raw.githubusercontent.com/jarun/nnn/refs/heads/master/plugins/preview-tui" > ~/.config/nnn/plugins/preview-tui
chmod +x ~/.config/nnn/plugins/preview-tui

# Music icon
sed 's/currentColor/white/g' /usr/share/icons/Papirus/24x24/symbolic/emblems/emblem-music-symbolic.svg > /tmp/temp.svg
magick -background none -fill white -density 400 /tmp/temp.svg -resize 100x100 ~/.local/share/regexghost/panel/emblem-music-symbolic.png

# For old intel systems <= 4th gen, stops an mpv error
sudo apt remove intel-media-va-driver

# Put chromium data in ~/.local/share
[ -d ~/.config/chromium ] && mv ~/.config/chromium ~/.local/share/chromium || mkdir ~/.local/share/chromium
ln -sf ~/.local/share/chromium ~/.config/chromium
