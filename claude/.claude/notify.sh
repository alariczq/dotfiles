#!/bin/bash
input=$(cat)
event=$(echo "$input" | jq -r '.hook_event_name // "unknown"')

case "$event" in
Stop)
  msg="Claude Code has finished the task"
  ;;
Notification)
  msg=$(echo "$input" | jq -r '.message // "Claude Code needs your attention"')
  ;;
*)
  msg="Claude Code: $event"
  ;;
esac

# Override auto-detection: set CLAUDE_NOTIFY to one of: osc9, tmux, osascript, bell
notify_method="${CLAUDE_NOTIFY:-auto}"

if [ "$notify_method" = "auto" ]; then
  case "${TERM_PROGRAM:-}" in
  vscode | cursor)
    if command -v osascript >/dev/null 2>&1; then
      notify_method="osascript"
    else
      notify_method="bell"
    fi
    ;;
  *)
    if [ -e /dev/tty ]; then
      notify_method="osc9"
    elif [ -n "${TMUX:-}" ]; then
      notify_method="tmux"
    elif command -v osascript >/dev/null 2>&1; then
      notify_method="osascript"
    else
      notify_method="bell"
    fi
    ;;
  esac
fi

case "$notify_method" in
osc9) printf '\e]9;%s\a' "$msg" >/dev/tty 2>/dev/null ;;
tmux) tmux display-message "$msg" 2>/dev/null ;;
osascript) osascript -e "display notification \"$msg\" with title \"Claude Code\"" 2>/dev/null ;;
bell) printf '\a' >/dev/tty 2>/dev/null ;;
esac
