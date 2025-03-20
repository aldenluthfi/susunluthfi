# vi mode
bindkey -v

# Fix bugs when switching modes
bindkey "^?" backward-delete-char
bindkey "^u" backward-kill-line
bindkey "^a" beginning-of-line
bindkey "^e" end-of-line
bindkey "^k" kill-line

# variables for PS3 prompt
newline=$'\n'

# PS3 prompt function
function zle-line-init zle-keymap-select {
    PS1="┌─[%n@%m]──[%~] ${newline}└─${${KEYMAP/vicmd/[n]}/(main|viins)/[i]}-> $ "
    zle reset-prompt
}

del-prompt-accept-line() {
    OLD_PROMPT="$PROMPT"
    PROMPT="> "
    zle reset-prompt
    PROMPT="$OLD_PROMPT"
    zle accept-line
}

# run PS3 prompt function
zle -N zle-line-init
zle -N zle-keymap-select
zle -N del-prompt-accept-line
bindkey "^M" del-prompt-accept-line
