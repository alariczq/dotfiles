export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share

export TERM=${TERM:-xterm-256color}
export LANG=${LANG:-"en_US.UTF-8"}
export LC_COLLATE=${LC_COLLATE:-C}

ZDOTDIR=$XDG_CONFIG_HOME/zsh
skip_global_compinit=1

export GOPATH=$HOME/.local/go 
export GOBIN=$GOPATH/bin

export LESSHISTFILE=/dev/null
export PYTHONSTARTUP=$XDG_CONFIG_HOME/python/startup.py; [[ ! -e $PYTHONSTARTUP ]] && unset PYTHONSTARTUP
export SSH_PROXY=127.0.0.1:1081
export CHTSH=~/.config/cht.sh

export PATH=$ZDOTDIR/bin:$PATH

export ENVFILEPATH=$ZDOTDIR/env

export LDFLAGS="-L/usr/local/opt/mysql-client/lib"
export CPPFLAGS="-I/usr/local/opt/mysql-client/include"
