#!/bin/sh

DMENU_SCRIPT="$XDG_DATA_HOME/regexghost/wm-scripts/dmenu-runner.sh"

stream="$(cat "$XDG_CONFIG_HOME/regexghost/streams.csv" | cut -d "," -f 1 | "$DMENU_SCRIPT" "Select Stream:" -ix)"

line="$(sed -n "$((stream+1))p" "$XDG_CONFIG_HOME/regexghost/streams.csv")"
twitch="$(echo "$line" | cut -d "," -f 2)"
youtube="$(echo "$line" | cut -d "," -f 3)"
kick="$(echo "$line" | cut -d "," -f 4)"

if ! [ "$youtube" = "NONE" ]; then
	mpv --no-resume-playback --ytdl-format="bestvideo[height<=480]" "https://youtube.com/${youtube}/live" && exit
fi

if ! [ "$kick" = "NONE" ]; then
	mpv --no-resume-playback --ytdl-format="2" "https://kick.com/${kick}" && exit
fi

if ! [ "$twitch" = "NONE" ]; then
	mpv --no-resume-playback "https://twitch.tv/${twitch}" && exit
fi

notify-send "Not live or unable to open stream"
