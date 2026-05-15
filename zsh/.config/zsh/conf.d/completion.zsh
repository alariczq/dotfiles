# Completion system + fzf-tab integration.

WORDCHARS=''
zmodload zsh/complist
autoload -Uz compinit

# Skip security check + run -C if dump is fresh (<24h) for faster startup
() {
  local zcompdump=$ZDOTDIR/.zcompdump
  if [[ -f $zcompdump(#qNm-1) ]]; then
    compinit -C -d $zcompdump
  else
    compinit -d $zcompdump
  fi
}

# Core completion behavior
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path ${XDG_CACHE_HOME:-$HOME/.cache}/zsh/compcache
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' sort false
zstyle ':completion:*:descriptions' format '[%d]'

# Per-command tweaks
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=01;34=0=01'
zstyle ':completion:*:*:*:*:processes' command "ps -u $USERNAME -o pid,user,comm -w -w"
zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories

# fzf-tab
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath --icons=auto'
zstyle ':fzf-tab:complete:kill:argument-rest' fzf-preview 'ps -p $word -o command -w -w | sed -e 1d'
zstyle ':fzf-tab:complete:kill:argument-rest' fzf-flags '--preview-window=down:3:wrap'
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
zstyle ':fzf-tab:*' switch-group ',' '.'
zstyle ':fzf-tab:*' use-fzf-default-opts yes
