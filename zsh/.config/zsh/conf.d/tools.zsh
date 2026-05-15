# External tool initialization + fzf defaults + editor.

# Sync: needed before prompt renders
eval "$(mise activate zsh --shims)" 2>/dev/null
eval "$(starship init zsh)" 2>/dev/null
[[ -f $ZDOTDIR/conf.d/starship-async.zsh ]] && source $ZDOTDIR/conf.d/starship-async.zsh

# Defer: not needed until user interacts
if (( $+functions[zsh-defer] )); then
  zsh-defer -c 'eval "$(pathctl activate)"'
  zsh-defer -c 'eval "$(zoxide init zsh)"'
  zsh-defer -c 'eval "$(fzf --zsh)"'
else
  eval "$(pathctl activate)" 2>/dev/null
  eval "$(zoxide init zsh)" 2>/dev/null
  eval "$(fzf --zsh)" 2>/dev/null
fi

# fzf defaults
export FZF_DEFAULT_COMMAND='fd --type f'
export FZF_DEFAULT_OPTS='
--ansi
--prompt="❯ "
--pointer="▌ "
--marker=" "
--layout=reverse
--info="inline: "
--scrollbar=▊
--color=pointer:#9d79d6,header:#738091,prompt:#baa1e2,border:#39506d,scrollbar:#39506d,gutter:#192330,marker:#9d79d6,separator:#39506d,hl:#9d79d6,info:#dc8ed9,hl+:#9d79d6,bg+:#29394f,spinner:#baa1e2,fg+:#cdcecf'

# Editor
(( $+commands[nvim] )) && EDITOR=nvim || EDITOR=vim
export EDITOR

export _ZO_FZF_OPTS="$FZF_DEFAULT_OPTS --preview='eza -1 --color=always --icons --group-directories-first {2..}'"

