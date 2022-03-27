libs=(
  # OMZL::theme-and-appearance.zsh
  # OMZL::git.zsh
  # OMZL::prompt_info_functions.zsh

  OMZL::clipboard.zsh
  OMZL::completion.zsh
  OMZL::directories.zsh
  OMZL::history.zsh
  #OMZL::key-bindings.zsh
)

# ohmyzsh 相关
snippets=(
  nocd wait"2"
    OMZP::colored-man-pages/colored-man-pages.plugin.zsh
  nocd wait"0"
    OMZP::docker-compose/docker-compose.plugin.zsh
  nocd wait"0"
    OMZP::sudo/sudo.plugin.zsh
  nocd wait"0"
    OMZP::kubectl/kubectl.plugin.zsh
  nocd wait"2" 
    OMZP::extract/extract.plugin.zsh
)

# 补全
completions=(
  mv"*.zsh -> _fzf" atload'source _fzf'
    'https://github.com/junegunn/fzf/blob/master/shell/completion.zsh'

  'https://github.com/ogham/exa/blob/master/completions/zsh/_exa'

  nocd
    OMZP::docker-compose/_docker-compose

  nocd
    OMZP::docker/_docker

  nocd
    OMZP::fd/_fd

  nocd mv=":zsh -> _cht" 
    https://cheat.sh/:zsh
)

keybinds=(
  'https://github.com/junegunn/fzf/blob/master/shell/key-bindings.zsh'
)

set_fast_theme() {
    FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}alias]='fg=blue'
    FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}function]='fg=blue'
}

# 插件
plugins=(
  atload="set_fast_theme" atinit"zicompinit; zicdreplay"
    zdharma-continuum/fast-syntax-highlighting

  blockf atpull'zinit creinstall -q .'
    zsh-users/zsh-completions

  atload"_zsh_autosuggest_start"
    zsh-users/zsh-autosuggestions

  Aloxaf/fzf-tab

  hlissner/zsh-autopair

  #Aloxaf/zsh-histdb
  #wait"0c"
    #skywind3000/z.lua
  #changyuheng/fz
  agkozak/zsh-z

  # wait"0c"
  #   wfxr/forgit

  hchbaw/zce.zsh

)

programs=(
  mv=":cht.sh -> cht.sh" atclone="chmod +x cht.sh" as="program"
    https://cht.sh/:cht.sh
)

