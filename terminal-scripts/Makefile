BIN="${HOME}/.local/bin"
TERMINAL="${XDG_DATA_HOME}/regexghost/terminal"

normal:
	mkdir -p ${BIN}
	cp cmpfolder.sh ${BIN}/cmpfolder
	cp hashfolder.sh ${BIN}/hashfolder
	cp rm-trash.sh ${BIN}/rm-trash
	gcc -o directory_bookmarks directory_bookmarks.c
	mv directory_bookmarks ${BIN}/directory_bookmarks
	cp github_latest_release.sh ${BIN}/github_latest_release
	cp heic_to_jpg.sh ${BIN}/heictojpg
	cp backup.sh ${BIN}/backup
	cp qmount.sh ${BIN}/qmount
	go build -o tablealigner tablealigner.go
	mv tablealigner ${BIN}/tablealigner
	go build -o geohash geohash.go
	mv geohash ${BIN}/geohash
	cd soundboard/; go build -o soundboard soundboard.go; mv soundboard ${BIN}/soundboard; cd ..
	cp tag-song.sh ${BIN}/tag-song
	cp download-vids.sh ${BIN}/download-vids
	cp download-pods.sh ${BIN}/download-pods
	cp am-extract.sh ${BIN}/am-extract
	cp yt-data.sh ${BIN}/yt-data
	cp tag-music.py ${TERMINAL}/tag-music.py
	cp stream-check.sh ${BIN}/stream-check
	cp opus-soundtrack.sh ${BIN}/opus-soundtrack
	cp opus-single.sh ${BIN}/opus-single
	cp webm_to_m4a.sh ${BIN}/webm_to_m4a
	gcc string-trunc.c -o string-trunc
	mv string-trunc ${BIN}/string-trunc
	cp ytdl-wrapper.sh ${BIN}/ytdl-wrapper
	cp mymv.sh ${BIN}/mymv
	cp login-bsky.sh ${BIN}/login-bsky
	cp favs-backup.sh ${BIN}/favs-backup
	cp balance-folders.sh ${BIN}/balance-folders
	cp iphone-mount.sh ${BIN}/iphone-mount
	cp iphone-music-sync.sh ${BIN}/iphone-music-sync
	cp media-cut.sh ${BIN}/media-cut
