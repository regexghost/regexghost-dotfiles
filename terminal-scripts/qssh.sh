#!/bin/sh

host="$(grep "^Host" ~/.ssh/config | cut -d " " -f 2- | fzf)"

[ "$host" = "" ] && exit

ssh "$host"
