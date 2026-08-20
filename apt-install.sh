#!/bin/sh

# Script to install packages, for Debian 13 (currently)
# Packages needed for program compiling are installed separately in other-programs.sh

# x11
# system utils
# web
# video
# audio
# images
# fonts
# terminal utils
# terminal programs
# gui programs
# dev stuff
# mobile
# other

sudo apt install \
	xorg xinit x11-xserver-utils xcompmgr picom xclip xdotool libnotify-bin dunst gammastep \
	curl wget bluetooth unzip git tar unrar-free \
	firefox-esr chromium w3m \
	mpv vlc \
	moc moc-ffmpeg-plugin pulseaudio-module-bluetooth mpd mpc \
	feh nomacs qimgv kimageformat-plugins kimageformat6-plugins \
	fonts-roboto fonts-firacode fonts-noto-core fonts-noto-cjk fonts-noto-color-emoji \
	fzf fasd trash-cli duf rsync pup aria2 gallery-dl mediainfo xmlstarlet rename jq yq expect \
	figlet ncdu pulsemixer gh nnn qalc vim alpine htop btop intel-gpu-tools \
	keepassxc-full xfe \
	golang python3-venv rustup groff texinfo \
	ifuse libimobiledevice-utils android-file-transfer \
	tidy wbritish wbritish-huge sqlite3
