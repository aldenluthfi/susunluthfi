[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='┌─[\u@\h]──[\w]\n└─[i]→ \$ '
PS0='\e[2A\e[2K\e[0J> $(fc -ln -0 | xargs) \n'

set -o vi