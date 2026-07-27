#!/bin/sh

set -e

export PATH="$HOME/.local/bin:$PATH"

export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

[ -d "$XDG_CACHE_HOME" ] || mkdir -p "$XDG_CACHE_HOME"
[ -d "$XDG_DATA_HOME" ] || mkdir -p "$XDG_DATA_HOME"
[ -d "$XDG_CONFIG_HOME" ] || mkdir -p "$XDG_CONFIG_HOME"
[ -d "$XDG_STATE_HOME" ] || mkdir -p "$XDG_STATE_HOME"

./setup.sh make dotfiles

. ~/.profile

# Install programs
./apt-install.sh

# Install dotfile scripts
cd panel-scripts/; make; cd ../
cd terminal-scripts/; make; cd ../
cd other/; make; cd ../
cd wm-scripts/; make; cd ../
cd helpers/subgo/; make full; cd ../../

# Compile programs
./otherPrograms.sh mine
./otherPrograms.sh notmine

# Create empty wgetrc to stop error
touch ~/.config/wgetrc

# Shell stuff
if ! grep -q "/usr/local/bin/oksh" /etc/shells; then
	cp /etc/shells ~/Downloads/shells_backup
	echo "/usr/local/bin/oksh" | sudo tee -a /etc/shells
fi
chsh

# Random setup
echo "50" > ~/.cache/volume
echo "no" > ~/.cache/muted
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

cd ~/.local/share/regexghost
python3 -m venv .venv
~/.local/share/regexghost/.venv/bin/pip install music-tag pillow requests beautifulsoup4 howlongtobeatpy
