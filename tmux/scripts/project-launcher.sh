#!/usr/bin/env bash

PROJECT_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/tmux/projects"

selected=$(ls "$PROJECT_DIR"/*.sh 2>/dev/null \
  | xargs -I{} basename {} .sh \
  | fzf --prompt="Project> " --reverse)

[[ -z "$selected" ]] && exit 0

bash "$PROJECT_DIR/$selected.sh"
