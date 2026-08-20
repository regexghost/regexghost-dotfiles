#!/bin/sh

# Simple script to give each st window a random title from a list

LIST="$XDG_CONFIG_HOME/regexghost/terminal-names.txt"

name="$(cat "$LIST" | grep -v "^#" | shuf -n 1)"

st -t "$name"
