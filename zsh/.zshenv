export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share

export LANG=${LANG:-"en_US.UTF-8"}
export LC_COLLATE=${LC_COLLATE:-C}

ZDOTDIR=$XDG_CONFIG_HOME/zsh
skip_global_compinit=1

export LESSHISTFILE=/dev/null
export PYTHONSTARTUP=$XDG_CONFIG_HOME/python/startup.py; [[ ! -e $PYTHONSTARTUP ]] && unset PYTHONSTARTUP
export CHTSH=~/.config/cht.sh

export PATH=$ZDOTDIR/bin:$PATH

export GOPATH=$HOME/.local/go
export GOBIN=$GOPATH/bin
export RUSTUP_HOME=$HOME/.local/rustup
export CARGO_HOME=$HOME/.local/cargo

[ -f $HOME/.zshenv.local ] && source $HOME/.zshenv.local
