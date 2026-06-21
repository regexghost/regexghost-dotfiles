#!/bin/sh

CONFIG_FILE="$XDG_CONFIG_HOME/regexghost/streams.csv"

format="pretty"
[ "$1" = "-yn" ] && format="yn" && shift

line="$(grep "^${1}," "$CONFIG_FILE")"
[ "$line" = "" ] && exit

name="$(echo "$line" | cut -d "," -f 1)"
twitch_at="$(echo "$line" | cut -d "," -f 2)"
youtube_at="$(echo "$line" | cut -d "," -f 3)"
kick_at="$(echo "$line" | cut -d "," -f 4)"

if ! [ "$twitch_at" = "NONE" ]; then
	curl --connect-timeout 5 -s "https://www.twitch.tv/${twitch_at}" > /tmp/live_twitch.html
	if grep -q "live_user" /tmp/live_twitch.html; then
		if [ "$format" = "pretty" ]; then
			echo "${name} is live on Twitch: https://www.twitch.tv/${twitch_at}"
		elif [ "$format" = "yn" ]; then
			echo "y"
			exit
		fi
	fi
fi
if ! [ "$youtube_at" = "NONE" ]; then
	curl --connect-timeout 5 -s "https://www.youtube.com/${youtube_at}/live" > /tmp/live_youtube.html
	if grep -q "isUpcoming\":true" /tmp/live_youtube.html; then
		if [ "$format" = "pretty" ]; then
			echo "${name} is about to go live on YouTube: https://www.youtube.com/${youtube_at}/live"
		elif [ "$format" = "yn" ]; then
			echo "w"
			exit
		fi
	elif grep -q "isLive\":true" /tmp/live_youtube.html; then
		if [ "$format" = "pretty" ]; then
			echo "${name} is live on YouTube: https://www.youtube.com/${youtube_at}/live"
		elif [ "$format" = "yn" ]; then
			echo "y"
			exit
		fi
	fi
fi
if ! [ "$kick_at" = "NONE" ]; then
	wget --hsts-file="$XDG_STATE_HOME/wget-hsts" --timeout=5 -q --user-agent "NetSurf" "https://kick.com/api/v1/channels/${kick_at}" -O /tmp/live_kick.html
	if grep -q "is_live\":true" /tmp/live_kick.html; then
		if [ "$format" = "pretty" ]; then
			echo "${name} is live on Kick: https://www.kick.com/${kick_at}"
		elif [ "$format" = "yn" ]; then
			echo "y"
			exit
		fi
	fi
fi

if [ "$format" = "yn" ]; then
	echo "n"
	exit
fi
