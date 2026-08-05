#!/bin/sh

# Have to specify the variables as part of the command, otherwise if tmux is open elsewhere, it won't inherit environmental variables set here
tmux new-session -d -s mys "NNN_FIFO=/tmp/nnn.fifo NNN_PLUG=v:preview-tui nnn -P v"
tmux attach -t mys
