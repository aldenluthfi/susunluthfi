[[ $- != *i* ]] && return

prompt_command () {
  HISTCMD_previous=$(fc -l -1); HISTCMD_previous=${HISTCMD_previous%%$'[\t ]'*}
  if [[ -z $HISTCMD_before_last ]]; then
    PS1='┌─[\u@\h]──[\w]\n'
  elif [[ $HISTCMD_before_last = "$HISTCMD_previous" ]]; then
    PS1='> '
  fi
  HISTCMD_before_last=$HISTCMD_previous
}

PROMPT_COMMAND='prompt_command'

alias ls='ls --color=auto'
PS0='\e[2A\e[2K\e[0J> $(fc -ln -0 | xargs) \n'

fastfetch
