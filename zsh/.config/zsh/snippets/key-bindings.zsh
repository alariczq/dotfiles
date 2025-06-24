local -A keybindings=(
    'Home'   beginning-of-line
    'End'    end-of-line
    'Delete' delete-char
    'Up'     up-line-or-beginning-search
    'Down'   down-line-or-beginning-search

    'C-Right'     forward-word
    'C-Left'      backward-word
    #'C-Backspace' backward-kill-word
    'C-w' backward-kill-word
    'Space' magic-space  # 按空格展开历史
    'C-d'   delete-char  # 不需要触发补全的功能
    #'C-w'   kill-region

    # 单行模式下将当前内容入栈开启一个临时 prompt
    # 多行模式下允许编辑前面的行
    'M-q' push-line-or-edit

    # 'C-j' self-insert-unmeta
)

setopt autocd
autoload -Uz zcalc zmv
autoload -U colors && colors

# 快速跳转到指定字符
function zce-jump-char() {
    [[ -z $BUFFER ]] && zle up-history
    zstyle ':zce:*' prompt-char '%B%F{green}Jump to character:%F%b '
    zstyle ':zce:*' prompt-key '%B%F{green}Target key:%F%b '
    with-zce zce-raw zce-searchin-read
    CURSOR+=1
}
zle -N zce-jump-char
keybindings[M-j]=zce-jump-char

ebindkey -A keybindings

