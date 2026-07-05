#!/bin/sh

set -e

# Install programs
sudo apt install xorg xinit x11-xserver-utils bluetooth unzip git firefox mpv vlc tar moc fasd fonts-roboto fonts-firacode figlet jq xcompmgr picom trash-cli

# Install dotfile scripts
cd panel-scripts; make; cd ..
cd terminal-scripts; make; cd ..
cd other; make; cd ..
cd wm-scripts; make; cd ..
cd helpers/subgo; make full; cd ../..

# Compile programs
./otherPrograms.sh mine
./otherPrograms.sh notmine

# Create empty wgetrc to stop error
touch ~/.config/wgetrc

# Shell stuf
cp /etc/shells ~/Downloads/shells_backup
echo "/usr/local/bin/oksh" | sudo tee -a /etc/shells
chsh
