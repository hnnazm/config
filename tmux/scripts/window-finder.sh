#!/usr/bin/env bash

# Fuzzy find tmux windows and panes in the CURRENT session only

list=$(tmux list-panes -s -F \
  "#{window_index}.#{pane_index} │ #{window_name} │ #{pane_current_command} │ #{pane_current_path}" \
  2>/dev/null)

[[ -z "$list" ]] && exit 0

selected=$(echo "$list" | fzf \
  --prompt="Window> " \
  --reverse \
  --no-sort \
  --delimiter="│" \
  --with-nth=1,2,3,4 \
  --preview='tmux capture-pane -ep -t {1}' \
  --preview-window=right:60%)

[[ -z "$selected" ]] && exit 0

target=$(echo "$selected" | awk -F '│' '{print $1}' | xargs)
tmux select-window -t "$target"
tmux select-pane -t "$target"
