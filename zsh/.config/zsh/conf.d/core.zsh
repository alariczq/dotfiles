# Shell behavior: options, history, key bindings.

# Terminal / prompt defaults
[[ -z $TERM ]] && export TERM=xterm-256color
PROMPT_EOL_MARK=''

# Shell options
setopt EXTENDED_GLOB
setopt AUTO_CD AUTO_PUSHD PUSHD_IGNORE_DUPS PUSHD_MINUS

# History
HISTFILE=$ZDOTDIR/.zsh_history
HISTSIZE=50000
SAVEHIST=100000
setopt EXTENDED_HISTORY HIST_EXPIRE_DUPS_FIRST HIST_IGNORE_DUPS HIST_SAVE_NO_DUPS
setopt HIST_IGNORE_SPACE HIST_VERIFY INC_APPEND_HISTORY HIST_FCNTL_LOCK

# Drop very long entries (>200 chars) from history
autoload -Uz add-zsh-hook
add-zsh-hook zshaddhistory _drop_long_history
_drop_long_history() { (( $#1 > 200 )) && return 2; return 0 }

# Emacs keybindings + history search
bindkey -e
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

bindkey "$terminfo[khome]"  beginning-of-line
bindkey "$terminfo[kend]"   end-of-line
bindkey "$terminfo[kdch1]"  delete-char
bindkey "$terminfo[kcuu1]"  up-line-or-beginning-search
bindkey "$terminfo[kcud1]"  down-line-or-beginning-search
bindkey '^[[1;5C'           forward-word
bindkey '^[[1;5D'           backward-word
bindkey '^w'                backward-kill-word
bindkey ' '                 magic-space
bindkey '^d'                delete-char
bindkey '^[q'               push-line-or-edit

autoload -U edit-command-line
zle -N edit-command-line
bindkey '^o' edit-command-line
