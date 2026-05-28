#!/bin/sh

read -p "Enter artist name: " artist

results="$(curl -s "https://itunes.apple.com/search?term=${artist}&entity=musicArtist" | jq -r '.results[] | "\(.artistName) - \(.artistId)"' | nl)"

echo "$results"

read -p "Which one?: " selection

selectedArtistID="$(echo "$results" | sed -n "${selection}p" | sed 's/.* - //g')"

albums="$(curl -s "https://itunes.apple.com/lookup?id=${selectedArtistID}&entity=album" | jq -r '.results[] | "\(.collectionName) - \(.collectionId)"' | nl)"

echo "$albums"

read -p "Which album?: " selection

selectedAlbumID="$(echo "$albums" | sed -n "${selection}p" | sed 's/.* - //g')"

echo "$selectedAlbumID"

albumInfo="$(curl -s "https://itunes.apple.com/lookup?id=${selectedAlbumID}&entity=song" | jq -r '.results[] | "\(.trackName) - \(.artistName) - \(.collectionName)"')"
echo "$albumInfo"
