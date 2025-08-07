command_check() {
	command -v "$1" &>/dev/null && alias "$2"
}

command_check eza 		'ls=eza -bh --icons'
command_check bat 		'cat=bat --plain'
command_check kitty 	        's=kitty +kitten ssh'

alias lh='ls --hyperlink'
# global alias
alias rm='rm -i'   	rd='rmdir'   		md='mkdir -p'
alias la='ls -la'  	lt='ls --tree'  	ll='ls -l'  l='ls'
alias dfh='df -h' 	dus='du -sh' 		del='gio trash' dusa='dus --apparent-size'
alias reload="exec $SHELL -l -i"  		grep="command grep --colour=auto --binary-files=without-match --directories=skip"
alias df='df -h'  	du='du -h'  plast="last -20"
alias cp='cp -v'   	mv='mv -v'
alias ts='date +%s'
alias v='nvim'
alias c='claude -p'

alias Sudo='command sudo '

alias sudo='_sudo'
_sudo() {
    local cmd=$1
    local type=$(which -w $cmd | cut -d\  -f2)

    if [[ $type == function ]]; then
        shift
        # TODO issue with calling nested function
        command sudo -E zsh -c "$(typeset -f $cmd);$cmd $*"
    elif [[ $type == alias ]]; then
        functions[_t_expand_alias]=$@ 2>/dev/null
        if (( $+functions[_t_expand_alias] )); then
            set -- ${(z)functions[_t_expand_alias]#$'\t'}
            unset -f _t_expand_alias

            local cmd=$1
            type=$(which -w $1 | cut -d\  -f2)
            if [[ $type == function ]]; then
                shift
                command sudo -E zsh -c "$(typeset -f $cmd);$cmd $*"
            else
                eval "command sudo -E $@"
            fi
        fi
    else
        command sudo -E $@
    fi
}
