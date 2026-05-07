BIN="${HOME}/.local/bin"

normal:
	mkdir -p ${BIN}
	cp cmpfolder.sh ${BIN}/cmpfolder
	cp hashfolder.sh ${BIN}/hashfolder
	cp rm-trash.sh ${BIN}/rm-trash
	gcc -o directory_bookmarks directory_bookmarks.c
	mv directory_bookmarks ${BIN}/directory_bookmarks
	cp github_latest_release.sh ${BIN}/github_latest_release
	cp heic_to_jpg.sh ${BIN}/heictojpg
	go build -o tablealigner tablealigner.go
	mv tablealigner ${BIN}/tablealigner
