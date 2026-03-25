[[ $- != *i* ]] && return

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - bash)"

prompt_command () {
  HISTCMD_before_last=$HISTCMD_previous
  HISTCMD_previous=$(history 1 | grep -oP '^\ +\K[0-9]+');

  if [ "$HISTCMD_before_last" = "$HISTCMD_previous" ] && \
      [ "$HISTCMD_before_last" ] && \
      [ "$HISTCMD_previous" ];
  then
    printf "\e[2A\e[2K\e[0J> \n"
  fi

  PS1='┌─[\u@\h]──[\w]\n'

}

PROMPT_COMMAND='prompt_command'

alias ls='ls --color=auto'
PS0='\e[2A\e[2K\e[0J> $(fc -ln -0 | xargs) \n'

fastfetch
