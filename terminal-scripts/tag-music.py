#!/usr/bin/env python3

import music_tag
from os.path import expanduser
import os
import json
import sys
import requests

home = expanduser("~")
xdg_data_home = os.environ["XDG_DATA_HOME"]
xdg_cache_home = os.environ["XDG_CACHE_HOME"]
art_file = xdg_cache_home + "/art.jpg"

inputFile = sys.argv[1]
genre = sys.argv[2]
albumArt = sys.argv[3]

cleanName = inputFile.replace(" - Topic", "")

split = cleanName.replace(".m4a", "").split(" -- ")

artist = split[1]
title = split[0]
album = split[2]

file = music_tag.load_file(inputFile)
file["title"] = title
file["artist"] = artist
file["album"] = album
file["genre"] = genre

r = requests.get(albumArt)
with open(art_file, "wb")as out:
	out.write(r.content)

with open(art_file, "rb") as img:
	file["artwork"] = img.read()

file.save()

metadata = xdg_data_home + "/regexghost/script-data/songs-metadata.csv"
f = open(metadata, "a")
f.write(inputFile.replace(" -- ", " - ") + "|" + title + "|" + artist + "|" + album + "|" + albumArt + "|" + genre + "\n")
f.close()


