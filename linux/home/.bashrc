[[ $- != *i* ]] && return

prompt_command () {
  HISTCMD_before_last=$HISTCMD_previous
  HISTCMD_previous=$(history 1 | grep -oP '^\ +\K[0-9]+'); 
  
  if [[ $HISTCMD_before_last = "$HISTCMD_previous" ]]; then
    printf "\e[2A\e[2K\e[0J> \n"
  fi
  
  PS1='┌─[\u@\h]──[\w]\n'

}

PROMPT_COMMAND='prompt_command'

alias ls='ls --color=auto'
PS0='\e[2A\e[2K\e[0J> $(fc -ln -0 | xargs) \n'

fastfetch
