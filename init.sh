#!/bin/sh

set -e

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
cp /etc/shells ~/Downloads/shells_backup
echo "/usr/local/bin/oksh" | sudo tee -a /etc/shells
chsh

# Random setup
echo "50" > ~/.cache/volume
echo "no" > ~/.cache/muted
mkdir ~/.config/aspell/
mkdir ~/.local/share/aspell/
sudo systemctl enable --now bluetooth
systemctl --user restart pulseaudio

# Make dirs
mkdir ~/Videos
mkdir ~/Videos/Podcasts
mkdir ~/Videos/YouTube
mkdir ~/Videos/YouTube/Videos
mkdir ~/Videos/YouTube/Shorts
mkdir ~/Videos/YouTube/toDownload
touch ~/Videos/Podcasts/toDownload.txt
