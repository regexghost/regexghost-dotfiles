# Alias for the ls, find and du commands

# Root Alias

alias ls='/usr/bin/ls --group-directories-first --file-type -N -h --color=auto'

# -A = -a but without "." and ".."
# -h means values will be human readable, if -l given
# -N = no quotes around names with spaces

## File Displaying

### Normal

alias l='ls -1'
alias la='ls -1 -A'
alias lsa='ls -A'

### Directories Only

# Using --file-type here displays a second "/" after the directory

alias ld='/usr/bin/ls --group-directories-first -N -1 -h --color=auto -d */ 2> /dev/null'
alias lda='/usr/bin/ls --group-directories-first -N -1 -h --color=auto -d */ .*/ 2> /dev/null'
alias lsd='/usr/bin/ls --group-directories-first -N -h --color=auto -d */ 2> /dev/null'
alias lsda='/usr/bin/ls --group-directories-first -N -h --color=auto -d */ .*/ 2> /dev/null'

### For FAT filesystems, to make it readable with coloured output

# Root Alias

alias lsfat='/usr/bin/ls --group-directories-first --file-type -N -h --color=no'

alias lfat='lsfat -1'
alias lafat='lsfat -1 -A'
alias lsafat='lsfat -A'

### Directories Only (FAT)

alias ldfat='/usr/bin/ls --group-directories-first -N -1 -h --color=no -d */ 2> /dev/null'
alias ldafat='/usr/bin/ls --group-directories-first -N -1 -h --color=no -d */ .*/ 2> /dev/null'
alias lsdfat='/usr/bin/ls --group-directories-first -N -h --color=no -d */ 2> /dev/null'
alias lsdafat='/usr/bin/ls --group-directories-first -N -h --color=no -d */ .*/ 2> /dev/null'

## File Counting

### Normal

alias lc='ls | wc -l'
alias lca='ls -A | wc -l'
alias lcd='ls -d */ | wc -l'
alias lcda='ls -d */ .*/ | wc -l'

### Recursive

alias lcr="/usr/bin/find . -not -path '*/[@.]*' -type f | wc -l"
alias lcra="/usr/bin/find . -type f | wc -l"
alias lcdr="/usr/bin/find . -not -path '*/[@.]*' -type d | wc -l"
alias lcdra="/usr/bin/find . -type d | wc -l"

## File Sizes

alias ldu='/usr/bin/du -Sh --exclude "./.*" | tail -n 1'
alias ldua='/usr/bin/du -Sh | tail -n 1'
alias ldur='/usr/bin/du -h --exclude "./.*" | tail -n 1'
alias ldura='/usr/bin/du -h | tail -n 1'
