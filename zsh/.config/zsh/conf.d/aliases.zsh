# Command aliases.

(( $+commands[eza] )) && alias ls='eza -bh --icons --hyperlink'
(( $+commands[bat] )) && alias cat='bat --plain'

alias l='ls -l'    ll='ls -la'   lt='ls --tree'

# Global aliases so `cd ...`, `ls ....`, `cp x ..../y` etc. all expand inline.
# `..` is a real dir + AUTO_CD covers it; start from 3 dots upward.
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'

alias rm='rm -i'   rd='rmdir'    md='mkdir -p'
alias cp='cp -v'   mv='mv -v'
alias df='df -h'   du='du -h'    dus='du -sh'   dusa='dus --apparent-size'

alias grep='command grep --colour=auto --binary-files=without-match'

alias reload="exec $SHELL -l -i"
alias plast='last -20'
alias ts='date +%s'

alias v='nvim'
alias c='cursor'   oc='opencode'  cc='claude'    cx='codex'
