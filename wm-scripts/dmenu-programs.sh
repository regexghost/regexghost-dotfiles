#!/bin/sh

DMENU_RUNNER="$XDG_DATA_HOME/regexghost/wm-scripts/dmenu-runner.sh"

dmenu_path | "$DMENU_RUNNER" | ${SHELL:-"/bin/sh"} &
