#!/bin/sh

CONFIG_LOC="$XDG_CONFIG_HOME/retroarch"

mkdir retroarch-github
cd retroarch-github

sudo apt install build-essential
sudo apt build-dep retroarch

git clone https://github.com/libretro/RetroArch
cd RetroArch
./configure --prefix="$HOME/.local"
make clean
make -j 3
make install
cd ..
retroarch 2> /dev/null > /dev/null # Just to create config
cat "${CONFIG_LOC}/retroarch.cfg" | \
	sed 's|assets_directory = "~/.config/retroarch/assets"|assets_directory = "~/.local/share/libretro/assets"|g; s|joypad_autoconfig_dir = "~/.config/retroarch/autoconfig"|joypad_autoconfig_dir = "~/.local/share/libretro/autoconfig"|g; s|osk_overlay_directory = "~/.config/retroarch/overlays/keyboards"|osk_overlay_directory = "~/.local/share/libretro/overlays/keyboards"|g; s|overlay_directory = "~/.config/retroarch/overlays"|overlay_directory = "~/.local/share/libretro/overlays"|g; s|video_shader_dir = "~/.config/retroarch/shaders"|video_shader_dir = "~/.local/share/libretro/shaders"|g' > /tmp/retroarch.cfg
cp /tmp/retroarch.cfg "${CONFIG_LOC}/retroarch.cfg"

read -p "q to quit if errors" quit
[ "$quit" = "q" ] && exit

git clone https://github.com/libretro/retroarch-assets
cd retroarch-assets
make install PREFIX="$HOME/.local"
cd ..

read -p "q to quit if errors" quit
[ "$quit" = "q" ] && exit

git clone https://github.com/libretro/retroarch-joypad-autoconfig
cd retroarch-joypad-autoconfig
make install PREFIX="$HOME/.local"
cd ..

read -p "q to quit if errors" quit
[ "$quit" = "q" ] && exit

git clone https://github.com/libretro/common-shaders
cd common-shaders
make install PREFIX="$HOME/.local"
cd ..

read -p "q to quit if errors" quit
[ "$quit" = "q" ] && exit

git clone https://github.com/libretro/common-overlays
cd common-overlays
make install PREFIX="$HOME/.local"
cd ..

read -p "q to quit if errors" quit
[ "$quit" = "q" ] && exit

cd ..

./compile-cores.sh

echo "All done"
