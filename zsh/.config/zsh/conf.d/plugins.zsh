# Plugin manager (antidote) + custom fpath + batched deferred loading.

fpath=($ZDOTDIR/functions $ZDOTDIR/completions $fpath)
autoload -Uz $ZDOTDIR/functions/*(N.:t)

# Antidote: only manages downloads and fpath, all kind:fpath
ANTIDOTE_HOME=${XDG_CACHE_HOME:-$HOME/.cache}/antidote

() {
  local src=$ZDOTDIR/.zsh_plugins.txt out=$ZDOTDIR/.zsh_plugins.zsh
  if [[ ! -f $out || $src -nt $out ]]; then
    local antidote=${HOMEBREW_PREFIX:-/usr/local}/opt/antidote/share/antidote/antidote.zsh
    [[ -f $antidote ]] && source $antidote && antidote bundle <$src >$out
  fi
  [[ -f $out ]] && source $out
}

# Load zsh-defer, then batch all interactive plugins into ONE deferred call.
# This results in a single prompt redraw instead of one per plugin.
source $ANTIDOTE_HOME/github.com/romkatv/zsh-defer/zsh-defer.plugin.zsh

zsh-defer -c '
  source $ANTIDOTE_HOME/github.com/Aloxaf/fzf-tab/fzf-tab.plugin.zsh
  source $ANTIDOTE_HOME/github.com/hlissner/zsh-autopair/zsh-autopair.plugin.zsh
  source $ANTIDOTE_HOME/github.com/zsh-users/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
  source $ANTIDOTE_HOME/github.com/zdharma-continuum/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
  _fsh_theme
'
