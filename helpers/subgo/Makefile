normal:
	go build -o sub sub.go

clean:
	rm sub

install:
	cp sub "${HOME}/.local/bin"

test:
	./test.sh

full: normal install clean
