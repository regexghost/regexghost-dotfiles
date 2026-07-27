#!/bin/sh

export NNN_FIFO=/tmp/nnn.fifo
export NNN_PLUG=v:preview-tui
tmux new-session -d -s mys "nnn -P v"
tmux attach
