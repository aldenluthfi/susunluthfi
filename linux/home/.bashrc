[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='┌─[\u@\h]──[\w]\n└─[i]→ \$ '
PS0='\r\r>'

set -o vi