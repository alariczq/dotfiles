# Command aliases.

# Modern replacements (only if installed)
(( $+commands[eza] )) && alias ls='eza -bh --icons --hyperlink'
(( $+commands[bat] )) && alias cat='bat --plain'

# ls family
alias l='ls -l'     ll='ls -la'   lt='ls --tree'

# Filesystem safety + shortcuts
alias rm='rm -i'    rd='rmdir'    md='mkdir -p'
alias cp='cp -v'    mv='mv -v'
alias df='df -h'    du='du -h'    dus='du -sh'    dusa='dus --apparent-size'

# Search
alias grep='command grep --colour=auto --binary-files=without-match'

# Misc
alias reload="exec $SHELL -l -i"
alias plast='last -20'
alias ts='date +%s'

# Editors / CLIs
alias v='nvim'
alias c='cursor' oc='opencode' cc='claude' cx='codex'
