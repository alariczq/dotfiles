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

