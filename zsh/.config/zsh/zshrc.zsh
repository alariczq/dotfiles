# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

[ -z "$TERM" ] || ! infocmp "$TERM" >/dev/null 2>&1 && export TERM=xterm-256color

# zsh 命令行提示符 % 问题
PROMPT_EOL_MARK=''

HIST_STAMPS='yyyy-mm-dd'

export FZF_DEFAULT_COMMAND='fd --type f'
export FZF_DEFAULT_OPTS='
--ansi 
--prompt="❯ " 
--pointer="▌ " 
--marker=" " 
--layout=reverse 
--info="inline: " 
--scrollbar=▊ 
--color=pointer:#9d79d6,header:#738091,prompt:#baa1e2,border:#39506d,scrollbar:#39506d,gutter:#192330,marker:#9d79d6,separator:#39506d,hl:#9d79d6,info:#dc8ed9,hl+:#9d79d6,bg+:#29394f,spinner:#baa1e2,fg+:#cdcecf'


zstyle ':fzf-tab:complete:_zlua:*' query-string input
zstyle ':fzf-tab:complete:kill:argument-rest' fzf-preview 'ps -p $word -o command -w -w | sed -e 1d'
zstyle ':fzf-tab:complete:kill:argument-rest' fzf-flags '--preview-window=down:3:wrap'
zstyle ':fzf-tab:complete:kill:*' popup-pad 0 3
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:complete:cd:*' popup-pad 80 0
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
zstyle ':fzf-tab:*' switch-group ',' '.'
zstyle ':fzf-tab:*' use-fzf-default-opts yes

zstyle ":completion:*:git-checkout:*" sort false
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' file-sort modification
zstyle ':completion:*' sort false # disable sort completions
zstyle ':completion:*:exa' sort false
zstyle ':completion:files' sort false

command -v nvim >/dev/null && export EDITOR=nvim || export EDITOR=vim

# 加强版通配符
setopt EXTENDED_GLOB

# 用 vim 编辑命令行
autoload -U       edit-command-line
zle -N            edit-command-line
bindkey '^o'      edit-command-line     # C-o 打开 vim 编辑命令行

typeset -A ZINIT=(
  BIN_DIR         $ZDOTDIR/zinit/bin
  HOME_DIR        $ZDOTDIR/zinit
  COMPINIT_OPTS   -C
)

source $ZDOTDIR/zinit/bin/zinit.zsh

FPATH=$XDG_CONFIG_HOME/zsh/functions:"$XDG_CONFIG_HOME/zsh/completions":$FPATH
autoload -Uz $XDG_CONFIG_HOME/zsh/functions/*(:t)

pathctl load $ZDOTDIR/.env >/dev/null 2>&1

command -v brew >/dev/null 2>&1 && eval "$(/opt/homebrew/bin/brew shellenv)"
command -v mise >/dev/null 2>&1 && eval "$(mise activate --shims)"

GENCOMP_DIR=$XDG_CONFIG_HOME/zsh/completions

export _ZL_DATA=$ZDOTDIR/.z
# ZSHZ_DATA=$ZDOTDIR/.z

for snp in $ZDOTDIR/snippets/*.zsh; do
  source $snp
done

zstyle ':zce:*' keys 'asdghklqwertyuiopzxcvbnmfj;23456789'

zicompinit; zicdreplay

# zinit 配置
zinit lucid nocd light-mode for $libs
zinit lucid nocd light-mode for $snippets
zinit lucid nocd light-mode for $keybinds
zinit lucid as"completion" for $completions
zinit wait lucid depth"1" nocd light-mode for $plugins
zinit lucid light-mode for $programs

# source $ZDOTDIR/.p10k.zsh
zinit depth"1 " nocd light-mode for romkatv/powerlevel10k


# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh
