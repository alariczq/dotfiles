#!/bin/bash

readonly GREY='\033[90m'
readonly RED='\033[31m'
readonly GREEN='\033[32m'
readonly YELLOW='\033[33m'
readonly BLUE='\033[34m'
readonly MAGENTA='\033[35m'
readonly CYAN='\033[36m'
readonly RESET='\033[0m'

format_path() {
  local path=$1
  [[ "$path" == "$HOME"* ]] && echo "~${path#$HOME}" || echo "$path"
}

format_tokens() {
  local tokens=$1
  if [ "$tokens" -ge 1000000 ]; then
    local m=$((tokens / 1000000))
    local r=$(( (tokens % 1000000) / 100000 ))
    [ "$r" -gt 0 ] && echo "${m}.${r}M" || echo "${m}M"
  elif [ "$tokens" -ge 1000 ]; then
    echo "$((tokens / 1000))k"
  else
    echo "$tokens"
  fi
}

format_duration() {
  local ms=$1
  local sec=$((ms / 1000))
  local min=$((sec / 60))
  local hour=$((min / 60))
  local day=$((hour / 24))
  local h_rem=$((hour % 24))
  local m_rem=$((min % 60))

  if [ "$day" -gt 0 ]; then
    [ "$h_rem" -gt 0 ] && echo "${day}d${h_rem}h" || echo "${day}d"
  elif [ "$hour" -gt 0 ]; then
    [ "$m_rem" -gt 0 ] && echo "${hour}h${m_rem}m" || echo "${hour}h"
  else
    echo "${min}m"
  fi
}

context_color() {
  local pct=$1 active=$2
  [ "$active" -eq 0 ] && echo "$GREY" && return
  [ "$pct" -ge 50 ] && echo "$GREEN" && return
  [ "$pct" -ge 25 ] && echo "$YELLOW" || echo "$RED"
}

git_dirty() {
  local dir=$1
  [ -n "$(git -C "$dir" --no-optional-locks status --porcelain 2>/dev/null)" ]
}

git_sync_status() {
  local dir=$1 upstream=$2
  local ahead=$(git -C "$dir" --no-optional-locks rev-list --count @{upstream}..HEAD 2>/dev/null || echo 0)
  local behind=$(git -C "$dir" --no-optional-locks rev-list --count HEAD..@{upstream} 2>/dev/null || echo 0)

  [[ ! "$ahead" =~ ^[0-9]+$ ]] && ahead=0
  [[ ! "$behind" =~ ^[0-9]+$ ]] && behind=0

  [ "$behind" -gt 0 ] && [ "$ahead" -gt 0 ] && echo "⇣⇡" && return
  [ "$behind" -gt 0 ] && echo "⇣" && return
  [ "$ahead" -gt 0 ] && echo "⇡"
}

git_status() {
  local dir=$1
  git -C "$dir" rev-parse --git-dir >/dev/null 2>&1 || return

  local branch=$(git -C "$dir" --no-optional-locks branch --show-current 2>/dev/null)
  [ -z "$branch" ] && return

  local dirty="" sync=""
  git_dirty "$dir" && dirty="*"

  local upstream=$(git -C "$dir" --no-optional-locks rev-parse --abbrev-ref @{upstream} 2>/dev/null)
  [ -n "$upstream" ] && sync="${CYAN}$(git_sync_status "$dir" "$upstream")${RESET}"

  echo " ${GREY}${branch}${dirty}${RESET}${sync}"
}

statusline() {
  local input=$(cat) dir model remaining cents added removed duration win_size

  IFS=$'\t' read -r dir model remaining cents added removed duration win_size < <(
    echo "$input" | jq -r '[
      .workspace.current_dir // "~",
      .model.display_name // "Unknown",
      .context_window.remaining_percentage // 100,
      ((.cost.total_cost_usd // 0) * 100 | round),
      .cost.total_lines_added // 0,
      .cost.total_lines_removed // 0,
      .cost.total_duration_ms // 0,
      .context_window.context_window_size // 0
    ] | @tsv'
  )

  [[ ! "$remaining" =~ ^[0-9]+$ ]] && remaining=100
  [[ ! "$cents" =~ ^[0-9]+$ ]] && cents=0
  [[ ! "$added" =~ ^[0-9]+$ ]] && added=0
  [[ ! "$removed" =~ ^[0-9]+$ ]] && removed=0
  [[ ! "$duration" =~ ^[0-9]+$ ]] && duration=0
  [[ ! "$win_size" =~ ^[0-9]+$ ]] && win_size=0

  local minutes=$((duration / 1000 / 60))
  local active=0
  [ "$remaining" -lt 100 ] || [ "$cents" -gt 0 ] && active=1
  local ctx=$(context_color "$remaining" "$active")

  local out="${BLUE}$(format_path "$dir")${RESET}$(git_status "$dir")"
  out+=" ${GREY}|${RESET} ${MAGENTA}${model}${RESET}"
  local win_label=""
  if [ "$win_size" -gt 0 ]; then
    local used=$((win_size * (100 - remaining) / 100))
    win_label=" ${GREY}($(format_tokens "$used")/$(format_tokens "$win_size"))${RESET}"
  fi
  out+=" ${GREY}·${RESET} ${ctx}left ${remaining}%${RESET}${win_label}"

  [ "$cents" -gt 0 ] && out+="${GREY} · \$$(printf "%d.%02d" $((cents / 100)) $((cents % 100)))${RESET}"
  [ "$minutes" -gt 0 ] && out+="${GREY} · $(format_duration "$duration")${RESET}"

  if [ "$added" -gt 0 ] || [ "$removed" -gt 0 ]; then
    out+=" ${GREY}|${RESET} ${GREEN}+${added}${RESET}${GREY}/${RESET}${RED}-${removed}${RESET}"
  fi

  echo "$out"
}

printf "%b" "$(statusline) "
