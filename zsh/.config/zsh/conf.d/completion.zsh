# Completion system + fzf-tab integration.

WORDCHARS=''
zmodload zsh/complist
autoload -Uz compinit

# Skip security check + run -C if dump is fresh (<24h) for faster startup
() {
  local zcompdump=${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump
  [[ -d ${zcompdump:h} ]] || mkdir -p ${zcompdump:h}
  if [[ -f $zcompdump(#qNm-1) ]]; then
    compinit -C -d $zcompdump
  else
    compinit -d $zcompdump
  fi
}

# Optional richer completions from carapace. Deferred so the ~22ms compdef
# load happens after the first prompt; cached to avoid regenerating each time.
if (( $+commands[carapace] )); then
  export CARAPACE_BRIDGES=${CARAPACE_BRIDGES:-zsh,fish,bash}
  _carapace_load='
    local cache=${XDG_CACHE_HOME:-$HOME/.cache}/zsh/carapace.zsh
    [[ -d ${cache:h} ]] || mkdir -p ${cache:h}
    if [[ ! -r $cache || $commands[carapace] -nt $cache ]]; then
      carapace _carapace >| $cache
    fi
    source $cache
  '
  if (( $+functions[zsh-defer] )); then
    zsh-defer -c $_carapace_load
  else
    eval $_carapace_load
  fi
  unset _carapace_load
fi

# Core completion behavior
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path ${XDG_CACHE_HOME:-$HOME/.cache}/zsh/compcache
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' sort false
zstyle ':completion:*:descriptions' format '▎ %d'

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
zstyle ':fzf-tab:*' active-group-style none

# Group indicator + colors (Tokyo Night palette, matches FZF_DEFAULT_OPTS).
# Reset (\e[0m) is embedded in `prefix` so the group color only paints the bar,
# leaving the word and description in the terminal's default fg for readability.
zstyle ':fzf-tab:*' prefix $'▎\e[0m '
zstyle ':fzf-tab:*' default-color $'\e[38;2;115;128;145m'
zstyle ':fzf-tab:*' group-colors \
  $'\e[38;2;157;121;214m' \
  $'\e[38;2;122;162;247m' \
  $'\e[38;2;115;218;202m' \
  $'\e[38;2;158;206;106m' \
  $'\e[38;2;224;175;104m' \
  $'\e[38;2;255;158;100m' \
  $'\e[38;2;247;118;142m' \
  $'\e[38;2;220;142;217m'
