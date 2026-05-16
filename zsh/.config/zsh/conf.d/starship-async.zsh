# Async cache for starship's left prompt.
# Starship still owns all prompt rendering and styling.

zmodload zsh/system 2>/dev/null || return
(( $+functions[prompt_starship_precmd] && $+commands[starship] )) || return

typeset -g _ss_starship="${commands[starship]}"
typeset -g _ss_sync_prompt="$PROMPT"
typeset -g _ss_sync_rprompt="$RPROMPT"
typeset -g _ss_prompt=''
typeset -g _ss_key=''
typeset -g _ss_pending_key=''
typeset -g _ss_buf=''
typeset -gA _ss_cache
typeset -ga _ss_cache_keys
typeset -gi _ss_fd=0
typeset -gi _ss_token=0
typeset -gi _ss_pending_token=0
typeset -gi _ss_cache_limit=16

_ss_args() {
  _ss_a=(
    --terminal-width="${COLUMNS:-80}"
    --keymap="${KEYMAP:-}"
    --status="${STARSHIP_CMD_STATUS:-}"
    --pipestatus="${STARSHIP_PIPE_STATUS[*]:-}"
    --cmd-duration="${STARSHIP_DURATION:-}"
    --jobs="${STARSHIP_JOBS_COUNT:-0}"
  )
}

_ss_key() {
  local -a _ss_a
  _ss_args
  REPLY=$PWD$'\1'${(j:\1:)_ss_a}
}

_ss_starship_prompt() {
  local -a _ss_a
  _ss_args
  command "$_ss_starship" prompt "${_ss_a[@]}"
}

_ss_render() {
  local out
  out="$(_ss_starship_prompt 2>/dev/null)"
  local rc=$?
  (( rc == 0 )) || return $rc
  [[ -n $out ]] || return 1
  REPLY=$out
}

_ss_cache_touch() {
  local key=$1 old
  local -a keys
  for old in "${_ss_cache_keys[@]}"; do
    [[ $old == "$key" ]] || keys+=("$old")
  done
  keys+=("$key")
  _ss_cache_keys=("${keys[@]}")
  while (( ${#_ss_cache_keys} > _ss_cache_limit )); do
    old=$_ss_cache_keys[1]
    unset "_ss_cache[$old]"
    shift _ss_cache_keys
  done
}

_ss_cache_get() {
  local key=$1
  (( $+_ss_cache[$key] )) || return 1
  REPLY=$_ss_cache[$key]
  _ss_cache_touch "$key"
}

_ss_cache_put() {
  local key=$1 value=$2
  _ss_cache[$key]=$value
  _ss_key=$key
  _ss_prompt=$value
  _ss_cache_touch "$key"
}

_ss_close() {
  local fd=$_ss_fd
  if (( fd )); then
    zle -F $fd 2>/dev/null
    exec {fd}<&- 2>/dev/null
  fi
  _ss_fd=0
  _ss_pending_key=''
  _ss_pending_token=0
  _ss_buf=''
}

_ss_read() {
  local fd=$1 chunk=''
  if (( fd != _ss_fd )); then
    zle -F $fd 2>/dev/null
    exec {fd}<&- 2>/dev/null
    return
  fi

  if sysread -i $fd chunk; then
    _ss_buf+=$chunk
    return
  fi

  zle -F $fd 2>/dev/null
  exec {fd}<&- 2>/dev/null
  _ss_fd=0
  local key=$_ss_pending_key token=$_ss_pending_token prompt=$_ss_buf
  _ss_pending_key=''
  _ss_pending_token=0
  _ss_buf=''

  (( token == _ss_token )) || return
  [[ -n $prompt ]] || return

  _ss_cache_put "$key" "$prompt"
  if [[ $PROMPT != "$prompt" && -z ${BUFFER:-} ]]; then
    PROMPT=$prompt
    zle reset-prompt 2>/dev/null
  fi
}

_ss_start() {
  local key=$1 token=$2
  if (( _ss_fd )) && [[ $_ss_pending_key == $key && $_ss_pending_token == $token ]]; then
    return
  fi
  _ss_close
  _ss_buf=''
  exec {_ss_fd}< <(_ss_starship_prompt 2>/dev/null) || return

  _ss_pending_key=$key
  _ss_pending_token=$token
  zle -F $_ss_fd _ss_read 2>/dev/null || _ss_close
}

_ss_precmd() {
  prompt_starship_precmd "$@"

  _ss_key
  local key=$REPLY
  (( ++_ss_token ))

  if _ss_cache_get "$key"; then
    PROMPT=$REPLY
    _ss_start "$key" $_ss_token
  elif _ss_render; then
    PROMPT=$REPLY
    _ss_cache_put "$key" "$REPLY"
  else
    PROMPT=$_ss_sync_prompt
    _ss_start "$key" $_ss_token
  fi
  RPROMPT=$_ss_sync_rprompt
}

_ss_zshexit() {
  _ss_close
  return 0
}

precmd_functions=(${precmd_functions:#_ss_precmd})
precmd_functions=(_ss_precmd ${precmd_functions:#prompt_starship_precmd})
autoload -Uz add-zsh-hook
add-zsh-hook -d zshexit _ss_zshexit 2>/dev/null
add-zsh-hook zshexit _ss_zshexit
