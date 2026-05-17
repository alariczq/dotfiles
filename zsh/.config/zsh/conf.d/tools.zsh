# External tool initialization + fzf defaults + editor.

# Sync: needed before the prompt renders.
eval "$(mise activate zsh --shims)" 2>/dev/null
eval "$(starship init zsh)" 2>/dev/null

# Defer when zsh-defer is loaded, otherwise inline-eval as a fallback.
_lazy() {
  if (( $+functions[zsh-defer] )); then
    zsh-defer -c "$1"
  else
    eval "$1" 2>/dev/null
  fi
}
_lazy 'eval "$(pathctl activate)"'
_lazy 'eval "$(zoxide init zsh)"'
_lazy '(( $+commands[atuin]  )) && eval "$(atuin init zsh --disable-up-arrow)"'
_lazy '(( $+commands[direnv] )) && eval "$(direnv hook zsh)"'

(( $+commands[nvim] )) && EDITOR=nvim || EDITOR=vim
export EDITOR

export FZF_DEFAULT_COMMAND='fd --type f'
export FZF_DEFAULT_OPTS='
--ansi
--prompt="❯ "
--pointer="▌ "
--marker="✔ "
--layout=reverse
--info="inline: "
--scrollbar=▊
--color=fg:#c0caf5,pointer:#9d79d6,header:#738091,prompt:#baa1e2,border:#39506d,scrollbar:#39506d,gutter:#192330,marker:#73daca,separator:#39506d,hl:#9d79d6,info:#dc8ed9,hl+:#9d79d6,bg+:#29394f,spinner:#baa1e2,fg+:#cdcecf'
export _ZO_FZF_OPTS="$FZF_DEFAULT_OPTS --height=~40% --min-height=10 --preview='eza -1 --color=always --icons --group-directories-first {2..}'"
