#!/usr/bin/env bash
# Per-window git branch: loop over every window, compute the git branch of the
# active pane's directory, store it as the window option @git_branch.
# Rendered in the status bar via #{@git_branch}.

exec 9>/tmp/tmux-git-branch.lock
flock -n 9 || exit 0

while :; do
  for session in $(tmux list-sessions -F '#{session_name}' 2>/dev/null); do
    tmux list-windows -t "$session" -F '#{window_id} #{pane_current_path}' 2>/dev/null |
      while read -r wid path; do
        branch=""
        if [ -n "$path" ] && git -C "$path" rev-parse --git-dir >/dev/null 2>&1; then
          branch="$(git -C "$path" rev-parse --abbrev-ref HEAD 2>/dev/null)"
          [ "$branch" = "HEAD" ] && branch=""
        fi
        tmux set-window-option -t "$wid" @git_branch "$branch" >/dev/null 2>&1
      done
  done
  sleep 5
done
