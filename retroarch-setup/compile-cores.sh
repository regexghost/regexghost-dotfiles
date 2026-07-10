#!/bin/sh

CONFIG_LOC="$XDG_CONFIG_HOME/retroarch"

cd retroarch-github

git clone https://github.com/libretro/libretro-super
cd libretro-super
./libretro-fetch.sh picodrive
JOBS=1 ./libretro-build.sh picodrive
cp libretro-picodrive/picodrive_libretro.so "${CONFIG_LOC}/cores/"

read -p "q to quit if errors" quit
[ "$quit" = "q" ] && exit

./libretro-fetch.sh nestopia
JOBS=1 ./libretro-build.sh nestopia
cp libretro-nestopia/libretro/nestopia_libretro.so "${CONFIG_LOC}/cores/"

read -p "q to quit if errors" quit
[ "$quit" = "q" ] && exit

./libretro-fetch.sh gambatte
JOBS=1 ./libretro-build.sh gambatte
cp libretro-gambatte/gambatte_libretro.so "${CONFIG_LOC}/cores/"

read -p "q to quit if errors" quit
[ "$quit" = "q" ] && exit

./libretro-fetch.sh stella2014
JOBS=1 ./libretro-build.sh stella2014
cp libretro-stella2014/stella2014_libretro.so "${CONFIG_LOC}/cores/"

read -p "q to quit if errors" quit
[ "$quit" = "q" ] && exit

./libretro-install.sh infofiles
cp infofiles/picodrive_libretro.info "${CONFIG_LOC}/cores/"
cp infofiles/gambatte_libretro.info "${CONFIG_LOC}/cores/"
cp infofiles/stella2014_libretro.info "${CONFIG_LOC}/cores/"
cp infofiles/nestopia_libretro.info "${CONFIG_LOC}/cores/"
cd ..
cd ..
