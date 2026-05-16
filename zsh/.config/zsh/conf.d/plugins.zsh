# Plugin manager (antidote) + custom fpath + batched deferred loading.

fpath=($ZDOTDIR/functions $ZDOTDIR/completions $fpath)
autoload -Uz $ZDOTDIR/functions/*(N.:t)

ANTIDOTE_HOME=${XDG_CACHE_HOME:-$HOME/.cache}/antidote

# Bootstrap antidote: try Homebrew first, fall back to git clone
() {
  local antidote_zsh
  for antidote_zsh in \
    ${HOMEBREW_PREFIX:-/usr/local}/opt/antidote/share/antidote/antidote.zsh \
    $ANTIDOTE_HOME/antidote/antidote.zsh; do
    [[ -f $antidote_zsh ]] && break
  done

  if [[ ! -f $antidote_zsh ]]; then
    print -P "%F{yellow}antidote not found, cloning...%f"
    git clone --depth=1 https://github.com/mattmc3/antidote.git $ANTIDOTE_HOME/antidote || return 1
    antidote_zsh=$ANTIDOTE_HOME/antidote/antidote.zsh
  fi

  source $antidote_zsh

  local src=$ZDOTDIR/.zsh_plugins.txt out=$ZDOTDIR/.zsh_plugins.zsh
  if [[ ! -f $out || $src -nt $out ]]; then
    antidote bundle <$src >$out
  fi
  [[ -f $out ]] && source $out
}

# Batch all interactive plugins into ONE deferred call for a single prompt redraw.
local _defer=$ANTIDOTE_HOME/github.com/romkatv/zsh-defer/zsh-defer.plugin.zsh
if [[ -f $_defer ]]; then
  source $_defer
  zsh-defer -m -p -c '
    source $ANTIDOTE_HOME/github.com/Aloxaf/fzf-tab/fzf-tab.plugin.zsh
    source $ANTIDOTE_HOME/github.com/hlissner/zsh-autopair/zsh-autopair.plugin.zsh
    source $ANTIDOTE_HOME/github.com/zsh-users/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
    source $ANTIDOTE_HOME/github.com/zdharma-continuum/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
    _fsh_theme
  '
fi
