#!/bin/sh

tmux new-session -d -s mys "NNN_FIFO=/tmp/nnn.fifo NNN_PLUG=v:preview-tui nnn -P v"
tmux attach -t mys
