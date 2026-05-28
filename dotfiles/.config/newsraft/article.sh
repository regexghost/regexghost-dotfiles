#!/bin/sh

if echo "$1" | grep -q "bbc"; then
	~/.config/newsraft/bbc-news.sh "$1"
fi
