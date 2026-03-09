#!/usr/bin/env bash

SESSION="dotfiles"
ROOT="$HOME/.config"

if tmux has-session -t "=$SESSION" 2>/dev/null; then
  tmux switch-client -t "=$SESSION"
  exit 0
fi

tmux new-session -d -s "$SESSION" -n "tmux" -c "$ROOT"
tmux send-keys -t "$SESSION" "nvim tmux/tmux.conf" Enter

tmux new-window -t "$SESSION" -n "bash" -c "$ROOT"
tmux send-keys -t "$SESSION" "nvim bash/bashrc" Enter

tmux new-window -t "$SESSION" -n "shell" -c "$ROOT"

tmux switch-client -t "$SESSION"
