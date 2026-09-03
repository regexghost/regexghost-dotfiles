#!/bin/sh

CONFIG_LOC="$XDG_CONFIG_HOME/retroarch"

cd retroarch-github

git clone https://github.com/libretro/libretro-super
cd libretro-super
./libretro-fetch.sh picodrive
./libretro-build.sh picodrive
cp libretro-picodrive/picodrive_libretro.so "${CONFIG_LOC}/cores/"

read -p "q to quit if errors" quit
[ "$quit" = "q" ] && exit

./libretro-fetch.sh nestopia
./libretro-build.sh nestopia
cp libretro-nestopia/libretro/nestopia_libretro.so "${CONFIG_LOC}/cores/"

read -p "q to quit if errors" quit
[ "$quit" = "q" ] && exit

./libretro-fetch.sh gambatte
./libretro-build.sh gambatte
cp libretro-gambatte/gambatte_libretro.so "${CONFIG_LOC}/cores/"

read -p "q to quit if errors" quit
[ "$quit" = "q" ] && exit

./libretro-fetch.sh stella2014
./libretro-build.sh stella2014
cp libretro-stella2014/stella2014_libretro.so "${CONFIG_LOC}/cores/"

read -p "q to quit if errors" quit
[ "$quit" = "q" ] && exit

./libretro-fetch.sh mgba
./libretro-build.sh mgba
cp libretro-mgba/mgba_libretro.so "${CONFIG_LOC}/cores/"

read -p "q to quit if errors" quit
[ "$quit" = "q" ] && exit

./libretro-fetch.sh gpsp
./libretro-build.sh gpsp
cp libretro-gpsp/gpsp_libretro.so "${CONFIG_LOC}/cores/"

read -p "q to quit if errors" quit
[ "$quit" = "q" ] && exit

./libretro-fetch.sh fceumm
./libretro-build.sh fceumm
cp libretro-fceumm/fceumm_libretro.so "${CONFIG_LOC}/cores/"

read -p "q to quit if errors" quit
[ "$quit" = "q" ] && exit

./libretro-fetch.sh smsplus
./libretro-build.sh smsplus
cp libretro-smsplus/smsplus_libretro.so "${CONFIG_LOC}/cores/"

read -p "q to quit if errors" quit
[ "$quit" = "q" ] && exit

./libretro-fetch.sh ppsspp
./libretro-build.sh ppsspp
cp libretro-ppsspp/build/lib/ppsspp_libretro.so "${CONFIG_LOC}/cores/"

read -p "q to quit if errors" quit
[ "$quit" = "q" ] && exit

./libretro-install.sh infofiles
cp infofiles/picodrive_libretro.info "${CONFIG_LOC}/cores/"
cp infofiles/nestopia_libretro.info "${CONFIG_LOC}/cores/"
cp infofiles/gambatte_libretro.info "${CONFIG_LOC}/cores/"
cp infofiles/stella2014_libretro.info "${CONFIG_LOC}/cores/"
cp infofiles/mgba_libretro.info "${CONFIG_LOC}/cores/"
cp infofiles/gpsp_libretro.info "${CONFIG_LOC}/cores/"
cp infofiles/fceumm_libretro.info "${CONFIG_LOC}/cores/"
cp infofiles/smsplus_libretro.info "${CONFIG_LOC}/cores/"
cp infofiles/ppsspp_libretro.info "${CONFIG_LOC}/cores/"
cd ..
cd ..
