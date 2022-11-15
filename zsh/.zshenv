export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share

export LANG="en_US.UTF-8"

ZDOTDIR=$XDG_CONFIG_HOME/zsh
skip_global_compinit=1

export GOPATH=$HOME/.local/go 
export GOBIN=$GOPATH/bin

export LESSHISTFILE=/dev/null
export PYTHONSTARTUP=$XDG_CONFIG_HOME/python/startup.py; [[ ! -e $PYTHONSTARTUP ]] && unset PYTHONSTARTUP
export SSH_PROXY=127.0.0.1:1081
export CHTSH=~/.config/cht.sh

export ENV_FILE=$ZDOTDIR/env
export PATH=${(j.:.)$(sed -e 's/^[ \t]*//' -e '/^[^#]/ s/^/echo /' $ENV_FILE 2>/dev/null| sh)}:$PATH
