#!/usr/bin/env bash
set -e
[ -n "$PYENV_DEBUG" ] && set -x

program="${0##*/}"

export PYENV_ROOT="/home/aldenluthfi/.pyenv"
exec "/usr/share/pyenv/libexec/pyenv" exec "$program" "$@"
