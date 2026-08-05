#!/bin/sh

DMENU_SCRIPT="$XDG_DATA_HOME/regexghost/wm-scripts/dmenu-runner.sh"

stream="$(cat "$XDG_CONFIG_HOME/regexghost/streams.csv" | cut -d "," -f 1 | "$DMENU_SCRIPT" "Select Stream:" -ix)"

[ "$stream" = "" ] && exit

line="$(sed -n "$((stream+1))p" "$XDG_CONFIG_HOME/regexghost/streams.csv")"
name="$(echo "$line" | cut -d "," -f 1)"
twitch="$(echo "$line" | cut -d "," -f 2)"
youtube="$(echo "$line" | cut -d "," -f 3)"
kick="$(echo "$line" | cut -d "," -f 4)"

# Try YouTube, then Kick, then Twitch

if ! [ "$youtube" = "NONE" ]; then
	notify-send "Launching ${name} YouTube stream"
	mpv --no-resume-playback --ytdl-format="best[height<=480]" "https://youtube.com/${youtube}/live" && exit
	notify-send "Failed to open YouTube stream"
fi

if ! [ "$kick" = "NONE" ]; then
	notify-send "Launching ${name} Kick stream"
	mpv --no-resume-playback --ytdl-format="2" "https://kick.com/${kick}" && exit
	notify-send "Failed to open Kick stream"
fi

if ! [ "$twitch" = "NONE" ]; then
	notify-send "Launching ${name} Twitch stream"
	mpv --no-resume-playback "https://twitch.tv/${twitch}" && exit
	notify-send "Failed to open Twitch stream"
fi

notify-send "Not live or unable to open stream"
