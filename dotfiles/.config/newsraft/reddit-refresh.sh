#!/bin/sh

USER_AGENT="NetSurf/3.10 (Linux)"
TMP_LOC="/tmp/reddit-rss"

[ -d "$XDG_CACHE_HOME/reddit-rss" ] && cp "$XDG_CACHE_HOME/reddit-rss" "$TMP_LOC" || mkdir "$TMP_LOC"

while true; do
	while read -r subreddit; do
		sleep 20
		curl -s -L --user-agent "$USER_AGENT" "https://www.reddit.com/r/${subreddit}/top/.rss?t=week" > "${TMP_LOC}/r.${subreddit}"
	done < "$XDG_CONFIG_HOME/newsraft/reddit-rss.txt"
	sleep 3600
done
