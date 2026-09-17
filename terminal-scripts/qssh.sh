#!/bin/sh

hosts="$(grep "^Host ${1}" ~/.ssh/config | cut -d " " -f 2-)"

# If only one host, skip fzf
if [ "$(echo "$hosts" | wc -l)" -eq 1 ]; then
	host="$hosts"
else
	host="$(echo "$hosts" | fzf)"
fi

[ "$host" = "" ] && exit

ssh "$host"
