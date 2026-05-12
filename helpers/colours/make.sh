#!/bin/sh

[ -d output/ ] && rm -rf output
mkdir output

scheme="$1"
. schemes/"$scheme.sh"
cp schemes/"$scheme".sh "$XDG_CONFIG_HOME/regexghost/current-theme.sh"

loadColours () {
	template="$1"
	output="$2"
	sed "s|BACKGROUND_BLACK|$BACKGROUND_BLACK|g" "$template" |\
	sed "s|FOREGROUND_WHITE|$FOREGROUND_WHITE|g" |\
	sed "s|BRIGHT_WHITE|$BRIGHT_WHITE|g" |\
	sed "s|BRIGHT_CYAN|$BRIGHT_CYAN|g" |\
	sed "s|BRIGHT_MAGENTA|$BRIGHT_MAGENTA|g" |\
	sed "s|BRIGHT_BLUE|$BRIGHT_BLUE|g" |\
	sed "s|BRIGHT_YELLOW|$BRIGHT_YELLOW|g" |\
	sed "s|BRIGHT_GREEN|$BRIGHT_GREEN|g" |\
	sed "s|BRIGHT_RED|$BRIGHT_RED|g" |\
	sed "s|BRIGHT_BLACK|$BRIGHT_BLACK|g" |\
	sed "s|WHITE|$WHITE|g" |\
	sed "s|CYAN|$CYAN|g" |\
	sed "s|MAGENTA|$MAGENTA|g" |\
	sed "s|BLUE|$BLUE|g" |\
	sed "s|YELLOW|$YELLOW|g" |\
	sed "s|GREEN|$GREEN|g" |\
	sed "s|RED|$RED|g" |\
	sed "s|BLACK|$BLACK|g" |\
	sed "s|FONT_FAMILY|$FONT_FAMILY|g" > "$output"
}

if [ "$2" = "website" ]; then
	loadColours templates/Template-style.css output/style.css
	cp output/style.css ~/Programs/websites/personal-website/static/style.css
	exit
fi

for template in templates/*; do
	outputFilename="$(echo "$template" | sed "s|Template|Colourscheme-Substitution-$scheme|g" | sed 's/templates/output/g')"
	loadColours "$template" "$outputFilename"
done

cp output/*-dunstrc ../../dotfiles/.config/dunst/
cp output/*-jwmrc ../../jwm/.config/jwm/
cp output/*-config.def.h ~/Programs/myRepos/st/config.def.h

rm -rf output/
