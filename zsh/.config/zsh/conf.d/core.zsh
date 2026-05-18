# Shell behavior: options, history, keybindings.

[[ -z $TERM ]] && export TERM=xterm-256color
PROMPT_EOL_MARK=''

setopt EXTENDED_GLOB INTERACTIVE_COMMENTS NO_BEEP
setopt AUTO_CD AUTO_PUSHD PUSHD_IGNORE_DUPS PUSHD_MINUS

HISTFILE=$ZDOTDIR/.zsh_history
HISTSIZE=50000
SAVEHIST=100000
setopt EXTENDED_HISTORY HIST_EXPIRE_DUPS_FIRST HIST_IGNORE_DUPS HIST_SAVE_NO_DUPS
setopt HIST_IGNORE_SPACE HIST_VERIFY INC_APPEND_HISTORY HIST_FCNTL_LOCK
setopt HIST_REDUCE_BLANKS HIST_FIND_NO_DUPS

autoload -Uz add-zsh-hook
_drop_long_history() { (( $#1 > 200 )) && return 2; return 0 }
add-zsh-hook zshaddhistory _drop_long_history

bindkey -e
KEYTIMEOUT=1
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search edit-command-line
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
zle -N edit-command-line
zle -N _fancy_ctrl_z
zle -N _sudo_prepend

bindkey "$terminfo[khome]"  beginning-of-line
bindkey "$terminfo[kend]"   end-of-line
bindkey "$terminfo[kdch1]"  delete-char
bindkey "$terminfo[kcuu1]"  up-line-or-beginning-search
bindkey "$terminfo[kcud1]"  down-line-or-beginning-search
bindkey '^[[1;5C'           forward-word
bindkey '^[[1;5D'           backward-word
bindkey '^w'                backward-kill-word
bindkey '^d'                delete-char
bindkey '^o'                edit-command-line
bindkey '^[q'               push-line-or-edit
bindkey ' '                 magic-space
bindkey '^Z'                _fancy_ctrl_z
bindkey '^[^['              _sudo_prepend
bindkey '^[[109;5u'         accept-line
bindkey '^[[27;2;13~'       accept-line

export FZF_DEFAULT_COMMAND='fd --type f'
export FZF_DEFAULT_OPTS='--ansi
--prompt="❯ "
--pointer="▌ "
--marker="✔ "
--layout=reverse
--info="inline: "
--scrollbar=▊
--color=fg:#c0caf5,\
pointer:#9d79d6,\
header:#738091,\
prompt:#baa1e2,\
border:#39506d,\
scrollbar:#39506d,\
gutter:#192330,\
marker:#73daca,\
separator:#39506d,\
hl:#9d79d6,\
info:#dc8ed9,\
hl+:#9d79d6,\
bg+:#29394f,\
spinner:#baa1e2,\
fg+:#cdcecf'
export _ZO_FZF_OPTS="$FZF_DEFAULT_OPTS --height=~40% --min-height=10 --preview='eza -1 --color=always --icons --group-directories-first {2..}'"

(( $+commands[nvim] )) && EDITOR=nvim || EDITOR=vim
export EDITOR

(( $+commands[switch-ime] )) && { switch-ime com.apple.keylayout.ABC &>/dev/null &! }
