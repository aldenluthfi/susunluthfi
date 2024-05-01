if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

if [ ! -f $HOME/.local/share/bash/.bash_history ]; then
    mkdir -p $HOME/.local/share/bash
    touch $HOME/.local/share/bash/.bash_history
fi

EXPORT HISTFILE=$HOME/.local/share/bash/.bash_history

Hyprland