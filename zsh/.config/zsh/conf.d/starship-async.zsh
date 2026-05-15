# Async wrapper for starship prompt.
# Requires: starship init zsh already sourced (sets prompt_starship_precmd).
# Remove this file to fall back to starship's default synchronous rendering.

zmodload zsh/system

typeset -g _ss_async_fd=0
typeset -g _ss_buf=''
typeset -g _ss_last=''
typeset -g _ss_last_pwd=''

_ss_callback() {
  local fd=$1 chunk=''
  if sysread -i $fd chunk; then
    _ss_buf+=$chunk
    return
  fi
  zle -F $fd
  exec {fd}<&-
  _ss_async_fd=0
  if [[ -n $_ss_buf ]]; then
    _ss_last=$_ss_buf
    _ss_last_pwd=$PWD
    PROMPT=$_ss_buf
    zle && zle reset-prompt
  fi
}

_ss_precmd() {
  prompt_starship_precmd "$@"
  if (( _ss_async_fd )); then
    zle -F $_ss_async_fd 2>/dev/null
    exec {_ss_async_fd}<&- 2>/dev/null
    _ss_async_fd=0
  fi
  _ss_buf=''
  exec {_ss_async_fd}< <(
    command starship prompt \
      --terminal-width="$COLUMNS" \
      --keymap="${KEYMAP:-}" \
      --status="${STARSHIP_CMD_STATUS:-}" \
      --pipestatus="${STARSHIP_PIPE_STATUS[*]:-}" \
      --cmd-duration="${STARSHIP_DURATION:-}" \
      --jobs="$STARSHIP_JOBS_COUNT" 2>/dev/null
  )
  zle -F $_ss_async_fd _ss_callback
  if [[ -n $_ss_last && $_ss_last_pwd == $PWD ]]; then
    PROMPT=$_ss_last
  else
    local g=$PWD d
    while [[ $g != / ]]; do; [[ -e $g/.git ]] && break; g=${g:h}; done
    if [[ $g != / && -e $g/.git ]]; then
      local rel=${PWD#$g}; d=${g:t}${rel}
    else
      d=${PWD/#$HOME/\~}
    fi
    PROMPT=$'%{\e[1;38;5;4m%}'"$d"$'%{\e[0m%}\n%{\e[38;5;5m%}❯%{\e[0m%} '
  fi
}

precmd_functions=(_ss_precmd ${precmd_functions:#prompt_starship_precmd})
RPROMPT=''
PROMPT=$'%F{5}❯%f '
