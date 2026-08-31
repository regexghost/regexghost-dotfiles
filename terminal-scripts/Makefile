BIN="${HOME}/.local/bin"
TERMINAL="${XDG_DATA_HOME}/regexghost/terminal"

normal:
	mkdir -p ${BIN}
	cp cmpfolder.sh ${BIN}/cmpfolder
	cp hashfolder.sh ${BIN}/hashfolder
	cp rm-trash.sh ${BIN}/rm-trash
	gcc -o directory-bookmarks directory-bookmarks.c
	mv directory-bookmarks ${BIN}/directory-bookmarks
	cp github-latest-release.sh ${BIN}/github-latest-release
	cp heic-to-jpg.sh ${BIN}/heic-to-jpg
	cp backup.sh ${BIN}/backup
	cp qmount.sh ${BIN}/qmount
	go build -o tablealigner tablealigner.go
	mv tablealigner ${BIN}/tablealigner
	go build -o geohash geohash.go
	mv geohash ${BIN}/geohash
	cd soundboard/; go get; go build -o soundboard soundboard.go; mv soundboard ${BIN}/soundboard; cd ..
	cp tag-song.sh ${BIN}/tag-song
	cp download-vids.sh ${BIN}/download-vids
	cp download-pods.sh ${BIN}/download-pods
	cp am-extract.sh ${BIN}/am-extract
	cp yt-data.sh ${BIN}/yt-data
	cp tag-music.py ${TERMINAL}/tag-music.py
	cp stream-check.sh ${BIN}/stream-check
	cp opus-soundtrack.sh ${BIN}/opus-soundtrack
	cp opus-single.sh ${BIN}/opus-single
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
	cp os-transfer-backup.sh ${BIN}/os-transfer-backup
	cp vid-play.sh ${BIN}/vid-play
	cp blog-devlog.sh ${BIN}/blog-devlog
	cp howlongtobeat.py ${TERMINAL}/howlongtobeat.py
	cp files.sh ${BIN}/files
	cp calendar.sh ${BIN}/calendar
	cp date-time.sh ${BIN}/date-time
	cp qssh.sh ${BIN}/qssh
	cp podcast-play.sh ${BIN}/podcast-play
	cp st-title.sh ${BIN}/st-title
